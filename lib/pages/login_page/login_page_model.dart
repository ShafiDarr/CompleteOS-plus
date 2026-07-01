import '/components/login_content/login_content_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'login_page_widget.dart' show LoginPageWidget;
import 'package:flutter/material.dart';

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
