import '/flutter_flow/flutter_flow_util.dart';
import 'area_form_widget.dart' show AreaFormWidget;
import 'package:flutter/material.dart';

class AreaFormModel extends FlutterFlowModel<AreaFormWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for NameField widget.
  FocusNode? nameFieldFocusNode;
  TextEditingController? nameFieldTextController;
  String? Function(BuildContext, String?)? nameFieldTextControllerValidator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for Switch widget.
  bool? switchValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nameFieldFocusNode?.dispose();
    nameFieldTextController?.dispose();

    textFieldFocusNode?.dispose();
    textController2?.dispose();
  }
}
