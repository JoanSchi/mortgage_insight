import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import '../../../model/nl/schulden/schulden.dart';
import 'debt_card.dart';

class GridList extends StatelessWidget {
  final bool nested;
  final IList<Schuld> list;

  GridList({Key? key, required this.list, required this.nested})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (nested)
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
          ),
        if (list.length > 0)
          SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final schuld = list[index];
                  return SchuldCard(
                    item: schuld,
                  );
                },
                childCount: list.length,
              )),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 72.0,
          ),
        )
      ],
    );
  }

  void onSelected(Schuld schuld, String selected) {
    switch (selected) {
      case 'edit':
        break;
      case 'delete':
        //ref.read(hypotheekContainerProvider.notifier).remmoveSchuld(widget.ak);
        break;
    }
  }
}
