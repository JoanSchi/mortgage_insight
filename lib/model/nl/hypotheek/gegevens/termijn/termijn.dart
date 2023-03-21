import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

import '../hypotheek/hypotheek.dart';

part 'termijn.freezed.dart';
part 'termijn.g.dart';

@freezed
class Termijn with _$Termijn {
  const Termijn._();

  const factory Termijn({
    required DateTime startPeriode,
    required DateTime eindPeriode,
    required DateTime startDatum,
    required DateTime eindDatum,
    required HypotheekVorm hypotheekVorm,
    required double rente,
    required double maandRenteBedragRatio,
    required double lening,
    required double aflossen,
    required double extraAflossen,
    @Default(false) bool volledigAfgelost,
    required int periode,
    required double aflossenTotaal,
    required double renteTotaal,
  }) = _Termijn;

  factory Termijn.fromJson(Map<String, Object?> json) =>
      _$TermijnFromJson(json);

  // int get dagen => diffDays(eindDatum, startDatum); //+1

  // int get dagenInPeriode => diffDays(eindPeriode, startPeriode); //+1

  // double get ratio => dagen / dagenInPeriode;

  bool get isStartPeriode => DateUtils.isSameDay(startDatum, startPeriode);

  bool get isEndPeriode => DateUtils.isSameDay(eindDatum, eindPeriode);

  double get leningNaAflossen => lening - aflossen - extraAflossen;
}
