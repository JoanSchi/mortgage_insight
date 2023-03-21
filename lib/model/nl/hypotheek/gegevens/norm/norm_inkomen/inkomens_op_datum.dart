import '../../../../inkomen/inkomen.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

// required: associates our `main.dart` with the code generated by Freezed
part 'inkomens_op_datum.freezed.dart';
// optional: Since our Person class is serializable, we must add this line.
// But if Person was not serializable, we could skip it.
part 'inkomens_op_datum.g.dart';

@freezed
class InkomensOpDatum with _$InkomensOpDatum {
  const InkomensOpDatum._();

  const factory InkomensOpDatum({
    required DateTime datum,
    required Inkomen? inkomen,
    required Inkomen? inkomenPartner,
  }) = _InkomensOpDatum;

  factory InkomensOpDatum.fromJson(Map<String, Object?> json) =>
      _$InkomensOpDatumFromJson(json);

  double get hoogsteBrutoInkomen {
    final a = inkomen?.indexatieTotaalBrutoJaar(datum) ?? 0.0;
    final b = inkomenPartner?.indexatieTotaalBrutoJaar(datum) ?? 0.0;
    return a < b ? b : a;
  }

  double get laagsteBrutoInkomen {
    final a = inkomen?.indexatieTotaalBrutoJaar(datum) ?? 0.0;
    final b = inkomenPartner?.indexatieTotaalBrutoJaar(datum) ?? 0.0;
    return a < b ? a : b;
  }

  double get totaal =>
      (inkomen?.indexatieTotaalBrutoJaar(datum) ?? 0.0) +
      (inkomenPartner?.indexatieTotaalBrutoJaar(datum) ?? 0.0);

  bool heeftInkomen(bool partner) =>
      (partner ? inkomenPartner : inkomen) != null;

  Iterable<Inkomen> toIterable() sync* {
    final lInkomen = inkomen;
    final lInkomenPartner = inkomenPartner;

    if (lInkomen != null && lInkomenPartner != null) {
      if (lInkomen.pensioen && !lInkomenPartner.pensioen) {
        yield lInkomenPartner;
        yield lInkomen;
      } else {
        yield lInkomen;
        yield lInkomenPartner;
      }
    } else if (lInkomen != null) {
      yield lInkomen;
    } else if (lInkomenPartner != null) {
      yield lInkomenPartner;
    }
  }
}
