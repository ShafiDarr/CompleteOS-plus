import '../database.dart';

class DailyPlansTable extends SupabaseTable<DailyPlansRow> {
  @override
  String get tableName => 'daily_plans';

  @override
  DailyPlansRow createRow(Map<String, dynamic> data) => DailyPlansRow(data);
}

class DailyPlansRow extends SupabaseDataRow {
  DailyPlansRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DailyPlansTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime get planDate => getField<DateTime>('plan_date')!;
  set planDate(DateTime value) => setField<DateTime>('plan_date', value);

  String? get templateId => getField<String>('template_id');
  set templateId(String? value) => setField<String>('template_id', value);

  String? get planType => getField<String>('plan_type');
  set planType(String? value) => setField<String>('plan_type', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get source => getField<String>('source');
  set source(String? value) => setField<String>('source', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
