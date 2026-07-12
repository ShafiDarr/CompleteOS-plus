import '../database.dart';

class RoutineStepsTable extends SupabaseTable<RoutineStepsRow> {
  @override
  String get tableName => 'routine_steps';

  @override
  RoutineStepsRow createRow(Map<String, dynamic> data) => RoutineStepsRow(data);
}

class RoutineStepsRow extends SupabaseDataRow {
  RoutineStepsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RoutineStepsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get taskId => getField<String>('task_id');
  set taskId(String? value) => setField<String>('task_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  int get stepOrder => getField<int>('step_order')!;
  set stepOrder(int value) => setField<int>('step_order', value);

  bool? get isRequired => getField<bool>('is_required');
  set isRequired(bool? value) => setField<bool>('is_required', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
