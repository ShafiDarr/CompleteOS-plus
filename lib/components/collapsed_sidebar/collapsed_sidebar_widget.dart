import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'collapsed_sidebar_model.dart';
export 'collapsed_sidebar_model.dart';

class CollapsedSidebarWidget extends StatefulWidget {
  const CollapsedSidebarWidget({super.key});

  @override
  State<CollapsedSidebarWidget> createState() => _CollapsedSidebarWidgetState();
}

class _CollapsedSidebarWidgetState extends State<CollapsedSidebarWidget> {
  late CollapsedSidebarModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CollapsedSidebarModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeInOut,
      width: 60.0,
      height: double.infinity,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryBackground,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            opaque: false,
            cursor: MouseCursor.defer ?? MouseCursor.defer,
            child: Container(
              width: double.infinity,
              height: 80.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                hoverColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () async {
                  FFAppState().sidebarExpanded = true;
                  FFAppState().update(() {});
                },
                child: Icon(
                  Icons.menu_rounded,
                  color: _model.isHovered == 'menu'
                      ? FlutterFlowTheme.of(context).primaryText
                      : FlutterFlowTheme.of(context).secondaryText,
                  size: 24.0,
                ),
              ),
            ),
            onEnter: ((event) async {
              safeSetState(() => _model.mouseRegionHovered1 = true);
              _model.isHovered = 'menu';
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
            child: Container(
              width: double.infinity,
              height: 44.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: Icon(
                Icons.add_circle_rounded,
                color: _model.isHovered == 'newItem'
                    ? FlutterFlowTheme.of(context).primaryText
                    : FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
              ),
            ),
            onEnter: ((event) async {
              safeSetState(() => _model.mouseRegionHovered2 = true);
              _model.isHovered = 'newItem';
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
            child: Container(
              width: double.infinity,
              height: 44.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: Icon(
                Icons.home_rounded,
                color: _model.isHovered == 'execution'
                    ? FlutterFlowTheme.of(context).primaryText
                    : FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
              ),
            ),
            onEnter: ((event) async {
              safeSetState(() => _model.mouseRegionHovered3 = true);
              _model.isHovered = 'execution';
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
              height: 44.0,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primaryBackground,
              ),
              child: Icon(
                Icons.account_balance_wallet_rounded,
                color: _model.isHovered == 'finance'
                    ? FlutterFlowTheme.of(context).primaryText
                    : FlutterFlowTheme.of(context).secondaryText,
                size: 24.0,
              ),
            ),
            onEnter: ((event) async {
              safeSetState(() => _model.mouseRegionHovered4 = true);
              _model.isHovered = 'finance';
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
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 24.0),
              child: Container(
                width: double.infinity,
                height: 44.0,
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
                    FFAppState().update(() {});
                  },
                  child: Icon(
                    Icons.dashboard_customize_rounded,
                    color: _model.isHovered == 'systems'
                        ? FlutterFlowTheme.of(context).primaryText
                        : FlutterFlowTheme.of(context).secondaryText,
                    size: 24.0,
                  ),
                ),
              ),
            ),
            onEnter: ((event) async {
              safeSetState(() => _model.mouseRegionHovered5 = true);
              _model.isHovered = 'systems';
              safeSetState(() {});
            }),
            onExit: ((event) async {
              safeSetState(() => _model.mouseRegionHovered5 = false);
              _model.isHovered = null;
              safeSetState(() {});
            }),
          ),
          Spacer(),
          MouseRegion(
            opaque: false,
            cursor: MouseCursor.defer ?? MouseCursor.defer,
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 24.0),
              child: Container(
                width: double.infinity,
                height: 44.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                ),
                alignment: AlignmentDirectional(0.0, 0.0),
                child: Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    color: _model.isHovered == 'profile'
                        ? FlutterFlowTheme.of(context).primaryText
                        : FlutterFlowTheme.of(context).secondaryText,
                    borderRadius: BorderRadius.circular(99.0),
                  ),
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Text(
                    'SD',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          fontSize: 18.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
                ),
              ),
            ),
            onEnter: ((event) async {
              safeSetState(() => _model.mouseRegionHovered6 = true);
              _model.isHovered = 'profile';
              safeSetState(() {});
            }),
            onExit: ((event) async {
              safeSetState(() => _model.mouseRegionHovered6 = false);
              _model.isHovered = null;
              safeSetState(() {});
            }),
          ),
        ],
      ),
    );
  }
}
