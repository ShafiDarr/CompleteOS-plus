import '../database.dart';

class RecurringTemplatesTable extends SupabaseTable<RecurringTemplatesRow> {
  @override
  String get tableName => 'recurring_templates';

  @override
  RecurringTemplatesRow createRow(Map<String, dynamic> data) =>
      RecurringTemplatesRow(data);
}

class RecurringTemplatesRow extends SupabaseDataRow {
  RecurringTemplatesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RecurringTemplatesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get defaultTaskType => getField<String>('default_task_type');
  set defaultTaskType(String? value) =>
      setField<String>('default_task_type', value);

  bool? get active => getField<bool>('active');
  set active(bool? value) => setField<bool>('active', value);

  String? get defaultStatus => getField<String>('default_status');
  set defaultStatus(String? value) => setField<String>('default_status', value);

  String? get defaultPriority => getField<String>('default_priority');
  set defaultPriority(String? value) =>
      setField<String>('default_priority', value);

  String? get scheduleType => getField<String>('schedule_type');
  set scheduleType(String? value) => setField<String>('schedule_type', value);

  String? get patternWeek => getField<String>('pattern_week');
  set patternWeek(String? value) => setField<String>('pattern_week', value);

  String? get frequency => getField<String>('frequency');
  set frequency(String? value) => setField<String>('frequency', value);

  double? get interval => getField<double>('interval');
  set interval(double? value) => setField<double>('interval', value);

  String? get daysOfWeek => getField<String>('days_of_week');
  set daysOfWeek(String? value) => setField<String>('days_of_week', value);

  PostgresTime? get timeOfDay => getField<PostgresTime>('time_of_day');
  set timeOfDay(PostgresTime? value) =>
      setField<PostgresTime>('time_of_day', value);

  double? get dayOfMonth => getField<double>('day_of_month');
  set dayOfMonth(double? value) => setField<double>('day_of_month', value);

  String? get areaId => getField<String>('area_id');
  set areaId(String? value) => setField<String>('area_id', value);

  String? get projectId => getField<String>('project_id');
  set projectId(String? value) => setField<String>('project_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get lastCompletedAt => getField<DateTime>('last_completed_at');
  set lastCompletedAt(DateTime? value) =>
      setField<DateTime>('last_completed_at', value);

  DateTime? get nextRunAt => getField<DateTime>('next_run_at');
  set nextRunAt(DateTime? value) => setField<DateTime>('next_run_at', value);

  bool? get calendarSync => getField<bool>('calendar_sync');
  set calendarSync(bool? value) => setField<bool>('calendar_sync', value);

  String? get recurrenceType => getField<String>('recurrence_type');
  set recurrenceType(String? value) =>
      setField<String>('recurrence_type', value);

  String? get defaultReminderLevel =>
      getField<String>('default_reminder_level');
  set defaultReminderLevel(String? value) =>
      setField<String>('default_reminder_level', value);

  DateTime? get lastGeneratedAt => getField<DateTime>('last_generated_at');
  set lastGeneratedAt(DateTime? value) =>
      setField<DateTime>('last_generated_at', value);
}
