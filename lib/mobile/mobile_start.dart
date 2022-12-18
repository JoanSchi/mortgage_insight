import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/nl/hypotheek_container/hypotheek_container.dart';
import 'dart:math' as math;
import '../routes/main_route.dart';

class Home extends ConsumerStatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

const documents = [
  'De Zandraket 1',
  'De kader 1',
  'Stationstraat 5',
  'Buxesrupsstraat 21'
];

class _HomeState extends ConsumerState<Home> {
  @override
  void didUpdateWidget(Home oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Theme(
      data: theme,
      child: Scaffold(
        body: Container(
          color: theme.primaryColor,
          // decoration: BoxDecoration(
          // gradient: LinearGradient(
          //   begin: Alignment.centerLeft,
          //   end: Alignment
          //       .centerRight, // 10% of the width, so there are ten blinds.
          //   colors: <Color>[
          //     Color(0xFF0088aa),
          //     Color(0xFF55ddff),
          //   ], // red to yellow
          //   tileMode: TileMode.repeated, // repeats the gradient over the canvas
          // ),
          // ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 200.0,
                        child: Stack(
                          children: [
                            Positioned(
                                left: 0.0,
                                right: 0.0,
                                top: 0.0,
                                bottom: 0.0,
                                child: Image.asset(
                                  'graphics/mortgage_logo.png',
                                  color: Colors.white,
                                  fit: BoxFit.fitHeight,
                                )),
                            Positioned(
                              top: 16.0,
                              right: 16.0,
                              child: IconButton(
                                  onPressed: () => resetHypotheekInzicht(ref),
                                  icon: Icon(Icons.rotate_left)),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      Text(
                        'Hypotheek Inzicht',
                        textScaleFactor: 2.0,
                        style: TextStyle(color: Colors.white),
                      ),
                      SizedBox(
                        height: 16.0,
                      ),
                    ],
                  ),
                ),

                // New Document
                SliverToBoxAdapter(child: NewDocument()),

                SliverToBoxAdapter(
                    child: SizedBox(
                  height: 16.0,
                )),

                SliverToBoxAdapter(
                    child: Container(
                  padding: const EdgeInsets.only(
                      left: 8.0, top: 16.0, right: 8.0, bottom: 8.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: Column(
                    children: [
                      Text(
                        'Documenten',
                        textScaleFactor: 1.5,
                      ),
                      Divider(
                        color: theme.primaryColor,
                      )
                    ],
                  ),
                )),

                // Next, create a SliverList
                SliverList(
                  // Use a delegate to build items as they're scrolled on screen.
                  delegate: SliverChildBuilderDelegate(
                    // The builder function returns a ListTile with a title that
                    // displays the index of the current item.
                    (context, index) {
                      return Container(
                        color: Colors.white,
                        // color: Colors.white,
                        // clipBehavior: Clip.antiAlias,
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: [
                            ListTile(
                              // leading: Image.asset(
                              //   'graphics/card_calculator.png',
                              //   width: 64.0,
                              //   height: 64.0,
                              //   fit: BoxFit.fitWidth,
                              // ),
                              title: Text(documents[index]),
                              subtitle: Text(
                                '17 februari 2021',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6)),
                              ),
                            ),
                          ],
                        ),
                      );
                    },

                    // Builds 1000 ListTiles
                    childCount: documents.length,
                  ),
                ),

                SliverToBoxAdapter(
                    child: Container(
                  height: 20.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                )),

                //End
                SliverToBoxAdapter(
                    child: SizedBox(
                  height: 16.0,
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NewDocument extends ConsumerStatefulWidget {
  const NewDocument({Key? key}) : super(key: key);

  @override
  _NewDocumentState createState() => _NewDocumentState();
}

enum NewDocumentOptions { pay_off, mortgage, custom }

class _NewDocumentState extends ConsumerState<NewDocument>
    with SingleTickerProviderStateMixin {
  late TextEditingController _nameController =
      TextEditingController(text: 'Mijn Hypotheek Inzicht');

  final customOptionList = [
    Enabled(title: 'Maximale lening', subtitle: 'Afgeleid van het Nibud'),
    Enabled(title: 'Schulden', subtitle: 'Invloed op hoogte lening'),
    Enabled(title: 'Teruggave', subtitle: 'Teruggave belastingdienst'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Nieuw Document',
              textScaleFactor: 1.5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Naam')),
                SizedBox(
                  height: 16.0,
                ),
                Align(
                    alignment: Alignment.centerRight,
                    child: Material(
                        child: TextButton(
                            onPressed: () =>
                                ref.read(routeMainProvider).push('/document'),
                            child: Text('Creëer')))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Enabled {
  String title;
  String subtitle;
  bool enabled;

  Enabled({
    required this.title,
    required this.subtitle,
    this.enabled = false,
  });

  Enabled copyWith({
    String? title,
    String? subtitle,
    bool? enabled,
  }) {
    return Enabled(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      enabled: enabled ?? this.enabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'enabled': enabled,
    };
  }

  factory Enabled.fromMap(Map<String, dynamic> map) {
    return Enabled(
      title: map['title'],
      subtitle: map['subtitle'],
      enabled: map['enabled'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Enabled.fromJson(String source) =>
      Enabled.fromMap(json.decode(source));

  @override
  String toString() =>
      'Enabled(title: $title, subtitle: $subtitle, enabled: $enabled)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Enabled &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.enabled == enabled;
  }

  @override
  int get hashCode => title.hashCode ^ subtitle.hashCode ^ enabled.hashCode;
}

class GroupButton extends StatefulWidget {
  final List<Enabled> list;

  GroupButton({Key? key, required this.list}) : super(key: key);

  @override
  _GroupButtonState createState() => _GroupButtonState();
}

class _GroupButtonState extends State<GroupButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 56.0),
      child: Column(
          children: widget.list
              .map((Enabled item) => CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(item.title),
                  subtitle: Text(item.subtitle),
                  value: item.enabled,
                  onChanged: (bool? value) {
                    setState(() {
                      item.enabled = value!;
                    });
                  }))
              .toList()),
    );
  }
}

typedef BuildHeader = Widget Function(
    {required double minExtent,
    required double maxExtent,
    required double shrinkOffset});

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.buildHeader,
  });

  final double minHeight;
  final double maxHeight;
  final BuildHeader buildHeader;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(
        child: buildHeader(
            minExtent: minExtent,
            maxExtent: maxExtent,
            shrinkOffset: shrinkOffset));
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}
