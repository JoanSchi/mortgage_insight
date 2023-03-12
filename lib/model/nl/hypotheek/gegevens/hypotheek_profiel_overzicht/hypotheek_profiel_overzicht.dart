import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../hypotheek_profiel/hypotheek_profiel.dart';

part 'hypotheek_profiel_overzicht.freezed.dart';
part 'hypotheek_profiel_overzicht.g.dart';

@freezed
class HypotheekProfielOverzicht with _$HypotheekProfielOverzicht {
  const HypotheekProfielOverzicht._();

  const factory HypotheekProfielOverzicht({
    @Default(IMapConst({})) IMap<String, HypotheekProfiel> hypotheekProfielen,
    @Default('') String actief,
  }) = _HypotheekProfielOverzicht;

  factory HypotheekProfielOverzicht.fromJson(Map<String, Object?> json) =>
      _$HypotheekProfielOverzichtFromJson(json);

  bool get isEmpty => hypotheekProfielen.isEmpty;
}
