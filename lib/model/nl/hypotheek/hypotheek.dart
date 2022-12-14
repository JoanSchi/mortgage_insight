import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:mortgage_insight/model/nl/hypotheek/kosten_hypotheek.dart';
import 'package:mortgage_insight/model/nl/hypotheek/parallel_leningen.dart';
import '../../../utilities/Kalender.dart';
import '../../../utilities/date.dart';
import 'hypotheek_iterator.dart';
import 'financierings_norm/norm.dart';

enum HypotheekVorm { Aflosvrij, Linear, Annuity }

enum OptiesHypotheekToevoegen {
  nieuw,
  verlengen,
}

enum DoelProfielOverzicht { nieuw, bestaand }

class HypotheekProfielContainer {
  HypotheekProfiel profiel;

  HypotheekProfielContainer(
    this.profiel,
  );

  HypotheekProfielContainer copyWith({
    HypotheekProfiel? profiel,
  }) {
    return HypotheekProfielContainer(
      profiel ?? this.profiel,
    );
  }
}

class HypotheekProfielen {
  String _profielID;
  Map<String, HypotheekProfielContainer> profielen;
  HypotheekProfielContainer? get profielContainer => profielen[_profielID];

  bool get isEmpty => profielen.isEmpty;

  HypotheekProfielen({
    String profielID = "",
    Map<String, HypotheekProfielContainer>? profielen,
    HypotheekProfielContainer? profiel,
  })  : _profielID = profielID,
        profielen = profielen ?? {};

  add(HypotheekProfiel nieuwProfiel) {
    _profielID = nieuwProfiel.id;
    profielen[nieuwProfiel.id] = HypotheekProfielContainer(nieuwProfiel);
  }

  remove({required String profielID}) {
    if (profielID == _profielID) {
      //Selecteer profiel boven de te verwijderen profiel
      String nieuweID = '';
      bool gepasseerd = false;

      for (String k in profielen.keys) {
        if (k == _profielID) {
          gepasseerd = true;
        } else {
          nieuweID = k;
        }

        if (gepasseerd && nieuweID.isNotEmpty) {
          break;
        }
      }
      _profielID = nieuweID;
    }
    profielen.remove(profielID);
  }

  updateProfielen() {
    profielen = Map.of(profielen);
  }

  bool change({required String profielID}) {
    if (_profielID != profielID) {
      _profielID = profielID;
      return true;
    } else {
      return false;
    }
  }

  updateProfiel() {
    if (_profielID.isNotEmpty) {
      profielen[_profielID] = profielen[_profielID]!.copyWith();
    }
  }

  updateHypotheekProfiel(HypotheekProfiel profiel) {
    _profielID = profiel.id;
    profielen[profiel.id] = HypotheekProfielContainer(profiel);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'profielID': _profielID,
      'hypotheekProfielen':
          profielen.map((key, value) => MapEntry(key, value.profiel.toMap())),
    };
  }

  factory HypotheekProfielen.fromMap(Map<String, dynamic> map) {
    return HypotheekProfielen(
      profielID: map['profielID'],
      profielen:
          Map<String, Map<String, dynamic>>.from(map['hypotheekProfielen']).map(
              (key, value) => MapEntry(key,
                  HypotheekProfielContainer(HypotheekProfiel.fromMap(value)))),
    );
  }

  String toJson() => json.encode(toMap());

  factory HypotheekProfielen.fromJson(String source) =>
      HypotheekProfielen.fromMap(json.decode(source));
}

class HypotheekProfiel {
  String id;
  String omschrijving;
  bool inkomensNormToepassen;
  bool woningWaardeNormToepassen;
  Map<String, Hypotheek> hypotheken;
  List<Hypotheek> eersteHypotheken;
  DoelProfielOverzicht doelOverzicht;
  Situatie situatie;
  EigenReserveWoning eigenReserveWoning;
  WoningLeningKostenGegevens vorigeWoningGegevens;

  DateTime datumWoningKopen;

  HypotheekProfiel({
    String? id,
    Map<String, Hypotheek>? hypotheken,
    List<Hypotheek>? eersteHypotheken,
    this.omschrijving = '',
    this.inkomensNormToepassen: true,
    this.woningWaardeNormToepassen: false,
    this.doelOverzicht: DoelProfielOverzicht.nieuw,
    this.situatie = Situatie.starter,
    EigenReserveWoning? eigenReserveWoning,
    WoningLeningKostenGegevens? vorigeWoningGegevens,
    DateTime? datumWoningKopen,
  })  : id = id ?? secondsID,
        hypotheken = hypotheken ?? {},
        eersteHypotheken = eersteHypotheken ?? [],
        eigenReserveWoning = eigenReserveWoning ?? EigenReserveWoning(),
        vorigeWoningGegevens = vorigeWoningGegevens ??
            WoningLeningKostenGegevens(
                kosten: WoningLeningKostenGegevens.suggestieKostenVorigeWoning()
                    .where((element) => element.standaard)
                    .map((e) => e.copyWith())
                    .toList()),
        datumWoningKopen = datumWoningKopen ?? hypotheekDatumSuggestie {
    this.hypotheken.forEach((key, value) {
      value.profiel = this;
    });
  }

