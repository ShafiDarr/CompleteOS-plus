import '/components/systems_menu/systems_menu_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'mobile_drawer_widget.dart' show MobileDrawerWidget;
import 'package:flutter/material.dart';

class MobileDrawerModel extends FlutterFlowModel<MobileDrawerWidget> {
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

  @override
  void initState(BuildContext context) {
    systemsMenuModel = createModel(context, () => SystemsMenuModel());
  }

  @override
  void dispose() {
    systemsMenuModel.dispose();
  }
}
