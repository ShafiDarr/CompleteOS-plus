import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'task_form_widget.dart' show TaskFormWidget;
import 'package:flutter/material.dart';

class TaskFormModel extends FlutterFlowModel<TaskFormWidget> {
  ///  Local state fields for this component.

  DateTime? selectedDueAt;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TaskName widget.
  FocusNode? taskNameFocusNode;
  TextEditingController? taskNameTextController;
  String? Function(BuildContext, String?)? taskNameTextControllerValidator;
  // State field(s) for TaskType widget.
  String? taskTypeValue;
  FormFieldController<String>? taskTypeValueController;
  DateTime? datePicked;
  // State field(s) for Priority widget.
  String? priorityValue;
  FormFieldController<String>? priorityValueController;
  // State field(s) for Area widget.
  String? areaValue;
  FormFieldController<String>? areaValueController;
  // State field(s) for Project widget.
  String? projectValue;
  FormFieldController<String>? projectValueController;
  // State field(s) for Status widget.
  String? statusValue;
  FormFieldController<String>? statusValueController;
  // State field(s) for Switch widget.
  bool? switchValue;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    taskNameFocusNode?.dispose();
    taskNameTextController?.dispose();
  }
}
