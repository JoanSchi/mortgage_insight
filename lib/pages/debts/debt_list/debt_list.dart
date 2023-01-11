import 'package:flutter/material.dart';
import 'package:nested_scroll_view_3m/nested_scroll_view_3m.dart';
import 'debt_card.dart';

class GridList<T> extends StatefulWidget {
  final bool nested;
  final List<T> list;

  GridList({Key? key, required this.list, required this.nested})
      : super(key: key);

  @override
  State<GridList<T>> createState() => _GridListState<T>();
}

class _GridListState<T> extends State<GridList<T>> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        if (widget.nested)
          SliverOverlapInjector(
            // This is the flip side of the SliverOverlapAbsorber
            // above.
            handle: NestedScrollView3M.sliverOverlapAbsorberHandleFor(context),
          ),
        if (widget.list.length > 0)
          SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 600.0,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 1.5,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return SchuldCard<T>(item: widget.list[index]);
                },
                childCount: widget.list.length,
              )),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 72.0,
          ),
        )
      ],
    );
  }
}
