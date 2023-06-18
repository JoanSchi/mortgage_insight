import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/schulden/gegevens/schulden.dart';
import 'package:mortgage_insight/pages/schulden/schuld_provider.dart';
import 'package:mortgage_insight/platform_page_format/page_actions.dart';
import '../../my_widgets/sliver_filler.dart';
import '../../platform_page_format/default_match_page_properties.dart';
import '../../platform_page_format/default_page.dart';

class SchuldenCategoriePanel extends ConsumerStatefulWidget {
  const SchuldenCategoriePanel({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<SchuldenCategoriePanel> createState() =>
      _SchuldenCategoriePanelState();
}

class _SchuldenCategoriePanelState
    extends ConsumerState<SchuldenCategoriePanel> {
  void selected(SchuldItem item) {
    ref.read(schuldProvider.notifier).selectSchuld(item);

    String categorie = switch (item.categorie) {
      SchuldenCategorie.aflopendKrediet => 'ak',
      SchuldenCategorie.verzendhuiskrediet => 'vk',
      SchuldenCategorie.autolease => 'oa',
      SchuldenCategorie.doorlopendKrediet => 'dk',
    };

    Beamer.of(context, root: true)
        .beamToNamed('/document/schulden/specificatie/$categorie');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultPage(
        getPageProperties: (
                {required hasScrollBars,
                required formFactorType,
                required orientation,
                required bottom}) =>
            hypotheekPageProperties(
              hasScrollBars: hasScrollBars,
              formFactorType: formFactorType,
              orientation: orientation,
              bottom: bottom,
              leftTopActions: [
                PageActionItem(
                    voidCallback: () =>
                        Beamer.of(context).popToNamed('/document/schulden'),
                    icon: Icons.arrow_back)
              ],
            ),
        title: 'Toevoegen',
        imageBuilder: (_) => Image(
            image: const AssetImage(
              'graphics/schuld.png',
            ),
            color: theme.colorScheme.onSurface),
        sliversBuilder: (
                {required BuildContext context,
                Widget? appBar,
                required EdgeInsets padding}) =>
            _build(context, theme, appBar, padding));
  }

  Widget _build(BuildContext context, ThemeData theme, Widget? appBar,
      EdgeInsets padding) {
    SchuldBewerken bewerken = ref.watch(schuldProvider);

    return CustomScrollView(slivers: [
      if (appBar != null) appBar,
      SliverFiller(
        offset: -8.0,
        itemCount: schuldenLijst.length,
        itemExtent: 56.0,
        // child: Container(
        //   color: Colors.pink,
        // ),
      ),
      SliverFixedExtentList.builder(
        itemBuilder: (BuildContext context, int index) {
          SchuldItem item = schuldenLijst[index];
          return Center(
            child: SelectedTextButton(
                value: item,
                groupValue: bewerken.selectedSchuldItem,
                onChanged: selected,
                // minWidthText: 300.0,
                // selectedBackbround: theme.primaryColor,
                // selectedTextColor: Colors.white,
                // textColor: theme.colorScheme.onSecondary,
                text: item.omschrijving),
          );
        },
        itemExtent: 56.0,
        itemCount: schuldenLijst.length,
      )
    ]);
  }
}

class SelectedTextButton extends StatelessWidget {
  final SchuldItem value;
  final SchuldItem? groupValue;
  final ValueChanged<SchuldItem> onChanged;
  final String text;

  const SelectedTextButton(
      {super.key,
      required this.value,
      this.groupValue,
      required this.onChanged,
      required this.text});

  bool get selected => value == groupValue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
        onPressed: () => onChanged(value),
        style: TextButton.styleFrom(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 32.0),
            textStyle: theme.textTheme.bodyMedium!.copyWith(fontSize: 18.0),
            minimumSize: const Size(300.0, 56.0),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            foregroundColor: selected
                ? theme.colorScheme.onPrimary
                : theme.colorScheme.primary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0)),
            backgroundColor: selected ? theme.colorScheme.primary : null),
        child: Text(text));
  }
}
