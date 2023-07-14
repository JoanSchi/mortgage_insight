// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/extra_of_kosten_lening/extra_of_kosten_lening.dart';
import 'package:mortgage_insight/my_widgets/animated_sliver_widgets/kosten_item_box_properties.dart';
import 'package:mortgage_insight/pages/hypotheek/dossier_bewerken/model/hypotheek_dossier_view_model.dart';
import '../../../utilities/my_number_format.dart';

class DossierKostenItemBewerken extends ConsumerStatefulWidget {
  final KostenItemBoxProperties properties;

  final VoidCallback changePanel;

  const DossierKostenItemBewerken({
    Key? key,
    required this.properties,
    required this.changePanel,
  }) : super(key: key);

  @override
  ConsumerState<DossierKostenItemBewerken> createState() =>
      _VorigeWoningKostenItemBewerkenState();
}

class _VorigeWoningKostenItemBewerkenState
    extends ConsumerState<DossierKostenItemBewerken> {
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
        // saveGetal();
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
          .read(hypotheekDossierProvider.notifier)
          .veranderingWaarde(waarde: waarde, omschrijving: _tecName.text);
    }
  }

  void saveGetal() {
    final getal = nf.parsToDouble(_tecWaarde.text);
    if (waarde.getal != getal) {
      ref
          .read(hypotheekDossierProvider.notifier)
          .veranderingWaarde(waarde: waarde, getal: getal);
    }
  }

  String get label {
    switch (waarde.eenheid) {
      case Eenheid.percentageWoningWaarde:
        return 'Wonings (%)';
      case Eenheid.percentageLening:
        return 'Lening (%)';
      case Eenheid.bedrag:
        return 'Bedrag';
      case Eenheid.percentageTaxatie:
        return 'Taxatie (%)';
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
                child: Row(
                  children: [
                    Checkbox(
                        value: waarde.aftrekbaar,
                        onChanged: (bool? value) {
                          ref
                              .read(hypotheekDossierProvider.notifier)
                              .veranderingWaarde(
                                  waarde: waarde, aftrekbaar: value);
                        }),
                    const Text('Aftrekbaar')
                  ],
                ),
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
          ref
              .read(hypotheekDossierProvider.notifier)
              .veranderingKostenVerwijderen(waarde);
          break;
        }
      case 'toevoegen':
        {
          ref
              .read(hypotheekDossierProvider.notifier)
              .veranderingKostenToevoegen([const Waarde()], positie: waarde);
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
        if (totaleKosten != null)
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

// class DefaultKostenRowItem extends StatefulWidget {
//   final KostenItemBoxProperties properties;
//   final Function(String omschrijving) omschrijvingAanpassen;
//   final Function(double value) waardeAanpassen;
//   final Widget Function(KostenItemBoxProperties properties) button;
//   final bool lastItem;

//   const DefaultKostenRowItem(
//       {super.key,
//       required this.properties,
//       required this.omschrijvingAanpassen,
//       required this.waardeAanpassen,
//       required this.button,
//       this.lastItem = false});

//   @override
//   State<DefaultKostenRowItem> createState() => _DefaultKostenRowItemState();
// }

// class _DefaultKostenRowItemState extends State<DefaultKostenRowItem> {
//   late final MyNumberFormat nf = MyNumberFormat(context);

//   Waarde get waarde => widget.properties.value;

//   late final TextEditingController _tecName =
//       TextEditingController(text: waarde.omschrijving);

//   late final FocusNode _fnName = FocusNode()
//     ..addListener(() {
//       if (!_fnName.hasFocus) {
//         widget.omschrijvingAanpassen(_tecName.text);
//       }
//     });

//   late final TextEditingController _tecWaarde = TextEditingController(
//       text: waarde.getal == 0.0 ? '' : nf.parseDblToText(waarde.getal));

//   late final FocusNode _fnWaarde = FocusNode()
//     ..addListener(() {
//       if (!_fnWaarde.hasFocus) {
//         widget.waardeAanpassen(nf.parsToDouble(_tecWaarde.text));
//       }
//     });

//   @override
//   void dispose() {
//     _tecName.dispose();
//     _fnName.dispose();
//     _tecWaarde.dispose();
//     _fnWaarde.dispose();
//     super.dispose();
//   }

//   String get label {
//     switch (waarde.eenheid) {
//       case Eenheid.percentageWoningWaarde:
//         return 'Wonings (%)';
//       case Eenheid.percentageLening:
//         return 'Lening (%)';
//       case Eenheid.bedrag:
//         return 'Bedrag';
//       case Eenheid.percentageTaxatie:
//         return 'Taxatie (%)';
//     }
//   }

//   String get hintText {
//     switch (waarde.eenheid) {
//       case Eenheid.percentageLening:
//       case Eenheid.percentageWoningWaarde:
//       case Eenheid.percentageTaxatie:
//         return '%';
//       case Eenheid.bedrag:
//         return '€';
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 1.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Expanded(
//             child: TextFormField(
//               controller: _tecName,
//               focusNode: _fnName,
//               decoration:
//                   const InputDecoration(hintText: '...', labelText: 'Naam'),
//               textInputAction: TextInputAction.next,
//             ),
//           ),
//           const SizedBox(
//             width: 12.0,
//           ),
//           SizedBox(
//             width: 80.0,
//             child: TextFormField(
//               textAlign: TextAlign.right,
//               controller: _tecWaarde,
//               focusNode: _fnWaarde,
//               decoration: InputDecoration(
//                 hintText: hintText,
//                 labelText: label,
//               ),
//               keyboardType: const TextInputType.numberWithOptions(
//                 signed: true,
//                 decimal: true,
//               ),
//               inputFormatters: [
//                 MyNumberFormat(context).numberInputFormat('#.00')
//               ],
//               textInputAction:
//                   widget.lastItem ? TextInputAction.done : TextInputAction.done,
//             ),
//           ),
//           Focus(
//               skipTraversal: true,
//               descendantsAreTraversable: false,
//               child: widget.button(widget.properties)),
//         ],
//       ),
//     );
//   }
// }

// class StandaardKostenMenu extends StatefulWidget {
//   final Waarde waarde;
//   final PopupMenuItemSelected<SelectedMenuPopupIdentifierValue<String, dynamic>>
//       aanpassenWaarde;

//   const StandaardKostenMenu({
//     Key? key,
//     required this.aanpassenWaarde,
//     required this.waarde,
//   }) : super(key: key);

//   @override
//   State<StandaardKostenMenu> createState() => _StandaardKostenMenuState();
// }

// class _StandaardKostenMenuState extends State<StandaardKostenMenu> {
//   late Eenheid eenheid = widget.waarde.eenheid;
//   late bool aftrekbaar = widget.waarde.aftrekbaar;

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<SelectedMenuPopupIdentifierValue<String, dynamic>>(
//       icon: const Icon(Icons.more_vert),
//       onSelected: widget.aanpassenWaarde,
//       itemBuilder: (BuildContext context) {
//         final Waarde w = widget.waarde;

//         final eenheidGroupNotifier = GroupValueNotifier(value: w.eenheid);

//         return [
//           GroupPopupMenuItem<String, Eenheid>(
//               identifierAndValue: SelectedMenuPopupIdentifierValue(
//                   identifier: 'eenheid', value: Eenheid.bedrag),
//               groupValueNotifier: eenheidGroupNotifier,
//               buildChild: (bool selected) => KostenMenuItem(
//                   selected: selected,
//                   icon: const Text('€'),
//                   text: 'Bedrag',
//                   color: Colors.amber)),

//           GroupPopupMenuItem<String, Eenheid>(
//               identifierAndValue: SelectedMenuPopupIdentifierValue(
//                   identifier: 'eenheid', value: Eenheid.percentageWoningWaarde),
//               groupValueNotifier: eenheidGroupNotifier,
//               buildChild: (bool selected) => KostenMenuItem(
//                   selected: selected,
//                   icon: const Text('%'),
//                   text: 'Woning',
//                   color: Colors.amber)),

//           GroupPopupMenuItem<String, Eenheid>(
//               identifierAndValue: SelectedMenuPopupIdentifierValue(
//                   identifier: 'eenheid', value: Eenheid.percentageLening),
//               groupValueNotifier: eenheidGroupNotifier,
//               buildChild: (bool selected) => KostenMenuItem(
//                   selected: selected,
//                   icon: const Text('%'),
//                   text: 'Lening',
//                   color: Colors.amber)),

//           SinglePopupMenuItem<String>(
//               identifierAndValue: SelectedMenuPopupIdentifierValue(
//                   identifier: 'aftrekbaar', value: w.aftrekbaar),
//               buildChild: (bool selected) => KostenMenuItem(
//                   selected: selected,
//                   icon: const Icon(Icons.mail, color: Color(0XFF154273)),
//                   text: 'Aftrekbaar',
//                   color: const Color(0xFFddeff8))),

//           // if (widget.verwijderen != null)
//           const PopupMenuDivider(),
//           // if (widget.verwijderen != null)
//           PopupMenuItem<SelectedMenuPopupIdentifierValue<String, String>>(
//               padding: EdgeInsets.zero,
//               value: SelectedMenuPopupIdentifierValue(
//                   identifier: 'verwijderen', value: ''),
//               child: const KostenMenuItem(
//                 icon: Icon(Icons.delete, color: Color(0XFF154273)),
//                 text: 'Verwijderen',
//               )),
//         ];
//       },
//       elevation: 1.0,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//     );
//   }
// }

// class VerbouwenVerduurzamenKostenMenu extends StatelessWidget {
//   final Waarde waarde;
//   final PopupMenuItemSelected<SelectedMenuPopupIdentifierValue<String, dynamic>>
//       aanpassenWaarde;

//   const VerbouwenVerduurzamenKostenMenu(
//       {Key? key, required this.waarde, required this.aanpassenWaarde})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return PopupMenuButton<SelectedMenuPopupIdentifierValue<String, dynamic>>(
//         icon: const Icon(Icons.more_vert),
//         onSelected: aanpassenWaarde,
//         itemBuilder: (BuildContext context) {
//           return [
//             SinglePopupMenuItem<String>(
//                 identifierAndValue: SelectedMenuPopupIdentifierValue(
//                     identifier: 'verduurzamen', value: waarde.verduurzamen),
//                 buildChild: (bool selected) => KostenMenuItem(
//                     selected: selected,
//                     icon: const Icon(Icons.eco, color: Color(0XFFBABD42)),
//                     text: 'Verduurzamen',
//                     color: const Color(0xFF224B0C))),
//             const PopupMenuDivider(),
//             PopupMenuItem<SelectedMenuPopupIdentifierValue<String, String>>(
//                 padding: EdgeInsets.zero,
//                 value: SelectedMenuPopupIdentifierValue(
//                     identifier: 'verwijderen', value: ''),
//                 child: const KostenMenuItem(
//                   icon: Icon(Icons.delete, color: Color(0XFF154273)),
//                   text: 'Verwijderen',
//                 )),
//           ];
//         });
//   }
// }

// class KostenMenuItem extends StatelessWidget {
//   final Widget icon;
//   final String text;
//   final bool selected;
//   final Color? color;

//   const KostenMenuItem({
//     Key? key,
//     required this.icon,
//     required this.text,
//     this.selected = false,
//     this.color,
//   }) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: SizedBox(
//         height: 48.0,
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children: [
//             SizedBox(
//                 width: 32.0,
//                 height: 32.0,
//                 child: Container(
//                   alignment: Alignment.center,
//                   decoration: selected
//                       ? BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: color,
//                         )
//                       : null,
//                   child: icon,
//                 )),
//             const SizedBox(
//               width: 8.0,
//             ),
//             Text(text)
//           ],
//         ),
//       ),
//     );
//   }
// }

// class PopupMenuHeader extends PopupMenuEntry<Never> {
//   final Widget child;

//   const PopupMenuHeader({Key? key, this.height = 56.0, required this.child})
//       : super(key: key);

//   @override
//   final double height;

//   @override
//   bool represents(void value) => false;

//   @override
//   State<PopupMenuHeader> createState() => _PopupMenuHeaderState();
// }

// class _PopupMenuHeaderState extends State<PopupMenuHeader> {
//   @override
//   Widget build(BuildContext context) => widget.child;
// }


