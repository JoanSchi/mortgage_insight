// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import 'package:mortgage_insight/my_widgets/animated_sliver_widgets/kosten_item_box_properties.dart';
import 'package:mortgage_insight/pages/hypotheek/dossier_bewerken/model/hypotheek_dossier_view_model.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/hypotheek_view_model.dart';
import 'package:selectable_group_widgets/selectable_group_widgets.dart';
import '../../../my_widgets/selectable_widgets/selectable_group_themes.dart';
import '../../../utilities/my_number_format.dart';

enum KostenItemAction { verwijderen, toevoegen, aanpassen }

class HypotheekKostenItemBewerken extends ConsumerStatefulWidget {
  final KostenItemBoxProperties properties;

  final VoidCallback changePanel;

  const HypotheekKostenItemBewerken({
    Key? key,
    required this.properties,
    required this.changePanel,
  }) : super(key: key);

  @override
  ConsumerState<HypotheekKostenItemBewerken> createState() =>
      _HypotheekKostenKostenItemBewerkenState();
}

class _HypotheekKostenKostenItemBewerkenState
    extends ConsumerState<HypotheekKostenItemBewerken> {
  late final MyNumberFormat nf = MyNumberFormat(context);

  Waarde get waarde => widget.properties.value;

  late final TextEditingController _tecName =
      TextEditingController(text: waarde.omschrijving);

  late final FocusNode _fnName = FocusNode()
    ..addListener(() {
      if (!_fnName.hasFocus) {
        saveOmschrijving();
      }
    });

  late final TextEditingController _tecWaarde = TextEditingController(
      text: waarde.getal == 0.0 ? '' : nf.parseDblToText(waarde.getal));

  late final FocusNode _fnWaarde = FocusNode()
    ..addListener(() {
      if (!_fnWaarde.hasFocus) {
        saveGetal();
      }
    });

  @override
  void dispose() {
    _tecName.dispose();
    _fnName.dispose();
    _tecWaarde.dispose();
    _fnWaarde
      ..unfocus()
      ..dispose();
    super.dispose();
  }

  exit() {
    saveOmschrijving();
    saveGetal();
    widget.changePanel();
  }

  void saveOmschrijving() {
    if (waarde.omschrijving != _tecName.text) {
      ref
          .read(hypotheekBewerkenProvider.notifier)
          .veranderingKostenItem(waarde, omschrijving: _tecName.text);
    }
  }

  void saveGetal() {
    final getal = nf.parsToDouble(_tecWaarde.text);
    if (waarde.getal != getal) {
      ref
          .read(hypotheekBewerkenProvider.notifier)
          .veranderingKostenItem(waarde, getal: getal);
    }
  }

  String get label {
    switch (waarde.eenheid) {
      case Eenheid.percentageWoningWaarde:
        return 'Ww. (%)';
      case Eenheid.percentageLening:
        return 'L. (%)';
      case Eenheid.bedrag:
        return 'Bedrag';
      case Eenheid.percentageTaxatie:
        return 'Tax. (%)';
    }
  }

  String get hintText {
    switch (waarde.eenheid) {
      case Eenheid.percentageLening:
      case Eenheid.percentageWoningWaarde:
      case Eenheid.percentageTaxatie:
        return '%';
      case Eenheid.bedrag:
        return '€';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 3.0),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24.0),
            color: const Color(0xFF21ABCD).withOpacity(0.1)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(
                height: 0.0,
              ),
              Focus(
                skipTraversal: true,
                descendantsAreFocusable: false,
                // descendantsAreTraversable: false,
                child: Row(
                  children: [
                    PopupMenuButton<String>(
                      // initialValue: ,
                      // Callback that sets the selected popup menu item.
                      onSelected: onSelected,
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'verwijderen',
                          child: Text('Verwijderen'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'toevoegen',
                          child: Text('Toevoegen'),
                        ),
                      ],
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    Text(
                      'Bewerken',
                      style: theme.textTheme.headlineMedium,
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    IconButton(
                        onPressed: exit, icon: const Icon(Icons.save_alt)),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 8.0,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: _tecName,
                      focusNode: _fnName,
                      decoration: const InputDecoration(
                          hintText: '...', labelText: 'Omschrijving'),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  SizedBox(
                    width: 80.0,
                    child: TextFormField(
                      textAlign: TextAlign.right,
                      controller: _tecWaarde,
                      focusNode: _fnWaarde,
                      decoration: InputDecoration(
                        hintText: hintText,
                        labelText: label,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                        decimal: true,
                      ),
                      inputFormatters: [
                        MyNumberFormat(context).numberInputFormat('#.00')
                      ],
                      textInputAction: TextInputAction.next,
                      // onEditingComplete: () {
                      //   _fnWaarde.nextFocus();

                      //   _fnWaarde.unfocus();
                      // },
                    ),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                ],
              ),
              const SizedBox(
                height: 8.0,
              ),
              Focus(
                skipTraversal: true,
                descendantsAreFocusable: false,
                child: UndefinedSelectableGroup(
                    groups: [
                      MyRadioGroup<Eenheid>(
                          list: [
                            RadioSelectable(
                                text: 'Bedrag', value: Eenheid.bedrag),
                            RadioSelectable(
                                text: 'Woningwaarde (%)',
                                value: Eenheid.percentageWoningWaarde),
                            RadioSelectable(
                                text: 'Lening (%)',
                                value: Eenheid.percentageLening)
                          ],
                          groupValue: waarde.eenheid,
                          onChange: (Eenheid? eenheid) {
                            ref
                                .read(hypotheekBewerkenProvider.notifier)
                                .veranderingKostenItem(waarde,
                                    eenheid: eenheid);
                          })
                    ],
                    getGroupLayoutProperties: (targetPlatform,
                            formFactorType) =>
                        GroupLayoutProperties.horizontal(
                            runAlignment: WrapAlignment.center,
                            alignment: WrapAlignment.center,
                            options: const SelectableGroupOptions(
                                selectedGroupTheme: SelectedGroupTheme.button,
                                space: 6.0))),
              ),
              SelectedIcon(
                selected: waarde.aftrekbaar,
                icon: const Icon(
                  size: 20,
                  Icons.mail,
                ),
                text: 'Aftrekbaar',
                onPressed: () {
                  ref
                      .read(hypotheekBewerkenProvider.notifier)
                      .veranderingKostenItem(waarde,
                          aftrekbaar: !waarde.aftrekbaar);
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onSelected(String selected) {
    switch (selected) {
      case 'verwijderen':
        {
          ref.read(hypotheekBewerkenProvider.notifier).veranderingKostenItem(
              waarde,
              kostenItemAction: KostenItemAction.verwijderen);
          break;
        }
      case 'toevoegen':
        {
          ref.read(hypotheekBewerkenProvider.notifier).veranderingKostenItem(
              waarde,
              kostenItemAction: KostenItemAction.toevoegen);
          break;
        }
    }
  }
}

class TotaleKostenEnToevoegen extends StatelessWidget {
  final double? totaleKosten;
  final VoidCallback toevoegen;

  const TotaleKostenEnToevoegen({
    super.key,
    required this.totaleKosten,
    required this.toevoegen,
  });

  @override
  Widget build(BuildContext context) {
    late final theme = Theme.of(context);

    Widget child = Stack(
      children: [
        if (totaleKosten != null && totaleKosten! > 0.0)
          Positioned(
            top: 0.0,
            right: 0.0,
            bottom: 0.0,
            width: 80.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Divider(
                  indent: 0.0,
                  height: 8.0,
                  thickness: 2.0,
                  color: theme.colorScheme.primary,
                ),
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    MyNumberFormat(context).parseDoubleToText(totaleKosten!),
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ),
        Center(
            child: IconButton(
          icon: const Icon(
            Icons.add,
          ),
          onPressed: toevoegen,
        ))
      ],
    );

    return child;
  }
}

class ToevoegenKostenButton extends StatelessWidget {
  final double roundedLeft;
  final double roundedRight;
  final VoidCallback pressed;
  final IconData icon;
  final Color? color;

  const ToevoegenKostenButton({
    Key? key,
    this.roundedLeft = 26.0,
    this.roundedRight = 26.0,
    this.icon = Icons.add,
    required this.pressed,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final RoundedRectangleBorder outlinedBorder = RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
      topLeft: Radius.circular(roundedLeft),
      bottomLeft: Radius.circular(roundedLeft),
      topRight: Radius.circular(roundedRight),
      bottomRight: Radius.circular(roundedRight),
    ));

    final backgroundColor = theme.colorScheme.onSurface;
    final primaryColor = theme.colorScheme.surface;

    final button = OutlinedButton(
        style: ButtonStyle(
          visualDensity: const VisualDensity(horizontal: 1, vertical: 1),
          // padding: MaterialStateProperty.all<EdgeInsets>(
          //     const EdgeInsets.symmetric(horizontal: 3.0, vertical: 3.0)),

          minimumSize: MaterialStateProperty.all<Size>(const Size(88.0, 42.0)),
          shape: MaterialStateProperty.all<OutlinedBorder>(outlinedBorder),
          backgroundColor: MaterialStateProperty.all<Color?>(backgroundColor),
          side: MaterialStateProperty.resolveWith<BorderSide>(
              (Set<MaterialState> states) {
            final color = states.contains(MaterialState.pressed)
                ? primaryColor
                : primaryColor;

            return BorderSide(color: color, width: 1.0);
          }),
        ),
        onPressed: pressed,
        child: Icon(
          icon,
          color: primaryColor,
        ));
    return button;
  }
}

class SelectedIcon extends StatelessWidget {
  final Widget icon;
  final bool selected;
  final String text;
  final VoidCallback? onPressed;

  const SelectedIcon(
      {super.key,
      required this.selected,
      required this.icon,
      required this.text,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            minimumSize: const Size(32, 32),
            maximumSize: const Size(32, 32),
            foregroundColor: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onPrimary,
            backgroundColor: selected ? null : theme.colorScheme.primary,
            shape: selected ? const CircleBorder() : null,
            padding: const EdgeInsets.all(2),
          ),
          child: icon,
        ),
        Text(text),
      ],
    );
  }
}
