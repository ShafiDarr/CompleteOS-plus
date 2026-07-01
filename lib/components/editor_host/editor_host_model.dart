import '/components/area_form/area_form_widget.dart';
import '/components/confirm_delete_dialog/confirm_delete_dialog_widget.dart';
import '/components/editor_actions_menu/editor_actions_menu_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'editor_host_widget.dart' show EditorHostWidget;
import 'package:flutter/material.dart';

class EditorHostModel extends FlutterFlowModel<EditorHostWidget> {
  ///  Local state fields for this component.

  String? isHovered;

  ///  State fields for stateful widgets in this component.

  // Model for AreaForm component.
  late AreaFormModel areaFormModel;
  // Model for EditorActionsMenu component.
  late EditorActionsMenuModel editorActionsMenuModel;
  // Model for ConfirmDeleteDialog component.
  late ConfirmDeleteDialogModel confirmDeleteDialogModel;

  @override
  void initState(BuildContext context) {
    areaFormModel = createModel(context, () => AreaFormModel());
    editorActionsMenuModel =
        createModel(context, () => EditorActionsMenuModel());
    confirmDeleteDialogModel =
        createModel(context, () => ConfirmDeleteDialogModel());
  }

  @override
  void dispose() {
    areaFormModel.dispose();
    editorActionsMenuModel.dispose();
    confirmDeleteDialogModel.dispose();
  }
}