  void removeHypotheek(Hypotheek hypotheek) {
    hypotheken.remove(hypotheek.id);
    final vorigeHypotheek = hypotheken[hypotheek.vorige];

    if (vorigeHypotheek == null) {
      eersteHypotheken.remove(hypotheek);
    } else {
      vorigeHypotheek.volgende = '';
    }

    void removeVolgende(Hypotheek hypotheek) {
      final volgendeHypotheek = hypotheken[hypotheek.volgende];

      if (volgendeHypotheek != null) {
        hypotheken.remove(volgendeHypotheek.id);
        removeVolgende(volgendeHypotheek);
      }
    }

    removeVolgende(hypotheek);
  }

  void addHypotheek(Hypotheek? hypotheek) {
    if (hypotheek == null) return;

    hypotheek.profiel = this;

    addOrder(hypotheek);

    hypotheken[hypotheek.id] = hypotheek;

    if (hypotheek.vorige.isEmpty) {
      eersteHypotheken
        ..add(hypotheek)
        ..sort(
          (Hypotheek a, Hypotheek b) {
            return a.currentOrder - b.currentOrder;
          },
        );
    } else {
      final vorigeHypotheek = hypotheken[hypotheek.vorige];
      vorigeHypotheek?.volgende = hypotheek.id;
    }
  }

  void addOrder(Hypotheek hypotheek) {
    final vorige = hypotheek.vorige;

    if (!hypotheek.order.containsKey(vorige)) {
      int order;

      if (vorige.isEmpty && eersteHypotheken.isNotEmpty) {
        order = eersteHypotheken.last.currentOrder + 1;

        assert(order != -1,
            'Order van -1, zou niet mogen order blijkbaar niet geinitieerd');
      } else {
        order = 0;
      }

      hypotheek.order[vorige] = order;
    }
  }

  int get maxTermijnenInJaren => doelOverzicht == DoelProfielOverzicht.nieuw &&
          situatie == Situatie.starter
      ? 40
      : 30;

  double woningWaardeVinden(DateTime startDatum) {
    double woningWaarde = 0.0;

    for (Hypotheek h in HypotheekIterator(
            eersteHypotheken: eersteHypotheken, hypotheken: hypotheken)
        .all()) {
      if (h.startDatum.compareTo(startDatum) <= 0 || woningWaarde == 0.0) {
        woningWaarde = h.woningLeningKosten.woningWaarde;
      } else {
        break;
      }
    }
    return woningWaarde;
  }

  double get erw {
    double erw = 0.0;

    if (eigenReserveWoning.erwToepassing) {
      if (eigenReserveWoning.erwBerekenen) {
        erw = vorigeWoningGegevens.woningWaarde -
            eigenReserveWoning.oorspronkelijkeHoofdsom +
            vorigeWoningGegevens.totaleKosten;
      } else {
        erw = eigenReserveWoning.erw;
      }

      if (erw < 0.0) {
        erw = 0.0;
      }
    }
    return erw;
  }

  double get verschil => vorigeWoningGegevens.verschil;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'omschrijving': omschrijving,
      'inkomensNormToepassen': inkomensNormToepassen,
      'eigenReserveWoning': eigenReserveWoning.toMap(),
      'vorigeWoningGegevens': vorigeWoningGegevens.toMap(),
      'woningWaardeNormToepassen': woningWaardeNormToepassen,
      'doelOverzicht': doelOverzicht.index,
      'hypotheken': hypotheken
          .map((String key, Hypotheek value) => MapEntry(key, value.toMap())),
      'eersteHypotheken': eersteHypotheken.map((x) => x.id).toList(),
      'datumWoningKopen': datumWoningKopen.toIso8601String(),
    };
  }

  factory HypotheekProfiel.fromMap(Map<String, dynamic> map) {
    final hypotheken = Map<String, dynamic>.from(map['hypotheken']).map(
        (String key, dynamic value) =>
            MapEntry<String, Hypotheek>(key, Hypotheek.fromMap(value)));

    return HypotheekProfiel(
      id: map['id'],
      omschrijving: map['omschrijving'],
      inkomensNormToepassen: map['inkomensNormToepassen'],
      vorigeWoningGegevens:
          WoningLeningKostenGegevens.fromMap(map['vorigeWoningGegevens']),
      eigenReserveWoning: EigenReserveWoning.fromMap(map['eigenReserveWoning']),
      woningWaardeNormToepassen: map['woningWaardeNormToepassen'],
      doelOverzicht: DoelProfielOverzicht.values[map['doelOverzicht']],
      hypotheken: hypotheken,
      eersteHypotheken: List<Hypotheek>.from(
          map['eersteHypotheken'].map((id) => hypotheken[id])),
      datumWoningKopen: DateTime.parse(map['datumWoningKopen']).toLocal(),
    );
  }

  String toJson() => json.encode(toMap());

  factory HypotheekProfiel.fromJson(String source) =>
      HypotheekProfiel.fromMap(json.decode(source));

  HypotheekProfiel copyWith({
    String? id,
    String? omschrijving,
    bool? financieringsNormToepassen,
    bool? woningWaardeNormToepassen,
    bool? nhgToepassen,
    WoningLeningKostenGegevens? vorigeWoningGegevens,
    EigenReserveWoning? eigenReserveWoning,
    Map<String, Hypotheek>? hypotheken,
    List<Hypotheek>? eersteHypotheken,
    DoelProfielOverzicht? doelOverzicht,
    Situatie? situatie,
    DateTime? datumWoningKopen,
  }) {
    final Map<String, Hypotheek> kopieHypotheken = hypotheken ??
        this.hypotheken.map((key, value) => MapEntry(key, value.copyWith()));

    final List<Hypotheek> kopieEersteHypotheken =
        (eersteHypotheken ?? this.eersteHypotheken)
            .map((e) => kopieHypotheken[e.id]!)
            .toList();

    return HypotheekProfiel(
      id: id ?? this.id,
      omschrijving: omschrijving ?? this.omschrijving,
      inkomensNormToepassen:
          financieringsNormToepassen ?? this.inkomensNormToepassen,
      woningWaardeNormToepassen:
          woningWaardeNormToepassen ?? this.woningWaardeNormToepassen,
      vorigeWoningGegevens:
          vorigeWoningGegevens ?? this.vorigeWoningGegevens.copyWith(),
      eigenReserveWoning:
          eigenReserveWoning ?? this.eigenReserveWoning.copyWith(),
      hypotheken: kopieHypotheken,
      eersteHypotheken: kopieEersteHypotheken,
      doelOverzicht: doelOverzicht ?? this.doelOverzicht,
      situatie: situatie ?? this.situatie,
      datumWoningKopen: datumWoningKopen ?? this.datumWoningKopen,
    );
  }
}

