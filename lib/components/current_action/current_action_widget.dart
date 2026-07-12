import '/components/action_option_sheet/action_option_sheet_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'current_action_model.dart';
export 'current_action_model.dart';

class CurrentActionWidget extends StatefulWidget {
  const CurrentActionWidget({
    super.key,
    required this.actionTitle,
    String? actionType,
    required this.actionId,
    this.metadataText,
    bool? showMetadata,
    required this.isExpandable,
    String? status,
    bool? canSkip,
    bool? canPostpone,
    bool? canInspect,
    this.stepCountText,
  })  : this.actionType = actionType ?? 'task',
        this.showMetadata = showMetadata ?? false,
        this.status = status ?? 'pending',
        this.canSkip = canSkip ?? true,
        this.canPostpone = canPostpone ?? true,
        this.canInspect = canInspect ?? true;

  final String? actionTitle;
  final String actionType;
  final String? actionId;
  final String? metadataText;
  final bool showMetadata;
  final bool? isExpandable;
  final String status;
  final bool canSkip;
  final bool canPostpone;
  final bool canInspect;
  final String? stepCountText;

  @override
  State<CurrentActionWidget> createState() => _CurrentActionWidgetState();
}

class _CurrentActionWidgetState extends State<CurrentActionWidget> {
  late CurrentActionModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CurrentActionModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Container(
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).alternate,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 12.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                width: 40.0,
                height: 40.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  borderRadius: BorderRadius.circular(99.0),
                ),
                child: Icon(
                  Icons.notifications_active_rounded,
                  color: FlutterFlowTheme.of(context).primaryText,
                  size: 24.0,
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await showModalBottomSheet(
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  enableDrag: false,
                                  context: context,
                                  builder: (context) {
                                    return Padding(
                                      padding: MediaQuery.viewInsetsOf(context),
                                      child: ActionOptionSheetWidget(
                                        actionTitle: widget!.actionTitle!,
                                        actionId: widget!.actionId!,
                                        actionType: widget!.actionType,
                                      ),
                                    );
                                  },
                                ).then((value) => safeSetState(() {}));
                              },
                              child: Text(
                                valueOrDefault<String>(
                                  widget!.actionTitle,
                                  'Current Task',
                                ),
                                textAlign: TextAlign.start,
                                maxLines: 1,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FontWeight.normal,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      fontSize: 15.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (widget!.showMetadata == true)
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (widget!.showMetadata == true)
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 0.0, 0.0, 8.0),
                                      child: Text(
                                        valueOrDefault<String>(
                                          widget!.metadataText,
                                          'No Area',
                                        ),
                                        textAlign: TextAlign.start,
                                        maxLines: 1,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryText,
                                              fontSize: 12.0,
                                              letterSpacing: 0.0,
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                          ].divide(SizedBox(height: 6.0)),
                        ),
                        Container(
                          width: 24.0,
                          decoration: BoxDecoration(),
                        ),
                        if (widget!.isExpandable == true)
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Text(
                              valueOrDefault<String>(
                                widget!.stepCountText,
                                '0/5',
                              ),
                              textAlign: TextAlign.start,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
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
                          ),
                        if (widget!.isExpandable == true)
                          Container(
                            width: 12.0,
                            decoration: BoxDecoration(),
                          ),
                        if ((widget!.isExpandable == true) &&
                            (_model.localExpanded == false))
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.localExpanded = true;
                                safeSetState(() {});
                              },
                              child: Icon(
                                Icons.arrow_drop_down,
                                color: FlutterFlowTheme.of(context).accent2,
                                size: 24.0,
                              ),
                            ),
                          ),
                        if ((widget!.isExpandable == true) &&
                            (_model.localExpanded == true))
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                _model.localExpanded = false;
                                safeSetState(() {});
                              },
                              child: Icon(
                                Icons.arrow_drop_up,
                                color: FlutterFlowTheme.of(context).accent2,
                                size: 24.0,
                              ),
                            ),
                          ),
                        if (widget!.isExpandable == false)
                          Theme(
                            data: ThemeData(
                              checkboxTheme: CheckboxThemeData(
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                shape: CircleBorder(),
                              ),
                              unselectedWidgetColor:
                                  FlutterFlowTheme.of(context).secondary,
                            ),
                            child: Checkbox(
                              value: _model.checkboxValue1 ??= false,
                              onChanged: (newValue) async {
                                safeSetState(
                                    () => _model.checkboxValue1 = newValue!);
                              },
                              side: (FlutterFlowTheme.of(context).secondary !=
                                      null)
                                  ? BorderSide(
                                      width: 2,
                                      color: FlutterFlowTheme.of(context)
                                          .secondary!,
                                    )
                                  : null,
                              activeColor: FlutterFlowTheme.of(context).primary,
                              checkColor: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                            ),
                          ),
                      ],
                    ),
                    if (widget!.isExpandable == true)
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_model.localExpanded == true)
                                Text(
                                  'Routine steps go here',
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
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
                                ),
                              Container(
                                width: 12.0,
                                height: 1.0,
                                decoration: BoxDecoration(),
                              ),
                              if (_model.localExpanded == true)
                                Theme(
                                  data: ThemeData(
                                    checkboxTheme: CheckboxThemeData(
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: CircleBorder(),
                                    ),
                                    unselectedWidgetColor:
                                        FlutterFlowTheme.of(context).secondary,
                                  ),
                                  child: Checkbox(
                                    value: _model.checkboxValue2 ??= false,
                                    onChanged: (newValue) async {
                                      safeSetState(() =>
                                          _model.checkboxValue2 = newValue!);
                                    },
                                    side: (FlutterFlowTheme.of(context)
                                                .secondary !=
                                            null)
                                        ? BorderSide(
                                            width: 2,
                                            color: FlutterFlowTheme.of(context)
                                                .secondary!,
                                          )
                                        : null,
                                    activeColor:
                                        FlutterFlowTheme.of(context).primary,
                                    checkColor: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
