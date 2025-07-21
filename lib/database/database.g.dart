// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $DocumentsTable extends Documents
    with TableInfo<$DocumentsTable, Document> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DocumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _fileNameMeta =
      const VerificationMeta('fileName');
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
      'file_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _fileHashMeta =
      const VerificationMeta('fileHash');
  @override
  late final GeneratedColumn<String> fileHash = GeneratedColumn<String>(
      'file_hash', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _fileSizeMeta =
      const VerificationMeta('fileSize');
  @override
  late final GeneratedColumn<int> fileSize = GeneratedColumn<int>(
      'file_size', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fileTypeMeta =
      const VerificationMeta('fileType');
  @override
  late final GeneratedColumn<String> fileType = GeneratedColumn<String>(
      'file_type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _uploadedAtMeta =
      const VerificationMeta('uploadedAt');
  @override
  late final GeneratedColumn<DateTime> uploadedAt = GeneratedColumn<DateTime>(
      'uploaded_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, fileName, fileHash, fileSize, fileType, uploadedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'documents';
  @override
  VerificationContext validateIntegrity(Insertable<Document> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('file_name')) {
      context.handle(_fileNameMeta,
          fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta));
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_hash')) {
      context.handle(_fileHashMeta,
          fileHash.isAcceptableOrUnknown(data['file_hash']!, _fileHashMeta));
    } else if (isInserting) {
      context.missing(_fileHashMeta);
    }
    if (data.containsKey('file_size')) {
      context.handle(_fileSizeMeta,
          fileSize.isAcceptableOrUnknown(data['file_size']!, _fileSizeMeta));
    } else if (isInserting) {
      context.missing(_fileSizeMeta);
    }
    if (data.containsKey('file_type')) {
      context.handle(_fileTypeMeta,
          fileType.isAcceptableOrUnknown(data['file_type']!, _fileTypeMeta));
    } else if (isInserting) {
      context.missing(_fileTypeMeta);
    }
    if (data.containsKey('uploaded_at')) {
      context.handle(
          _uploadedAtMeta,
          uploadedAt.isAcceptableOrUnknown(
              data['uploaded_at']!, _uploadedAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Document map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Document(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      fileName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_name'])!,
      fileHash: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_hash'])!,
      fileSize: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}file_size'])!,
      fileType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}file_type'])!,
      uploadedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}uploaded_at'])!,
    );
  }

  @override
  $DocumentsTable createAlias(String alias) {
    return $DocumentsTable(attachedDatabase, alias);
  }
}

class Document extends DataClass implements Insertable<Document> {
  final int id;
  final String fileName;
  final String fileHash;
  final int fileSize;
  final String fileType;
  final DateTime uploadedAt;
  const Document(
      {required this.id,
      required this.fileName,
      required this.fileHash,
      required this.fileSize,
      required this.fileType,
      required this.uploadedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['file_name'] = Variable<String>(fileName);
    map['file_hash'] = Variable<String>(fileHash);
    map['file_size'] = Variable<int>(fileSize);
    map['file_type'] = Variable<String>(fileType);
    map['uploaded_at'] = Variable<DateTime>(uploadedAt);
    return map;
  }

  DocumentsCompanion toCompanion(bool nullToAbsent) {
    return DocumentsCompanion(
      id: Value(id),
      fileName: Value(fileName),
      fileHash: Value(fileHash),
      fileSize: Value(fileSize),
      fileType: Value(fileType),
      uploadedAt: Value(uploadedAt),
    );
  }

  factory Document.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Document(
      id: serializer.fromJson<int>(json['id']),
      fileName: serializer.fromJson<String>(json['fileName']),
      fileHash: serializer.fromJson<String>(json['fileHash']),
      fileSize: serializer.fromJson<int>(json['fileSize']),
      fileType: serializer.fromJson<String>(json['fileType']),
      uploadedAt: serializer.fromJson<DateTime>(json['uploadedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'fileName': serializer.toJson<String>(fileName),
      'fileHash': serializer.toJson<String>(fileHash),
      'fileSize': serializer.toJson<int>(fileSize),
      'fileType': serializer.toJson<String>(fileType),
      'uploadedAt': serializer.toJson<DateTime>(uploadedAt),
    };
  }

  Document copyWith(
          {int? id,
          String? fileName,
          String? fileHash,
          int? fileSize,
          String? fileType,
          DateTime? uploadedAt}) =>
      Document(
        id: id ?? this.id,
        fileName: fileName ?? this.fileName,
        fileHash: fileHash ?? this.fileHash,
        fileSize: fileSize ?? this.fileSize,
        fileType: fileType ?? this.fileType,
        uploadedAt: uploadedAt ?? this.uploadedAt,
      );
  Document copyWithCompanion(DocumentsCompanion data) {
    return Document(
      id: data.id.present ? data.id.value : this.id,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      fileHash: data.fileHash.present ? data.fileHash.value : this.fileHash,
      fileSize: data.fileSize.present ? data.fileSize.value : this.fileSize,
      fileType: data.fileType.present ? data.fileType.value : this.fileType,
      uploadedAt:
          data.uploadedAt.present ? data.uploadedAt.value : this.uploadedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Document(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSize: $fileSize, ')
          ..write('fileType: $fileType, ')
          ..write('uploadedAt: $uploadedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, fileName, fileHash, fileSize, fileType, uploadedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Document &&
          other.id == this.id &&
          other.fileName == this.fileName &&
          other.fileHash == this.fileHash &&
          other.fileSize == this.fileSize &&
          other.fileType == this.fileType &&
          other.uploadedAt == this.uploadedAt);
}

class DocumentsCompanion extends UpdateCompanion<Document> {
  final Value<int> id;
  final Value<String> fileName;
  final Value<String> fileHash;
  final Value<int> fileSize;
  final Value<String> fileType;
  final Value<DateTime> uploadedAt;
  const DocumentsCompanion({
    this.id = const Value.absent(),
    this.fileName = const Value.absent(),
    this.fileHash = const Value.absent(),
    this.fileSize = const Value.absent(),
    this.fileType = const Value.absent(),
    this.uploadedAt = const Value.absent(),
  });
  DocumentsCompanion.insert({
    this.id = const Value.absent(),
    required String fileName,
    required String fileHash,
    required int fileSize,
    required String fileType,
    this.uploadedAt = const Value.absent(),
  })  : fileName = Value(fileName),
        fileHash = Value(fileHash),
        fileSize = Value(fileSize),
        fileType = Value(fileType);
  static Insertable<Document> custom({
    Expression<int>? id,
    Expression<String>? fileName,
    Expression<String>? fileHash,
    Expression<int>? fileSize,
    Expression<String>? fileType,
    Expression<DateTime>? uploadedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (fileName != null) 'file_name': fileName,
      if (fileHash != null) 'file_hash': fileHash,
      if (fileSize != null) 'file_size': fileSize,
      if (fileType != null) 'file_type': fileType,
      if (uploadedAt != null) 'uploaded_at': uploadedAt,
    });
  }

  DocumentsCompanion copyWith(
      {Value<int>? id,
      Value<String>? fileName,
      Value<String>? fileHash,
      Value<int>? fileSize,
      Value<String>? fileType,
      Value<DateTime>? uploadedAt}) {
    return DocumentsCompanion(
      id: id ?? this.id,
      fileName: fileName ?? this.fileName,
      fileHash: fileHash ?? this.fileHash,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (fileHash.present) {
      map['file_hash'] = Variable<String>(fileHash.value);
    }
    if (fileSize.present) {
      map['file_size'] = Variable<int>(fileSize.value);
    }
    if (fileType.present) {
      map['file_type'] = Variable<String>(fileType.value);
    }
    if (uploadedAt.present) {
      map['uploaded_at'] = Variable<DateTime>(uploadedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DocumentsCompanion(')
          ..write('id: $id, ')
          ..write('fileName: $fileName, ')
          ..write('fileHash: $fileHash, ')
          ..write('fileSize: $fileSize, ')
          ..write('fileType: $fileType, ')
          ..write('uploadedAt: $uploadedAt')
          ..write(')'))
        .toString();
  }
}

class $ChunksTable extends Chunks with TableInfo<$ChunksTable, Chunk> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChunksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _documentIdMeta =
      const VerificationMeta('documentId');
  @override
  late final GeneratedColumn<int> documentId = GeneratedColumn<int>(
      'document_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES documents (id)'));
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _embeddingMeta =
      const VerificationMeta('embedding');
  @override
  late final GeneratedColumn<Uint8List> embedding = GeneratedColumn<Uint8List>(
      'embedding', aliasedName, false,
      type: DriftSqlType.blob, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns =>
      [id, documentId, content, title, embedding, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chunks';
  @override
  VerificationContext validateIntegrity(Insertable<Chunk> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('document_id')) {
      context.handle(
          _documentIdMeta,
          documentId.isAcceptableOrUnknown(
              data['document_id']!, _documentIdMeta));
    } else if (isInserting) {
      context.missing(_documentIdMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('embedding')) {
      context.handle(_embeddingMeta,
          embedding.isAcceptableOrUnknown(data['embedding']!, _embeddingMeta));
    } else if (isInserting) {
      context.missing(_embeddingMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chunk map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chunk(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      documentId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}document_id'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      embedding: attachedDatabase.typeMapping
          .read(DriftSqlType.blob, data['${effectivePrefix}embedding'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ChunksTable createAlias(String alias) {
    return $ChunksTable(attachedDatabase, alias);
  }
}

class Chunk extends DataClass implements Insertable<Chunk> {
  final int id;
  final int documentId;
  final String content;
  final String? title;
  final Uint8List embedding;
  final DateTime createdAt;
  const Chunk(
      {required this.id,
      required this.documentId,
      required this.content,
      this.title,
      required this.embedding,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['document_id'] = Variable<int>(documentId);
    map['content'] = Variable<String>(content);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['embedding'] = Variable<Uint8List>(embedding);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ChunksCompanion toCompanion(bool nullToAbsent) {
    return ChunksCompanion(
      id: Value(id),
      documentId: Value(documentId),
      content: Value(content),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      embedding: Value(embedding),
      createdAt: Value(createdAt),
    );
  }

  factory Chunk.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chunk(
      id: serializer.fromJson<int>(json['id']),
      documentId: serializer.fromJson<int>(json['documentId']),
      content: serializer.fromJson<String>(json['content']),
      title: serializer.fromJson<String?>(json['title']),
      embedding: serializer.fromJson<Uint8List>(json['embedding']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'documentId': serializer.toJson<int>(documentId),
      'content': serializer.toJson<String>(content),
      'title': serializer.toJson<String?>(title),
      'embedding': serializer.toJson<Uint8List>(embedding),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Chunk copyWith(
          {int? id,
          int? documentId,
          String? content,
          Value<String?> title = const Value.absent(),
          Uint8List? embedding,
          DateTime? createdAt}) =>
      Chunk(
        id: id ?? this.id,
        documentId: documentId ?? this.documentId,
        content: content ?? this.content,
        title: title.present ? title.value : this.title,
        embedding: embedding ?? this.embedding,
        createdAt: createdAt ?? this.createdAt,
      );
  Chunk copyWithCompanion(ChunksCompanion data) {
    return Chunk(
      id: data.id.present ? data.id.value : this.id,
      documentId:
          data.documentId.present ? data.documentId.value : this.documentId,
      content: data.content.present ? data.content.value : this.content,
      title: data.title.present ? data.title.value : this.title,
      embedding: data.embedding.present ? data.embedding.value : this.embedding,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chunk(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('content: $content, ')
          ..write('title: $title, ')
          ..write('embedding: $embedding, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, documentId, content, title,
      $driftBlobEquality.hash(embedding), createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chunk &&
          other.id == this.id &&
          other.documentId == this.documentId &&
          other.content == this.content &&
          other.title == this.title &&
          $driftBlobEquality.equals(other.embedding, this.embedding) &&
          other.createdAt == this.createdAt);
}

class ChunksCompanion extends UpdateCompanion<Chunk> {
  final Value<int> id;
  final Value<int> documentId;
  final Value<String> content;
  final Value<String?> title;
  final Value<Uint8List> embedding;
  final Value<DateTime> createdAt;
  const ChunksCompanion({
    this.id = const Value.absent(),
    this.documentId = const Value.absent(),
    this.content = const Value.absent(),
    this.title = const Value.absent(),
    this.embedding = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ChunksCompanion.insert({
    this.id = const Value.absent(),
    required int documentId,
    required String content,
    this.title = const Value.absent(),
    required Uint8List embedding,
    this.createdAt = const Value.absent(),
  })  : documentId = Value(documentId),
        content = Value(content),
        embedding = Value(embedding);
  static Insertable<Chunk> custom({
    Expression<int>? id,
    Expression<int>? documentId,
    Expression<String>? content,
    Expression<String>? title,
    Expression<Uint8List>? embedding,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (documentId != null) 'document_id': documentId,
      if (content != null) 'content': content,
      if (title != null) 'title': title,
      if (embedding != null) 'embedding': embedding,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ChunksCompanion copyWith(
      {Value<int>? id,
      Value<int>? documentId,
      Value<String>? content,
      Value<String?>? title,
      Value<Uint8List>? embedding,
      Value<DateTime>? createdAt}) {
    return ChunksCompanion(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      content: content ?? this.content,
      title: title ?? this.title,
      embedding: embedding ?? this.embedding,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (documentId.present) {
      map['document_id'] = Variable<int>(documentId.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (embedding.present) {
      map['embedding'] = Variable<Uint8List>(embedding.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChunksCompanion(')
          ..write('id: $id, ')
          ..write('documentId: $documentId, ')
          ..write('content: $content, ')
          ..write('title: $title, ')
          ..write('embedding: $embedding, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DocumentsTable documents = $DocumentsTable(this);
  late final $ChunksTable chunks = $ChunksTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [documents, chunks];
}

typedef $$DocumentsTableCreateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  required String fileName,
  required String fileHash,
  required int fileSize,
  required String fileType,
  Value<DateTime> uploadedAt,
});
typedef $$DocumentsTableUpdateCompanionBuilder = DocumentsCompanion Function({
  Value<int> id,
  Value<String> fileName,
  Value<String> fileHash,
  Value<int> fileSize,
  Value<String> fileType,
  Value<DateTime> uploadedAt,
});

final class $$DocumentsTableReferences
    extends BaseReferences<_$AppDatabase, $DocumentsTable, Document> {
  $$DocumentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ChunksTable, List<Chunk>> _chunksRefsTable(
          _$AppDatabase db) =>
      MultiTypedResultKey.fromTable(db.chunks,
          aliasName:
              $_aliasNameGenerator(db.documents.id, db.chunks.documentId));

  $$ChunksTableProcessedTableManager get chunksRefs {
    final manager = $$ChunksTableTableManager($_db, $_db.chunks)
        .filter((f) => f.documentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_chunksRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$DocumentsTableFilterComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileHash => $composableBuilder(
      column: $table.fileHash, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => ColumnFilters(column));

  Expression<bool> chunksRefs(
      Expression<bool> Function($$ChunksTableFilterComposer f) f) {
    final $$ChunksTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chunks,
        getReferencedColumn: (t) => t.documentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChunksTableFilterComposer(
              $db: $db,
              $table: $db.chunks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DocumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileName => $composableBuilder(
      column: $table.fileName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileHash => $composableBuilder(
      column: $table.fileHash, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fileSize => $composableBuilder(
      column: $table.fileSize, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get fileType => $composableBuilder(
      column: $table.fileType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => ColumnOrderings(column));
}

class $$DocumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DocumentsTable> {
  $$DocumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get fileHash =>
      $composableBuilder(column: $table.fileHash, builder: (column) => column);

  GeneratedColumn<int> get fileSize =>
      $composableBuilder(column: $table.fileSize, builder: (column) => column);

  GeneratedColumn<String> get fileType =>
      $composableBuilder(column: $table.fileType, builder: (column) => column);

  GeneratedColumn<DateTime> get uploadedAt => $composableBuilder(
      column: $table.uploadedAt, builder: (column) => column);

  Expression<T> chunksRefs<T extends Object>(
      Expression<T> Function($$ChunksTableAnnotationComposer a) f) {
    final $$ChunksTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.chunks,
        getReferencedColumn: (t) => t.documentId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$ChunksTableAnnotationComposer(
              $db: $db,
              $table: $db.chunks,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$DocumentsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, $$DocumentsTableReferences),
    Document,
    PrefetchHooks Function({bool chunksRefs})> {
  $$DocumentsTableTableManager(_$AppDatabase db, $DocumentsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DocumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DocumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DocumentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> fileName = const Value.absent(),
            Value<String> fileHash = const Value.absent(),
            Value<int> fileSize = const Value.absent(),
            Value<String> fileType = const Value.absent(),
            Value<DateTime> uploadedAt = const Value.absent(),
          }) =>
              DocumentsCompanion(
            id: id,
            fileName: fileName,
            fileHash: fileHash,
            fileSize: fileSize,
            fileType: fileType,
            uploadedAt: uploadedAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String fileName,
            required String fileHash,
            required int fileSize,
            required String fileType,
            Value<DateTime> uploadedAt = const Value.absent(),
          }) =>
              DocumentsCompanion.insert(
            id: id,
            fileName: fileName,
            fileHash: fileHash,
            fileSize: fileSize,
            fileType: fileType,
            uploadedAt: uploadedAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$DocumentsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({chunksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (chunksRefs) db.chunks],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (chunksRefs)
                    await $_getPrefetchedData<Document, $DocumentsTable, Chunk>(
                        currentTable: table,
                        referencedTable:
                            $$DocumentsTableReferences._chunksRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$DocumentsTableReferences(db, table, p0)
                                .chunksRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.documentId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$DocumentsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $DocumentsTable,
    Document,
    $$DocumentsTableFilterComposer,
    $$DocumentsTableOrderingComposer,
    $$DocumentsTableAnnotationComposer,
    $$DocumentsTableCreateCompanionBuilder,
    $$DocumentsTableUpdateCompanionBuilder,
    (Document, $$DocumentsTableReferences),
    Document,
    PrefetchHooks Function({bool chunksRefs})>;
typedef $$ChunksTableCreateCompanionBuilder = ChunksCompanion Function({
  Value<int> id,
  required int documentId,
  required String content,
  Value<String?> title,
  required Uint8List embedding,
  Value<DateTime> createdAt,
});
typedef $$ChunksTableUpdateCompanionBuilder = ChunksCompanion Function({
  Value<int> id,
  Value<int> documentId,
  Value<String> content,
  Value<String?> title,
  Value<Uint8List> embedding,
  Value<DateTime> createdAt,
});

final class $$ChunksTableReferences
    extends BaseReferences<_$AppDatabase, $ChunksTable, Chunk> {
  $$ChunksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DocumentsTable _documentIdTable(_$AppDatabase db) => db.documents
      .createAlias($_aliasNameGenerator(db.chunks.documentId, db.documents.id));

  $$DocumentsTableProcessedTableManager get documentId {
    final $_column = $_itemColumn<int>('document_id')!;

    final manager = $$DocumentsTableTableManager($_db, $_db.documents)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_documentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$ChunksTableFilterComposer
    extends Composer<_$AppDatabase, $ChunksTable> {
  $$ChunksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<Uint8List> get embedding => $composableBuilder(
      column: $table.embedding, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  $$DocumentsTableFilterComposer get documentId {
    final $$DocumentsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.documentId,
        referencedTable: $db.documents,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DocumentsTableFilterComposer(
              $db: $db,
              $table: $db.documents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChunksTableOrderingComposer
    extends Composer<_$AppDatabase, $ChunksTable> {
  $$ChunksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<Uint8List> get embedding => $composableBuilder(
      column: $table.embedding, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  $$DocumentsTableOrderingComposer get documentId {
    final $$DocumentsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.documentId,
        referencedTable: $db.documents,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DocumentsTableOrderingComposer(
              $db: $db,
              $table: $db.documents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChunksTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChunksTable> {
  $$ChunksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<Uint8List> get embedding =>
      $composableBuilder(column: $table.embedding, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$DocumentsTableAnnotationComposer get documentId {
    final $$DocumentsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.documentId,
        referencedTable: $db.documents,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$DocumentsTableAnnotationComposer(
              $db: $db,
              $table: $db.documents,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$ChunksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ChunksTable,
    Chunk,
    $$ChunksTableFilterComposer,
    $$ChunksTableOrderingComposer,
    $$ChunksTableAnnotationComposer,
    $$ChunksTableCreateCompanionBuilder,
    $$ChunksTableUpdateCompanionBuilder,
    (Chunk, $$ChunksTableReferences),
    Chunk,
    PrefetchHooks Function({bool documentId})> {
  $$ChunksTableTableManager(_$AppDatabase db, $ChunksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChunksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChunksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChunksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> documentId = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<Uint8List> embedding = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ChunksCompanion(
            id: id,
            documentId: documentId,
            content: content,
            title: title,
            embedding: embedding,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int documentId,
            required String content,
            Value<String?> title = const Value.absent(),
            required Uint8List embedding,
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ChunksCompanion.insert(
            id: id,
            documentId: documentId,
            content: content,
            title: title,
            embedding: embedding,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$ChunksTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({documentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (documentId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.documentId,
                    referencedTable:
                        $$ChunksTableReferences._documentIdTable(db),
                    referencedColumn:
                        $$ChunksTableReferences._documentIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$ChunksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ChunksTable,
    Chunk,
    $$ChunksTableFilterComposer,
    $$ChunksTableOrderingComposer,
    $$ChunksTableAnnotationComposer,
    $$ChunksTableCreateCompanionBuilder,
    $$ChunksTableUpdateCompanionBuilder,
    (Chunk, $$ChunksTableReferences),
    Chunk,
    PrefetchHooks Function({bool documentId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DocumentsTableTableManager get documents =>
      $$DocumentsTableTableManager(_db, _db.documents);
  $$ChunksTableTableManager get chunks =>
      $$ChunksTableTableManager(_db, _db.chunks);
}
