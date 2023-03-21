import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../eigenwoningreserve/eigenwoningreserve.dart';
import '../hypotheek/hypotheek.dart';
import '../woning_lening_kosten/woning_lening_kosten.dart';

part 'hypotheek_dossier.freezed.dart';
part 'hypotheek_dossier.g.dart';

enum DoelHypotheekOverzicht { nieuweWoning, huidigeWoning }

@freezed
class HypotheekDossier with _$HypotheekDossier {
  const HypotheekDossier._();

  const factory HypotheekDossier({
    @Default(-1) int id,
    @Default(IMapConst({})) IMap<String, Hypotheek> hypotheken,
    @Default(IListConst([])) IList<Hypotheek> eersteHypotheken,
    @Default('') String omschrijving,
    @Default(true) bool inkomensNormToepassen,
    @Default(true) bool woningWaardeNormToepassen,
    @Default(DoelHypotheekOverzicht.nieuweWoning)
        DoelHypotheekOverzicht doelHypotheekOverzicht,
    @Default(false) bool starter,
    @Default(EigenWoningReserve()) EigenWoningReserve eigenWoningReserve,
    @Default(WoningLeningKosten()) WoningLeningKosten vorigeWoningKosten,
  }) = _HypotheekDossier;

  factory HypotheekDossier.fromJson(Map<String, Object?> json) =>
      _$HypotheekDossierFromJson(json);
}
