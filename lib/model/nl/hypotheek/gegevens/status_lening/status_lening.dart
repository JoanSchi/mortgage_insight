import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../hypotheek/hypotheek.dart';

part 'status_lening.freezed.dart';
part 'status_lening.g.dart';

@freezed
class ParallelLeningen with _$ParallelLeningen {
  const factory ParallelLeningen({
    required IList<StatusLening> list,
    required double somLeningen,
    required double somVerduurzaamKosten,
    required double somVerbouwKosten,
  }) = _ParallelLeningen;

  factory ParallelLeningen.fromJson(Map<String, Object?> json) =>
      _$ParallelLeningenFromJson(json);
}

@freezed
class StatusLening with _$StatusLening {
  const factory StatusLening({
    required String id,
    required double lening,
    required int periode,
    required double rente,
    required double toetsRente,
    required int aflosTermijnInMaanden,
    required HypotheekVorm hypotheekVorm,
    required double verduurzaamKosten,
    required double verbouwKosten,
  }) = _StatusLening;

  factory StatusLening.fromJson(Map<String, Object?> json) =>
      _$StatusLeningFromJson(json);
}
