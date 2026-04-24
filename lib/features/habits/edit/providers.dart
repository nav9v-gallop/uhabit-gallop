import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/models/habit.dart';
import '../data/habit_repository.dart';
import '../data/providers.dart';
import 'bloc/edit_habit_bloc.dart';

/// Provider family for EditHabitBloc, parameterized by habit type.
///
/// Usage:
/// ```dart
/// final bloc = ref.read(editHabitBlocProvider(HabitType.boolean));
/// ```
final editHabitBlocProvider =
    Provider.family<EditHabitBloc, HabitType>((ref, habitType) {
  final repository = ref.watch(habitRepositoryProvider);
  return EditHabitBloc(
    habitRepository: repository,
    habitType: habitType,
  );
});
