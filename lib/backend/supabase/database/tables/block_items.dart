import '../database.dart';

class BlockItemsTable extends SupabaseTable<BlockItemsRow> {
  @override
  String get tableName => 'block_items';

  @override
  BlockItemsRow createRow(Map<String, dynamic> data) => BlockItemsRow(data);
}

class BlockItemsRow extends SupabaseDataRow {
  BlockItemsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => BlockItemsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  String? get dayBlockId => getField<String>('day_block_id');
  set dayBlockId(String? value) => setField<String>('day_block_id', value);

  String get itemType => getField<String>('item_type')!;
  set itemType(String value) => setField<String>('item_type', value);

  String? get taskId => getField<String>('task_id');
  set taskId(String? value) => setField<String>('task_id', value);

  String get title => getField<String>('title')!;
  set title(String value) => setField<String>('title', value);

  double? get targetAmount => getField<double>('target_amount');
  set targetAmount(double? value) => setField<double>('target_amount', value);

  String? get unit => getField<String>('unit');
  set unit(String? value) => setField<String>('unit', value);

  PostgresTime? get targetTime => getField<PostgresTime>('target_time');
  set targetTime(PostgresTime? value) =>
      setField<PostgresTime>('target_time', value);

  PostgresTime? get deadlineTime => getField<PostgresTime>('deadline_time');
  set deadlineTime(PostgresTime? value) =>
      setField<PostgresTime>('deadline_time', value);

  int? get graceMinutes => getField<int>('grace_minutes');
  set graceMinutes(int? value) => setField<int>('grace_minutes', value);

  int get sortOrder => getField<int>('sort_order')!;
  set sortOrder(int value) => setField<int>('sort_order', value);

  bool? get isRequired => getField<bool>('is_required');
  set isRequired(bool? value) => setField<bool>('is_required', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  int? get targetOffsetMinutes => getField<int>('target_offset_minutes');
  set targetOffsetMinutes(int? value) =>
      setField<int>('target_offset_minutes', value);

  int? get deadlineOffsetMinutes => getField<int>('deadline_offset_minutes');
  set deadlineOffsetMinutes(int? value) =>
      setField<int>('deadline_offset_minutes', value);
}
