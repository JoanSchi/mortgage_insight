// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hypotheek_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_HypotheekDocument _$$_HypotheekDocumentFromJson(Map<String, dynamic> json) =>
    _$_HypotheekDocument(
      hypotheekProfielOverzicht: json['hypotheekProfielOverzicht'] == null
          ? const HypotheekProfielOverzicht()
          : HypotheekProfielOverzicht.fromJson(
              json['hypotheekProfielOverzicht'] as Map<String, dynamic>),
      inkomenOverzicht: json['inkomenOverzicht'] == null
          ? const InkomensOverzicht()
          : InkomensOverzicht.fromJson(
              json['inkomenOverzicht'] as Map<String, dynamic>),
      schuldenOverzicht: json['schuldenOverzicht'] == null
          ? const SchuldenOverzicht()
          : SchuldenOverzicht.fromJson(
              json['schuldenOverzicht'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_HypotheekDocumentToJson(
        _$_HypotheekDocument instance) =>
    <String, dynamic>{
      'hypotheekProfielOverzicht': instance.hypotheekProfielOverzicht,
      'inkomenOverzicht': instance.inkomenOverzicht,
      'schuldenOverzicht': instance.schuldenOverzicht,
    };
