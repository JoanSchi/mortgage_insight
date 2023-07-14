import 'package:flutter/material.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek/hypotheek.dart';
import '../../my_widgets/custom_fitted_box.dart';
import '../../my_widgets/mortgage_card.dart';
import '../../utilities/my_number_format.dart';
import 'package:intl/intl.dart';
import '../../utilities/date.dart';

class HypotheekCard extends StatelessWidget {
  final Hypotheek hypotheek;
  final VoidCallback verwijderen;
  final VoidCallback bewerken;

  const HypotheekCard({
    super.key,
    required this.hypotheek,
    required this.verwijderen,
    required this.bewerken,
  });

  @override
  Widget build(BuildContext context) {
    late final nf = MyNumberFormat(context);

    final startDatum =
        DateFormat.yMMMMd(localeToString(context)).format(hypotheek.startDatum);

    final bottom = Text(
        'Termijn: ${hypotheek.aflosTermijnInJaren} J ; Periode: ${hypotheek.periodeInJaren} (J) ; Rente: ${hypotheek.rente} %');

    return MoCard(
      onLongPress: bewerken,
      color: const Color(0xFFe6f5fa),
      top: SizedBox(
        height: 56.0,
        child: Stack(children: [
          Positioned(
            left: 8.0,
            top: 6.0,
            bottom: 8.0,
            child: Center(child: Text(startDatum, textScaleFactor: 1.2)),
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
            top: 22.0,
            right: 0.0,
            bottom: 44.0,
            child: CustomFittedBox(
                customApplyBoxFit: _defaultBoxFit,
                child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 80.0),
                    child: Text(
                      nf.parseDoubleToText(hypotheek.lening),
                      textAlign: TextAlign.center,
                    ))),
          ),
        ],
      ),
      bottom: bottom,
    );
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

FittedSizes _defaultBoxFit(BoxFit fit, Size inputSize, Size outputSize) {
  if (inputSize.height <= 0.0 ||
      inputSize.width <= 0.0 ||
      outputSize.height <= 0.0 ||
      outputSize.width <= 0.0) return const FittedSizes(Size.zero, Size.zero);

  Size sourceSize = inputSize;

  final scale = (outputSize.width / 3.0 * 2.0) / inputSize.width;
  Size destinationSize = sourceSize * scale;

  return FittedSizes(sourceSize, destinationSize);
}
