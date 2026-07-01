import '../database.dart';

class DayBlocksTable extends SupabaseTable<DayBlocksRow> {
  @override
  String get tableName => 'day_blocks';

  @override
  DayBlocksRow createRow(Map<String, dynamic> data) => DayBlocksRow(data);
}

class DayBlocksRow extends SupabaseDataRow {
  DayBlocksRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DayBlocksTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  bool? get isActive => getField<bool>('is_active');
  set isActive(bool? value) => setField<bool>('is_active', value);

  PostgresTime? get startTime => getField<PostgresTime>('start_time');
  set startTime(PostgresTime? value) =>
      setField<PostgresTime>('start_time', value);

  PostgresTime? get endTime => getField<PostgresTime>('end_time');
  set endTime(PostgresTime? value) => setField<PostgresTime>('end_time', value);

  int get sortOrder => getField<int>('sort_order')!;
  set sortOrder(int value) => setField<int>('sort_order', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