class Hypotheek {
  int leningNummer = 0;
  final String id;
  String omschrijving;
  String volgende;
  String vorige;
  List<Termijn> termijnen;
  double lening;
  double _gewensteLening;
  NormInkomen maxLeningInkomen;
  DefaultNorm maxLeningWoningWaarde;
  DefaultNorm maxLeningNHG;
  double boeteVrijPercentage;
  double minLening;
  HypotheekVorm hypotheekvorm;
  double rente;
  Map<String, int> order;
  WoningLeningKostenGegevens woningLeningKosten;
  VerbouwVerduurzaamKosten verbouwVerduurzaamKosten;
  OptiesHypotheekToevoegen optiesHypotheekToevoegen;
  ParallelLeningen parallelLeningen;
  HypotheekProfiel? profiel;

  int get currentOrder => order[vorige] ?? -1;

  List<AflosItems> extraAflossen = [
    AflosItems(date: DateTime(2021, 8, 15), value: 600, terms: 5),
    AflosItems(date: DateTime(2040, 6, 14), value: 700),
    AflosItems(date: DateTime(2050, 12, 29), value: 770)
  ];

  DateTime _startDatum;
  DateTime? _eindDatum;
  int periodeInMaanden;
  bool usePeriodeInMaanden;
  late DateTime startDatumAflossen;
  late DateTime datumLaatsteTermijn;
  late DateTime endMortgage;
  int aflosTermijnInMaanden;
  bool deelsAfgelosteLening;
  DateTime datumDeelsAfgelosteLening;
  bool afgesloten;

  Hypotheek({
    String? id,
    this.omschrijving = '',
    required this.optiesHypotheekToevoegen,
    this.lening = 0.0,
    double gewensteLening = 0.0,
    required this.maxLeningInkomen,
    required this.maxLeningWoningWaarde,
    required this.maxLeningNHG,
    required DateTime startDatum,
    DateTime? startDatumAflossen,
    DateTime? eindDatum,
    required this.periodeInMaanden,
    required this.aflosTermijnInMaanden,
    this.hypotheekvorm = HypotheekVorm.Annuity,
    List<Termijn>? termijnen,
    this.rente = 1.0,
    this.boeteVrijPercentage = 10.0,
    this.usePeriodeInMaanden = true,
    this.minLening = 7500.0,
    List<AflosItems>? extraAflossen,
    this.volgende = '',
    this.vorige = '',
    Map<String, int>? order,
    WoningLeningKostenGegevens? woningLeningKosten,
    VerbouwVerduurzaamKosten? verduurzaamKosten,
    this.deelsAfgelosteLening = false,
    DateTime? datumDeelsAfgelosteLening,
    ParallelLeningen? parallelLeningen,
    bool afgesloten = false,
  })  : assert(periodeInMaanden > 0 || eindDatum != null,
            'EindDatum kan niet bepaald worden, vul aantal periodes in in Maanden > 0 of voeg einddatum toe'),
        id = id ?? secondsID,
        _gewensteLening = gewensteLening,
        termijnen = termijnen ?? [],
        extraAflossen = extraAflossen ?? [],
        _startDatum = startDatum,
        startDatumAflossen = startDatumAflossen ?? startDatum,
        _eindDatum = eindDatum,
        order = order ?? {},
        parallelLeningen = parallelLeningen ?? ParallelLeningen(),
        woningLeningKosten = woningLeningKosten ?? WoningLeningKostenGegevens(),
        verbouwVerduurzaamKosten =
            verduurzaamKosten ?? VerbouwVerduurzaamKosten(),
        datumDeelsAfgelosteLening = datumDeelsAfgelosteLening ?? startDatum,
        afgesloten = afgesloten
            ? true
            : startDatum.isBefore(DateUtils.dateOnly(DateTime.now()));

  DateTime get startDatum => _startDatum;

  set startDatum(DateTime value) {
    _startDatum = value;
    controleerAfgesloten();
  }

  double get gewensteLening => afgesloten ? lening : _gewensteLening;

