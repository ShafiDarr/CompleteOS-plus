import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'system_tab_model.dart';
export 'system_tab_model.dart';

class SystemTabWidget extends StatefulWidget {
  const SystemTabWidget({
    super.key,
    required this.label,
    this.isSelected,
  });

  final String? label;
  final bool? isSelected;

  @override
  State<SystemTabWidget> createState() => _SystemTabWidgetState();
}

class _SystemTabWidgetState extends State<SystemTabWidget> {
  late SystemTabModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SystemTabModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: Text(
        valueOrDefault<String>(
          widget.label,
          'label',
        ),
        textAlign: TextAlign.center,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              font: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
              color: widget.isSelected == true
                  ? FlutterFlowTheme.of(context).primaryText
                  : FlutterFlowTheme.of(context).secondaryText,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w600,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
      ),
    );
  }
}
