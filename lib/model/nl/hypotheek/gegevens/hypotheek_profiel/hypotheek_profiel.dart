import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../eigenwoningreserve/eigenwoningreserve.dart';
import '../hypotheek/hypotheek.dart';
import '../woning_lening_kosten/woning_lening_kosten.dart';

part 'hypotheek_profiel.freezed.dart';
part 'hypotheek_profiel.g.dart';

enum DoelHypotheekOverzicht { nieuweWoning, huidigeWoning }

@freezed
class HypotheekProfiel with _$HypotheekProfiel {
  const HypotheekProfiel._();

  const factory HypotheekProfiel({
    required String id,
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
  }) = _HypotheekProfiel;

  factory HypotheekProfiel.fromJson(Map<String, Object?> json) =>
      _$HypotheekProfielFromJson(json);
}
