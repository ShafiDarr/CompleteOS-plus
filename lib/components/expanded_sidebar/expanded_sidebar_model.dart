import '/auth/supabase_auth/auth_util.dart';
import '/components/systems_menu/systems_menu_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'expanded_sidebar_widget.dart' show ExpandedSidebarWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ExpandedSidebarModel extends FlutterFlowModel<ExpandedSidebarWidget> {
  ///  Local state fields for this component.

  String? isHovered;

  bool systemsExpanded = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for MouseRegion widget.
  bool mouseRegionHovered1 = false;
  // State field(s) for MouseRegion widget.
  bool mouseRegionHovered2 = false;
  // State field(s) for MouseRegion widget.
  bool mouseRegionHovered3 = false;
  // State field(s) for MouseRegion widget.
  bool mouseRegionHovered4 = false;
  // State field(s) for MouseRegion widget.
  bool mouseRegionHovered5 = false;
  // Model for SystemsMenu component.
  late SystemsMenuModel systemsMenuModel;
  // State field(s) for MouseRegion widget.
  bool mouseRegionHovered6 = false;
  // State field(s) for MouseRegion widget.
  bool mouseRegionHovered7 = false;
  // State field(s) for MouseRegion widget.
  bool mouseRegionHovered8 = false;
  // State field(s) for MouseRegion widget.
  bool mouseRegionHovered9 = false;

  @override
  void initState(BuildContext context) {
    systemsMenuModel = createModel(context, () => SystemsMenuModel());
  }

  @override
  void dispose() {
    systemsMenuModel.dispose();
  }
}
