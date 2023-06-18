import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/inkomen/gegevens/inkomen.dart';
import 'package:mortgage_insight/model/nl/provider/hypotheek_document_provider.dart';
import '../../my_widgets/custom_fitted_box.dart';
import '../../my_widgets/mortgage_card.dart';
import '../../utilities/my_number_format.dart';
import 'package:intl/intl.dart';
import '../../utilities/date.dart';
import 'inkomen_bewerken/inkomen_bewerken_model.dart';

class InkomenCard extends ConsumerStatefulWidget {
  final Inkomen inkomenItem;
  final bool partner;

  const InkomenCard(
      {Key? key, required this.inkomenItem, required this.partner})
      : super(key: key);

  @override
  ConsumerState<InkomenCard> createState() => _IncomeCardState();
}

class _IncomeCardState extends ConsumerState<InkomenCard> {
  late final nf = MyNumberFormat(context);

  @override
  Widget build(BuildContext context) {
    final ik = widget.inkomenItem;

    final monthYear =
        DateFormat.yMMMM(localeToString(context)).format(ik.datum);

    Widget? leftTop;
    Widget leftBottom;
    Widget? rightTop;
    Widget? rightBottom;

    if (ik.pensioen) {
      leftBottom = Text(ik.periodeInkomen == PeriodeInkomen.jaar
          ? 'Bruto jaarinkomen'
          : 'Bruto Mnd: ${nf.parseDoubleToText(ik.brutoInkomen)}');
      rightTop = const Text('Pensioen');
    } else {
      if (ik.periodeInkomen == PeriodeInkomen.jaar) {
        leftBottom = const Text('Bruto jaarinkomen');
      } else {
        leftBottom =
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Bruto Mnd: ${nf.parseDoubleToText(ik.brutoInkomen)}'),
          if (ik.vakantiegeld)
            Text(
                'Vakantiegeld (8%): ${nf.parseDoubleToText(ik.bedragVakantiegeld)}')
        ]);

        if (ik.dertiendeMaand) rightBottom = const Text('Dertiende mnd');
      }
    }

    return MoCard(
      onLongPress: edit,
      color: ik.pensioen
          ? const Color.fromARGB(255, 243, 248, 250)
          : const Color(0xFFe6f5fa),
      top: SizedBox(
        height: 56.0,
        child: Stack(children: [
          Positioned(
            left: 8.0,
            top: 6.0,
            bottom: 8.0,
            child: Center(child: Text(monthYear, textScaleFactor: 1.2)),
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
          if (leftTop != null)
            Positioned(
              left: 8.0,
              top: 8.0,
              child: leftTop,
            ),
          if (rightTop != null)
            Positioned(
              right: 8.0,
              top: 8.0,
              child: rightTop,
            ),

          Positioned(
            left: 8.0,
            bottom: 2.0,
            child: leftBottom,
          ),

          if (rightBottom != null)
            Positioned(
              right: 8.0,
              bottom: 2.0,
              child: rightBottom,
            ),
          // Positioned(
          //     right: 8.0,
          //     bottom: 6.0,
          //     width: 80.0,
          //     child: Image.asset(
          //       'graphics/card_lease_auto.png',
          //       color: theme.colorScheme.primaryContainer,
          //     )),
          // Positioned(
          //     right: 8.0,
          //     bottom: 0.0,
          //     child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.end,
          //         children: legend)),
          Positioned(
            left: 0.0,
            top: 22.0,
            right: 0.0,
            bottom: 44.0,
            child: CustomFittedBox(
                customApplyBoxFit: defaultIncomeFit,
                child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 80.0),
                    child: Text(
                      nf.parseDoubleToText(
                          ik.indexatieTotaalBrutoJaar(DateTime.now())),
                      textAlign: TextAlign.center,
                    ))),
          ),
        ],
      ),
    );
  }

  void edit() {
    ref.read(inkomenBewerkenViewProvider.notifier).bestaand(
          lijst: ref
              .read(hypotheekDocumentProvider)
              .inkomenOverzicht
              .lijst(partner: widget.partner),
          inkomen: widget.inkomenItem,
        );
    Beamer.of(context, root: true).beamToNamed('/document/inkomen/aanpassen');
  }

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        edit();
        break;
      case 'delete':
        ref.read(hypotheekDocumentProvider.notifier).inkomenVerwijderen(
            inkomen: widget.inkomenItem, partner: widget.partner);
        break;
    }
  }
}

FittedSizes defaultIncomeFit(BoxFit fit, Size inputSize, Size outputSize) {
  if (inputSize.height <= 0.0 ||
      inputSize.width <= 0.0 ||
      outputSize.height <= 0.0 ||
      outputSize.width <= 0.0) return const FittedSizes(Size.zero, Size.zero);

  Size sourceSize = inputSize;

  final scale = (outputSize.width / 3.0 * 2.0) / inputSize.width;
  Size destinationSize = sourceSize * scale;

  return FittedSizes(sourceSize, destinationSize);
}