  set gewensteLening(double value) {
    controleerAfgesloten();

    if (afgesloten) {
      lening = value;
    } else {
      _gewensteLening = value;
    }
  }

  set aflosTermijnInJaren(int value) {
    aflosTermijnInMaanden = value * 12;
  }

  int get aflosTermijnInJaren => aflosTermijnInMaanden ~/ 12;

  set periodeInJaren(int value) {
    periodeInMaanden = value * 12;
  }

  int get periodeInJaren => periodeInMaanden ~/ 12;

  DateTime get eindDatum {
    if (termijnen.isNotEmpty) {
      //EindDatum kan verkort worden door extra aflossen
      return termijnen.last.eindDatum;
    } else if (usePeriodeInMaanden) {
      return addDateTime(startDatum, months: periodeInMaanden);
    } else {
      assert(_eindDatum != null,
          'Einddatum kan niet null zijn als usePeriodeInMaanden false is');
      return _eindDatum!;
    }
  }

  set eindDatum(DateTime value) {
    _eindDatum = value;
  }

  berekenOverzicht() {
    opschonen();
    normaliseerLening();
    if (lening > 0.0) {
      termijnenAanmaken();
      voegRenteToe();
      voegExtraAflossenToe();
      berekenPeriode();
    }
  }

  opschonen() {
    termijnen = [];
  }

  termijnenAanmaken() {
    startDatumAflossen = startDatum;

    if (true && startDatum.day != 1) {
      DateTime endMonth = endOfMonth(startDatum);

      termijnen.add(Termijn(startDatum: startDatum, eindDatum: endMonth));

      startDatumAflossen = addDateTime(endMonth, days: 0);
    }

    DateTime startMonth = startDatumAflossen;
    endMortgage = addDateTime(startDatumAflossen, months: periodeInMaanden);
    datumLaatsteTermijn =
        addDateTime(startDatumAflossen, months: periodeInMaanden);

    int period = 0;

    do {
      DateTime endMonth = addDateTime(startMonth, months: 1, days: 0);

      termijnen.add(Termijn(
          startDatum: startMonth,
          eindDatum: endMonth.isBefore(datumLaatsteTermijn)
              ? endMonth
              : datumLaatsteTermijn,
          hypotheekVorm: hypotheekvorm,
          periode: period));

      period++;
      startMonth = addDateTime(startDatumAflossen, months: period);
    } while (startMonth.isBefore(datumLaatsteTermijn));
  }

  void normaliseerLening() {
    if (!afgesloten) {
      Norm ml = maxLening;

      if (ml.toepassen && ml.fouten.isEmpty) {
        if (_gewensteLening < 0.1) {
          lening = ml.resterend;
          _gewensteLening = ml.resterend;
        } else if (ml.resterend < _gewensteLening) {
          lening = ml.resterend;
        } else {
          lening = _gewensteLening;
        }
      }
    }
    woningLeningKosten.lening = lening;
  }

  void berekenPeriode() {
    // double kapitalPeriode = lening;

    double leningPeriode = lening;
    double aflossenTotaal = 0.0;
    double renteTotaal = 0.0;

    for (Termijn a in termijnen) {
      // if (a.isStartPeriod) {
      //   leningPeriode = kapitalPeriode;
      // }
      double extraAflossen = a.extraAflossenIngevuld;

      if (extraAflossen > 0.0) {
        if (leningPeriode - extraAflossen < 1.0) {
          a.extraAflossen = leningPeriode;
          leningPeriode = 0;
          a.volledigAfgelost = true;
          break;
        } else {
          leningPeriode -= extraAflossen;
        }
      }

      a.lening = leningPeriode;

      double maandRente = a.rente / 12.0;
      double ratio = a.ratio;
      double aflossen;

      final double maandRenteBedragRatio =
          leningPeriode / 100.0 * maandRente * ratio;

      switch (a.hypotheekVorm) {
        case HypotheekVorm.Annuity:
          {
            double annuity = leningPeriode /
                100.0 *
                maandRente /
                (1.0 -
                    (math.pow(1.0 + maandRente / 100.0,
                        -(aflosTermijnInMaanden - a.periode)))) *
                ratio;
            aflossen = annuity - maandRenteBedragRatio;
            break;
          }
        case HypotheekVorm.Linear:
          {
            aflossen =
                leningPeriode / (aflosTermijnInMaanden - a.periode) * ratio;
            break;
          }
        default:
          {
            aflossen = 0.0;
          }
      }
      leningPeriode -= aflossen;

      a.maandRenteBedragRatio = maandRenteBedragRatio;
      a.aflossen = aflossen;
      a.extraAflossen = extraAflossen;

      aflossenTotaal += aflossen + extraAflossen;
      renteTotaal += maandRenteBedragRatio;

      a.aflossenTotaal = aflossenTotaal;
      a.renteTotaal = renteTotaal;

      // if (a.isEndPeriod) {
      //   kapitalPeriode = leningPeriode - payment;
      // }
    }
  }

