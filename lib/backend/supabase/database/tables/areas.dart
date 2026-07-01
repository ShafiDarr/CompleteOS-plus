import '../database.dart';

class AreasTable extends SupabaseTable<AreasRow> {
  @override
  String get tableName => 'areas';

  @override
  AreasRow createRow(Map<String, dynamic> data) => AreasRow(data);
}

class AreasRow extends SupabaseDataRow {
  AreasRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AreasTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String get name => getField<String>('name')!;
  set name(String value) => setField<String>('name', value);

  String? get description => getField<String>('description');
  set description(String? value) => setField<String>('description', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  bool? get active => getField<bool>('active');
  set active(bool? value) => setField<bool>('active', value);
}
