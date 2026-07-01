import '../database.dart';

class RoutinesTable extends SupabaseTable<RoutinesRow> {
  @override
  String get tableName => 'routines';

  @override
  RoutinesRow createRow(Map<String, dynamic> data) => RoutinesRow(data);
}

class RoutinesRow extends SupabaseDataRow {
  RoutinesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => RoutinesTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get areaId => getField<String>('area_id');
  set areaId(String? value) => setField<String>('area_id', value);

  String? get projectId => getField<String>('project_id');
  set projectId(String? value) => setField<String>('project_id', value);

  String? get templateId => getField<String>('template_id');
  set templateId(String? value) => setField<String>('template_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