  voegRenteToe() {
    termijnen.forEach((Termijn t) => t.rente = rente);

    // int index = 0;
    // int length = termijnen.length;

    // Termijn vorige = termijnen[0];

    // for (RentePeriode interest in rentePeriodes) {
    //   DateTime startDate = interest.date;
    //   bool found = false;

    //   while (index < length && !found) {
    //     Termijn mi = termijnen[index];

    //     switch (startDate.compareTo(mi.startDatum)) {
    //       case 0:
    //         mi.interest = interest.value;

    //         found = true;
    //         break;
    //       case -1:
    //         termijnen.insert(
    //             index,
    //             vorige.copyWith(
    //               startDatum: startDate,
    //               interest: interest.value,
    //             ));

    //         vorige.eindDatum = startDate.add(const Duration(days: -1));

    //         mi.interest = interest.value;

    //         index++;
    //         length++;
    //         found = true;
    //         break;
    //       case 1:
    //         mi.interest = vorige.interest;

    //         if (index == length - 1 && startDate.compareTo(lastMortgage) < 0
    //             // startDate.millisecondsSinceEpoch <
    //             //     lastMortgage.millisecondsSinceEpoch
    //             ) {
    //           termijnen.add(
    //               mi.copyWith(interest: interest.value, startDatum: startDate));

    //           mi.eindDatum = startDate.add(const Duration(days: -1));
    //         }

    //         break;
    //     }
    //     vorige = mi;
    //     index++;
    //   }
    // }
    //
    // while (index < length) {
    //   termijnen[index].interest = vorige.interest;
    //   index++;
    // }
  }

  void voegExtraAflossenToe() {
    int length = termijnen.length;

    for (AflosItems aflosItem in extraAflossen) {
      int term = 0;
      DateTime startDate = aflosItem.date;
      int index = 0;
      Termijn vorige = termijnen[0];
      do {
        bool found = false;

        while (index < length && !found) {
          Termijn mi = termijnen[index];

          switch (startDate.compareTo(mi.startDatum)) {
            case 0:
              {
                mi.extraAflossenIngevuld = aflosItem.value;
                found = true;
                break;
              }
            case -1:
              {
                termijnen.insert(
                    index,
                    vorige.copyWith(
                        startDatum: startDate,
                        extraAflossenIngevuld: aflosItem.value));

                vorige.eindDatum = startDate; //.add(const Duration(days: -1));

                index++;
                length++;
                found = true;
                break;
              }
            case 1:
              // Paymant in final month is strange
              {
                if (index == length - 1 &&
                        startDate.compareTo(datumLaatsteTermijn) < 0
                    // startDate.millisecondsSinceEpoch <
                    //     lastMortgage.millisecondsSinceEpoch
                    ) {
                  termijnen.add(mi.copyWith(
                      startDatum: startDate,
                      extraAflossenIngevuld: aflosItem.value));

                  mi.eindDatum = startDate; //.add(const Duration(days: -1));
                }
                break;
              }
          }
          vorige = mi;
          index++;
        }

        term++;
        startDate = addDateTime(aflosItem.date,
            months: term * aflosItem.periodInMonths);
      } while (term < aflosItem.terms && index < length);
    }
  }

  double get restSchuld {
    assert(lening == 0.0 || termijnen.isNotEmpty,
        'Geen termijnen maar wel lening $lening, berekening niet uitgevoerd?');

    return lening == 0.0 || termijnen.isEmpty
        ? 0.0
        : termijnen.last.leningNaAflossen;
  }

  double get financieringsNormInkomen => maxLeningInkomen.totaal;

  double get financieringsNormWoningWaarde => maxLeningWoningWaarde.totaal;

  Norm get maxLening => maxLeningInkomen
      .minHuidige(maxLeningWoningWaarde)
      .minHuidige(maxLeningNHG);

  void controleerAfgesloten() {
    afgesloten = _startDatum.isBefore(DateUtils.dateOnly(DateTime.now()));
  }

