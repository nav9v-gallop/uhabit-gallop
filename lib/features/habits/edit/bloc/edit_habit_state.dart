import 'package:equatable/equatable.dart';
import '../../../../domain/models/habit.dart';

/// Status of the edit habit form.
enum EditHabitStatus {
  initial,
  saving,
  success,
  failure,
}

/// State for the EditHabitBloc.
///
/// Contains all form field values, validation errors, and save status.
class EditHabitState extends Equatable {
  final EditHabitStatus status;
  final HabitType habitType;

  // Form fields
  final String name;
  final String question;
  final String description;
  final int freqNum;
  final int freqDen;
  final int color;
  final double targetValue;
  final int targetType;
  final String unit;
  final int? reminderHour;
  final int? reminderMin;
  final int reminderDays;

  // Validation errors (null = no error)
  final String? nameError;
  final String? targetValueError;
  final String? saveError;

  const EditHabitState({
    this.status = EditHabitStatus.initial,
    this.habitType = HabitType.boolean,
    this.name = '',
    this.question = '',
    this.description = '',
    this.freqNum = 1,
    this.freqDen = 1,
    this.color = 8,
    this.targetValue = 0.0,
    this.targetType = 0,
    this.unit = '',
    this.reminderHour,
    this.reminderMin,
    this.reminderDays = 127,
    this.nameError,
    this.targetValueError,
    this.saveError,
  });

  /// Whether the form has been modified from defaults.
  bool get hasChanges {
    return name.isNotEmpty ||
        question.isNotEmpty ||
        description.isNotEmpty ||
        freqNum != 1 ||
        freqDen != 1 ||
        color != 8 ||
        targetValue != 0.0 ||
        targetType != 0 ||
        unit.isNotEmpty ||
        reminderHour != null ||
        reminderMin != null;
  }

  /// Whether a reminder is configured.
  bool get hasReminder => reminderHour != null && reminderMin != null;

  EditHabitState copyWith({
    EditHabitStatus? status,
    HabitType? habitType,
    String? name,
    String? question,
    String? description,
    int? freqNum,
    int? freqDen,
    int? color,
    double? targetValue,
    int? targetType,
    String? unit,
    int? Function()? reminderHour,
    int? Function()? reminderMin,
    int? reminderDays,
    String? Function()? nameError,
    String? Function()? targetValueError,
    String? Function()? saveError,
  }) {
    return EditHabitState(
      status: status ?? this.status,
      habitType: habitType ?? this.habitType,
      name: name ?? this.name,
      question: question ?? this.question,
      description: description ?? this.description,
      freqNum: freqNum ?? this.freqNum,
      freqDen: freqDen ?? this.freqDen,
      color: color ?? this.color,
      targetValue: targetValue ?? this.targetValue,
      targetType: targetType ?? this.targetType,
      unit: unit ?? this.unit,
      reminderHour:
          reminderHour != null ? reminderHour() : this.reminderHour,
      reminderMin:
          reminderMin != null ? reminderMin() : this.reminderMin,
      reminderDays: reminderDays ?? this.reminderDays,
      nameError: nameError != null ? nameError() : this.nameError,
      targetValueError: targetValueError != null
          ? targetValueError()
          : this.targetValueError,
      saveError: saveError != null ? saveError() : this.saveError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        habitType,
        name,
        question,
        description,
        freqNum,
        freqDen,
        color,
        targetValue,
        targetType,
        unit,
        reminderHour,
        reminderMin,
        reminderDays,
        nameError,
        targetValueError,
        saveError,
      ];
}
