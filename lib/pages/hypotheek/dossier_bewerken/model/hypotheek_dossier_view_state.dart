import 'package:animated_sliver_box/sliver_box_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hypotheek_berekeningen/hypotheek/gegevens/hypotheek_dossier/hypotheek_dossier.dart';
import 'package:mortgage_insight/pages/hypotheek/dossier_bewerken/model/hypotheek_dossier_sliver_box_model.dart';

part 'hypotheek_dossier_view_state.freezed.dart';

@freezed
class HypotheekDossierViewState with _$HypotheekDossierViewState {
  const HypotheekDossierViewState._();

  const factory HypotheekDossierViewState({
    required HypotheekDossier hypotheekDossier,
    required SliverBoxController<DossierSliverBoxModel>
        controllerVorigeWoningKosten,
  }) = _HypotheekDossierViewState;
}
