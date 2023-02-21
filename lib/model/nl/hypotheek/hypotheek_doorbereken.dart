import 'package:mortgage_insight/model/nl/hypotheek/financierings_norm/norm_nhg.dart';
import 'package:mortgage_insight/model/nl/hypotheek/financierings_norm/norm_woningwaarde.dart';
import 'package:mortgage_insight/model/nl/hypotheek/hypotheek.dart';
import 'package:mortgage_insight/model/nl/hypotheek/parallel_leningen.dart';
import '../inkomen/inkomen.dart';
import '../schulden/remove_schulden.dart';
import 'financierings_norm/norm_inkomen.dart';
import 'hypotheek_iterator.dart';

class DoorBerekenen {
  HypotheekProfiel profiel;
  List<Inkomen> inkomenLijst;
  List<Inkomen> inkomenPartnerLijst;
  List<RemoveSchuld> schuldenLijst;

  DoorBerekenen({
    required this.profiel,
    required this.inkomenLijst,
    required this.inkomenPartnerLijst,
    required this.schuldenLijst,
  });

  doorbereken({Hypotheek? tm, Hypotheek? vanaf}) {
    final parallelHypotheken = HypotheekIterator(
            eersteHypotheken: profiel.eersteHypotheken,
            hypotheken: profiel.hypotheken)
        .parallelTm(vanaf: vanaf, tm: tm);

    for (HypotheekIterateItem iItem in parallelHypotheken) {
      final hypotheek = iItem.hypotheek;

      iItem.hypotheek.parallelLeningen = ParallelLeningen.from(
          parallelHypotheken: iItem.parallelHypotheken,
          hypotheek: iItem.hypotheek);

      BerekenNormInkomen(
          hypotheek: hypotheek,
          profiel: profiel,
          parallelHypotheken: iItem.parallelHypotheken,
          inkomenLijst: inkomenLijst,
          inkomenLijstPartner: inkomenPartnerLijst,
          schuldenLijst: schuldenLijst);

      BerekenNormWoningWaarde(
        hypotheek: iItem.hypotheek,
        profiel: profiel,
        parallelHypotheken: iItem.parallelHypotheken,
      );

      BerekenNormNhg(
        hypotheek: iItem.hypotheek,
        profiel: profiel,
        parallelHypotheken: iItem.parallelHypotheken,
      );

      hypotheek.normaliseerLening();

      if (hypotheek.termijnen.isEmpty ||
          hypotheek.termijnen.first.lening != hypotheek.lening) {
        hypotheek.termijnen.clear();

        if (hypotheek.lening > 0.0) {
          hypotheek
            ..termijnenAanmaken()
            ..voegRenteToe()
            ..voegExtraAflossenToe()
            ..berekenPeriode();
        }
      }
    }
  }

  // controleerHypotheken({Hypotheek? hypotheek}) {
  //   final parallelHypotheken = HypotheekIterator(
  //           eersteHypotheken: eersteHypotheken, hypotheken: hypotheken)
  //       .parallel(hypotheek);

  //   for (HypotheekIterateItem iItem in parallelHypotheken) {
  //     statusParallelLening(
  //         parallelHypotheken: iItem.parallelHypotheken,
  //         hypotheek: iItem.hypotheek);
  //     BerekenNormInkomen(
  //       profiel: this,
  //       hypotheek: iItem.hypotheek,
  //     )..maxLeningInkomen();

  //     // BerekenNormWoningWaarde(profiel: this, hypotheek: iItem.hypotheek)
  //     //     .maxLeningWoningWaarde();

  //     // BerekenNormNHG(profiel: this, hypotheek: iItem.hypotheek).maxLeninNHG();
  //   }
  // }
}
