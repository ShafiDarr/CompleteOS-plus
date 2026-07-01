import '../database.dart';

class DailyPlanBlocksTable extends SupabaseTable<DailyPlanBlocksRow> {
  @override
  String get tableName => 'daily_plan_blocks';

  @override
  DailyPlanBlocksRow createRow(Map<String, dynamic> data) =>
      DailyPlanBlocksRow(data);
}

class DailyPlanBlocksRow extends SupabaseDataRow {
  DailyPlanBlocksRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DailyPlanBlocksTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get dailyPlanId => getField<String>('daily_plan_id')!;
  set dailyPlanId(String value) => setField<String>('daily_plan_id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get areaId => getField<String>('area_id');
  set areaId(String? value) => setField<String>('area_id', value);

  String get blockName => getField<String>('block_name')!;
  set blockName(String value) => setField<String>('block_name', value);

  PostgresTime get startTime => getField<PostgresTime>('start_time')!;
  set startTime(PostgresTime value) =>
      setField<PostgresTime>('start_time', value);

  PostgresTime get endTime => getField<PostgresTime>('end_time')!;
  set endTime(PostgresTime value) => setField<PostgresTime>('end_time', value);

  int? get sortOrder => getField<int>('sort_order');
  set sortOrder(int? value) => setField<int>('sort_order', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get sourceDayBlockId => getField<String>('source_day_block_id');
  set sourceDayBlockId(String? value) =>
      setField<String>('source_day_block_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAtupdatedAt =>
      getField<DateTime>('updated_atupdated_at');
  set updatedAtupdatedAt(DateTime? value) =>
      setField<DateTime>('updated_atupdated_at', value);
}
