
import '../../../../../utilities/kalender.dart';
import '../../../inkomen/inkomen.dart';
import '../../financierings_norm/bereken_norm_inkomen.dart';
import '../../financierings_norm/bereken_norm_woningwaarde.dart';
import '../../financierings_norm/financierings_last_tabel.dart';
import '../../gegevens/combi_rest_schuld/combi_rest_schuld.dart';
import '../../gegevens/hypotheek/hypotheek.dart';
import '../../gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import '../../gegevens/norm/norm.dart';
import '../../gegevens/norm/norm_inkomen/inkomens_op_datum.dart';
import '../../gegevens/status_lening/status_lening.dart';
import '../../gegevens/termijn/termijn.dart';
import '../../gegevens/verbouw_verduurzaam_kosten/verbouw_verduurzaam_kosten.dart';
import '../../gegevens/woning_lening_kosten/woning_lening_kosten.dart';
import '../../hypotheek_iterator.dart';
import 'hypotheek_verwerken.dart';

class HypotheekVerwerkenR {
  List<Inkomen> inkomen = [];
  List<Inkomen> inkomenPartner = [];
  Map<DateTime, CombiRestSchuld> restSchulden = {};
  List<Hypotheek> teVerlengenHypotheken = [];
  List<Hypotheek> parallelHypotheken = [];
  HypotheekDossier hypotheekDossier;

  HypotheekVerwerkenR.bewerken(
      {required this.hypotheekDossier, Hypotheek? hypotheek}) {
    teVerlengenHypotheken =
        HypotheekVerwerken.teVerlengenHypotheek(hypotheekDossier, hypotheek);
    final restSchulden = HypotheekVerwerken.restSchuldInventarisatie(
        hypotheekDossier, hypotheek);

    if (hypotheek == null) {
    } else {}
  }

  void nieuweHypotheek() {
    double lening;

    if (teVerlengenHypotheken.isEmpty) {
      lening = 0.0;
    } else {
      lening = teVerlengenHypotheken.first.termijnen.last.lening;
    }

    final startDatum = Kalender.voegPeriodeToe(DateTime.now(),
        maanden: 1, periodeOpties: PeriodeOpties.eersteDag);

    final aflosTermijnInMaanden = (hypotheekDossier.starter ? 40 : 30) * 12;
    const hypotheekVorm = HypotheekVorm.annuity;

    parallelHypotheken = HypotheekIterator(
            eersteHypotheken: hypotheekDossier.eersteHypotheken,
            hypotheken: hypotheekDossier.hypotheken)
        .parallelStartDatum(startDatum)
        .toList();

    final inkomensOpDatum = InkomensOpDatum(
        datum: startDatum,
        inkomen: vindInkomenOpDatum(
          startDatum: startDatum,
          lijst: inkomen,
        ),
        inkomenPartner: vindInkomenOpDatum(
          startDatum: startDatum,
          lijst: inkomenPartner,
        ));

    List<StatusLening> statusParralleleLeningen = HypotheekVerwerken.statusParralleleLeningen(startDatum, parallelHypotheken);

    NormInkomen normInkomen = BerekenNormInkomen(
            startDatum: startDatum,
            hypotheekDossier: hypotheekDossier,
            aflosTermijnInMaanden: aflosTermijnInMaanden,
            hypotheekVorm: hypotheekVorm,
            statusParalleleLeningen: statusParralleleLeningen,
            inkomensOpDatum: inkomensOpDatum,
            erw: 0.0)
        .bereken();

    const VerbouwVerduurzaamKosten verbouwVerduurzaamKosten =
        VerbouwVerduurzaamKosten();
    const WoningLeningKosten woningLeningKosten = WoningLeningKosten();

    NormWoningwaarde normWoningwaarde = BerekenNormWoningWaarde(
        hypotheekDossier: hypotheekDossier,
        statusParalleleLeningen: statusParralleleLeningen,
        verbouwVerduurzaamKosten: verbouwVerduurzaamKosten,
        woningLeningKosten: woningLeningKosten).bereken();

    final Hypotheek hypotheek = Hypotheek(
      id: '',
      startDatum: startDatum,
      aflosTermijnInMaanden: aflosTermijnInMaanden,
      optiesHypotheekToevoegen: OptiesHypotheekToevoegen.nieuw,
      periodeInMaanden: 10 * 12,
      gewensteLening: lening,
      rente: 1.0,
      boeteVrijPercentage: 10.0,
      datumDeelsAfgelosteLening: DateTime(0),
      deelsAfgelosteLening: false,
      hypotheekvorm: hypotheekVorm,
      eindDatum: DateTime(0),
      afgesloten: true,
      normInkomen: normInkomen,
      normWoningwaarde:  normWoningwaarde,
      minLening: 0.0,
      omschrijving: '',
      usePeriodeInMaanden: true,
      startDatumAflossen: DateTime(0),
    );
  }

  

  Inkomen? vindInkomenOpDatum(
      {required DateTime startDatum, required List<Inkomen> lijst}) {
    Inkomen? inkomen;

    DateTime stop = Kalender.voegPeriodeToe(startDatum, jaren: 10);

    int index = 0;
    int length = lijst.length;

    while (index < length) {
      final i = lijst[index];

      if (i.datum.compareTo(startDatum) <= 0) {
        inkomen = i;
        index++;
      } else {
        break;
      }
    }

    if (inkomen == null) {
      return inkomen;
    }

    if (inkomen.pensioen) {
      return inkomen;
    }

    while (index < length) {
      final i = lijst[index];

      if (i.datum.isAfter(stop)) {
        break;
      } else if (i.pensioen) {
        return i;
      }
      index++;
    }
  }

   
}