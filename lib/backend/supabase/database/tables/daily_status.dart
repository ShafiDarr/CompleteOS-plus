import '../database.dart';

class DailyStatusTable extends SupabaseTable<DailyStatusRow> {
  @override
  String get tableName => 'daily_status';

  @override
  DailyStatusRow createRow(Map<String, dynamic> data) => DailyStatusRow(data);
}

class DailyStatusRow extends SupabaseDataRow {
  DailyStatusRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DailyStatusTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String get userId => getField<String>('user_id')!;
  set userId(String value) => setField<String>('user_id', value);

  DateTime get statusDate => getField<DateTime>('status_date')!;
  set statusDate(DateTime value) => setField<DateTime>('status_date', value);

  String? get dayState => getField<String>('day_state');
  set dayState(String? value) => setField<String>('day_state', value);

  DateTime? get checkInTime => getField<DateTime>('check_in_time');
  set checkInTime(DateTime? value) =>
      setField<DateTime>('check_in_time', value);

  DateTime? get checkOutTime => getField<DateTime>('check_out_time');
  set checkOutTime(DateTime? value) =>
      setField<DateTime>('check_out_time', value);

  String? get wakeStatus => getField<String>('wake_status');
  set wakeStatus(String? value) => setField<String>('wake_status', value);

  String? get wakeMessage => getField<String>('wake_message');
  set wakeMessage(String? value) => setField<String>('wake_message', value);

  String? get sleepStatus => getField<String>('sleep_status');
  set sleepStatus(String? value) => setField<String>('sleep_status', value);

  String? get sleepMessage => getField<String>('sleep_message');
  set sleepMessage(String? value) => setField<String>('sleep_message', value);

  double? get alignmentScore => getField<double>('alignment_score');
  set alignmentScore(double? value) =>
      setField<double>('alignment_score', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
