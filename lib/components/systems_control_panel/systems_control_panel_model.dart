import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/area_card/area_card_widget.dart';
import '/components/system_tab/system_tab_widget.dart';
import '/components/task_type_section/task_type_section_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'systems_control_panel_widget.dart' show SystemsControlPanelWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SystemsControlPanelModel
    extends FlutterFlowModel<SystemsControlPanelWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for SystemTab component.
  late SystemTabModel systemTabModel1;
  // Model for SystemTab component.
  late SystemTabModel systemTabModel2;
  // Model for SystemTab component.
  late SystemTabModel systemTabModel3;
  // Model for SystemTab component.
  late SystemTabModel systemTabModel4;
  // Model for SystemTab component.
  late SystemTabModel systemTabModel5;
  // Model for SystemTab component.
  late SystemTabModel systemTabModel6;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Model for TaskTypeSection component.
  late TaskTypeSectionModel taskTypeSectionModel;

  @override
  void initState(BuildContext context) {
    systemTabModel1 = createModel(context, () => SystemTabModel());
    systemTabModel2 = createModel(context, () => SystemTabModel());
    systemTabModel3 = createModel(context, () => SystemTabModel());
    systemTabModel4 = createModel(context, () => SystemTabModel());
    systemTabModel5 = createModel(context, () => SystemTabModel());
    systemTabModel6 = createModel(context, () => SystemTabModel());
    taskTypeSectionModel = createModel(context, () => TaskTypeSectionModel());
  }

  @override
  void dispose() {
    systemTabModel1.dispose();
    systemTabModel2.dispose();
    systemTabModel3.dispose();
    systemTabModel4.dispose();
    systemTabModel5.dispose();
    systemTabModel6.dispose();
    textFieldFocusNode?.dispose();
    textController?.dispose();

    taskTypeSectionModel.dispose();
  }
}
