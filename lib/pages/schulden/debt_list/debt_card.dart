import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mortgage_insight/model/nl/schulden/autolease_verwerken.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import '../../../model/nl/hypotheek_container/hypotheek_container.dart';
import '../../../model/nl/schulden/remove_schulden_aflopend_krediet.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../my_widgets/custom_fitted_box.dart';
import '../../../my_widgets/mortgage_card.dart';
import '../../../my_widgets/summary_pie_chart/pie_chart.dart';
import '../../../utilities/MyNumberFormat.dart';
import '../../../utilities/date.dart';
import 'package:intl/intl.dart';

class SchuldCard extends StatelessWidget {
  final Schuld item;

  const SchuldCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return item.map(
        leaseAuto: (LeaseAuto value) => LeaseAutoCard(leaseAuto: value),
        aflopendKrediet: (AflopendKrediet value) =>
            OhNo(text: 'not implemented'),
        verzendKrediet: (VerzendKrediet value) => OhNo(text: 'not implemented'),
        doorlopendKrediet: (DoorlopendKrediet value) =>
            DoorlopendKredietCard(dk: value));
  }
}

class AflopendKredietCard extends ConsumerStatefulWidget {
  final RemoveAflopendKrediet ak;

  AflopendKredietCard({
    Key? key,
    required this.ak,
  }) : super(key: key);

  @override
  ConsumerState<AflopendKredietCard> createState() =>
      _AflopendKredietCardState();
}

class _AflopendKredietCardState extends ConsumerState<AflopendKredietCard> {
  late final nf = MyNumberFormat(context);

  @override
  Widget build(BuildContext context) {
    final ak = widget.ak;
    final theme = Theme.of(context);
    final huidigeDatum = DateUtils.dateOnly(DateTime.now());
    final dateStatus = ak.dateStatus(huidigeDatum);

    final beginDatumText =
        DateFormat.yMMMMd(localeToString(context)).format(ak.beginDatum);

    final eindDatumText =
        DateFormat.yMMMMd(localeToString(context)).format(ak.eindDatum);

    final piePieces = [
      PiePiece(
          value: ak.lening,
          name: 'Lening',
          color: _leningPieColor(ak.dateStatus(huidigeDatum))),
      PiePiece(value: ak.somInterest, name: 'Interest', color: Colors.black87)
    ];

    final legend = [
      LegendItem(
        item: piePieces[0],
        valueToText: (double v) => nf.parseDoubleToText(v, '#.00'),
      ),
      LegendItem(
        item: piePieces[1],
        valueToText: (double v) =>
            '${nf.parseDoubleToText(v, '#.00')} (${nf.parseDoubleToText(ak.rente, '#0.0')}%)',
      ),
    ];

    return MoCard(
      // positioneds: [
      //   Positioned(
      //       left: -100.0,
      //       bottom: -100.0,
      //       width: 225.0,
      //       height: 225.0,
      //       child: Container(
      //         decoration: BoxDecoration(
      //             color: theme.primaryColor, shape: BoxShape.circle),
      //       ))
      // ],
      onLongPress: edit,
      color: _backgroundColorCard(dateStatus), // Color(0xFFe6f5fa),
      top: SizedBox(
        height: 56.0,
        child: Stack(children: [
          Positioned(
            left: 8.0,
            top: 6.0,
            bottom: 8.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aflopend Krediet',
                ),
                if (ak.omschrijving.isNotEmpty)
                  Text(
                    '${ak.omschrijving}',
                  )
              ],
            ),
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
            left: 8.0,
            top: 8.0,
            child: Text(
              beginDatumText,
            ),
          ),
          Positioned(
              right: 8.0,
              top: 8.0,
              child: Text(
                eindDatumText,
              )),
          Positioned(
              left: 4.0,
              bottom: 4.0,
              width: 60.0,
              child: Image.asset(
                'graphics/card_aflopend_krediet.png',
                color: theme.colorScheme.primaryContainer,
              )),
          Positioned(
              right: 8.0,
              bottom: 0.0,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: legend)),
          Positioned(
            left: 0.0,
            top: 2.0,
            right: 0.0,
            bottom: 24.0,
            child: PieChart(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomFittedBox(
                  customApplyBoxFit: defaultPieApplyBoxFit,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: 40.0),
                    child: Text(
                      nf.parseDoubleToText(ak.termijnBedragMnd, '#0.0'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyText2
                          ?.copyWith(color: _maandLastTextColor(dateStatus)),
                    ),
                  ),
                ),
              ),
              useLine: true,
              pieces: piePieces,
              total: ak.somAnn,
            ),
          ),
        ],
      ),
    );
  }

  void edit() => {};

  // ref.read(routeEditPageProvider.notifier).editState =
  //     EditRouteState(route: routeDebtsEdit, object: widget.ak.copyWith());

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        edit();
        break;
      case 'delete':
        // ref.read(hypotheekContainerProvider.notifier).removeSchuld(widget.ak);
        break;
    }
  }
}

