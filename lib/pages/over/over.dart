// // Copyright (C) 2023 Joan Schipper
// //
// // This file is part of mortgage_insight.
// //
// // mortgage_insight is free software: you can redistribute it and/or modify
// // it under the terms of the GNU General Public License as published by
// // the Free Software Foundation, either version 3 of the License, or
// // (at your option) any later version.
// //
// // mortgage_insight is distributed in the hope that it will be useful,
// // but WITHOUT ANY WARRANTY; without even the implied warranty of
// // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// // GNU General Public License for more details.
// //
// // You should have received a copy of the GNU General Public License
// // along with mortgage_insight.  If not, see <http://www.gnu.org/licenses/>.

// import 'package:beamer/beamer.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import '../../platform_page_format/default_match_page_properties.dart';
// import '../../platform_page_format/default_page.dart';
// import '../../platform_page_format/page_actions.dart';

// class Algemeen extends ConsumerStatefulWidget {
//   const Algemeen({super.key});

//   @override
//   ConsumerState<Algemeen> createState() => AlgemeenState();
// }

// class AlgemeenState extends ConsumerState<Algemeen> {
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return DefaultPage(
//       title: 'Algemeen',
//       imageBuilder: (_) => Image(
//           image: AssetImage(
//             partner ? 'graphics/persons.png' : 'graphics/person.png',
//           ),
//           color: theme.colorScheme.onSurface),
//       getPageProperties: (
//               {required hasScrollBars,
//               required formFactorType,
//               required orientation,
//               required bottom}) =>
//           hypotheekPageProperties(
//               hasScrollBars: hasScrollBars,
//               formFactorType: formFactorType,
//               orientation: orientation,
//               bottom: bottom,
//               ),
//       sliversBuilder: (
//               {required BuildContext context,
//               Widget? appBar,
//               required EdgeInsets padding}) =>
          
//           ,
//     );
//   }
// }
