import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../database/app_database.dart' as db;
import '../../features/habits/data/habit_repository.dart';
import '../../domain/models/habit.dart';
import 'command.dart';

/// Command that creates a new habit in the database.
///
/// Generates a UUID v4, computes the next position, builds a
/// [HabitsCompanion], and calls [HabitRepository.insert].
class CreateHabitCommand extends Command {
  final HabitRepository habitRepository;
  final String name;
  final String description;
  final String question;
  final int freqNum;
  final int freqDen;
  final int color;
  final int? reminderHour;
  final int? reminderMin;
  final int reminderDays;
  final HabitType habitType;
  final double targetValue;
  final int targetType;
  final String unit;

  /// The ID of the created habit, available after [run] completes.
  int? createdHabitId;

  CreateHabitCommand({
    required this.habitRepository,
    required this.name,
    this.description = '',
    this.question = '',
    this.freqNum = 1,
    this.freqDen = 1,
    this.color = 8,
    this.reminderHour,
    this.reminderMin,
    this.reminderDays = 127,
    this.habitType = HabitType.boolean,
    this.targetValue = 0.0,
    this.targetType = 0,
    this.unit = '',
  });

  @override
  Future<void> run() async {
    final uuid = const Uuid().v4();
    final position = await habitRepository.getNextPosition();

    final companion = db.HabitsCompanion(
      uuid: Value(uuid),
      name: Value(name),
      description: Value(description),
      question: Value(question),
      freqNum: Value(freqNum),
      freqDen: Value(freqDen),
      color: Value(color),
      position: Value(position),
      reminderHour: Value(reminderHour),
      reminderMin: Value(reminderMin),
      reminderDays: Value(reminderDays),
      highlight: const Value(0),
      archived: const Value(0),
      type: Value(habitType.value),
      targetValue: Value(targetValue),
      targetType: Value(targetType),
      unit: Value(unit),
    );

    createdHabitId = await habitRepository.insert(companion);
  }
}
