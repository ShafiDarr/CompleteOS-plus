import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/collapsed_sidebar/collapsed_sidebar_widget.dart';
import '/components/current_action/current_action_widget.dart';
import '/components/date_time_component/date_time_component_widget.dart';
import '/components/editor_host/editor_host_widget.dart';
import '/components/expanded_sidebar/expanded_sidebar_widget.dart';
import '/components/mobile_collapsed_sidebar/mobile_collapsed_sidebar_widget.dart';
import '/components/mobile_drawer/mobile_drawer_widget.dart';
import '/components/score/score_widget.dart';
import '/components/systems_control_panel/systems_control_panel_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'execution_page_model.dart';
export 'execution_page_model.dart';

class ExecutionPageWidget extends StatefulWidget {
  const ExecutionPageWidget({super.key});

  static String routeName = 'ExecutionPage';
  static String routePath = '/executionPage';

  @override
  State<ExecutionPageWidget> createState() => _ExecutionPageWidgetState();
}

class _ExecutionPageWidgetState extends State<ExecutionPageWidget> {
  late ExecutionPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ExecutionPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        endDrawer: Container(
          width: 420.0,
          child: Drawer(
            elevation: 16.0,
            child: Container(
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: Visibility(
                visible: responsiveVisibility(
                  context: context,
                  phone: false,
                ),
                child: wrapWithModel(
                  model: _model.editorHostModel,
                  updateCallback: () => safeSetState(() {}),
                  updateOnChange: true,
                  child: EditorHostWidget(
                    initialTaskDueAt: _model.editingTaskDueAt,
                    initialTaskStartAt: _model.editingTaskStartAt,
                    initialTaskEndAt: _model.editingTaskEndAt,
                    closeEndDrawer: () async {
                      FFAppState().selectedRecordID = '';
                      FFAppState().update(() {});
                      _model.editingTaskDueAt = null;
                      _model.editingTaskStartAt = null;
                      _model.editingTaskEndAt = null;
                      safeSetState(() {});
                      safeSetState(() {
                        _model.editorHostModel.taskFormModel
                            .taskTypeValueController
                            ?.reset();
                        _model.editorHostModel.taskFormModel.taskTypeValue =
                            null;
                        _model.editorHostModel.taskFormModel.areaValueController
                            ?.reset();
                        _model.editorHostModel.taskFormModel.areaValue = null;
                        _model
                            .editorHostModel.taskFormModel.statusValueController
                            ?.reset();
                        _model.editorHostModel.taskFormModel.statusValue = null;
                        _model.editorHostModel.taskFormModel
                            .projectValueController
                            ?.reset();
                        _model.editorHostModel.taskFormModel.projectValue =
                            null;
                        _model.editorHostModel.taskFormModel
                            .priorityValueController
                            ?.reset();
                        _model.editorHostModel.taskFormModel.priorityValue =
                            null;
                      });
                      safeSetState(() {
                        _model.editorHostModel.areaFormModel
                            .nameFieldTextController
                            ?.clear();
                        _model.editorHostModel.areaFormModel.textController2
                            ?.clear();
                        _model.editorHostModel.taskFormModel
                            .taskNameTextController
                            ?.clear();
                        _model.systemsControlPanelModel.textController?.clear();
                      });
                      safeSetState(() {
                        _model.editorHostModel.areaFormModel.switchValue = true;
                        _model.editorHostModel.taskFormModel.switchValue = true;
                      });
                      if (scaffoldKey.currentState!.isDrawerOpen ||
                          scaffoldKey.currentState!.isEndDrawerOpen) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          top: true,
          child: Stack(
            children: [
              if (FFAppState().editorType == 'none')
                Align(
                  alignment: AlignmentDirectional(1.0, -1.0),
                  child: wrapWithModel(
                    model: _model.scoreModel,
                    updateCallback: () => safeSetState(() {}),
                    child: ScoreWidget(),
                  ),
                ),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if ((FFAppState().sidebarExpanded == true) &&
                      responsiveVisibility(
                        context: context,
                        phone: false,
                      ))
                    wrapWithModel(
                      model: _model.expandedSidebarModel,
                      updateCallback: () => safeSetState(() {}),
                      child: ExpandedSidebarWidget(),
                    ),
                  if ((FFAppState().sidebarExpanded == false) &&
                      responsiveVisibility(
                        context: context,
                        phone: false,
                      ))
                    wrapWithModel(
                      model: _model.collapsedSidebarModel,
                      updateCallback: () => safeSetState(() {}),
                      child: CollapsedSidebarWidget(),
                    ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        wrapWithModel(
                          model: _model.dateTimeComponentModel,
                          updateCallback: () => safeSetState(() {}),
                          child: DateTimeComponentWidget(),
                        ),
                        FutureBuilder<List<CurrentActionCandidatesRow>>(
                          future: CurrentActionCandidatesTable().querySingleRow(
                            queryFn: (q) => q
                                .eqOrNull(
                                  'user_id',
                                  currentUserUid,
                                )
                                .neqOrNull(
                                  'status',
                                  'Completed',
                                )
                                .order('priority_rank', ascending: true)
                                .order('start_at',
                                    ascending: true, nullsFirst: false)
                                .order('due_at',
                                    ascending: true, nullsFirst: false)
                                .order('created_at', ascending: true),
                          ),
                          builder: (context, snapshot) {
                            // Customize what your widget looks like when it's loading.
                            if (!snapshot.hasData) {
                              return Center(
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );
                            }
                            List<CurrentActionCandidatesRow>
                                rowCurrentActionCandidatesRowList =
                                snapshot.data!;

                            // Return an empty Container when the item does not exist.
                            if (snapshot.data!.isEmpty) {
                              return Container();
                            }
                            final rowCurrentActionCandidatesRow =
                                rowCurrentActionCandidatesRowList.isNotEmpty
                                    ? rowCurrentActionCandidatesRowList.first
                                    : null;

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (rowCurrentActionCandidatesRow?.id != ''
                                    ? true
                                    : false)
                                  wrapWithModel(
                                    model: _model.currentActionModel,
                                    updateCallback: () => safeSetState(() {}),
                                    child: CurrentActionWidget(
                                      actionTitle:
                                          rowCurrentActionCandidatesRow!.name!,
                                      actionType: rowCurrentActionCandidatesRow!
                                          .taskType!,
                                      actionId:
                                          rowCurrentActionCandidatesRow!.id!,
                                      metadataText:
                                          rowCurrentActionCandidatesRow?.areaId,
                                      showMetadata:
                                          rowCurrentActionCandidatesRow
                                                          ?.areaId !=
                                                      null &&
                                                  rowCurrentActionCandidatesRow
                                                          ?.areaId !=
                                                      ''
                                              ? true
                                              : false,
                                      isExpandable:
                                          rowCurrentActionCandidatesRow
                                                      ?.taskType ==
                                                  'Routine'
                                              ? true
                                              : false,
                                      status:
                                          rowCurrentActionCandidatesRow?.status,
                                      canSkip: true,
                                      canPostpone: true,
                                      canInspect: true,
                                      stepCountText: '0/0',
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if ((FFAppState().mobileDrawerOpen == false) &&
                  responsiveVisibility(
                    context: context,
                    tablet: false,
                    tabletLandscape: false,
                    desktop: false,
                  ))
                wrapWithModel(
                  model: _model.mobileCollapsedSidebarModel,
                  updateCallback: () => safeSetState(() {}),
                  child: MobileCollapsedSidebarWidget(),
                ),
              if ((FFAppState().mobileDrawerOpen == true) &&
                  responsiveVisibility(
                    context: context,
                    tablet: false,
                    tabletLandscape: false,
                    desktop: false,
                  ))
                wrapWithModel(
                  model: _model.mobileDrawerModel,
                  updateCallback: () => safeSetState(() {}),
                  child: MobileDrawerWidget(),
                ),
              if ((FFAppState().activePanel == 'system') &&
                  responsiveVisibility(
                    context: context,
                    phone: false,
                  ))
                Opacity(
                  opacity: 0.8,
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        FFAppState().activePanel = 'none';
                        FFAppState().activeSystemTab = 'none';
                        safeSetState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              FlutterFlowTheme.of(context).secondaryBackground,
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                      ),
                    ),
                  ),
                ),
              if ((FFAppState().activePanel == 'system') &&
                  responsiveVisibility(
                    context: context,
                    phone: false,
                  ))
                Align(
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Container(
                    decoration: BoxDecoration(),
                    child: Visibility(
                      visible: (FFAppState().activePanel == 'system') &&
                          responsiveVisibility(
                            context: context,
                            phone: false,
                          ),
                      child: wrapWithModel(
                        model: _model.systemsControlPanelModel,
                        updateCallback: () => safeSetState(() {}),
                        updateOnChange: true,
                        child: SystemsControlPanelWidget(
                          openEndDrawer: () async {
                            FFAppState().editorType =
                                FFAppState().activeSystemTab;
                            FFAppState().update(() {});
                            FFAppState().editorMode = 'new';
                            FFAppState().update(() {});
                            FFAppState().selectedRecordID = '';
                            FFAppState().update(() {});
                            scaffoldKey.currentState!.openEndDrawer();
                            await Future.delayed(
                              Duration(
                                milliseconds: 50,
                              ),
                            );
                            safeSetState(() {
                              _model.editorHostModel.areaFormModel
                                  .nameFieldTextController?.text = '';
                            });
                            safeSetState(() {
                              _model.editorHostModel.areaFormModel
                                  .textController2?.text = '';
                            });
                            safeSetState(() {
                              _model.editorHostModel.areaFormModel.switchValue =
                                  true;
                            });
                            safeSetState(() {
                              _model.editorHostModel.taskFormModel
                                  .taskNameTextController?.text = '';
                            });
                            safeSetState(() {
                              _model.editorHostModel.taskFormModel
                                  .priorityValueController?.value = '';
                              _model.editorHostModel.taskFormModel
                                  .priorityValue = '';
                            });
                          },
                          onAreaEdit: (areaID, areaName, areaDescription,
                              areaActive) async {
                            FFAppState().editorType = 'area';
                            FFAppState().update(() {});
                            FFAppState().editorMode = 'edit';
                            FFAppState().update(() {});
                            FFAppState().selectedRecordID = areaID;
                            FFAppState().update(() {});
                            scaffoldKey.currentState!.openEndDrawer();
                            await Future.delayed(
                              Duration(
                                milliseconds: 100,
                              ),
                            );
                            safeSetState(() {
                              _model.editorHostModel.areaFormModel
                                  .nameFieldTextController?.text = areaName;
                            });
                            safeSetState(() {
                              _model.editorHostModel.areaFormModel.switchValue =
                                  areaActive;
                            });
                            safeSetState(() {
                              _model.editorHostModel.areaFormModel
                                  .textController2?.text = areaDescription;
                            });
                          },
                          onTaskEdit: (taskID,
                              taskName,
                              taskType,
                              taskDueAt,
                              taskPriority,
                              taskStatus,
                              taskAreaID,
                              taskProjectID,
                              taskActive,
                              taskStartAt,
                              taskEndAt) async {
                            FFAppState().editorType = 'task';
                            FFAppState().editorMode = 'edit';
                            FFAppState().selectedRecordID = taskID;
                            FFAppState().update(() {});
                            _model.editingTaskDueAt = taskDueAt;
                            safeSetState(() {});
                            scaffoldKey.currentState!.openEndDrawer();
                            await Future.delayed(
                              Duration(
                                milliseconds: 200,
                              ),
                            );

                            safeSetState(() {});
                            safeSetState(() {
                              _model.editorHostModel.taskFormModel
                                  .taskNameTextController?.text = taskName!;
                            });
                            safeSetState(() {
                              _model.editorHostModel.taskFormModel
                                  .taskTypeValueController?.value = taskType!;
                              _model.editorHostModel.taskFormModel
                                  .taskTypeValue = taskType!;
                            });
                            safeSetState(() {
                              _model
                                  .editorHostModel
                                  .taskFormModel
                                  .priorityValueController
                                  ?.value = taskPriority!;
                              _model.editorHostModel.taskFormModel
                                  .priorityValue = taskPriority!;
                            });
                            safeSetState(() {
                              _model.editorHostModel.taskFormModel
                                  .statusValueController?.value = taskStatus!;
                              _model.editorHostModel.taskFormModel.statusValue =
                                  taskStatus!;
                            });
                            safeSetState(() {
                              _model.editorHostModel.taskFormModel
                                  .areaValueController?.value = taskAreaID!;
                              _model.editorHostModel.taskFormModel.areaValue =
                                  taskAreaID!;
                            });
                            safeSetState(() {
                              _model
                                  .editorHostModel
                                  .taskFormModel
                                  .projectValueController
                                  ?.value = taskProjectID!;
                              _model.editorHostModel.taskFormModel
                                  .projectValue = taskProjectID!;
                            });
                            safeSetState(() {
                              _model.editorHostModel.taskFormModel.switchValue =
                                  taskActive;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
