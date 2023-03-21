import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mortgage_insight/model/nl/inkomen/inkomen.dart';
import '../hypotheek/gegevens/hypotheek_dossier_overzicht/hypotheek_dossier_overzicht.dart';
import '../schulden/schulden.dart';

part 'hypotheek_document.freezed.dart';
part 'hypotheek_document.g.dart';

@freezed
class HypotheekDocument with _$HypotheekDocument {
  const factory HypotheekDocument({
    @Default(HypotheekDossierOverzicht())
        HypotheekDossierOverzicht hypotheekDossierOverzicht,
    @Default(InkomensOverzicht()) InkomensOverzicht inkomenOverzicht,
    @Default(SchuldenOverzicht()) SchuldenOverzicht schuldenOverzicht,
  }) = _HypotheekDocument;

  factory HypotheekDocument.fromJson(Map<String, Object?> json) =>
      _$HypotheekDocumentFromJson(json);
}
