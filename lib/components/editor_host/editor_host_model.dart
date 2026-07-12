import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/area_form/area_form_widget.dart';
import '/components/confirm_delete_dialog/confirm_delete_dialog_widget.dart';
import '/components/editor_actions_menu/editor_actions_menu_widget.dart';
import '/components/task_form/task_form_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'editor_host_widget.dart' show EditorHostWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditorHostModel extends FlutterFlowModel<EditorHostWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for AreaForm component.
  late AreaFormModel areaFormModel;
  // Model for TaskForm component.
  late TaskFormModel taskFormModel;
  // Model for EditorActionsMenu component.
  late EditorActionsMenuModel editorActionsMenuModel;
  // Model for ConfirmDeleteDialog component.
  late ConfirmDeleteDialogModel confirmDeleteDialogModel;

  @override
  void initState(BuildContext context) {
    areaFormModel = createModel(context, () => AreaFormModel());
    taskFormModel = createModel(context, () => TaskFormModel());
    editorActionsMenuModel =
        createModel(context, () => EditorActionsMenuModel());
    confirmDeleteDialogModel =
        createModel(context, () => ConfirmDeleteDialogModel());
  }

  @override
  void dispose() {
    areaFormModel.dispose();
    taskFormModel.dispose();
    editorActionsMenuModel.dispose();
    confirmDeleteDialogModel.dispose();
  }
}
