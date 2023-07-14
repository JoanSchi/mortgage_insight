// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mortgage_insight/my_widgets/oh_no.dart';
import 'package:mortgage_insight/pages/hypotheek/dossier_bewerken/hypotheek_dossier_bewerken.dart';
import 'package:mortgage_insight/pages/welkom/welkom.dart';
import 'package:mortgage_insight/routes/navigation_large.dart';
import 'package:mortgage_insight/routes/navigation_medium.dart';
import '../pages/route_fout/route_fout.dart';
import '../pages/hypotheek/hypotheek_bewerken/hypotheek_bewerken.dart';
import '../pages/schulden/schuld_specificatie_panel.dart';
import 'navigation_mobile.dart';
import '../pages/schulden/schuld_bewerken_panel.dart';
import '../pages/schulden/schulden_overzicht_panel.dart';
import '../pages/hypotheek/hypotheek_panel.dart';
import '../pages/inkomen/inkomen_bewerken/inkomen_bewerken_panel.dart';
import '../pages/inkomen/inkomen_panel.dart';
import '../utilities/device_info.dart';

class DocumentLocation extends BeamLocation<BeamState> {
  DocumentLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<String> get pathPatterns => [
        '/document/*',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final FormFactorType formFactorType =
        DeviceScreen3.of(context).formFactorType;

    final pathPatternSegments = state.pathPatternSegments;

    var (key, isPhone, child) = switch (formFactorType) {
      (FormFactorType type) when type == FormFactorType.monitor => (
          'L',
          false,
          const LargeNavigation(key: Key('monitor'))
        ),
      (FormFactorType type) when type == FormFactorType.tablet => (
          'M',
          false,
          const MediumNavigation(key: Key('tablet'))
        ),
      (_) => ('S', true, const MobileNavigation(key: Key('mobile'))),
    };

    return [
      BeamPage(
        key: ValueKey(key),
        name: 'document',
        title: 'document',
        child: switch (formFactorType) {
          (FormFactorType type) when type == FormFactorType.monitor => child,
          (FormFactorType type) when type == FormFactorType.tablet => child,
          (_) => child,
        },
      ),
      if (isPhone && pathPatternSegments.length > 2) ..._aanpassen(state)
    ];
  }
}

class Pagina extends StatefulWidget {
  const Pagina({super.key});

  @override
  State<Pagina> createState() => _PaginaState();
}

class _PaginaState extends State<Pagina> {
  final b = BeamerDelegate(
    locationBuilder: (routeInformation, _) => PaginaLocation(routeInformation),
  );

  @override
  Widget build(BuildContext context) {
    return Beamer(routerDelegate: b);
  }
}

class PaginaLocation extends BeamLocation<BeamState> {
  PaginaLocation(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<String> get pathPatterns =>
      ['/inkomen/*', '/schulden/*', '/hypotheek/*'];

  @override
  bool get strictPathPatterns => false;

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final isPhone = DeviceScreen3.of(context).formTypeFactorIsPhone;

    final pathPatternSegments = state.pathPatternSegments;
    return [
      switch (pathPatternSegments) {
        (List<String> p) when p.contains('inkomen') => const BeamPage(
            key: ValueKey('inkomen'),
            name: 'inkomen',
            title: 'inkomen',
            child: InkomenPanel(),
          ),
        (List<String> p) when p.contains('schulden') => const BeamPage(
            key: ValueKey('schulden'),
            name: 'schulden',
            title: 'schulden',
            child: SchuldenOverzichtPanel(),
          ),
        (List<String> p) when p.length <= 4 && p.contains('hypotheek') =>
          BeamPage(
            key: const ValueKey('hypotheek'),
            name: 'hypotheek',
            title: 'hypotheek',
            child: HypotheekPanel(onderwerp: p.length >= 3 ? p[2] : ''),
          ),
        (List<String> p) when p.length == 1 && p.contains('document') =>
          const BeamPage(
            key: ValueKey('Welkom'),
            name: 'Welkom',
            title: 'Welkom',
            child: Welkom(),
          ),
        (_) => const BeamPage(
            key: ValueKey('DeWegKwijt'),
            name: 'DeWegKwijt',
            title: 'DeWegKwijt',
            child: RouteFout(),
          ),
      },
      if (!isPhone && pathPatternSegments.length > 2) ..._aanpassen(state)
    ];
  }
}

List<BeamPage> _aanpassen(BeamState state) {
  final location = state.routeInformation.location;
  final segment = state.pathPatternSegments;
  if (location == null) return [];

  return [
    if (segment[1] == 'inkomen' && segment.length >= 2)
      switch (segment) {
        (List<String> segment)
            when segment[1] == 'inkomen' &&
                (segment[2] == 'toevoegen' || segment[2] == 'aanpassen') =>
          BeamPage(
            key: ValueKey(segment[2]),
            name: segment[2],
            title: segment[2],
            child: const InkomenBewerken(),
          ),
        (_) => _ohnoBeamPage(location)
      },

    // Schulden categorie of bewerken
    //
    //
    if (segment[1] == 'schulden' && segment.length == 3)
      switch (segment[2]) {
        'specificatie' => const BeamPage(
            key: ValueKey('specificatie'),
            name: 'specificatie',
            title: 'specificatie',
            child: SchuldenCategoriePanel(),
          ),
        (String l) when l == 'ak' || l == 'vk' || l == 'oa' || l == 'dk' =>
          BeamPage(
            key: ValueKey(l),
            name: l,
            title: l,
            child: const SchuldBewerkenPanel(),
          ),
        (_) => _ohnoBeamPage(location)
      },

    // Schulden toevoegen
    // Schuld toevoegen komt over specificatie
    //

    if (segment[1] == 'schulden' &&
        segment[2] == 'specificatie' &&
        segment.length >= 4 &&
        (segment[3] == 'ak' ||
            segment[3] == 'vk' ||
            segment[3] == 'oa' ||
            segment[3] == 'dk'))
      BeamPage(
        key: ValueKey(segment[3]),
        name: segment[3],
        title: segment[3],
        child: const SchuldBewerkenPanel(),
      ),

    // Hypotheek
    //
    //
    if (segment[1] == 'hypotheek' && segment.length == 4)
      switch ((segment[2], segment[3])) {
        (String l2, String l3)
            when l2 == 'dossier' && (l3 == 'toevoegen' || l3 == 'aanpassen') =>
          BeamPage(
            key: ValueKey(l3),
            name: l3,
            title: l3,
            child: const HypotheekDossierBewerken(),
          ),
        (String l2, String l3)
            when l2 == 'lening' && (l3 == 'toevoegen' || l3 == 'aanpassen') =>
          BeamPage(
            key: ValueKey(l3),
            name: l3,
            title: l3,
            child: const BewerkHypotheek(),
          ),
        (_) => _ohnoBeamPage('raar')
      },
  ];
}

BeamPage _ohnoBeamPage(String location) => BeamPage(
      key: const ValueKey(':('),
      name: ':(',
      title: ':(',
      child: Container(
          padding: const EdgeInsets.all(16.0),
          alignment: Alignment.center,
          color: Colors.pink[50],
          child: Text(
            'Location not found:\n $location',
            style: TextStyle(color: Colors.red[700], fontSize: 24.0),
          )),
    );
