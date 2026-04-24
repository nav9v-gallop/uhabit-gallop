import 'package:drift/drift.dart';
import '../../../database/app_database.dart';

/// Abstract repository interface for habit persistence.
abstract class HabitRepository {
  /// Inserts a new habit and returns the auto-generated id.
  Future<int> insert(HabitsCompanion habit);

  /// Returns the next available position (COALESCE(MAX(position), -1) + 1).
  Future<int> getNextPosition();

  /// Returns all habits ordered by position.
  Future<List<Habit>> findAll();
}

/// Concrete implementation of [HabitRepository] using drift.
class HabitRepositoryImpl implements HabitRepository {
  final AppDatabase database;

  HabitRepositoryImpl({required this.database});

  @override
  Future<int> insert(HabitsCompanion habit) async {
    return await database.into(database.habits).insert(habit);
  }

  @override
  Future<int> getNextPosition() async {
    return await database.getNextPosition();
  }

  @override
  Future<List<Habit>> findAll() async {
    final query = database.select(database.habits)
      ..orderBy([(t) => OrderingTerm.asc(t.position)]);
    return await query.get();
  }
}
