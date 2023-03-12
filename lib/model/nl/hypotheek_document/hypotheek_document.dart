import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mortgage_insight/model/nl/inkomen/inkomen.dart';
import '../hypotheek/gegevens/hypotheek_profiel_overzicht/hypotheek_profiel_overzicht.dart';
import '../schulden/schulden.dart';

part 'hypotheek_document.freezed.dart';
part 'hypotheek_document.g.dart';

@freezed
class HypotheekDocument with _$HypotheekDocument {
  const factory HypotheekDocument({
    @Default(HypotheekProfielOverzicht())
        HypotheekProfielOverzicht hypotheekProfielOverzicht,
    @Default(InkomensOverzicht()) InkomensOverzicht inkomenOverzicht,
    @Default(SchuldenOverzicht()) SchuldenOverzicht schuldenOverzicht,
  }) = _HypotheekDocument;

  factory HypotheekDocument.fromJson(Map<String, Object?> json) =>
      _$HypotheekDocumentFromJson(json);
}
