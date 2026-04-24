import 'package:equatable/equatable.dart';

/// Habit types matching the source app's encoding.
/// 0 = boolean (Yes/No), 1 = numerical (Measurable).
enum HabitType {
  boolean(0),
  numerical(1);

  const HabitType(this.value);
  final int value;

  static HabitType fromInt(int value) {
    return value == 1 ? HabitType.numerical : HabitType.boolean;
  }
}

/// Numerical habit target types.
/// 0 = at least, 1 = at most.
enum NumericalHabitTargetType {
  atLeast(0),
  atMost(1);

  const NumericalHabitTargetType(this.value);
  final int value;

  static NumericalHabitTargetType fromInt(int value) {
    return value == 1
        ? NumericalHabitTargetType.atMost
        : NumericalHabitTargetType.atLeast;
  }
}

/// Domain model representing a Habit.
///
/// This is a pure domain object, separate from the drift-generated
/// database companion. Conversion happens in the repository layer.
class Habit extends Equatable {
  final int? id;
  final String uuid;
  final String name;
  final String description;
  final String question;
  final int freqNum;
  final int freqDen;
  final int color;
  final int position;
  final int? reminderHour;
  final int? reminderMin;
  final int reminderDays;
  final int highlight;
  final int archived;
  final HabitType type;
  final double targetValue;
  final NumericalHabitTargetType targetType;
  final String unit;

  const Habit({
    this.id,
    required this.uuid,
    required this.name,
    this.description = '',
    this.question = '',
    this.freqNum = 1,
    this.freqDen = 1,
    this.color = 8,
    this.position = 0,
    this.reminderHour,
    this.reminderMin,
    this.reminderDays = 127,
    this.highlight = 0,
    this.archived = 0,
    this.type = HabitType.boolean,
    this.targetValue = 0.0,
    this.targetType = NumericalHabitTargetType.atLeast,
    this.unit = '',
  });

  bool get isNumerical => type == HabitType.numerical;
  bool get hasReminder => reminderHour != null && reminderMin != null;

  Habit copyWith({
    int? id,
    String? uuid,
    String? name,
    String? description,
    String? question,
    int? freqNum,
    int? freqDen,
    int? color,
    int? position,
    int? Function()? reminderHour,
    int? Function()? reminderMin,
    int? reminderDays,
    int? highlight,
    int? archived,
    HabitType? type,
    double? targetValue,
    NumericalHabitTargetType? targetType,
    String? unit,
  }) {
    return Habit(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      description: description ?? this.description,
      question: question ?? this.question,
      freqNum: freqNum ?? this.freqNum,
      freqDen: freqDen ?? this.freqDen,
      color: color ?? this.color,
      position: position ?? this.position,
      reminderHour:
          reminderHour != null ? reminderHour() : this.reminderHour,
      reminderMin:
          reminderMin != null ? reminderMin() : this.reminderMin,
      reminderDays: reminderDays ?? this.reminderDays,
      highlight: highlight ?? this.highlight,
      archived: archived ?? this.archived,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      targetType: targetType ?? this.targetType,
      unit: unit ?? this.unit,
    );
  }

  @override
  List<Object?> get props => [
        id,
        uuid,
        name,
        description,
        question,
        freqNum,
        freqDen,
        color,
        position,
        reminderHour,
        reminderMin,
        reminderDays,
        highlight,
        archived,
        type,
        targetValue,
        targetType,
        unit,
      ];
}
