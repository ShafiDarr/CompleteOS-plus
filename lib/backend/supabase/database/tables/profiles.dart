import '../database.dart';

class ProfilesTable extends SupabaseTable<ProfilesRow> {
  @override
  String get tableName => 'profiles';

  @override
  ProfilesRow createRow(Map<String, dynamic> data) => ProfilesRow(data);
}

class ProfilesRow extends SupabaseDataRow {
  ProfilesRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProfilesTable();

  String get id => getField<String>('id')!;
  set id(String value) => setField<String>('id', value);

  String? get displayName => getField<String>('display_name');
  set displayName(String? value) => setField<String>('display_name', value);

  String? get timezone => getField<String>('timezone');
  set timezone(String? value) => setField<String>('timezone', value);

  PostgresTime? get wakeTime => getField<PostgresTime>('wake_time');
  set wakeTime(PostgresTime? value) =>
      setField<PostgresTime>('wake_time', value);

  PostgresTime? get sleepTime => getField<PostgresTime>('sleep_time');
  set sleepTime(PostgresTime? value) =>
      setField<PostgresTime>('sleep_time', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
