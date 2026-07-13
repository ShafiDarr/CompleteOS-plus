import 'package:flutter/material.dart';
import 'backend/supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/flutter_flow_util.dart';

class FFAppState extends ChangeNotifier {
  static FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal();

  static void reset() {
    _instance = FFAppState._internal();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _safeInit(() {
      _sidebarExpanded =
          prefs.getBool('ff_sidebarExpanded') ?? _sidebarExpanded;
    });
    _safeInit(() {
      _mobileDrawerOpen =
          prefs.getBool('ff_mobileDrawerOpen') ?? _mobileDrawerOpen;
    });
  }

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }

  late SharedPreferences prefs;

  bool _sidebarExpanded = true;
  bool get sidebarExpanded => _sidebarExpanded;
  set sidebarExpanded(bool value) {
    _sidebarExpanded = value;
    prefs.setBool('ff_sidebarExpanded', value);
  }

  bool _mobileDrawerOpen = false;
  bool get mobileDrawerOpen => _mobileDrawerOpen;
  set mobileDrawerOpen(bool value) {
    _mobileDrawerOpen = value;
    prefs.setBool('ff_mobileDrawerOpen', value);
  }

  String _activePanel = 'none';
  String get activePanel => _activePanel;
  set activePanel(String value) {
    _activePanel = value;
  }

  String _activeSystemTab = 'none';
  String get activeSystemTab => _activeSystemTab;
  set activeSystemTab(String value) {
    _activeSystemTab = value;
  }

  String _editorType = 'none';
  String get editorType => _editorType;
  set editorType(String value) {
    _editorType = value;
  }

  String _editorMode = 'new';
  String get editorMode => _editorMode;
  set editorMode(String value) {
    _editorMode = value;
  }

  String _selectedRecordID = '';
  String get selectedRecordID => _selectedRecordID;
  set selectedRecordID(String value) {
    _selectedRecordID = value;
  }

  bool _currentActionRefreshTrigger = true;
  bool get currentActionRefreshTrigger => _currentActionRefreshTrigger;
  set currentActionRefreshTrigger(bool value) {
    _currentActionRefreshTrigger = value;
  }
}

void _safeInit(Function() initializeField) {
  try {
    initializeField();
  } catch (_) {}
}

Future _safeInitAsync(Function() initializeField) async {
  try {
    await initializeField();
  } catch (_) {}
}
