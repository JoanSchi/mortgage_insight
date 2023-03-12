import 'package:flutter/material.dart';
import 'package:ltrb_navigation_drawer/drawer_layout.dart';
import '../my_widgets/summary_pie_chart/pie_chart.dart';
import '../utilities/my_number_format.dart';

class Document {
  final String naam;
  final DateTime datum;
  final double lening;
  final double rente;

  const Document({
    required this.naam,
    required this.datum,
    required this.lening,
    required this.rente,
  });
}

final documentsMobileVoorbeelden = [
  Document(
      naam: 'De Zandraket 1',
      datum: DateTime(2014, 6, 12),
      lening: 18800.0,
      rente: 9000.0),
  Document(
      naam: 'De kader 1',
      datum: DateTime(2018, 3, 7),
      lening: 25000.0,
      rente: 4000.0),
  Document(
    naam: 'Stationstraat 5',
    datum: DateTime(2019, 1, 1),
    lening: 12000.0,
    rente: 3000.0,
  ),
  Document(
      naam: 'Buxesrupsstraat 21',
      datum: DateTime(2014, 6, 12),
      lening: 18800.0,
      rente: 9000.0)
];

const List<Color> _colors = [
  Color(0xFFaad400),
  Color(0xFFffd42a),
];

class MobileDocumentCard extends StatelessWidget {
  final Document document;
  final int index;
  final int length;
  final double? minOverflowWidth;

  const MobileDocumentCard(
      {Key? key,
      required this.document,
      required this.index,
      required this.length,
      this.minOverflowWidth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final nf = MyNumberFormat(context);
    double lening = document.lening;
    double rente = document.rente;
    double totaal = lening + rente;

    Widget center = Column(children: [
      Text(document.naam),
      const Divider(),
      Row(children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text('Lening'),
          Text('Rente'),
          Text('Afgelost'),
          Text('Totaal')
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
          Text(' : '),
          Text(' : '),
          Text(' : '),
          Text(' : ')
        ]),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(nf.parseDblToText(lening)),
          Text(nf.parseDblToText(rente)),
          Text(nf.parseDblToText(0.0)),
          Text(nf.parseDblToText(totaal))
        ]),
        const SizedBox(
          width: 8.0,
        ),
        Expanded(
          child: SizedBox(
            height: 150,
            child: PieChart(
              pieces: [
                PiePiece(
                    value: rente / totaal * 100.0,
                    name: 'Rente',
                    color: Colors.black),
                PiePiece(
                    value: lening / totaal * 100.0,
                    name: 'Lening',
                    color: _colors[index % _colors.length])
              ],
            ),
          ),
        )
      ])
    ]);

    return Column(
      children: [
        SizedBox(height: index != 0 ? 8.0 : 0.0),
        Card(
          elevation: 0.5,
          margin: EdgeInsets.zero,
          color: index % 2 == 0 ? const Color(0xFFd7eef4) : Colors.white,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: minOverflowWidth == null
                ? center
                : DrawerOverflowBox(minWidth: minOverflowWidth!, child: center),
          ),
        ),
        SizedBox(height: index != length - 1 ? 8.0 : 0.0),
      ],
    );
  }
}