  Hypotheek copyWith({
    String? id,
    String? omschrijving,
    OptiesHypotheekToevoegen? optiesHypotheekToevoegen,
    String? volgende,
    String? vorige,
    List<Termijn>? termijnen,
    double? lening,
    double? gewensteLening,
    NormInkomen? maxLeningInkomen,
    DefaultNorm? maxLeningWoningWaarde,
    DefaultNorm? maxLeningNHG,
    double? boeteVrijPercentage,
    double? minLening,
    double? rente,
    List<AflosItems>? extraAflossen,
    DateTime? startDatum,
    DateTime? eindDatum,
    int? periodeInMaanden,
    bool? usePeriodeInMaanden,
    DateTime? startPrincipalPayment,
    DateTime? lastMortgage,
    DateTime? endMortgage,
    int? aflosTermijnInMaanden,
    HypotheekVorm? hypotheekvorm,
    Map<String, int>? order,
    double? inkomen,
    double? inkomenPartner,
    HypotheekProfiel? profiel,
    ParallelLeningen? parallelLeningen,
    WoningLeningKostenGegevens? woningLeningKosten,
    VerbouwVerduurzaamKosten? verduurzaamKosten,
    bool? deelsAfgelosteLening,
    DateTime? datumDeelsAfgelosteLening,
    bool? afgesloten,
  }) {
    return Hypotheek(
      id: id ?? this.id,
      omschrijving: omschrijving ?? this.omschrijving,
      optiesHypotheekToevoegen:
          optiesHypotheekToevoegen ?? this.optiesHypotheekToevoegen,
      volgende: volgende ?? this.volgende,
      vorige: vorige ?? this.vorige,
      termijnen: termijnen ?? this.termijnen,
      lening: lening ?? this.lening,
      gewensteLening: gewensteLening ?? _gewensteLening,
      maxLeningInkomen: maxLeningInkomen ?? this.maxLeningInkomen.copyWith(),
      maxLeningWoningWaarde:
          maxLeningWoningWaarde ?? this.maxLeningWoningWaarde.copyWith(),
      maxLeningNHG: maxLeningNHG ?? this.maxLeningNHG.copyWith(),
      boeteVrijPercentage: boeteVrijPercentage ?? this.boeteVrijPercentage,
      minLening: minLening ?? this.minLening,
      rente: rente ?? this.rente,
      extraAflossen: extraAflossen ?? this.extraAflossen,
      startDatum: startDatum ?? this._startDatum,
      eindDatum: eindDatum ?? this._eindDatum,
      periodeInMaanden: periodeInMaanden ?? this.periodeInMaanden,
      usePeriodeInMaanden: usePeriodeInMaanden ?? this.usePeriodeInMaanden,
      startDatumAflossen: startPrincipalPayment ?? this.startDatumAflossen,
      aflosTermijnInMaanden:
          aflosTermijnInMaanden ?? this.aflosTermijnInMaanden,
      hypotheekvorm: hypotheekvorm ?? this.hypotheekvorm,
      order: order ?? this.order,
      woningLeningKosten:
          woningLeningKosten ?? this.woningLeningKosten.copyWith(),
      verduurzaamKosten:
          verduurzaamKosten ?? this.verbouwVerduurzaamKosten.copyWith(),
      deelsAfgelosteLening: deelsAfgelosteLening ?? this.deelsAfgelosteLening,
      datumDeelsAfgelosteLening:
          datumDeelsAfgelosteLening ?? this.datumDeelsAfgelosteLening,
      afgesloten: afgesloten ?? this.afgesloten,
      parallelLeningen: parallelLeningen ?? this.parallelLeningen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'omschrijving': omschrijving,
      'optiesHypotheekToevoegen': optiesHypotheekToevoegen.index,
      'lening': lening,
      'gewensteLening': _gewensteLening,
      'maxLening': maxLeningInkomen.toMap(),
      'maxLeningWoningWaarde': maxLeningWoningWaarde.toMap(),
      'maxLeningNHG': maxLeningNHG.toMap(),
      'boeteVrijPercentage': boeteVrijPercentage,
      'minLening': minLening,
      'rente': rente,
      'extraAflossen': extraAflossen.map((x) => x.toMap()).toList(),
      '_startDatum': _startDatum.toIso8601String(),
      '_eindDatum': _eindDatum?.toIso8601String(),
      'periodeInMaanden': periodeInMaanden,
      'usePeriodeInMaanden': usePeriodeInMaanden,
      'startDatumAflossen': startDatumAflossen.toIso8601String(),
      'aflosTermijnInMaanden': aflosTermijnInMaanden,
      'order': order,
      'termijnen': termijnen.map((e) => e.toMap()).toList(),
      'woningLeningKosten': woningLeningKosten.toMap(),
      'verduurzaamKosten': verbouwVerduurzaamKosten.toMap(),
      'deelsAfgelosteLening': deelsAfgelosteLening,
      'datumDeelsAfgelosteLening': datumDeelsAfgelosteLening.toIso8601String(),
      'afgesloten': afgesloten,
      'parallelLeningen': parallelLeningen
    };
  }

  factory Hypotheek.fromMap(Map<String, dynamic> map) {
    return Hypotheek(
        id: map['id'],
        omschrijving: map['omschrijving'],
        optiesHypotheekToevoegen:
            OptiesHypotheekToevoegen.values[map['optiesHypotheekToevoegen']],
        lening: map['lening']?.toDouble(),
        gewensteLening: map['gewensteLening']?.toDouble(),
        maxLeningInkomen: NormInkomen.fromMap(map['maxLening']),
        maxLeningWoningWaarde:
            DefaultNorm.fromMap(map['maxLeningWoningWaarde']),
        maxLeningNHG: DefaultNorm.fromMap(map['maxLeningNHG']),
        boeteVrijPercentage: map['boeteVrijPercentage']?.toDouble(),
        minLening: map['minLening']?.toDouble(),
        rente: map['rente']?.toDouble(),
        extraAflossen: List<AflosItems>.from(
            map['extraAflossen'].map((x) => AflosItems.fromMap(x))),
        startDatum: DateTime.parse(map['_startDatum']).toLocal(),
        eindDatum: map['_eindDatum'] != null
            ? DateTime.parse(map['_eindDatum']).toLocal()
            : null,
        periodeInMaanden: map['periodeInMaanden']?.toInt(),
        usePeriodeInMaanden: map['usePeriodeInMaanden'],
        startDatumAflossen: DateTime.parse(map['startDatumAflossen']).toLocal(),
        aflosTermijnInMaanden: map['aflosTermijnInMaanden']?.toInt(),
        order: Map<String, int>.from(map['order']),
        termijnen:
            List<Termijn>.from(map['termijnen'].map((x) => Termijn.fromMap(x))),
        woningLeningKosten:
            WoningLeningKostenGegevens.fromMap(map['woningLeningKosten']),
        verduurzaamKosten:
            VerbouwVerduurzaamKosten.fromMap(map['verduurzaamKosten']),
        deelsAfgelosteLening: map['deelsAfgelosteLening'],
        datumDeelsAfgelosteLening:
            DateTime.parse(map['datumDeelsAfgelosteLening']).toLocal(),
        afgesloten: map['afgesloten'],
        parallelLeningen: ParallelLeningen.fromMap(map['parallelLeningen']));
  }

