import 'package:drift/drift.dart';

class Documents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fileName => text()();
  TextColumn get fileHash => text().unique()();
  IntColumn get fileSize => integer()();
  TextColumn get fileType => text()();
  DateTimeColumn get uploadedAt => dateTime().withDefault(currentDateAndTime)();
}

class Chunks extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get documentId => integer().references(Documents, #id)();
  TextColumn get content => text()();
  TextColumn get title => text().nullable()(); // Section heading or topic
  BlobColumn get embedding => blob()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}