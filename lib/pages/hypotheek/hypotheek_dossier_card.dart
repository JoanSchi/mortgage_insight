import 'package:flutter/material.dart';
import '../../model/nl/hypotheek/gegevens/hypotheek/hypotheek.dart';
import '../../model/nl/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import '../../my_widgets/animated_checkmark.dart';
import '../../my_widgets/mortgage_card.dart';
import '../../my_widgets/summary_pie_chart/pie_chart.dart';
import '../../utilities/my_number_format.dart';

class DossierCard extends StatelessWidget {
  final int geselecteerd;
  final HypotheekDossier hd;
  final VoidCallback selecteren;
  final VoidCallback verwijderen;
  final VoidCallback bewerken;

  const DossierCard({
    super.key,
    required this.hd,
    required this.geselecteerd,
    required this.selecteren,
    required this.verwijderen,
    required this.bewerken,
  });

  @override
  Widget build(BuildContext context) {
    final omschrijving = hd.omschrijving.isEmpty ? '${hd.id}' : hd.omschrijving;

    bool selected = geselecteerd == hd.id;

    return MoCard(
      onTap: () => selecteerDossier(hd.id),
      onLongPress: bewerken,
      color: selected
          ? const Color.fromARGB(255, 180, 218, 230)
          : const Color(0xFFe6f5fa),
      top: SizedBox(
        height: 56.0,
        child: Stack(children: [
          Positioned(
            left: 0.0,
            bottom: 8.0,
            child: Row(children: [
              AnimatedCheck(
                checked: selected,
                size: 48.0,
                color: const Color.fromARGB(255, 55, 70, 75),
                duration: const Duration(milliseconds: 200),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(omschrijving, textScaleFactor: 1.2),
              )
            ]),
          ),
          Positioned(
            top: 8.0,
            right: 8.0,
            bottom: 8.0,
            child: buildMoCardMenu(
                items: [MoCardMenuItem.edit(), MoCardMenuItem.delete()],
                onSelected: onSelected),
          )
        ]),
      ),
      body: Stack(
        children: [
          Positioned(
              left: 0.0,
              top: 0.0,
              right: 0.0,
              bottom: 0.0,
              child: HypotheekDossierCenter(
                hd: hd,
              )),
        ],
      ),
      // bottom: bottom,
    );
  }

  void selecteerDossier(int? id) {
    selecteren();
  }

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        bewerken();
        break;
      case 'delete':
        verwijderen();
        break;
    }
  }
}

// FittedSizes _defaultBoxFit(BoxFit fit, Size inputSize, Size outputSize) {
//   if (inputSize.height <= 0.0 ||
//       inputSize.width <= 0.0 ||
//       outputSize.height <= 0.0 ||
//       outputSize.width <= 0.0) return const FittedSizes(Size.zero, Size.zero);

//   Size sourceSize = inputSize;

//   final scale = (outputSize.width / 3.0 * 2.0) / inputSize.width;
//   Size destinationSize = sourceSize * scale;

//   return FittedSizes(sourceSize, destinationSize);
// }

class HypotheekDossierCenter extends StatelessWidget {
  final HypotheekDossier hd;

  const HypotheekDossierCenter({super.key, required this.hd});

  @override
  Widget build(BuildContext context) {
    final nf = MyNumberFormat(context);
    double somLening = 0.0;
    double somAflossen = 0.0;
    double somRente = 0.0;
    double restSchuld = 0.0;
    String geenTermijn = '';

    bool voegSomToe(Hypotheek h) {
      if (h.termijnen.isNotEmpty) {
        final laatsteTermijn = h.termijnen.last;
        somAflossen += laatsteTermijn.aflossenTotaal;
        somRente += laatsteTermijn.renteTotaal;
        restSchuld += laatsteTermijn.leningNaAflossen;
        return true;
      } else {
        geenTermijn = h.omschrijving.isEmpty ? h.id : h.omschrijving;
        return false;
      }
    }

    for (Hypotheek h in hd.eersteHypotheken) {
      if (h.lening == 0.0) {
        continue;
      }

      somLening += h.lening;

      if (!voegSomToe(h)) {
        break;
      }

      Hypotheek vorige = h;
      Hypotheek? volgende = hd.hypotheken[h.volgende];

      while (volgende != null) {
        if (vorige.restSchuld < volgende.lening) {
          somLening += volgende.lening - vorige.restSchuld;
          restSchuld -= vorige.restSchuld;
        } else {
          restSchuld -= volgende.lening;
        }

        if (!voegSomToe(volgende)) {
          break;
        }

        volgende = hd.hypotheken[volgende.volgende];
      }
    }

    if (somLening == 0.0) {
      return const Center(
          child: Text(
        'Geen lening',
        textAlign: TextAlign.center,
        textScaleFactor: 3.0,
      ));
    }

    if (geenTermijn.isNotEmpty) {
      return const Center(
          child: Text(
        'Geen Termijn:\ngeenTermijn',
        textAlign: TextAlign.center,
        textScaleFactor: 3.0,
      ));
    }

    final som = somLening + somRente;

    final pieces = <PiePiece>[
      PiePiece(
          value: somAflossen, name: 'Afgelost', color: const Color(0xFFF6E7D8)),
      if (restSchuld > 0.0)
        PiePiece(
            value: restSchuld,
            name: 'RestSchuld',
            color: const Color(0xFFF68989)),
      PiePiece(value: somRente, name: 'Rente', color: const Color(0xFFC65D7B)),
    ];

    final overlayPiePiece = <PiePiece>[
      PiePiece(value: somLening, name: 'Lening', color: const Color(0xFF874356))
    ];
    // calculateWidthFromText(
    //     textToWidth: widthLegend,
    //     text: '99.9%',
    //     textStyle: textStyleTable,
    //     textScaleFactor: textScaleFactor);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Stack(
            children: [
              Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: PieChart(
                  padding: 4.0,
                  total: som,
                  pieces: pieces,
                  child: Container(),
                ),
              ),
              Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: PieChart(
                  paddingRatio: 1.0 / 6.0,
                  total: som,
                  pieces: overlayPiePiece,
                  child: Container(),
                ),
              ),
            ],
          ),
        ),
        Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: [...overlayPiePiece, ...pieces]
                .map((PiePiece e) => LegendItem(
                      minValue: 20.0,
                      valueToText: (double v) =>
                          '${nf.parseDblToText(v, format: '#0')}; ${(v / som * 100.0).round()}%',
                      item: e,
                    ))
                .toList())
      ],
    );
  }
}
