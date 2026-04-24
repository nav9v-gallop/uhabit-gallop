import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/commands/create_habit_command.dart';
import '../../../../domain/models/habit.dart';
import '../../../../features/habits/data/habit_repository.dart';
import 'edit_habit_event.dart';
import 'edit_habit_state.dart';

/// BLoC managing the create/edit habit form state.
///
/// Handles all field changes, validation on save, and dispatching
/// [CreateHabitCommand] to persist the habit.
class EditHabitBloc extends Bloc<EditHabitEvent, EditHabitState> {
  final HabitRepository habitRepository;

  EditHabitBloc({
    required this.habitRepository,
    HabitType habitType = HabitType.boolean,
  }) : super(EditHabitState(habitType: habitType)) {
    on<EditHabitNameChanged>(_onNameChanged);
    on<EditHabitQuestionChanged>(_onQuestionChanged);
    on<EditHabitDescriptionChanged>(_onDescriptionChanged);
    on<EditHabitFrequencyChanged>(_onFrequencyChanged);
    on<EditHabitColorChanged>(_onColorChanged);
    on<EditHabitTargetValueChanged>(_onTargetValueChanged);
    on<EditHabitTargetTypeChanged>(_onTargetTypeChanged);
    on<EditHabitUnitChanged>(_onUnitChanged);
    on<EditHabitReminderChanged>(_onReminderChanged);
    on<EditHabitSaveRequested>(_onSaveRequested);
  }

  void _onNameChanged(
    EditHabitNameChanged event,
    Emitter<EditHabitState> emit,
  ) {
    emit(state.copyWith(
      name: event.name,
      nameError: () => null, // Clear error on edit
    ));
  }

  void _onQuestionChanged(
    EditHabitQuestionChanged event,
    Emitter<EditHabitState> emit,
  ) {
    emit(state.copyWith(question: event.question));
  }

  void _onDescriptionChanged(
    EditHabitDescriptionChanged event,
    Emitter<EditHabitState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onFrequencyChanged(
    EditHabitFrequencyChanged event,
    Emitter<EditHabitState> emit,
  ) {
    // Silently correct freq_num < 1 to 1
    final correctedNum = event.num < 1 ? 1 : event.num;
    emit(state.copyWith(freqNum: correctedNum, freqDen: event.den));
  }

  void _onColorChanged(
    EditHabitColorChanged event,
    Emitter<EditHabitState> emit,
  ) {
    emit(state.copyWith(color: event.colorIndex.clamp(0, 19)));
  }

  void _onTargetValueChanged(
    EditHabitTargetValueChanged event,
    Emitter<EditHabitState> emit,
  ) {
    emit(state.copyWith(
      targetValue: event.value,
      targetValueError: () => null, // Clear error on edit
    ));
  }

  void _onTargetTypeChanged(
    EditHabitTargetTypeChanged event,
    Emitter<EditHabitState> emit,
  ) {
    emit(state.copyWith(targetType: event.targetType));
  }

  void _onUnitChanged(
    EditHabitUnitChanged event,
    Emitter<EditHabitState> emit,
  ) {
    emit(state.copyWith(unit: event.unit));
  }

  void _onReminderChanged(
    EditHabitReminderChanged event,
    Emitter<EditHabitState> emit,
  ) {
    emit(state.copyWith(
      reminderHour: () => event.hour,
      reminderMin: () => event.min,
      reminderDays: event.days,
    ));
  }

  Future<void> _onSaveRequested(
    EditHabitSaveRequested event,
    Emitter<EditHabitState> emit,
  ) async {
    // --- Validation ---
    String? nameError;
    String? targetValueError;

    if (state.name.trim().isEmpty) {
      nameError = 'Name cannot be empty';
    }

    if (state.habitType == HabitType.numerical && state.targetValue <= 0) {
      targetValueError = 'Target value is required';
    }

    if (nameError != null || targetValueError != null) {
      emit(state.copyWith(
        nameError: () => nameError,
        targetValueError: () => targetValueError,
      ));
      return;
    }

    // --- Save ---
    emit(state.copyWith(status: EditHabitStatus.saving));

    try {
      final command = CreateHabitCommand(
        habitRepository: habitRepository,
        name: state.name.trim(),
        description: state.description,
        question: state.question,
        freqNum: state.freqNum,
        freqDen: state.freqDen,
        color: state.color,
        reminderHour: state.reminderHour,
        reminderMin: state.reminderMin,
        reminderDays: state.reminderDays,
        habitType: state.habitType,
        targetValue: state.targetValue,
        targetType: state.targetType,
        unit: state.unit,
      );

      await command.run();

      emit(state.copyWith(
        status: EditHabitStatus.success,
        saveError: () => null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: EditHabitStatus.failure,
        saveError: () => 'Failed to save habit. Please try again.',
      ));
    }
  }
}
