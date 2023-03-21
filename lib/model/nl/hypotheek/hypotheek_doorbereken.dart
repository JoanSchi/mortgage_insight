// import 'package:mortgage_insight/model/nl/hypotheek/remove_financierings_norm/norm_nhg.dart';
// import 'package:mortgage_insight/model/nl/hypotheek/remove_financierings_norm/remove_norm_woningwaarde.dart';
// import 'package:mortgage_insight/model/nl/hypotheek/remove_hypotheek.dart';
// import 'package:mortgage_insight/model/nl/hypotheek/remove_parallel_leningen.dart';
// import '../inkomen/inkomen.dart';
// import '../schulden/schulden.dart';
// import 'remove_financierings_norm/remove_norm_inkomen.dart';
// import 'hypotheek_iterator.dart';

// class DoorBerekenen {
//   RemoveHypotheekProfiel profiel;
//   List<Inkomen> inkomenLijst;
//   List<Inkomen> inkomenPartnerLijst;
//   List<Schuld> schuldenLijst;

//   DoorBerekenen({
//     required this.profiel,
//     required this.inkomenLijst,
//     required this.inkomenPartnerLijst,
//     required this.schuldenLijst,
//   });

//   doorbereken({RemoveHypotheek? tm, RemoveHypotheek? vanaf}) {
//     final parallelHypotheken = HypotheekIterator(
//             eersteHypotheken: profiel.eersteHypotheken,
//             hypotheken: profiel.hypotheken)
//         .parallelTm(vanaf: vanaf, tm: tm);

//     for (HypotheekIterateItem iItem in parallelHypotheken) {
//       final hypotheek = iItem.hypotheek;

//       iItem.hypotheek.parallelLeningen = RemoveParallelLeningen.from(
//           parallelHypotheken: iItem.parallelHypotheken,
//           hypotheek: iItem.hypotheek);

//       RemoveBerekenNormInkomen(
//           hypotheek: hypotheek,
//           profiel: profiel,
//           parallelHypotheken: iItem.parallelHypotheken,
//           inkomenLijst: inkomenLijst,
//           inkomenLijstPartner: inkomenPartnerLijst,
//           schuldenLijst: schuldenLijst);

//       RemoveBerekenNormWoningWaarde(
//         hypotheek: iItem.hypotheek,
//         profiel: profiel,
//         parallelHypotheken: iItem.parallelHypotheken,
//       );

//       BerekenNormNhg(
//         hypotheek: iItem.hypotheek,
//         profiel: profiel,
//         parallelHypotheken: iItem.parallelHypotheken,
//       );

//       hypotheek.normaliseerLening();

//       if (hypotheek.termijnen.isEmpty ||
//           hypotheek.termijnen.first.lening != hypotheek.lening) {
//         hypotheek.termijnen.clear();

//         if (hypotheek.lening > 0.0) {
//           hypotheek
//             ..termijnenAanmaken()
//             ..voegRenteToe()
//             ..voegExtraAflossenToe()
//             ..berekenPeriode();
//         }
//       }
//     }
//   }

//   // controleerHypotheken({Hypotheek? hypotheek}) {
//   //   final parallelHypotheken = HypotheekIterator(
//   //           eersteHypotheken: eersteHypotheken, hypotheken: hypotheken)
//   //       .parallel(hypotheek);

//   //   for (HypotheekIterateItem iItem in parallelHypotheken) {
//   //     statusParallelLening(
//   //         parallelHypotheken: iItem.parallelHypotheken,
//   //         hypotheek: iItem.hypotheek);
//   //     BerekenNormInkomen(
//   //       profiel: this,
//   //       hypotheek: iItem.hypotheek,
//   //     )..maxLeningInkomen();

//   //     // BerekenNormWoningWaarde(profiel: this, hypotheek: iItem.hypotheek)
//   //     //     .maxLeningWoningWaarde();

//   //     // BerekenNormNHG(profiel: this, hypotheek: iItem.hypotheek).maxLeninNHG();
//   //   }
//   // }
// }
