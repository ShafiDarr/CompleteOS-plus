import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'add_task_sheet_widget.dart' show AddTaskSheetWidget;
import 'package:flutter/material.dart';

class AddTaskSheetModel extends FlutterFlowModel<AddTaskSheetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;
  DateTime? datePicked;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController1;
  String? get choiceChipsValue1 =>
      choiceChipsValueController1?.value?.firstOrNull;
  set choiceChipsValue1(String? val) =>
      choiceChipsValueController1?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController2;
  String? get choiceChipsValue2 =>
      choiceChipsValueController2?.value?.firstOrNull;
  set choiceChipsValue2(String? val) =>
      choiceChipsValueController2?.value = val != null ? [val] : [];
  // State field(s) for DropDown widget.
  String? dropDownValue1;
  FormFieldController<String>? dropDownValueController1;
  // State field(s) for DropDown widget.
  String? dropDownValue2;
  FormFieldController<String>? dropDownValueController2;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController3;
  List<String>? get choiceChipsValues3 => choiceChipsValueController3?.value;
  set choiceChipsValues3(List<String>? val) =>
      choiceChipsValueController3?.value = val;
  // State field(s) for DropDown widget.
  String? dropDownValue3;
  FormFieldController<String>? dropDownValueController3;
  // State field(s) for DropDown widget.
  String? dropDownValue4;
  FormFieldController<String>? dropDownValueController4;
  // State field(s) for DropDown widget.
  String? dropDownValue5;
  FormFieldController<String>? dropDownValueController5;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController4;
  List<String>? get choiceChipsValues4 => choiceChipsValueController4?.value;
  set choiceChipsValues4(List<String>? val) =>
      choiceChipsValueController4?.value = val;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController5;
  List<String>? get choiceChipsValues5 => choiceChipsValueController5?.value;
  set choiceChipsValues5(List<String>? val) =>
      choiceChipsValueController5?.value = val;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController6;
  String? get choiceChipsValue6 =>
      choiceChipsValueController6?.value?.firstOrNull;
  set choiceChipsValue6(String? val) =>
      choiceChipsValueController6?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController7;
  String? get choiceChipsValue7 =>
      choiceChipsValueController7?.value?.firstOrNull;
  set choiceChipsValue7(String? val) =>
      choiceChipsValueController7?.value = val != null ? [val] : [];
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController8;
  String? get choiceChipsValue8 =>
      choiceChipsValueController8?.value?.firstOrNull;
  set choiceChipsValue8(String? val) =>
      choiceChipsValueController8?.value = val != null ? [val] : [];
  // State field(s) for DropDown widget.
  String? dropDownValue6;
  FormFieldController<String>? dropDownValueController6;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController9;
  String? get choiceChipsValue9 =>
      choiceChipsValueController9?.value?.firstOrNull;
  set choiceChipsValue9(String? val) =>
      choiceChipsValueController9?.value = val != null ? [val] : [];
  // State field(s) for Switch widget.
  bool? switchValue1;
  // State field(s) for Switch widget.
  bool? switchValue2;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
