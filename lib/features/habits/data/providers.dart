import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../database/app_database.dart';
import 'habit_repository.dart';

/// Provides the singleton AppDatabase instance.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase.instance;
});

/// Provides the HabitRepository.
final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  final database = ref.watch(appDatabaseProvider);
  return HabitRepositoryImpl(database: database);
});
