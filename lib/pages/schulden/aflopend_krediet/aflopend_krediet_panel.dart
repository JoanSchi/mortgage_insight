import 'package:flutter/material.dart';
import 'aflopend_krediet_segmenten.dart';
import 'aflopend_krediet_overview.dart';
import 'aflopend_krediet_tabel.dart';

class AflopendKredietPanel extends StatelessWidget {
  final double topPadding;
  final double bottomPadding;

  const AflopendKredietPanel({
    Key? key,
    required this.topPadding,
    required this.bottomPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverList(
            delegate: SliverChildListDelegate.fixed(
          [
            SizedBox(height: topPadding),
            const AflopendKredietOptiePanel(),
            const Divider(),
            const AflopendkredietInvulPanel(),
            const OverzichtLening(),
            const AflopendKredietErrorWidget(),
            SizedBox(height: topPadding),
          ],
        )),
        AflopendKredietTabel(),
      ],
    );
  }
}
