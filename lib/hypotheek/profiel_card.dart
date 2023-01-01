import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import 'package:mortgage_insight/routes/routes_items.dart';
import 'package:mortgage_insight/state_manager/edit_state.dart';
import '../model/nl/hypotheek/hypotheek.dart';
import '../my_widgets/mortgage_card.dart';
import '../my_widgets/summary_pie_chart/pie_chart.dart';
import '../utilities/MyNumberFormat.dart';
import 'profiel_bewerken/hypotheek_profiel_model.dart';

class ProfielCard extends ConsumerStatefulWidget {
  final HypotheekProfiel profiel;
  final String? selected;

  ProfielCard({
    Key? key,
    required this.profiel,
    required this.selected,
  }) : super(key: key);

  @override
  ConsumerState<ProfielCard> createState() => _ProfielCardState();
}

class _ProfielCardState extends ConsumerState<ProfielCard> {
  late final nf = MyNumberFormat(context);
  HypotheekProfiel get profiel => widget.profiel;

  @override
  Widget build(BuildContext context) {
    final omschrijving =
        profiel.omschrijving.isEmpty ? profiel.id : profiel.omschrijving;

    return MoCard(
      onTap: () => selecteerProfiel(profiel.id),
      onLongPress: edit,
      color: widget.selected == profiel.id
          ? Color.fromARGB(255, 246, 250, 230)
          : Color(0xFFe6f5fa),
      top: SizedBox(
        height: 56.0,
        child: Stack(children: [
          Positioned(
            left: 4.0,
            top: 6.0,
            bottom: 8.0,
            child: Row(children: [
              Radio<String>(
                  value: profiel.id,
                  groupValue: widget.selected,
                  onChanged: selecteerProfiel),
              Text(omschrijving, textScaleFactor: 1.2)
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
              child: ProfielCenter(
                profiel: profiel,
              )),
        ],
      ),
      // bottom: bottom,
    );
  }

  void selecteerProfiel(String? id) {
    if (id == null) return;

    ref
        .read(hypotheekContainerProvider)
        .changeSelectedHypotheekContainerProfiel(id);
    ref.read(pageHypotheekProvider).page = 1;
  }

  void edit() {
    final profielContainer = ref.read(hypotheekContainerProvider);
// TODO: Fix
    // ref.read(routeEditPageProvider.notifier).editState = EditRouteState(
    //   route: routeNieweHypotheekProfielEdit,
    //   object: HypotheekProfielViewModel(
    //       hypotheekProfielen: profielContainer.container.hypotheekProfielen,
    //       profiel: profielContainer.huidigeHypotheekProfielContainer?.profiel),
    // );
  }

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        edit();
        break;
      case 'delete':
        ref
            .read(hypotheekContainerProvider.notifier)
            .removeProfielHypotheek(widget.profiel);

        break;
    }
  }
}

FittedSizes defaultIncomeFit(_fit, Size inputSize, Size outputSize) {
  if (inputSize.height <= 0.0 ||
      inputSize.width <= 0.0 ||
      outputSize.height <= 0.0 ||
      outputSize.width <= 0.0) return const FittedSizes(Size.zero, Size.zero);

  Size sourceSize = inputSize;

  final scale = (outputSize.width / 3.0 * 2.0) / inputSize.width;
  Size destinationSize = sourceSize * scale;

  return FittedSizes(sourceSize, destinationSize);
}

class ProfielCenter extends StatefulWidget {
  final HypotheekProfiel profiel;
  ProfielCenter({Key? key, required this.profiel}) : super(key: key);

  @override
  State<ProfielCenter> createState() => _ProfielCenterState();
}

class _ProfielCenterState extends State<ProfielCenter> {
  late MyNumberFormat nf = MyNumberFormat(context);

  @override
  Widget build(BuildContext context) {
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

    for (Hypotheek h in widget.profiel.eersteHypotheken) {
      if (h.lening == 0.0) {
        continue;
      }

      somLening += h.lening;

      if (!voegSomToe(h)) {
        break;
      }

      Hypotheek vorige = h;
      Hypotheek? volgende = widget.profiel.hypotheken[h.volgende];

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

        volgende = widget.profiel.hypotheken[volgende.volgende];
      }
    }

    if (somLening == 0.0) {
      return Center(
          child: Text(
        'Geen lening',
        textAlign: TextAlign.center,
        textScaleFactor: 3.0,
      ));
    }

    if (geenTermijn.isNotEmpty) {
      return Center(
          child: Text(
        'Geen Termijn:\ngeenTermijn',
        textAlign: TextAlign.center,
        textScaleFactor: 3.0,
      ));
    }

    final som = somLening + somRente;

    final pieces = <PiePiece>[
      PiePiece(value: somAflossen, name: 'Afgelost', color: Color(0xFFF6E7D8)),
      if (restSchuld > 0.0)
        PiePiece(
            value: restSchuld, name: 'RestSchuld', color: Color(0xFFF68989)),
      PiePiece(value: somRente, name: 'Rente', color: Color(0xFFC65D7B)),
    ];

    final overlayPiePiece = <PiePiece>[
      PiePiece(value: somLening, name: 'Lening', color: Color(0xFF874356))
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
                  child: Container(),
                  total: som,
                  pieces: pieces,
                ),
              ),
              Positioned(
                left: 0.0,
                top: 0.0,
                right: 0.0,
                bottom: 0.0,
                child: PieChart(
                  paddingRatio: 1.0 / 6.0,
                  child: Container(),
                  total: som,
                  pieces: overlayPiePiece,
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
                          '${nf.parseDblToText(v, format: '#0')}; ${(v / som * 100).round()}%',
                      item: e,
                    ))
                .toList())
      ],
    );
  }
}
