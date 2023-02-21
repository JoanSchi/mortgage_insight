import 'package:mortgage_insight/model/nl/schulden/schulden.dart';

import '../../../utilities/Kalender.dart';

class VerzendKredietVerwerken {
  static double maandLast(VerzendKrediet vk, DateTime huidige) {
    final _eindDatum = eindDatum(vk);
    if (huidige.compareTo(vk.beginDatum) < 0 ||
        huidige.compareTo(_eindDatum) > 0) {
      return 0.0;
    } else if (vk.heeftSlotTermijn &&
        huidige.isAfter(Kalender.voegPeriodeToe(_eindDatum, maanden: -1))) {
      return vk.slotTermijn;
    } else {
      return vk.mndBedrag;
    }
  }

  static DateTime eindDatum(VerzendKrediet vk) =>
      Kalender.voegPeriodeToe(vk.beginDatum, maanden: vk.maanden);

  static VerzendKrediet veranderen(VerzendKrediet vk,
      {DateTime? beginDatum,
      int? maanden,
      bool? isTotalbedrag,
      double? bedrag,
      bool? heeftSlotTermijn,
      double? slotBedrag,
      int? decimalen}) {
    final DateTime _beginDatum = beginDatum ?? vk.beginDatum;
    final int _maanden = maanden ?? vk.maanden;
    final bool _isTotalbedrag = isTotalbedrag ?? vk.isTotalbedrag;
    double _mndBedrag =
        _isTotalbedrag ? vk.mndBedrag : (bedrag ?? vk.mndBedrag);
    double _totaalBedrag =
        _isTotalbedrag ? (bedrag ?? vk.totaalBedrag) : vk.totaalBedrag;
    bool _heeftSlotTermijn = heeftSlotTermijn ?? vk.heeftSlotTermijn;
    double _slotBedrag = slotBedrag ?? vk.slotTermijn;
    final int _decimalen = decimalen ?? vk.decimalen;

    if ((_isTotalbedrag ? _totaalBedrag == 0.0 : _mndBedrag == 0.0) ||
        maanden == 0) {
      return vk.copyWith(
          statusBerekening: StatusBerekening.nietBerekend,
          beginDatum: _beginDatum,
          maanden: _maanden,
          isTotalbedrag: _isTotalbedrag,
          mndBedrag: _mndBedrag,
          totaalBedrag: _totaalBedrag,
          heeftSlotTermijn: _heeftSlotTermijn,
          slotTermijn: _slotBedrag,
          decimalen: _decimalen);
    }

    if (_isTotalbedrag) {
      if (_totaalBedrag > 0.0 && _maanden != 0) {
        int afronden;

        switch (decimalen) {
          case 1:
            {
              afronden = 10;
              break;
            }
          case 2:
            {
              afronden = 100;
              break;
            }
          default:
            {
              afronden = 1;
            }
        }

        if (_maanden == 1 ||
            (_totaalBedrag * afronden % _maanden) / afronden == 0) {
          _mndBedrag = _totaalBedrag / _maanden;
          _slotBedrag = 0.0;
          _heeftSlotTermijn = false;
        } else {
          _mndBedrag =
              (_totaalBedrag * afronden / _maanden).ceilToDouble() / afronden;
          _slotBedrag = _totaalBedrag % _mndBedrag;
          _heeftSlotTermijn = _slotBedrag != 0.0;
        }
      }
    } else {
      if (_mndBedrag > 0.0 && _maanden != 0) {
        if (_heeftSlotTermijn && _slotBedrag > 0.0) {
          _totaalBedrag = (_maanden - 1) * _mndBedrag + _slotBedrag;
        } else {
          _totaalBedrag = _maanden * _mndBedrag;
          _slotBedrag = 0.0;
        }
      }
    }

    return vk.copyWith(
        statusBerekening: StatusBerekening.berekend,
        beginDatum: _beginDatum,
        maanden: _maanden,
        isTotalbedrag: _isTotalbedrag,
        mndBedrag: _mndBedrag,
        totaalBedrag: _totaalBedrag,
        heeftSlotTermijn: _heeftSlotTermijn,
        slotTermijn: _slotBedrag,
        decimalen: _decimalen);
  }
}
