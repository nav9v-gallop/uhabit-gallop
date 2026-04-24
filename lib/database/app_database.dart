import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/habits.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Habits])
class AppDatabase extends _$AppDatabase {
  AppDatabase._() : super(_openConnection());

  static final AppDatabase instance = AppDatabase._();

  @override
  int get schemaVersion => 1;

  /// Returns the next available position for a new habit.
  /// Computes COALESCE(MAX(position), -1) + 1.
  Future<int> getNextPosition() async {
    final result = await customSelect(
      'SELECT COALESCE(MAX(position), -1) + 1 AS next_pos FROM habits',
    ).getSingle();
    return result.read<int>('next_pos');
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'loop_habits.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