  String toJson() => json.encode(toMap());

  factory Hypotheek.fromJson(String source) =>
      Hypotheek.fromMap(json.decode(source));
}

class Termijn {
  DateTime startDatum;
  DateTime eindDatum;
  final DateTime _startPeriode;
  final DateTime _eindPeriode;
  HypotheekVorm hypotheekVorm;
  double rente;
  double extraAflossenIngevuld;
  double maandRenteBedragRatio;
  double lening;
  double aflossen;
  double extraAflossen;
  double netMontly;
  bool volledigAfgelost;
  int periode;
  double aflossenTotaal;
  double renteTotaal;

  Termijn({
    DateTime? startPeriode,
    DateTime? eindPeriode,
    required this.startDatum,
    required this.eindDatum,
    this.hypotheekVorm = HypotheekVorm.Aflosvrij,
    this.rente = 0.0,
    this.extraAflossenIngevuld = 0.0,
    this.maandRenteBedragRatio = 0.0,
    this.lening = 0.0,
    this.aflossen = 0.0,
    this.extraAflossen = 0.0,
    this.netMontly = 0.0,
    this.volledigAfgelost = false,
    this.periode = 0,
    this.aflossenTotaal = 0.0,
    this.renteTotaal = 0.0,
  })  : _startPeriode = startPeriode ?? startDatum,
        _eindPeriode = eindPeriode ?? eindDatum;

  int get dagen => diffDays(eindDatum, startDatum); //+1

  int get dagenInPeriode => diffDays(_eindPeriode, _startPeriode); //+1

  double get ratio => dagen / dagenInPeriode;

  bool get isStartPeriode => DateUtils.isSameDay(startDatum, _startPeriode);

  bool get isEndPeriode => DateUtils.isSameDay(eindDatum, _eindPeriode);

