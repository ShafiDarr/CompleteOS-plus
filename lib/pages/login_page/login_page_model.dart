import '/components/login_content_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'login_page_widget.dart' show LoginPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPageModel extends FlutterFlowModel<LoginPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for LoginContent component.
  late LoginContentModel loginContentModel;

  @override
  void initState(BuildContext context) {
    loginContentModel = createModel(context, () => LoginContentModel());
  }

  @override
  void dispose() {
    loginContentModel.dispose();
  }
}
