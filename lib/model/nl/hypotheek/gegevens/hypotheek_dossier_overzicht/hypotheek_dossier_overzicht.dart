import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../hypotheek_dossier/hypotheek_dossier.dart';

part 'hypotheek_dossier_overzicht.freezed.dart';
part 'hypotheek_dossier_overzicht.g.dart';

@freezed
class HypotheekDossierOverzicht with _$HypotheekDossierOverzicht {
  const HypotheekDossierOverzicht._();

  const factory HypotheekDossierOverzicht({
    @Default(IMapConst({})) IMap<int, HypotheekDossier> hypotheekDossiers,
    @Default(-1) int geselecteerd,
  }) = _HypotheekDossierOverzicht;

  factory HypotheekDossierOverzicht.fromJson(Map<String, Object?> json) =>
      _$HypotheekDossierOverzichtFromJson(json);

  bool get isEmpty => hypotheekDossiers.isEmpty;
}
