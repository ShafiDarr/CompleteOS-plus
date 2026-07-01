import '/components/signup_content/signup_content_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'signup_page_widget.dart' show SignupPageWidget;
import 'package:flutter/material.dart';

class SignupPageModel extends FlutterFlowModel<SignupPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for SignupContent component.
  late SignupContentModel signupContentModel;

  @override
  void initState(BuildContext context) {
    signupContentModel = createModel(context, () => SignupContentModel());
  }

  @override
  void dispose() {
    signupContentModel.dispose();
  }
}
