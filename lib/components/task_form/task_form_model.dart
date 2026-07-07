import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'task_form_widget.dart' show TaskFormWidget;
import 'package:flutter/material.dart';

class TaskFormModel extends FlutterFlowModel<TaskFormWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for NameField widget.
  FocusNode? nameFieldFocusNode;
  TextEditingController? nameFieldTextController;
  String? Function(BuildContext, String?)? nameFieldTextControllerValidator;
  DateTime? datePicked;
  // State field(s) for NameField widget.
  String? nameFieldValue1;
  FormFieldController<String>? nameFieldValueController1;
  // State field(s) for NameField widget.
  String? nameFieldValue2;
  FormFieldController<String>? nameFieldValueController2;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nameFieldFocusNode?.dispose();
    nameFieldTextController?.dispose();
  }
}
