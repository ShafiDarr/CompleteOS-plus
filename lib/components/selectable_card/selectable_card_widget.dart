import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'selectable_card_model.dart';
export 'selectable_card_model.dart';

class SelectableCardWidget extends StatefulWidget {
  const SelectableCardWidget({
    super.key,
    required this.title,
    required this.isSelected,
  });

  final String? title;
  final bool? isSelected;

  @override
  State<SelectableCardWidget> createState() => _SelectableCardWidgetState();
}

class _SelectableCardWidgetState extends State<SelectableCardWidget> {
  late SelectableCardModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SelectableCardModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12.0),
      child: Container(
        width: 120.0,
        height: 70.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(16.0),
          border: Border.all(
            color: widget!.isSelected == true
                ? FlutterFlowTheme.of(context).primary
                : FlutterFlowTheme.of(context).secondary,
            width: 1.0,
          ),
        ),
        alignment: AlignmentDirectional(0.0, 0.0),
        child: Text(
          valueOrDefault<String>(
            widget!.title,
            'title',
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                font: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                ),
                fontSize: 13.0,
                letterSpacing: 0.0,
                fontWeight: FontWeight.w600,
                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
              ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
