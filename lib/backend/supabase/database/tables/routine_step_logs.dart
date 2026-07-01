import '../database.dart';

class RoutineStepLogsTable extends SupabaseTable<RoutineStepLogsRow> {
  @override
  String get tableName => 'routine_step_logs';

  @override
  RoutineStepLogsRow createRow(Map<String, dynamic> data) =>
      RoutineStepLogsRow(data);
}

class RoutineStepLogsRow extends SupabaseDataRow {
  RoutineStepLogsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RoutineStepLogsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get routineStepId => getField<String>('routine_step_id')!;
  set routineStepId(String value) => setField<String>('routine_step_id', value);

  DateTime get logDate => getField<DateTime>('log_date')!;
  set logDate(DateTime value) => setField<DateTime>('log_date', value);

  DateTime? get completedAt => getField<DateTime>('completed_at');
  set completedAt(DateTime? value) => setField<DateTime>('completed_at', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
