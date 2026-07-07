import '../database.dart';

class HabitLogsTable extends SupabaseTable<HabitLogsRow> {
  @override
  String get tableName => 'habit_logs';

  @override
  HabitLogsRow createRow(Map<String, dynamic> data) => HabitLogsRow(data);
}

class HabitLogsRow extends SupabaseDataRow {
  HabitLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => HabitLogsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get logDate => getField<DateTime>('log_date');
  set logDate(DateTime? value) => setField<DateTime>('log_date', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);

  String? get taskId => getField<String>('task_id');
  set taskId(String? value) => setField<String>('task_id', value);
}
