import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/collapsed_sidebar/collapsed_sidebar_widget.dart';
import '/components/current_action/current_action_widget.dart';
import '/components/date_time_component/date_time_component_widget.dart';
import '/components/editor_host/editor_host_widget.dart';
import '/components/expanded_sidebar/expanded_sidebar_widget.dart';
import '/components/mobile_collapsed_sidebar/mobile_collapsed_sidebar_widget.dart';
import '/components/mobile_drawer/mobile_drawer_widget.dart';
import '/components/score/score_widget.dart';
import '/components/systems_control_panel/systems_control_panel_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'execution_page_widget.dart' show ExecutionPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExecutionPageModel extends FlutterFlowModel<ExecutionPageWidget> {
  ///  Local state fields for this page.

  String? isHovered;

  DateTime? editingTaskDueAt;

  ///  State fields for stateful widgets in this page.

  // Model for Score component.
  late ScoreModel scoreModel;
  // Model for ExpandedSidebar component.
  late ExpandedSidebarModel expandedSidebarModel;
  // Model for CollapsedSidebar component.
  late CollapsedSidebarModel collapsedSidebarModel;
  // Model for DateTimeComponent component.
  late DateTimeComponentModel dateTimeComponentModel;
  // Model for CurrentAction component.
  late CurrentActionModel currentActionModel;
  // Model for MobileCollapsedSidebar component.
  late MobileCollapsedSidebarModel mobileCollapsedSidebarModel;
  // Model for MobileDrawer component.
  late MobileDrawerModel mobileDrawerModel;
  // Model for SystemsControlPanel component.
  late SystemsControlPanelModel systemsControlPanelModel;
  // Model for EditorHost component.
  late EditorHostModel editorHostModel;

  @override
  void initState(BuildContext context) {
    scoreModel = createModel(context, () => ScoreModel());
    expandedSidebarModel = createModel(context, () => ExpandedSidebarModel());
    collapsedSidebarModel = createModel(context, () => CollapsedSidebarModel());
    dateTimeComponentModel =
        createModel(context, () => DateTimeComponentModel());
    currentActionModel = createModel(context, () => CurrentActionModel());
    mobileCollapsedSidebarModel =
        createModel(context, () => MobileCollapsedSidebarModel());
    mobileDrawerModel = createModel(context, () => MobileDrawerModel());
    systemsControlPanelModel =
        createModel(context, () => SystemsControlPanelModel());
    editorHostModel = createModel(context, () => EditorHostModel());
  }

  @override
  void dispose() {
    scoreModel.dispose();
    expandedSidebarModel.dispose();
    collapsedSidebarModel.dispose();
    dateTimeComponentModel.dispose();
    currentActionModel.dispose();
    mobileCollapsedSidebarModel.dispose();
    mobileDrawerModel.dispose();
    systemsControlPanelModel.dispose();
    editorHostModel.dispose();
  }
}
