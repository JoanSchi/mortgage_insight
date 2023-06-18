import 'package:animated_sliver_box/animated_sliver_box.dart';
import 'package:animated_sliver_box/sliver_box_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek/hypotheek.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/vervolg_lening/vervolg_lening.dart';
import 'package:mortgage_insight/pages/hypotheek/hypotheek_bewerken/model/hypotheek_view_model.dart';
import 'lening_kosten_sliver_box_model.dart';
import 'lening_verbouw_sliver_box_model.dart';
import 'vervolg_hypotheek_sliver_box_model.dart';
part 'hypotheek_view_state.freezed.dart';

@freezed
class HypotheekViewState with _$HypotheekViewState {
  const HypotheekViewState._();

  const factory HypotheekViewState({
    required HypotheekDossier hypotheekDossier,
    @Default(0.0) double heightVervolg,
    @Default('') String id,
    @Default([]) List<LeningVerlengen> teVerlengen,
    @Default([]) List<HerFinancieren> teHerFinancieren,
    required SliverBoxController<HypotheekKostenSliverBoxModel>
        kostenSliverBoxController,
    required SliverBoxController<HypotheekVerbouwKostenSliverBoxModel>
        verbouwKostenSliverBoxController,
    required SliverBoxController<VervolgHypotheekSliverBoxModel>
        vervolgHypotheekSliverBoxController,
  }) = _HypotheekViewState;

  Hypotheek? get hypotheek => hypotheekDossier.hypotheken[id];

  double get heightVervolgLening =>
      switch (hypotheek?.optiesHypotheekToevoegen) {
        OptiesHypotheekToevoegen.nieuw =>
          teHerFinancieren.isEmpty ? 0.0 : 200.0,
        OptiesHypotheekToevoegen.verlengen => teVerlengen.isEmpty ? 0.0 : 300.0,
        (_) => 0.0
      };

  (String tag, List<VervolgHypotheekItemBoxProperties> items, double height)
      vervolgBoxItems({required BoxItemTransitionState transitionState}) =>
          HypotheekViewModelVerwerken.vervolgBoxItems(
              optiesHypotheekToevoegen: hypotheek?.optiesHypotheekToevoegen,
              teHerFinancieren: teHerFinancieren,
              teVerlengen: teVerlengen,
              transitionState: transitionState);
}