  double get leningNaAflossen => lening - aflossen - extraAflossen;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'startDatum': startDatum.toIso8601String(),
      'eindDatum': eindDatum.toIso8601String(),
      '_startPeriode': _startPeriode.toIso8601String(),
      '_eindPeriode': _eindPeriode.toIso8601String(),
      'hypotheekVorm': hypotheekVorm.index,
      'rente': rente,
      'extraAflossenIngevuld': extraAflossenIngevuld,
      'maandRenteBedragRatio': maandRenteBedragRatio,
      'lening': lening,
      'aflossen': aflossen,
      'extraAflossen': extraAflossen,
      'netMontly': netMontly,
      'volledigAfgelost': volledigAfgelost,
      'periode': periode,
      'aflossenTotaal': aflossenTotaal,
      'renteTotaal': renteTotaal,
    };
  }

  factory Termijn.fromMap(Map<String, dynamic> map) {
    return Termijn(
      startDatum: DateTime.parse(map['startDatum']).toLocal(),
      eindDatum: DateTime.parse(map['eindDatum']).toLocal(),
      startPeriode: DateTime.parse(map['_startPeriode']).toLocal(),
      eindPeriode: DateTime.parse(map['_eindPeriode']).toLocal(),
      hypotheekVorm: HypotheekVorm.values[map['hypotheekVorm']],
      rente: map['rente']?.toDouble(),
      extraAflossenIngevuld: map['extraAflossenIngevuld']?.toDouble(),
      maandRenteBedragRatio: map['maandRenteBedragRatio']?.toDouble(),
      lening: map['lening']?.toDouble(),
      aflossen: map['aflossen']?.toDouble(),
      extraAflossen: map['extraAflossen']?.toDouble(),
      netMontly: map['netMontly']?.toDouble(),
      volledigAfgelost: map['volledigAfgelost'],
      periode: map['periode']?.toInt(),
      aflossenTotaal: map['aflossenTotaal']?.toDouble(),
      renteTotaal: map['renteTotaal']?.toDouble(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Termijn.fromJson(String source) =>
      Termijn.fromMap(json.decode(source));

  Termijn copyWith({
    DateTime? startDatum,
    DateTime? eindDatum,
    DateTime? startPeriode,
    DateTime? eindPeriode,
    HypotheekVorm? hypotheekVorm,
    double? interest,
    double? extraAflossenIngevuld,
    double? maandRenteRatio,
    double? lening,
    double? aflossen,
    double? extraAflossen,
    double? netMontly,
    bool? volledigAfgelost,
    int? periode,
  }) {
    return Termijn(
      startDatum: startDatum ?? this.startDatum,
      eindDatum: eindDatum ?? this.eindDatum,
      startPeriode: startPeriode ?? _startPeriode,
      eindPeriode: eindPeriode ?? _eindPeriode,
      hypotheekVorm: hypotheekVorm ?? this.hypotheekVorm,
      rente: interest ?? this.rente,
      extraAflossenIngevuld:
          extraAflossenIngevuld ?? this.extraAflossenIngevuld,
      maandRenteBedragRatio: maandRenteRatio ?? this.maandRenteBedragRatio,
      lening: lening ?? this.lening,
      aflossen: aflossen ?? this.aflossen,
      extraAflossen: extraAflossen ?? this.extraAflossen,
      netMontly: netMontly ?? this.netMontly,
      volledigAfgelost: volledigAfgelost ?? this.volledigAfgelost,
      periode: periode ?? this.periode,
    );
  }
}

// class Belasting {
//   bool partner;
//   MaandItem startIndex;
//   MaandItem endIndex;
//  double belastbaarInkomen;
//  double sumRatioVanMaanden = 0.0;
//   int dagenPerJaar = 0;
//   double loonheffing = 0.0;
//   double percentageEigenaar;
//   int jaar;

//
// Belasting({this.partner = false, required this.startIndex, this.percentageEigenaar =0.5, required this.jaar}){
//   this.endIndex = startIndex;
//   this.belastbaarInkomen = getbelastbaarInkomen(partner, jaar)
//   loonheffing = getLoonHeffing(jaar, belastbaarInkomen, geboortedatum, aowCheck, aowDatum)
// }
//
// //  Wordt extra aftrekpost gecreerd (eigenWoningforfait - rente) om de eigenWoningforfait per saldo op 0 te zetten;
// // rente - eigenWoningforfait  + (eigenWoningforfait - rente);
//   double get terugGave() {
//     if (rente > eigenWoningforFait) {
//       (rente - eigenWoningforFait) / 100 * percentageEigenaar / 100 *
//           loonheffing
//     } else {
//       0.0
//     }
//   }

// private val eigenWoningforFait: Double
// get() = eigenwoningforfaitMetWaardeCorrectie(jaar) / dagenInJaar * dagenPerJaar
//
//
//
// internal fun kanTerugGaveBerekenen(): Boolean {
// return kanBelastingBerekenenVanJaar(jaar)
// }
//
// internal fun getTerugGave(ratio: Double): Double {
// return if (kanBelastingBerekenenVanJaar(jaar)) terugGave / sumRatioVanMaanden * ratio else 0.0
// }
// }

class RentePeriode {
  DateTime date;
  double value;

  RentePeriode({required this.date, required this.value});
}

class AflosItems {
  DateTime date;
  double value;
  int terms;
  int periodInMonths;

  AflosItems(
      {required this.date,
      required this.value,
      this.terms = 1,
      this.periodInMonths = 6});

  Map<String, dynamic> toMap() {
    return {
      'date': date.millisecondsSinceEpoch,
      'value': value,
      'terms': terms,
      'periodInMonths': periodInMonths,
    };
  }

  factory AflosItems.fromMap(Map<String, dynamic> map) {
    return AflosItems(
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      value: map['value']?.toDouble() ?? 0.0,
      terms: map['terms']?.toInt() ?? 0,
      periodInMonths: map['periodInMonths']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AflosItems.fromJson(String source) =>
      AflosItems.fromMap(json.decode(source));

  AflosItems copyWith({
    DateTime? date,
    double? value,
    int? terms,
    int? periodInMonths,
  }) {
    return AflosItems(
      date: date ?? this.date,
      value: value ?? this.value,
      terms: terms ?? this.terms,
      periodInMonths: periodInMonths ?? this.periodInMonths,
    );
  }
}

//Calendar

int diffDays(DateTime dt1, DateTime dt2) =>
    (dt1.millisecondsSinceEpoch - dt2.millisecondsSinceEpoch) ~/
    Duration.millisecondsPerDay;

DateTime endOfMonth(DateTime dateTime) {
  int date = _daysInMonthArray[dateTime.month];
  if (_isLeapYear(dateTime.year) && dateTime.month == 2) {
    date = 29;
  }
  return DateTime(dateTime.year, dateTime.month, date);
}

DateTime addDateTime(
  DateTime dateTime, {
  Duration duration = Duration.zero,
  int years = 0,
  int months = 0,
  int weeks = 0,
  int days = 0,
  int hours = 0,
}) {
  if (duration != Duration.zero) dateTime = dateTime.add(duration);

  if (weeks != 0 || days != 0 || hours != 0) {
    dateTime = dateTime.add(Duration(
      days: days + (weeks * 7),
      hours: hours,
    ));
  }

  if (months != 0) dateTime = _addMonths(dateTime, months);

  if (years != 0) dateTime = _addMonths(dateTime, years * 12);

  return dateTime;
}

int _daysInMonth(int year, int month) {
  var result = _daysInMonthArray[month];
  if (month == 2 && _isLeapYear(year)) result++;
  return result;
}

DateTime _addMonths(DateTime from, int months) {
  final r = months % 12;
  final q = (months - r) ~/ 12;
  var newYear = from.year + q;
  var newMonth = from.month + r;
  if (newMonth > 12) {
    newYear++;
    newMonth -= 12;
  }
  final newDay = math.min(from.day, _daysInMonth(newYear, newMonth));
  if (from.isUtc) {
    return DateTime.utc(newYear, newMonth, newDay, from.hour, from.minute,
        from.second, from.millisecond, from.microsecond);
  } else {
    return DateTime(newYear, newMonth, newDay, from.hour, from.minute,
        from.second, from.millisecond, from.microsecond);
  }
}

bool _isLeapYear(int year) =>
    (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

const _daysInMonthArray = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

DateTime get hypotheekDatumSuggestie => DateUtils.dateOnly(
      Kalender.voegPeriodeToe(DateTime.now(),
          maanden: 3, periodeOpties: PeriodeOpties.EERSTEDAG),
    );
