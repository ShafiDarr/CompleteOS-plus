import '/auth/supabase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/components/area_card/area_card_widget.dart';
import '/components/system_tab/system_tab_widget.dart';
import '/components/task_type_section/task_type_section_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'systems_control_panel_model.dart';
export 'systems_control_panel_model.dart';

class SystemsControlPanelWidget extends StatefulWidget {
  const SystemsControlPanelWidget({
    super.key,
    this.openEndDrawer,
    this.onAreaEdit,
    this.onTaskEdit,
  });

  final Future Function()? openEndDrawer;
  final Future Function(String areaID, String areaName, String areaDescription,
      bool areaActive)? onAreaEdit;
  final Future Function(
      String taskID,
      String? taskName,
      String? taskType,
      String? taskDueAt,
      String? taskPriority,
      String? taskStatus,
      String? taskAreaID,
      String? taskProjectID,
      bool taskActive)? onTaskEdit;

  @override
  State<SystemsControlPanelWidget> createState() =>
      _SystemsControlPanelWidgetState();
}

class _SystemsControlPanelWidgetState extends State<SystemsControlPanelWidget> {
  late SystemsControlPanelModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SystemsControlPanelModel());

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (responsiveVisibility(
            context: context,
            phone: false,
          ))
            Padding(
              padding: EdgeInsets.all(24.0),
              child: Container(
                width: 900.0,
                height: 720.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'System',
                                  style: FlutterFlowTheme.of(context)
                                      .headlineMedium
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .headlineMedium
                                                  .fontStyle,
                                        ),
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .headlineMedium
                                            .fontStyle,
                                      ),
                                ),
                                Text(
                                  'Configure your personal operating system.',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                        letterSpacing: 0.0,
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ].divide(SizedBox(height: 4.0)),
                            ),
                            FlutterFlowIconButton(
                              borderRadius: 99.0,
                              icon: Icon(
                                Icons.add_circle_rounded,
                                color: FlutterFlowTheme.of(context).primary,
                                size: 39.0,
                              ),
                              onPressed: () async {
                                FFAppState().editorType =
                                    FFAppState().activeSystemTab;
                                FFAppState().update(() {});
                                FFAppState().editorMode = 'new';
                                FFAppState().selectedRecordID = '';
                                FFAppState().update(() {});
                                await widget.openEndDrawer?.call();
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            12.0, 0.0, 12.0, 0.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().activePanel = 'system';
                                FFAppState().activeSystemTab = 'area';
                                FFAppState().update(() {});
                              },
                              child: wrapWithModel(
                                model: _model.systemTabModel1,
                                updateCallback: () => safeSetState(() {}),
                                child: SystemTabWidget(
                                  label: 'Areas',
                                  isSelected:
                                      FFAppState().activeSystemTab == 'area'
                                          ? true
                                          : false,
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().activePanel = 'system';
                                FFAppState().activeSystemTab = 'goal';
                                FFAppState().update(() {});
                              },
                              child: wrapWithModel(
                                model: _model.systemTabModel2,
                                updateCallback: () => safeSetState(() {}),
                                child: SystemTabWidget(
                                  label: 'Goals',
                                  isSelected:
                                      FFAppState().activeSystemTab == 'goal'
                                          ? true
                                          : false,
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().activePanel = 'system';
                                FFAppState().activeSystemTab = 'project';
                                FFAppState().update(() {});
                              },
                              child: wrapWithModel(
                                model: _model.systemTabModel3,
                                updateCallback: () => safeSetState(() {}),
                                child: SystemTabWidget(
                                  label: 'Projects',
                                  isSelected:
                                      FFAppState().activeSystemTab == 'project'
                                          ? true
                                          : false,
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().activePanel = 'system';
                                FFAppState().activeSystemTab = 'task';
                                FFAppState().update(() {});
                              },
                              child: wrapWithModel(
                                model: _model.systemTabModel4,
                                updateCallback: () => safeSetState(() {}),
                                child: SystemTabWidget(
                                  label: 'Tasks',
                                  isSelected:
                                      FFAppState().activeSystemTab == 'task'
                                          ? true
                                          : false,
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().activePanel = 'system';
                                FFAppState().activeSystemTab = 'schedule';
                                FFAppState().update(() {});
                              },
                              child: wrapWithModel(
                                model: _model.systemTabModel5,
                                updateCallback: () => safeSetState(() {}),
                                child: SystemTabWidget(
                                  label: 'Schedules',
                                  isSelected:
                                      FFAppState().activeSystemTab == 'schedule'
                                          ? true
                                          : false,
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                FFAppState().activePanel = 'system';
                                FFAppState().activeSystemTab = 'automation';
                                FFAppState().update(() {});
                              },
                              child: wrapWithModel(
                                model: _model.systemTabModel6,
                                updateCallback: () => safeSetState(() {}),
                                child: SystemTabWidget(
                                  label: 'Automation',
                                  isSelected: FFAppState().activeSystemTab ==
                                          'automation'
                                      ? true
                                      : false,
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 30.0)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                child: TextFormField(
                                  controller: _model.textController,
                                  focusNode: _model.textFieldFocusNode,
                                  autofocus: false,
                                  enabled: true,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    labelStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    hintText: () {
                                      if (FFAppState().activeSystemTab ==
                                          'area') {
                                        return 'Search areas . . .';
                                      } else if (FFAppState().activeSystemTab ==
                                          'task') {
                                        return 'Search tasks . . .';
                                      } else if (FFAppState().activeSystemTab ==
                                          'schedule') {
                                        return 'Search schedules . . .';
                                      } else if (FFAppState().activeSystemTab ==
                                          'automation') {
                                        return 'Search automations . . .';
                                      } else if (FFAppState().activeSystemTab ==
                                          'goal') {
                                        return 'Search goals . . .';
                                      } else if (FFAppState().activeSystemTab ==
                                          'project') {
                                        return 'Search projects . . .';
                                      } else {
                                        return 'Search . . .';
                                      }
                                    }(),
                                    hintStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .labelMedium
                                                    .fontStyle,
                                          ),
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .labelMedium
                                                  .fontStyle,
                                        ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color(0x00000000),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    filled: true,
                                    fillColor:
                                        FlutterFlowTheme.of(context).alternate,
                                  ),
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.interTight(
                                          fontWeight:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontWeight,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
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
                                  cursorColor:
                                      FlutterFlowTheme.of(context).primaryText,
                                  enableInteractiveSelection: true,
                                  validator: _model.textControllerValidator
                                      .asValidator(context),
                                ),
                              ),
                            ),
                          ].divide(SizedBox(width: 16.0)),
                        ),
                      ),
                      if (responsiveVisibility(
                        context: context,
                        phone: false,
                      ))
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    if ((FFAppState().activeSystemTab ==
                                            'area') &&
                                        responsiveVisibility(
                                          context: context,
                                          phone: false,
                                        ))
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            12.0, 0.0, 12.0, 12.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            borderRadius:
                                                BorderRadius.circular(16.0),
                                          ),
                                          child: Visibility(
                                            visible: responsiveVisibility(
                                              context: context,
                                              phone: false,
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(12.0),
                                              child:
                                                  FutureBuilder<List<AreasRow>>(
                                                future: AreasTable().queryRows(
                                                  queryFn: (q) => q
                                                      .eqOrNull(
                                                        'user_id',
                                                        currentUserUid,
                                                      )
                                                      .order('created_at',
                                                          ascending: true),
                                                ),
                                                builder: (context, snapshot) {
                                                  // Customize what your widget looks like when it's loading.
                                                  if (!snapshot.hasData) {
                                                    return Center(
                                                      child: SizedBox(
                                                        width: 50.0,
                                                        height: 50.0,
                                                        child:
                                                            CircularProgressIndicator(
                                                          valueColor:
                                                              AlwaysStoppedAnimation<
                                                                  Color>(
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                  List<AreasRow>
                                                      listViewAreasRowList =
                                                      snapshot.data!;

                                                  return ListView.builder(
                                                    padding: EdgeInsets.zero,
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount:
                                                        listViewAreasRowList
                                                            .length,
                                                    itemBuilder: (context,
                                                        listViewIndex) {
                                                      final listViewAreasRow =
                                                          listViewAreasRowList[
                                                              listViewIndex];
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        focusColor:
                                                            Colors.transparent,
                                                        hoverColor:
                                                            Colors.transparent,
                                                        highlightColor:
                                                            Colors.transparent,
                                                        onTap: () async {
                                                          FFAppState()
                                                                  .selectedRecordID =
                                                              listViewAreasRow
                                                                  .id!;
                                                          FFAppState()
                                                              .update(() {});
                                                          FFAppState()
                                                                  .editorType =
                                                              FFAppState()
                                                                  .activeSystemTab;
                                                          FFAppState()
                                                              .update(() {});
                                                          FFAppState()
                                                                  .editorMode =
                                                              'edit';
                                                          FFAppState()
                                                              .update(() {});
                                                          await widget
                                                              .onAreaEdit
                                                              ?.call(
                                                            listViewAreasRow
                                                                .id!,
                                                            listViewAreasRow
                                                                .name,
                                                            listViewAreasRow
                                                                .description!,
                                                            listViewAreasRow
                                                                .active!,
                                                          );
                                                        },
                                                        child: AreaCardWidget(
                                                          key: Key(
                                                              'Keytv3_${listViewIndex}_of_${listViewAreasRowList.length}'),
                                                          areaName:
                                                              listViewAreasRow
                                                                  .name,
                                                          activityCount: 0,
                                                          isActive:
                                                              listViewAreasRow
                                                                  .active!,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    wrapWithModel(
                                      model: _model.taskTypeSectionModel,
                                      updateCallback: () => safeSetState(() {}),
                                      child: TaskTypeSectionWidget(
                                        onTaskEdit: (taskID,
                                            taskName,
                                            taskType,
                                            taskDueAt,
                                            taskPriority,
                                            taskStatus,
                                            taskAreaID,
                                            taskProjectID,
                                            taskActive) async {
                                          FFAppState().selectedRecordID =
                                              taskID;
                                          FFAppState().editorType =
                                              FFAppState().activeSystemTab;
                                          FFAppState().editorMode = 'edit';
                                          FFAppState().update(() {});
                                          await widget.onTaskEdit?.call(
                                            taskID,
                                            taskName,
                                            taskType,
                                            taskDueAt?.toString(),
                                            taskPriority,
                                            taskStatus,
                                            taskAreaID,
                                            taskProjectID,
                                            taskActive,
                                          );
                                        },
                                      ),
                                    ),
                                    if ((FFAppState().activeSystemTab ==
                                            'schedule') &&
                                        responsiveVisibility(
                                          context: context,
                                          phone: false,
                                        ))
                                      Container(
                                        decoration: BoxDecoration(),
                                      ),
                                    if ((FFAppState().activeSystemTab ==
                                            'automation') &&
                                        responsiveVisibility(
                                          context: context,
                                          phone: false,
                                        ))
                                      Container(
                                        decoration: BoxDecoration(),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                    ].divide(SizedBox(height: 12.0)),
                  ),
                ),
              ),
            ),
          if (responsiveVisibility(
            context: context,
            tablet: false,
            tabletLandscape: false,
            desktop: false,
          ))
            Container(
              width: 100.0,
              height: 100.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
              ),
            ),
        ],
      ),
    );
  }
}
