// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mortgage_insight/model/nl/schulden/autolease_verwerken.dart';
import '../../../model/nl/schulden/schulden.dart';
import '../../../my_widgets/custom_fitted_box.dart';
import '../../../my_widgets/mortgage_card.dart';
import '../../../my_widgets/summary_pie_chart/pie_chart.dart';
import '../../../utilities/my_number_format.dart';
import '../../../utilities/date.dart';

class AflopendKredietCard extends StatelessWidget {
  final AflopendKrediet ak;
  final VoidCallback aanpassen;
  final VoidCallback verwijderen;

  const AflopendKredietCard(
      {Key? key,
      required this.ak,
      required this.aanpassen,
      required this.verwijderen})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    final nf = MyNumberFormat(context);
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
      onLongPress: aanpassen,
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
                const Text(
                  'Aflopend Krediet',
                ),
                if (ak.omschrijving.isNotEmpty)
                  Text(
                    ak.omschrijving,
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
                color: theme.colorScheme.onSurface,
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
              useLine: true,
              pieces: piePieces,
              total: ak.somAnn,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomFittedBox(
                  customApplyBoxFit: defaultPieApplyBoxFit,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(minWidth: 40.0),
                    child: Text(
                      nf.parseDoubleToText(ak.termijnBedragMnd, '#0.0'),
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: _maandLastTextColor(dateStatus)),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        aanpassen();
        break;
      case 'delete':
        verwijderen();
        break;
    }
  }
}

class DoorlopendKredietCard extends StatelessWidget {
  final DoorlopendKrediet dk;
  final VoidCallback aanpassen;
  final VoidCallback verwijderen;

  const DoorlopendKredietCard({
    Key? key,
    required this.dk,
    required this.aanpassen,
    required this.verwijderen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nf = MyNumberFormat(context);
    final theme = Theme.of(context);

    final huidigeDatum = DateUtils.dateOnly(DateTime.now());
    final dateStatus = dk.dateStatus(huidigeDatum);

    final beginDatum =
        DateFormat.yMMMMd(localeToString(context)).format(dk.beginDatum);

    final eindDatum =
        DateFormat.yMMMMd(localeToString(context)).format(dk.eindDatum);

    return MoCard(
      onLongPress: aanpassen,
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
                const Text(
                  'Doorlopend Krediet',
                ),
                if (dk.omschrijving.isNotEmpty)
                  Text(
                    dk.omschrijving,
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
                color: theme.colorScheme.onSurface,
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
                constraints: const BoxConstraints(minWidth: 40.0),
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

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        aanpassen();
        break;
      case 'delete':
        verwijderen();
        break;
    }
  }
}

class VerzendKredietCard extends StatelessWidget {
  final VerzendKrediet vk;
  final VoidCallback aanpassen;
  final VoidCallback verwijderen;

  const VerzendKredietCard({
    Key? key,
    required this.vk,
    required this.aanpassen,
    required this.verwijderen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nf = MyNumberFormat(context);
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
      onLongPress: aanpassen,
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
                const Text(
                  'Verzend Krediet',
                ),
                if (vk.omschrijving.isNotEmpty)
                  Text(
                    vk.omschrijving,
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
                  color: theme.colorScheme.onSurface)),
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
                constraints: const BoxConstraints(minWidth: 40.0),
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

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        aanpassen();
        break;
      case 'delete':
        verwijderen();
        break;
    }
  }
}

class LeaseAutoCard extends StatelessWidget {
  final LeaseAuto leaseAuto;
  final VoidCallback aanpassen;
  final VoidCallback verwijderen;

  const LeaseAutoCard({
    Key? key,
    required this.leaseAuto,
    required this.aanpassen,
    required this.verwijderen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nf = MyNumberFormat(context);
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
      onLongPress: aanpassen,
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
                const Text(
                  'Operationele Auto Lease',
                ),
                if (leaseAuto.omschrijving.isNotEmpty)
                  Text(
                    leaseAuto.omschrijving,
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
                color: theme.colorScheme.onSurface,
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
                  constraints: const BoxConstraints(minWidth: 40.0),
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

  void onSelected(String selected) {
    switch (selected) {
      case 'edit':
        aanpassen();
        break;
      case 'delete':
        verwijderen();
        break;
    }
  }
}

Color _leningPieColor(DateStatus status) {
  switch (status) {
    case DateStatus.now:
      return const Color.fromARGB(255, 219, 168, 2);
    case DateStatus.before:
      return const Color.fromARGB(255, 38, 123, 151);
    case DateStatus.after:
      return const Color.fromARGB(
          255, 153, 204, 191); //Color.fromARGB(255, 44, 175, 121);
  }
}

Color _maandLastTextColor(DateStatus status) {
  switch (status) {
    case DateStatus.now:
      return const Color.fromARGB(255, 219, 168, 2);
    case DateStatus.before:
      return const Color.fromARGB(255, 38, 123, 151);
    case DateStatus.after:
      return const Color.fromARGB(255, 119, 170, 157);
  }
}

Color _backgroundColorCard(DateStatus status) {
  switch (status) {
    case DateStatus.now:
      return const Color.fromARGB(255, 250, 243, 222);
    case DateStatus.before:
      return const Color(0xFFe6f5fa);
    case DateStatus.after:
      return const Color.fromARGB(255, 241, 253, 236);
  }
}