class DoorlopendKredietCard extends ConsumerStatefulWidget {
  final DoorlopendKrediet dk;

  DoorlopendKredietCard({
    Key? key,
    required this.dk,
  }) : super(key: key);

  @override
  ConsumerState<DoorlopendKredietCard> createState() =>
      _DoorlopendKredietCardCardState();
}

class _DoorlopendKredietCardCardState
    extends ConsumerState<DoorlopendKredietCard> {
  late final nf = MyNumberFormat(context);

  @override
  Widget build(BuildContext context) {
    final dk = widget.dk;
    final theme = Theme.of(context);

    final huidigeDatum = DateUtils.dateOnly(DateTime.now());
    final dateStatus = dk.dateStatus(huidigeDatum);

    final beginDatum =
        DateFormat.yMMMMd(localeToString(context)).format(dk.beginDatum);

    final eindDatum =
        DateFormat.yMMMMd(localeToString(context)).format(dk.eindDatum);

    return MoCard(
      // positioneds: [
      //   Positioned(
      //       right: -100.0,
      //       bottom: -100.0,
      //       width: 225.0,
      //       height: 225.0,
      //       child: Container(
      //         decoration: BoxDecoration(
      //             color: theme.primaryColor, shape: BoxShape.circle),
      //       ))
      // ],
      onLongPress: edit,
      color: _backgroundColorCard(
          dateStatus), //Color.fromARGB(255, 247, 251, 252), // Color(0xFFe6f5fa),
      top: SizedBox(
        height: 56.0,
        child: Stack(children: [
          Positioned(
            left: 8.0,
            top: 6.0,
            bottom: 8.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Doorlopend Krediet',
                ),
                if (dk.omschrijving.isNotEmpty)
                  Text(
                    '${dk.omschrijving}',
                  )
              ],
            ),
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
            left: 8.0,
            top: 8.0,
            child: Text(
              beginDatum,
            ),
          ),
          Positioned(
              right: 8.0,
              top: 8.0,
              child: Text(
                eindDatum,
              )),
          Positioned(
            left: 8.0,
            bottom: 2.0,
            child: Text('Krediet: ${nf.parseDoubleToText(dk.bedrag, '#0.0#')}'),
          ),
          Positioned(
              right: 8.0,
              bottom: 6.0,
              width: 60.0,
              child: Image.asset(
                'graphics/card_doorlopend_krediet.png',
                color: theme.colorScheme.primaryContainer,
              )),
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
              customApplyBoxFit: defaultPieApplyBoxFit,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 40.0),
                child: Text(
                  nf.parseDoubleToText(dk.maandLast(DateTime.now()), '#0.0'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: _maandLastTextColor(dateStatus)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void edit() => {};
  // TODO: Fix
  // ref.read(routeEditPageProvider.notifier).editState =
  // EditRouteState(route: routeDebtsEdit, object: widget.dk.copyWith());

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        edit();
        break;
      case 'delete':
        ref.read(hypotheekContainerProvider.notifier).removeSchuld(widget.dk);
        break;
    }
  }
}

class VerzendKredietCard extends ConsumerStatefulWidget {
  final VerzendKrediet vk;

  VerzendKredietCard({
    Key? key,
    required this.vk,
  }) : super(key: key);

  @override
  ConsumerState<VerzendKredietCard> createState() =>
      _VerzendKredietCardCardState();
}

class _VerzendKredietCardCardState extends ConsumerState<VerzendKredietCard> {
  late final nf = MyNumberFormat(context);

  @override
  Widget build(BuildContext context) {
    final vk = widget.vk;
    final theme = Theme.of(context);
    final huidigeDatum = DateUtils.dateOnly(DateTime.now());
    final dateStatus = vk.dateStatus(huidigeDatum);

    final beginDatum =
        DateFormat.yMMMMd(localeToString(context)).format(vk.beginDatum);

    final eindDatum =
        DateFormat.yMMMMd(localeToString(context)).format(vk.eindDatum);

    return MoCard(
      // positioneds: [
      //   Positioned(
      //       right: -100.0,
      //       bottom: -100.0,
      //       width: 225.0,
      //       height: 225.0,
      //       child: Container(
      //         decoration: BoxDecoration(
      //             color: theme.primaryColor, shape: BoxShape.circle),
      //       ))
      // ],
      onLongPress: edit,
      color: _backgroundColorCard(dateStatus),
      top: SizedBox(
        height: 56.0,
        child: Stack(children: [
          Positioned(
            left: 8.0,
            top: 6.0,
            bottom: 8.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verzend Krediet',
                ),
                if (vk.omschrijving.isNotEmpty)
                  Text(
                    '${vk.omschrijving}',
                  )
              ],
            ),
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
            left: 8.0,
            top: 8.0,
            child: Text(
              beginDatum,
            ),
          ),
          Positioned(
              right: 8.0,
              top: 8.0,
              child: Text(
                eindDatum,
              )),
          Positioned(
            left: 8.0,
            bottom: 2.0,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Termijn: ${nf.parseDoubleToText(vk.mndBedrag, '#0.0#')}'),
              if (vk.heeftSlotTermijn && vk.slotTermijn != 0.0)
                Text(
                    'Slottermijn: ${nf.parseDoubleToText(vk.slotTermijn, '#0.0#')}'),
              Text('Total: ${nf.parseDoubleToText(vk.totaalBedrag, '#0.0#')}')
            ]),
          ),
          Positioned(
              right: 8.0,
              bottom: 6.0,
              width: 50.0,
              child: Image.asset('graphics/card_verzend_krediet.png',
                  color: theme.colorScheme.primaryContainer)),
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
              customApplyBoxFit: defaultPieApplyBoxFit,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: 40.0),
                child: Text(
                  nf.parseDoubleToText(vk.maandLast(DateTime.now()), '#0.0'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: _maandLastTextColor(dateStatus)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void edit() => {};
  // TODO: Fix
  // ref.read(routeEditPageProvider.notifier).editState =
  // EditRouteState(route: routeDebtsEdit, object: widget.vk.copyWith());

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        edit();
        break;
      case 'delete':
        // ref.read(hypotheekContainerProvider.notifier).removeSchuld(widget.vk);
        break;
    }
  }
}

class LeaseAutoCard extends ConsumerStatefulWidget {
  final LeaseAuto leaseAuto;

  LeaseAutoCard({
    Key? key,
    required this.leaseAuto,
  }) : super(key: key);

  @override
  ConsumerState<LeaseAutoCard> createState() => _LeaseAutoCardState();
}

class _LeaseAutoCardState extends ConsumerState<LeaseAutoCard> {
  late final nf = MyNumberFormat(context);

  @override
  Widget build(BuildContext context) {
    final leaseAuto = widget.leaseAuto;
    final theme = Theme.of(context);

    final huidigeDatum = DateUtils.dateOnly(DateTime.now());
    final dateStatus = leaseAuto.dateStatus(huidigeDatum);

    Map<String, dynamic> overzicht =
        LeaseAutoVerwerken.overzicht(leaseAuto, huidigeDatum);

    List<Widget> overzichtList = overzicht.containsKey('fout')
        ? [Text(overzicht['fout'])]
        : [
            Text(
                'Registrate: ${nf.parseDoubleToText(overzicht['registratiePercentage'], '#0.0#')}%:'),
            Text(
                ' - Mnd: ${nf.parseDoubleToText(overzicht['maandlast'], '#0.0#')}'),
            Text(
                ' - Total: ${nf.parseDoubleToText(overzicht['registratieBedrag'], '#0.0#')}')
          ];

    final beginDatum =
        DateFormat.yMMMMd(localeToString(context)).format(leaseAuto.beginDatum);

    final eindDatum =
        DateFormat.yMMMMd(localeToString(context)).format(leaseAuto.eindDatum);

    return MoCard(
      onLongPress: edit,
      color: _backgroundColorCard(dateStatus), // Color(0xFFe6f5fa),
      top: SizedBox(
        height: 56.0,
        child: Stack(children: [
          Positioned(
            left: 8.0,
            top: 6.0,
            bottom: 8.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Operationele Auto Lease',
                ),
                if (leaseAuto.omschrijving.isNotEmpty)
                  Text(
                    '${leaseAuto.omschrijving}',
                  )
              ],
            ),
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
            left: 8.0,
            top: 8.0,
            child: Text(
              beginDatum,
            ),
          ),
          Positioned(
              right: 8.0,
              top: 8.0,
              child: Text(
                eindDatum,
              )),
          Positioned(
            left: 8.0,
            bottom: 2.0,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: overzichtList),
          ),
          Positioned(
              right: 8.0,
              bottom: 6.0,
              width: 80.0,
              child: Image.asset(
                'graphics/card_lease_auto.png',
                color: theme.colorScheme.primaryContainer,
              )),
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
              customApplyBoxFit: defaultPieApplyBoxFit,
              child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 40.0),
                  child: Text(
                      nf.parseDoubleToText(
                          leaseAuto.maandLast(DateTime.now()), '#0.0'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: _maandLastTextColor(dateStatus)))),
            ),
          ),
        ],
      ),
    );
  }

  void edit() => {};
  // TODO: Fix
  // ref.read(routeEditPageProvider.notifier).editState =
  // EditRouteState<Schuld>(
  //     route: routeDebtsEdit, object: widget.ola.copyWith());

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        edit();
        break;
      case 'delete':
        ref
            .read(hypotheekContainerProvider.notifier)
            .removeSchuld(widget.leaseAuto);
        break;
    }
  }
}

Color _leningPieColor(DateStatus status) {
  switch (status) {
    case DateStatus.now:
      return Color.fromARGB(255, 219, 168, 2);
    case DateStatus.before:
      return Color.fromARGB(255, 38, 123, 151);
    case DateStatus.after:
      return Color.fromARGB(
          255, 153, 204, 191); //Color.fromARGB(255, 44, 175, 121);
  }
}

Color _maandLastTextColor(DateStatus status) {
  switch (status) {
    case DateStatus.now:
      return Color.fromARGB(255, 219, 168, 2);
    case DateStatus.before:
      return Color.fromARGB(255, 38, 123, 151);
    case DateStatus.after:
      return Color.fromARGB(255, 119, 170, 157);
  }
}

Color _backgroundColorCard(DateStatus status) {
  switch (status) {
    case DateStatus.now:
      return Color.fromARGB(255, 250, 243, 222);
    case DateStatus.before:
      return Color(0xFFe6f5fa);
    case DateStatus.after:
      return Color.fromARGB(255, 241, 253, 236);
  }
}
