import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../hypotheek/hypotheek.dart';

part 'combi_rest_schuld.freezed.dart';
part 'combi_rest_schuld.g.dart';

@freezed
class CombiRestSchuld with _$CombiRestSchuld {
  const CombiRestSchuld._();

  const factory CombiRestSchuld({
    required DateTime datum,
    required double restSchuld,
    required IList<String> idLijst,
  }) = _CombiRestSchuld;

  factory CombiRestSchuld.fromJson(Map<String, Object?> json) =>
      _$CombiRestSchuldFromJson(json);

  CombiRestSchuld toevoegen(Hypotheek hypotheek) {
    return copyWith(
        restSchuld: restSchuld + hypotheek.restSchuld,
        idLijst: idLijst.add(hypotheek.id));
  }

  CombiRestSchuld verwijderen(Hypotheek hypotheek) {
    return copyWith(
        restSchuld: restSchuld - hypotheek.restSchuld,
        idLijst: idLijst.remove(hypotheek.id));
  }
}
