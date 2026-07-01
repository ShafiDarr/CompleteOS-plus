import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'systems_menu_model.dart';
export 'systems_menu_model.dart';

class SystemsMenuWidget extends StatefulWidget {
  const SystemsMenuWidget({super.key});

  @override
  State<SystemsMenuWidget> createState() => _SystemsMenuWidgetState();
}

class _SystemsMenuWidgetState extends State<SystemsMenuWidget> {
  late SystemsMenuModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SystemsMenuModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          opaque: false,
          cursor: MouseCursor.defer ?? MouseCursor.defer,
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              FFAppState().activePanel = 'areas';
              safeSetState(() {});
            },
            child: Container(
              width: double.infinity,
              height: 36.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  FFAppState().activePanel = 'system';
                  FFAppState().activeSystemTab = 'area';
                  FFAppState().update(() {});
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(64.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Areas',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.interTight(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: _model.isHovered == 'areas'
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onEnter: ((event) async {
            safeSetState(() => _model.mouseRegionHovered1 = true);
            _model.isHovered = 'areas';
            safeSetState(() {});
          }),
          onExit: ((event) async {
            safeSetState(() => _model.mouseRegionHovered1 = false);
            _model.isHovered = null;
            safeSetState(() {});
          }),
        ),
        MouseRegion(
          opaque: false,
          cursor: MouseCursor.defer ?? MouseCursor.defer,
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              FFAppState().activePanel = 'areas';
              safeSetState(() {});
            },
            child: Container(
              width: double.infinity,
              height: 36.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  FFAppState().activePanel = 'system';
                  FFAppState().activeSystemTab = 'goal';
                  FFAppState().update(() {});
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(64.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Goals',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.interTight(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: _model.isHovered == 'areas'
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onEnter: ((event) async {
            safeSetState(() => _model.mouseRegionHovered2 = true);
            _model.isHovered = 'areas';
            safeSetState(() {});
          }),
          onExit: ((event) async {
            safeSetState(() => _model.mouseRegionHovered2 = false);
            _model.isHovered = null;
            safeSetState(() {});
          }),
        ),
        MouseRegion(
          opaque: false,
          cursor: MouseCursor.defer ?? MouseCursor.defer,
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              FFAppState().activePanel = 'areas';
              safeSetState(() {});
            },
            child: Container(
              width: double.infinity,
              height: 36.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  FFAppState().activePanel = 'system';
                  FFAppState().activeSystemTab = 'project';
                  FFAppState().update(() {});
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(64.0, 0.0, 0.0, 0.0),
                      child: Text(
                        'Projects',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.interTight(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: _model.isHovered == 'areas'
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context).secondaryText,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          onEnter: ((event) async {
            safeSetState(() => _model.mouseRegionHovered3 = true);
            _model.isHovered = 'areas';
            safeSetState(() {});
          }),
          onExit: ((event) async {
            safeSetState(() => _model.mouseRegionHovered3 = false);
            _model.isHovered = null;
            safeSetState(() {});
          }),
        ),
        MouseRegion(
          opaque: false,
          cursor: MouseCursor.defer ?? MouseCursor.defer,
          child: Container(
            width: double.infinity,
            height: 36.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                FFAppState().activePanel = 'system';
                FFAppState().activeSystemTab = 'task';
                FFAppState().update(() {});
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(64.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Tasks',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: _model.isHovered == 'activities'
                                ? FlutterFlowTheme.of(context).primaryText
                                : FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onEnter: ((event) async {
            safeSetState(() => _model.mouseRegionHovered4 = true);
            _model.isHovered = 'activities';
            safeSetState(() {});
          }),
          onExit: ((event) async {
            safeSetState(() => _model.mouseRegionHovered4 = false);
            _model.isHovered = null;
            safeSetState(() {});
          }),
        ),
        MouseRegion(
          opaque: false,
          cursor: MouseCursor.defer ?? MouseCursor.defer,
          child: Container(
            width: double.infinity,
            height: 36.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            child: InkWell(
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              hoverColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () async {
                FFAppState().activePanel = 'system';
                FFAppState().activeSystemTab = 'schedule';
                FFAppState().update(() {});
              },
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(64.0, 0.0, 0.0, 0.0),
                    child: Text(
                      'Schedules',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.interTight(
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: _model.isHovered == 'schedules'
                                ? FlutterFlowTheme.of(context).primaryText
                                : FlutterFlowTheme.of(context).secondaryText,
                            letterSpacing: 0.0,
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onEnter: ((event) async {
            safeSetState(() => _model.mouseRegionHovered5 = true);
            _model.isHovered = 'schedules';
            safeSetState(() {});
          }),
          onExit: ((event) async {
            safeSetState(() => _model.mouseRegionHovered5 = false);
            _model.isHovered = null;
            safeSetState(() {});
          }),
        ),
        MouseRegion(
          opaque: false,
          cursor: MouseCursor.defer ?? MouseCursor.defer,
          child: Container(
            width: double.infinity,
            height: 36.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryBackground,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(64.0, 0.0, 0.0, 0.0),
                  child: Text(
                    'Automation',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.interTight(
                            fontWeight: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontWeight,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: _model.isHovered == 'automation'
                              ? FlutterFlowTheme.of(context).primaryText
                              : FlutterFlowTheme.of(context).secondaryText,
                          letterSpacing: 0.0,
                          fontWeight: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontWeight,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ),
              ],
            ),
          ),
          onEnter: ((event) async {
            safeSetState(() => _model.mouseRegionHovered6 = true);
            _model.isHovered = 'automation';
            safeSetState(() {});
          }),
          onExit: ((event) async {
            safeSetState(() => _model.mouseRegionHovered6 = false);
            _model.isHovered = null;
            safeSetState(() {});
          }),
        ),
      ],
    );
  }
}
