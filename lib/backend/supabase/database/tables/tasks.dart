import '../database.dart';

class TasksTable extends SupabaseTable<TasksRow> {
  @override
  String get tableName => 'tasks';

  @override
  TasksRow createRow(Map<String, dynamic> data) => TasksRow(data);
}

class TasksRow extends SupabaseDataRow {
  TasksRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => TasksTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get projectId => getField<String>('project_id');
  set projectId(String? value) => setField<String>('project_id', value);

  String? get name => getField<String>('name');
  set name(String? value) => setField<String>('name', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get priority => getField<String>('priority');
  set priority(String? value) => setField<String>('priority', value);

  DateTime? get dueAt => getField<DateTime>('due_at');
  set dueAt(DateTime? value) => setField<DateTime>('due_at', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);

  bool? get calendarSync => getField<bool>('calendar_sync');
  set calendarSync(bool? value) => setField<bool>('calendar_sync', value);

  String? get areaId => getField<String>('area_id');
  set areaId(String? value) => setField<String>('area_id', value);

  String? get templateId => getField<String>('template_id');
  set templateId(String? value) => setField<String>('template_id', value);

  String? get taskType => getField<String>('task_type');
  set taskType(String? value) => setField<String>('task_type', value);

  String? get reminderLevel => getField<String>('reminder_level');
  set reminderLevel(String? value) => setField<String>('reminder_level', value);

  bool? get requiresVerification => getField<bool>('requires_verification');
  set requiresVerification(bool? value) =>
      setField<bool>('requires_verification', value);

  DateTime? get acknowledgedAt => getField<DateTime>('acknowledged_at');
  set acknowledgedAt(DateTime? value) =>
      setField<DateTime>('acknowledged_at', value);

  String? get verificationStatus => getField<String>('verification_status');
  set verificationStatus(String? value) =>
      setField<String>('verification_status', value);

  bool? get completionSynced => getField<bool>('completion_synced');
  set completionSynced(bool? value) =>
      setField<bool>('completion_synced', value);

  String? get calendarEventId => getField<String>('calendar_event_id');
  set calendarEventId(String? value) =>
      setField<String>('calendar_event_id', value);

  DateTime? get calendarSyncedAt => getField<DateTime>('calendar_synced_at');
  set calendarSyncedAt(DateTime? value) =>
      setField<DateTime>('calendar_synced_at', value);

  bool? get completed => getField<bool>('completed');
  set completed(bool? value) => setField<bool>('completed', value);

  double? get targetValue => getField<double>('target_value');
  set targetValue(double? value) => setField<double>('target_value', value);

  String? get unit => getField<String>('unit');
  set unit(String? value) => setField<String>('unit', value);

  String? get frequency => getField<String>('frequency');
  set frequency(String? value) => setField<String>('frequency', value);

  DateTime? get startAt => getField<DateTime>('start_at');
  set startAt(DateTime? value) => setField<DateTime>('start_at', value);

  DateTime? get endAt => getField<DateTime>('end_at');
  set endAt(DateTime? value) => setField<DateTime>('end_at', value);

  String? get location => getField<String>('location');
  set location(String? value) => setField<String>('location', value);

  double? get amount => getField<double>('amount');
  set amount(double? value) => setField<double>('amount', value);

  String? get payee => getField<String>('payee');
  set payee(String? value) => setField<String>('payee', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  String? get loginUrl => getField<String>('login_url');
  set loginUrl(String? value) => setField<String>('login_url', value);

  String? get trackingType => getField<String>('tracking_type');
  set trackingType(String? value) => setField<String>('tracking_type', value);
}
