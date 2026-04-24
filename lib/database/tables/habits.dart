import 'package:drift/drift.dart';

/// Drift table definition for the Habits table.
///
/// Maps 1:1 to the source app's v25 schema. All 19 columns are preserved
/// with identical names and types.
class Habits extends Table {
  /// Auto-increment primary key.
  IntColumn get id => integer().autoIncrement()();

  /// UUID v4 generated on creation.
  TextColumn get uuid => text()();

  /// Habit name — required, non-empty (validated in BLoC).
  TextColumn get name => text()();

  /// Optional description.
  TextColumn get description => text().withDefault(const Constant(''))();

  /// Optional question (e.g. "Did you exercise today?").
  TextColumn get question => text().withDefault(const Constant(''))();

  /// Frequency numerator. See frequency encoding table.
  IntColumn get freqNum => integer().withDefault(const Constant(1))();

  /// Frequency denominator. See frequency encoding table.
  IntColumn get freqDen => integer().withDefault(const Constant(1))();

  /// Palette color index (0–19). Default 8 = teal #00897B.
  IntColumn get color => integer().withDefault(const Constant(8))();

  /// Display position in the habit list (auto-assigned: max + 1).
  IntColumn get position => integer()();

  /// Reminder hour (0–23). Null means no reminder.
  IntColumn get reminderHour => integer().nullable()();

  /// Reminder minute (0–59). Null means no reminder.
  IntColumn get reminderMin => integer().nullable()();

  /// Reminder days bitmask. Default 127 = all days.
  /// Bit 0=Saturday, 1=Sunday, 2=Monday, ..., 6=Friday.
  IntColumn get reminderDays => integer().withDefault(const Constant(127))();

  /// Highlight flag. Default 0, not set during creation.
  IntColumn get highlight => integer().withDefault(const Constant(0))();

  /// Archived flag. 0 = active, 1 = archived.
  IntColumn get archived => integer().withDefault(const Constant(0))();

  /// Habit type. 0 = boolean (Yes/No), 1 = numerical (Measurable).
  IntColumn get type => integer()();

  /// Target value for numerical habits.
  RealColumn get targetValue => real().withDefault(const Constant(0.0))();

  /// Target type. 0 = at least, 1 = at most.
  IntColumn get targetType => integer().withDefault(const Constant(0))();

  /// Unit for numerical habits (e.g. "glasses", "minutes").
  TextColumn get unit => text().withDefault(const Constant(''))();
}
