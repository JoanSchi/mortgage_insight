import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import '../aflos_item/aflos_item.dart';
import '../status_lening/status_lening.dart';
import '../termijn/termijn.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import '../verbouw_verduurzaam_kosten/verbouw_verduurzaam_kosten.dart';
import '../woning_lening_kosten/woning_lening_kosten.dart';

part 'hypotheek.freezed.dart';
part 'hypotheek.g.dart';

enum HypotheekVorm { aflosvrij, linear, annuity }

enum OptiesHypotheekToevoegen {
  nieuw,
  verlengen,
}

@freezed
class Hypotheek with _$Hypotheek {
  const Hypotheek._();

  const factory Hypotheek({
    required String id,
    required String omschrijving,
    required OptiesHypotheekToevoegen optiesHypotheekToevoegen,
    required double lening,
    required double gewensteLening,
    required double maxLeningInkomen,
    required double maxLeningWoningWaarde,
    @Default(0.0) double maxLeningNgh,
    @Default(true) bool toepassenNhg,
    required DateTime startDatum,
    required DateTime startDatumAflossen,
    required DateTime eindDatum,
    required int periodeInMaanden,
    required int aflosTermijnInMaanden,
    required HypotheekVorm hypotheekvorm,
    @Default(IListConst([])) IList<Termijn> termijnen,
    required double rente,
    required double boeteVrijPercentage,
    required bool usePeriodeInMaanden,
    required double minLening,
    required IList<AflosItem> extraAflossen,
    @Default("") String volgende,
    @Default("") String vorige,
    @Default(IMapConst({})) IMap<String, int> order,
    @Default(WoningLeningKosten()) WoningLeningKosten woningLeningKosten,
    @Default(VerbouwVerduurzaamKosten())
        VerbouwVerduurzaamKosten verduurzaamKosten,
    required bool deelsAfgelosteLening,
    required DateTime datumDeelsAfgelosteLening,
    required ParallelLeningen parallelLeningen,
    required bool afgesloten,
    @Default(0.0) double restSchuld,
  }) = $Hypotheek;

  factory Hypotheek.fromJson(Map<String, Object?> json) =>
      _$HypotheekFromJson(json);

  int get aflosTermijnInJaren => aflosTermijnInMaanden ~/ 12;

  int get periodeInJaren => periodeInMaanden ~/ 12;
}
