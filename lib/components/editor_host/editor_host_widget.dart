import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/area_form/area_form_widget.dart';
import '/components/confirm_delete_dialog/confirm_delete_dialog_widget.dart';
import '/components/editor_actions_menu/editor_actions_menu_widget.dart';
import '/components/task_form/task_form_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'editor_host_model.dart';
export 'editor_host_model.dart';

class EditorHostWidget extends StatefulWidget {
  const EditorHostWidget({
    super.key,
    this.closeEndDrawer,
  });

  final Future Function()? closeEndDrawer;

  @override
  State<EditorHostWidget> createState() => _EditorHostWidgetState();
}

class _EditorHostWidgetState extends State<EditorHostWidget> {
  late EditorHostModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditorHostModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Visibility(
      visible: responsiveVisibility(
        context: context,
        phone: false,
      ),
      child: Container(
        width: 420.0,
        height: double.infinity,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            bottomLeft: Radius.circular(20.0),
          ),
        ),
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          unawaited(
                            () async {
                              await widget.closeEndDrawer?.call();
                            }(),
                          );
                        },
                        child: Icon(
                          Icons.close,
                          color: FlutterFlowTheme.of(context).primaryText,
                          size: 24.0,
                        ),
                      ),
                      Spacer(),
                      Text(
                        () {
                          if ((FFAppState().editorMode == 'new') &&
                              (FFAppState().editorType == 'area')) {
                            return 'New Area';
                          } else if ((FFAppState().editorMode == 'edit') &&
                              (FFAppState().editorType == 'area')) {
                            return 'Edit Area';
                          } else if ((FFAppState().editorMode == 'new') &&
                              (FFAppState().editorType == 'task')) {
                            return 'New Task';
                          } else if ((FFAppState().editorMode == 'edit') &&
                              (FFAppState().editorType == 'task')) {
                            return 'Edit Task';
                          } else {
                            return '';
                          }
                        }(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                      Spacer(),
                      if (FFAppState().editorMode == 'edit')
                        InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            FFAppState().editorMode = 'action';
                            FFAppState().update(() {});
                          },
                          child: Icon(
                            Icons.more_vert_rounded,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 24.0,
                          ),
                        ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          if ((FFAppState().editorType == 'area') &&
                              (FFAppState().editorMode == 'new')) {
                            await AreasTable().insert({
                              'name': _model
                                  .areaFormModel.nameFieldTextController.text,
                              'description':
                                  _model.areaFormModel.textController2.text,
                              'active': _model.areaFormModel.switchValue,
                              'user_id': currentUserUid,
                            });
                            safeSetState(() {
                              _model.areaFormModel.textController2?.clear();
                              _model.areaFormModel.nameFieldTextController
                                  ?.clear();
                            });
                            safeSetState(() {
                              _model.areaFormModel.switchValue = false;
                            });
                            FFAppState().selectedRecordID = '';
                            FFAppState().editorType = 'none';
                            FFAppState().editorMode = 'new';
                            FFAppState().update(() {});
                            Navigator.pop(context);
                          } else {
                            if ((FFAppState().editorType == 'area') &&
                                (FFAppState().editorMode == 'edit')) {
                              await AreasTable().update(
                                data: {
                                  'name': _model.areaFormModel
                                      .nameFieldTextController.text,
                                  'description':
                                      _model.areaFormModel.textController2.text,
                                  'active': _model.areaFormModel.switchValue,
                                },
                                matchingRows: (rows) => rows
                                    .eqOrNull(
                                      'id',
                                      FFAppState().selectedRecordID,
                                    )
                                    .eqOrNull(
                                      'user_id',
                                      currentUserUid,
                                    ),
                              );
                              safeSetState(() {
                                _model.areaFormModel.textController2?.clear();
                                _model.areaFormModel.nameFieldTextController
                                    ?.clear();
                              });
                              safeSetState(() {
                                _model.areaFormModel.switchValue = false;
                              });
                              FFAppState().selectedRecordID = '';
                              FFAppState().editorType = 'none';
                              FFAppState().editorMode = 'new';
                              FFAppState().update(() {});
                              Navigator.pop(context);
                            } else {
                              if ((FFAppState().editorMode == 'new') &&
                                  (FFAppState().editorType == 'task')) {
                                await TasksTable().insert({
                                  'name': _model.taskFormModel
                                      .taskNameTextController.text,
                                  'task_type':
                                      _model.taskFormModel.taskTypeValue,
                                  'due_at': supaSerialize<DateTime>(
                                      _model.taskFormModel.datePicked),
                                  'user_id': currentUserUid,
                                  'priority':
                                      _model.taskFormModel.priorityValue,
                                  'status': _model.taskFormModel.statusValue,
                                  'is_active': _model.taskFormModel.switchValue,
                                  'area_id': _model.taskFormModel.areaValue,
                                  'project_id':
                                      _model.taskFormModel.projectValue,
                                });
                                safeSetState(() {
                                  _model.taskFormModel.taskNameTextController
                                      ?.clear();
                                });
                                safeSetState(() {
                                  _model.taskFormModel.switchValue = false;
                                });
                                safeSetState(() {
                                  _model.taskFormModel.taskTypeValueController
                                      ?.reset();
                                  _model.taskFormModel.taskTypeValue = null;
                                  _model.taskFormModel.priorityValueController
                                      ?.reset();
                                  _model.taskFormModel.priorityValue = null;
                                  _model.taskFormModel.areaValueController
                                      ?.reset();
                                  _model.taskFormModel.areaValue = null;
                                  _model.taskFormModel.projectValueController
                                      ?.reset();
                                  _model.taskFormModel.projectValue = null;
                                  _model.taskFormModel.statusValueController
                                      ?.reset();
                                  _model.taskFormModel.statusValue = null;
                                });
                                FFAppState().selectedRecordID = '';
                                FFAppState().editorType = 'none';
                                FFAppState().editorMode = 'new';
                                FFAppState().update(() {});
                                Navigator.pop(context);
                              } else {
                                if ((FFAppState().editorMode == 'edit') &&
                                    (FFAppState().editorType == 'task')) {
                                  await TasksTable().update(
                                    data: {
                                      'name': _model.taskFormModel
                                          .taskNameTextController.text,
                                      'task_type':
                                          _model.taskFormModel.taskTypeValue,
                                      'due_at': supaSerialize<DateTime>(
                                          _model.taskFormModel.datePicked),
                                      'priority':
                                          _model.taskFormModel.priorityValue,
                                      'status':
                                          _model.taskFormModel.statusValue,
                                      'is_active':
                                          _model.taskFormModel.switchValue,
                                      'area_id': _model.taskFormModel.areaValue,
                                      'project_id':
                                          _model.taskFormModel.projectValue,
                                    },
                                    matchingRows: (rows) => rows
                                        .eqOrNull(
                                          'id',
                                          FFAppState().selectedRecordID,
                                        )
                                        .eqOrNull(
                                          'user_id',
                                          currentUserUid,
                                        ),
                                  );
                                  safeSetState(() {
                                    _model.taskFormModel.taskNameTextController
                                        ?.clear();
                                  });
                                  safeSetState(() {
                                    _model.taskFormModel.switchValue = false;
                                  });
                                  safeSetState(() {
                                    _model.taskFormModel.taskTypeValueController
                                        ?.reset();
                                    _model.taskFormModel.taskTypeValue = null;
                                    _model.taskFormModel.priorityValueController
                                        ?.reset();
                                    _model.taskFormModel.priorityValue = null;
                                    _model.taskFormModel.areaValueController
                                        ?.reset();
                                    _model.taskFormModel.areaValue = null;
                                    _model.taskFormModel.projectValueController
                                        ?.reset();
                                    _model.taskFormModel.projectValue = null;
                                    _model.taskFormModel.statusValueController
                                        ?.reset();
                                    _model.taskFormModel.statusValue = null;
                                  });
                                  FFAppState().selectedRecordID = '';
                                  FFAppState().editorType = 'none';
                                  FFAppState().editorMode = 'new';
                                  FFAppState().update(() {});
                                  Navigator.pop(context);
                                }
                              }
                            }
                          }
                        },
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: FlutterFlowTheme.of(context).primary,
                          size: 24.0,
                        ),
                      ),
                    ].divide(SizedBox(width: 8.0)),
                  ),
                  if (FFAppState().editorType == 'area')
                    Expanded(
                      child: wrapWithModel(
                        model: _model.areaFormModel,
                        updateCallback: () => safeSetState(() {}),
                        child: AreaFormWidget(),
                      ),
                    ),
                  if (FFAppState().editorType == 'task')
                    Expanded(
                      child: wrapWithModel(
                        model: _model.taskFormModel,
                        updateCallback: () => safeSetState(() {}),
                        child: TaskFormWidget(),
                      ),
                    ),
                ].divide(SizedBox(height: 20.0)),
              ),
            ),
            if ((FFAppState().editorMode == 'action') ||
                (FFAppState().editorMode == 'delete'))
              Container(
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (FFAppState().editorMode == 'action')
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: wrapWithModel(
                            model: _model.editorActionsMenuModel,
                            updateCallback: () => safeSetState(() {}),
                            child: EditorActionsMenuWidget(),
                          ),
                        ),
                      if (FFAppState().editorMode == 'delete')
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: wrapWithModel(
                            model: _model.confirmDeleteDialogModel,
                            updateCallback: () => safeSetState(() {}),
                            child: ConfirmDeleteDialogWidget(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
