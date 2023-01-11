import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/hypotheek_container/hypotheek_container.dart';
import '../../model/nl/hypotheek/hypotheek.dart';
import '../../my_widgets/custom_fitted_box.dart';
import '../../my_widgets/mortgage_card.dart';
import '../../utilities/MyNumberFormat.dart';
import 'package:intl/intl.dart';
import '../../utilities/date.dart';

class HypotheekCard extends ConsumerStatefulWidget {
  final Hypotheek hypotheek;

  HypotheekCard({
    Key? key,
    required this.hypotheek,
  }) : super(key: key);

  @override
  ConsumerState<HypotheekCard> createState() => _HypotheekCardState();
}

class _HypotheekCardState extends ConsumerState<HypotheekCard> {
  late final nf = MyNumberFormat(context);

  @override
  Widget build(BuildContext context) {
    final h = widget.hypotheek;

    final startDatum =
        DateFormat.yMMMMd(localeToString(context)).format(h.startDatum);

    final bottom = Text(
        'Aflostermijn: ${h.aflosTermijnInMaanden ~/ 12} J ; RentePeriode: ${h.aflosTermijnInMaanden ~/ 12} (J) ; Rente: ${h.rente} %');

    return MoCard(
      color: Color(0xFFe6f5fa),
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
                customApplyBoxFit: defaultIncomeFit,
                child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 80.0),
                    child: Text(
                      nf.parseDoubleToText(h.lening),
                      textAlign: TextAlign.center,
                    ))),
          ),
        ],
      ),
      bottom: bottom,
    );
  }

  void edit() {
    final hypotheekContainer = ref.read(hypotheekContainerProvider);
    // TODO:
    // ref.read(routeEditPageProvider.notifier).editState = EditRouteState(
    //     route: routeMortgageEdit,
    //     object: HypotheekViewModel(
    //         inkomenLijst: hypotheekContainer.inkomenLijst(),
    //         inkomenLijstPartner: hypotheekContainer.inkomenLijst(partner: true),
    //         profiel:
    //             hypotheekContainer.huidigeHypotheekProfielContainer!.profiel,
    //         schuldenLijst: hypotheekContainer.schuldenContainer.list,
    //         id: widget.hypotheek.id));
  }

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        edit();
        break;
      case 'delete':
        ref
            .read(hypotheekContainerProvider.notifier)
            .removeHypotheek(widget.hypotheek);

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
