import '../database.dart';

class HabitsTable extends SupabaseTable<HabitsRow> {
  @override
  String get tableName => 'habits';

  @override
  HabitsRow createRow(Map<String, dynamic> data) => HabitsRow(data);
}

class HabitsRow extends SupabaseDataRow {
  HabitsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => HabitsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  double? get targetValue => getField<double>('target_value');
  set targetValue(double? value) => setField<double>('target_value', value);

  String? get unit => getField<String>('unit');
  set unit(String? value) => setField<String>('unit', value);

  String? get frequency => getField<String>('frequency');
  set frequency(String? value) => setField<String>('frequency', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get templateId => getField<String>('template_id');
  set templateId(String? value) => setField<String>('template_id', value);

  String? get areaId => getField<String>('area_id');
  set areaId(String? value) => setField<String>('area_id', value);

  String? get projectId => getField<String>('project_id');
  set projectId(String? value) => setField<String>('project_id', value);

  String? get trackingType => getField<String>('tracking_type');
  set trackingType(String? value) => setField<String>('tracking_type', value);
}
