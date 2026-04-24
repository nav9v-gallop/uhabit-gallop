import 'package:equatable/equatable.dart';

/// Base class for all EditHabit events.
sealed class EditHabitEvent extends Equatable {
  const EditHabitEvent();

  @override
  List<Object?> get props => [];
}

/// User changed the habit name.
class EditHabitNameChanged extends EditHabitEvent {
  final String name;
  const EditHabitNameChanged(this.name);

  @override
  List<Object?> get props => [name];
}

/// User changed the habit question.
class EditHabitQuestionChanged extends EditHabitEvent {
  final String question;
  const EditHabitQuestionChanged(this.question);

  @override
  List<Object?> get props => [question];
}

/// User changed the habit description.
class EditHabitDescriptionChanged extends EditHabitEvent {
  final String description;
  const EditHabitDescriptionChanged(this.description);

  @override
  List<Object?> get props => [description];
}

/// User changed the frequency (numerator + denominator).
class EditHabitFrequencyChanged extends EditHabitEvent {
  final int num;
  final int den;
  const EditHabitFrequencyChanged(this.num, this.den);

  @override
  List<Object?> get props => [num, den];
}

/// User selected a new color from the palette.
class EditHabitColorChanged extends EditHabitEvent {
  final int colorIndex;
  const EditHabitColorChanged(this.colorIndex);

  @override
  List<Object?> get props => [colorIndex];
}

/// User changed the target value (numerical habits only).
class EditHabitTargetValueChanged extends EditHabitEvent {
  final double value;
  const EditHabitTargetValueChanged(this.value);

  @override
  List<Object?> get props => [value];
}

/// User changed the target type (numerical habits only).
/// 0 = at least, 1 = at most.
class EditHabitTargetTypeChanged extends EditHabitEvent {
  final int targetType;
  const EditHabitTargetTypeChanged(this.targetType);

  @override
  List<Object?> get props => [targetType];
}

/// User changed the unit (numerical habits only).
class EditHabitUnitChanged extends EditHabitEvent {
  final String unit;
  const EditHabitUnitChanged(this.unit);

  @override
  List<Object?> get props => [unit];
}

/// User configured or updated the reminder.
class EditHabitReminderChanged extends EditHabitEvent {
  final int? hour;
  final int? min;
  final int days;
  const EditHabitReminderChanged(this.hour, this.min, this.days);

  @override
  List<Object?> get props => [hour, min, days];
}

/// User tapped the SAVE button.
class EditHabitSaveRequested extends EditHabitEvent {
  const EditHabitSaveRequested();
}
