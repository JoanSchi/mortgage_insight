import 'package:mortgage_insight/model/nl/schulden/schulden.dart';

import '../../../utilities/kalender.dart';

class VerzendKredietVerwerken {
  static double maandLast(VerzendKrediet vk, DateTime huidige) {
    final lEindDatum = eindDatum(vk);
    if (huidige.compareTo(vk.beginDatum) < 0 ||
        huidige.compareTo(lEindDatum) > 0) {
      return 0.0;
    } else if (vk.heeftSlotTermijn &&
        huidige.isAfter(Kalender.voegPeriodeToe(lEindDatum,
            maanden: -1, periodeOpties: PeriodeOpties.volgende))) {
      return vk.slotTermijn;
    } else {
      return vk.mndBedrag;
    }
  }

  static DateTime eindDatum(VerzendKrediet vk) =>
      Kalender.voegPeriodeToe(vk.beginDatum,
          maanden: vk.maanden, periodeOpties: PeriodeOpties.volgende);

  static VerzendKrediet veranderen(VerzendKrediet vk,
      {DateTime? beginDatum,
      int? maanden,
      VKbedrag? vkBedrag,
      double? bedrag,
      bool? heeftSlotTermijn,
      double? slotBedrag,
      int? decimalen}) {
    final DateTime lBeginDatum = beginDatum ?? vk.beginDatum;
    final int lMaanden = maanden ?? vk.maanden;
    final VKbedrag lVkBedrag = vkBedrag ?? vk.vkBedrag;
    double lMndBedrag =
        lVkBedrag == VKbedrag.totaal ? vk.mndBedrag : (bedrag ?? vk.mndBedrag);
    double lTotaalBedrag = lVkBedrag == VKbedrag.totaal
        ? (bedrag ?? vk.totaalBedrag)
        : vk.totaalBedrag;
    bool lHeeftSlotTermijn = heeftSlotTermijn ?? vk.heeftSlotTermijn;
    double lSlotBedrag = slotBedrag ?? vk.slotTermijn;
    final int lDecimalen = decimalen ?? vk.decimalen;

    if ((lVkBedrag == VKbedrag.totaal
            ? lTotaalBedrag == 0.0
            : lMndBedrag == 0.0) ||
        maanden == 0) {
      return vk.copyWith(
          statusBerekening: StatusBerekening.nietBerekend,
          beginDatum: lBeginDatum,
          maanden: lMaanden,
          vkBedrag: lVkBedrag,
          mndBedrag: lMndBedrag,
          totaalBedrag: lTotaalBedrag,
          heeftSlotTermijn: lHeeftSlotTermijn,
          slotTermijn: lSlotBedrag,
          decimalen: lDecimalen);
    }

    if (lVkBedrag == VKbedrag.totaal) {
      if (lTotaalBedrag > 0.0 && lMaanden != 0) {
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

        if (lMaanden == 1 ||
            (lTotaalBedrag * afronden % lMaanden) / afronden == 0) {
          lMndBedrag = lTotaalBedrag / lMaanden;
          lSlotBedrag = 0.0;
          lHeeftSlotTermijn = false;
        } else {
          lMndBedrag =
              (lTotaalBedrag * afronden / lMaanden).ceilToDouble() / afronden;
          lSlotBedrag = lTotaalBedrag % lMndBedrag;
          lHeeftSlotTermijn = lSlotBedrag != 0.0;
        }
      }
    } else {
      if (lMndBedrag > 0.0 && lMaanden != 0) {
        if (lHeeftSlotTermijn && lSlotBedrag > 0.0) {
          lTotaalBedrag = (lMaanden - 1) * lMndBedrag + lSlotBedrag;
        } else {
          lTotaalBedrag = lMaanden * lMndBedrag;
          lSlotBedrag = 0.0;
        }
      }
    }

    return vk.copyWith(
        statusBerekening: StatusBerekening.berekend,
        beginDatum: lBeginDatum,
        maanden: lMaanden,
        vkBedrag: lVkBedrag,
        mndBedrag: lMndBedrag,
        totaalBedrag: lTotaalBedrag,
        heeftSlotTermijn: lHeeftSlotTermijn,
        slotTermijn: lSlotBedrag,
        decimalen: lDecimalen);
  }

  static bool showSlottermijn(VerzendKrediet vk) =>
      vk.heeftSlotTermijn && vk.vkBedrag == VKbedrag.mnd;
}
