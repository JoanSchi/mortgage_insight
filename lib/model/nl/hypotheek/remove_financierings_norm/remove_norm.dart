// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

// import 'remove_norm_inkomen.dart';

// abstract class Norm {
//   String omschrijving;
//   int order;
//   bool toepassen;

//   Norm({
//     required this.omschrijving,
//     required this.order,
//     required this.toepassen,
//   });

//   double get totaal;

//   double get resterend;

//   bool get fataleFout;

//   List<String> get fouten;

//   double get verduurzaamKosten;

//   bool get isbepaald => toepassen && !fataleFout;

//   Norm minHuidige(DefaultNorm other) {
//     if (toepassen && !(other.toepassen && other.fouten.isEmpty)) {
//       return this;
//     } else if (!(toepassen && fouten.isEmpty) && other.toepassen) {
//       return other;
//     }

//     if (resterend < other.resterend) {
//       return this;
//     } else if (resterend > other.resterend) {
//       return other;
//     } else {
//       return order < other.order ? this : other;
//     }
//   }
// }

// class DefaultNorm extends Norm {
//   double totaal;
//   double resterend;
//   double verduurzaamKosten;
//   List<String> fouten;

//   DefaultNorm({
//     super.omschrijving: '',
//     super.order: 0,
//     super.toepassen = false,
//     this.totaal = 0.0,
//     this.resterend = 0.0,
//     this.verduurzaamKosten = 0.0,
//     List<String>? fouten,
//   }) : fouten = fouten ?? [];

//   void wissen() {
//     totaal = 0.0;
//     resterend = 0.0;
//     fouten.clear();
//   }

//   bool get fataleFout => fouten.isNotEmpty;

//   DefaultNorm copyWith({
//     String? omschrijving,
//     int? order,
//     bool? toepassen,
//     double? totaal,
//     double? resterend,
//     double? verduurzaamKosten,
//     List<String>? fouten,
//   }) {
//     return DefaultNorm(
//       omschrijving: omschrijving ?? this.omschrijving,
//       order: order ?? this.order,
//       toepassen: toepassen ?? this.toepassen,
//       totaal: totaal ?? this.totaal,
//       resterend: resterend ?? this.resterend,
//       verduurzaamKosten: verduurzaamKosten ?? this.verduurzaamKosten,
//       fouten: fouten ?? this.fouten,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'omschrijving': omschrijving,
//       'order': order,
//       'toepassen': toepassen,
//       'totaal': totaal,
//       'resterend': resterend,
//       'verduurzaamKosten': verduurzaamKosten,
//       'fouten': fouten,
//     };
//   }

//   factory DefaultNorm.fromMap(Map<String, dynamic> map) {
//     return DefaultNorm(
//       omschrijving: map['omschrijving'],
//       order: map['order']?.toInt(),
//       toepassen: map['toepassen'],
//       totaal: map['totaal']?.toDouble(),
//       resterend: map['resterend']?.toDouble(),
//       verduurzaamKosten: map['verduurzaamKosten']?.toDouble(),
//       fouten: List<String>.from(
//         (map['fouten'] as List<String>),
//       ),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory DefaultNorm.fromJson(String source) =>
//       DefaultNorm.fromMap(json.decode(source));
// }

// class RemoveNormInkomen extends Norm {
//   List<RemoveGegevensNormInkomen> gegevens;
//   RemoveGegevensNormInkomen? maximumLening;

//   RemoveNormInkomen({
//     super.omschrijving: 'Inkomen',
//     required super.order,
//     required super.toepassen,
//     List<RemoveGegevensNormInkomen>? gegevens,
//     List<String>? fouten,
//   }) : gegevens = gegevens ?? [] {
//     vindMaximumLening();
//   }

//   @override
//   double get verduurzaamKosten => maximumLening?.verduurzaamKosten ?? 0.0;

//   vindMaximumLening() {
//     maximumLening = fataleFout
//         ? null
//         : gegevens
//             .reduce((RemoveGegevensNormInkomen a, RemoveGegevensNormInkomen b) {
//             if (a.fout.isEmpty && b.fout.isNotEmpty) {
//               return a;
//             } else if (a.fout.isNotEmpty && b.fout.isEmpty) {
//               return b;
//             } else if (a.optimalisatieLast.initieleLening <
//                 b.optimalisatieLast.initieleLening) {
//               return a;
//             } else {
//               return b;
//             }
//           });
//   }

//   @override
//   double get resterend =>
//       maximumLening?.optimalisatieLast.initieleLening ?? 0.0;

//   @override
//   double get totaal {
//     final RemoveGegevensNormInkomen? g = maximumLening;

//     return g == null
//         ? 0.0
//         : (gegevens.first.parallelLeningen.somLeningen +
//                 g.optimalisatieLast.initieleLening)
//             .roundToDouble();
//   }

//   List<String> get fouten =>
//       gegevens.where((e) => e.fout.isNotEmpty).map((e) => e.fout).toList();

//   bool get fataleFout => gegevens.isEmpty || gegevens.first.fout.isNotEmpty;

//   RemoveNormInkomen copyWith({
//     String? omschrijving,
//     bool? toepassen,
//     int? order,
//     List<RemoveGegevensNormInkomen>? gegevens,
//   }) {
//     return RemoveNormInkomen(
//       omschrijving: omschrijving ?? this.omschrijving,
//       toepassen: toepassen ?? this.toepassen,
//       order: order ?? this.order,
//       gegevens: gegevens ?? this.gegevens,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'omschrijving': omschrijving,
//       'order': order,
//       'toepassen': toepassen,
//       'gegevens': gegevens.map((x) => x.toMap()).toList(),
//       // 'fouten': fouten,
//       'maximumLening': maximumLening?.toMap(),
//     };
//   }

//   factory RemoveNormInkomen.fromMap(Map<String, dynamic> map) {
//     return RemoveNormInkomen(
//       omschrijving: map['omschrijving'],
//       order: map['order']?.toInt(),
//       toepassen: map['toepassen'],
//       gegevens: List<RemoveGegevensNormInkomen>.from(
//         (map['gegevens'] as List<int>).map<RemoveGegevensNormInkomen>(
//           (x) => RemoveGegevensNormInkomen.fromMap(x as Map<String, dynamic>),
//         ),
//       ),
//       // fouten: List<String>.from(
//       //   (map['fouten'] as List<String>),
//       // ),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory RemoveNormInkomen.fromJson(String source) =>
//       RemoveNormInkomen.fromMap(json.decode(source) as Map<String, dynamic>);
// }
