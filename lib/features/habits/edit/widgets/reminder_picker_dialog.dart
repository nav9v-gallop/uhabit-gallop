import 'package:flutter/material.dart';

/// Result from the reminder picker dialog.
class ReminderResult {
  final int hour;
  final int minute;
  final int daysBitmask;

  const ReminderResult({
    required this.hour,
    required this.minute,
    required this.daysBitmask,
  });
}

/// Two-step reminder picker dialog.
///
/// Step 1: Time picker (using Flutter's built-in M3 showTimePicker).
/// Step 2: Weekday selection with checkboxes.
///
/// Returns [ReminderResult] on save, or null on cancel.
class ReminderPickerDialog extends StatefulWidget {
  final int habitColorIndex;
  final int? initialHour;
  final int? initialMinute;
  final int initialDaysBitmask;

  const ReminderPickerDialog({
    super.key,
    required this.habitColorIndex,
    this.initialHour,
    this.initialMinute,
    this.initialDaysBitmask = 127,
  });

  /// Shows the two-step reminder picker.
  static Future<ReminderResult?> show(
    BuildContext context, {
    required int habitColorIndex,
    int? initialHour,
    int? initialMinute,
    int initialDaysBitmask = 127,
  }) async {
    // Step 1: Time Picker
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: initialHour ?? 8,
        minute: initialMinute ?? 0,
      ),
      helpText: 'Select reminder time',
    );

    if (time == null || !context.mounted) return null;

    // Step 2: Weekday Selection
    return showDialog<ReminderResult>(
      context: context,
      builder: (context) => _WeekdaySelectionDialog(
        hour: time.hour,
        minute: time.minute,
        initialDaysBitmask: initialDaysBitmask,
        habitColorIndex: habitColorIndex,
      ),
    );
  }

  @override
  State<ReminderPickerDialog> createState() => _ReminderPickerDialogState();
}

class _ReminderPickerDialogState extends State<ReminderPickerDialog> {
  @override
  Widget build(BuildContext context) {
    // This widget is not used directly — use ReminderPickerDialog.show() instead.
    return const SizedBox.shrink();
  }
}

/// Step 2: Weekday selection dialog with checkboxes.
class _WeekdaySelectionDialog extends StatefulWidget {
  final int hour;
  final int minute;
  final int initialDaysBitmask;
  final int habitColorIndex;

  const _WeekdaySelectionDialog({
    required this.hour,
    required this.minute,
    required this.initialDaysBitmask,
    required this.habitColorIndex,
  });

  @override
  State<_WeekdaySelectionDialog> createState() =>
      _WeekdaySelectionDialogState();
}

class _WeekdaySelectionDialogState extends State<_WeekdaySelectionDialog> {
  late int _daysBitmask;

  // Day names and their bit positions in the bitmask.
  // Bit 0=Saturday, 1=Sunday, 2=Monday, ..., 6=Friday
  static const _days = [
    ('Monday', 2),
    ('Tuesday', 3),
    ('Wednesday', 4),
    ('Thursday', 5),
    ('Friday', 6),
    ('Saturday', 0),
    ('Sunday', 1),
  ];

  @override
  void initState() {
    super.initState();
    _daysBitmask = widget.initialDaysBitmask;
  }

  bool _isDaySelected(int bitPosition) {
    return (_daysBitmask & (1 << bitPosition)) != 0;
  }

  void _toggleDay(int bitPosition) {
    setState(() {
      _daysBitmask ^= (1 << bitPosition);
    });
  }

  bool get _canSave => _daysBitmask > 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Repeat on days'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Step indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _stepDot(false),
              const SizedBox(width: 8),
              _stepDot(true),
            ],
          ),
          const SizedBox(height: 16),
          // Weekday checkboxes
          ..._days.map((day) {
            final (name, bit) = day;
            final isChecked = _isDaySelected(bit);
            return InkWell(
              onTap: () => _toggleDay(bit),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (_) => _toggleDay(bit),
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Back'),
        ),
        TextButton(
          onPressed: _canSave
              ? () {
                  Navigator.of(context).pop(ReminderResult(
                    hour: widget.hour,
                    minute: widget.minute,
                    daysBitmask: _daysBitmask,
                  ));
                }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _stepDot(bool active) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.grey[700] : Colors.grey[300],
      ),
    );
  }
}

/// Helper to format a reminder for display.
///
/// Returns a string like "8:00 AM — Mon, Tue, Wed, Thu, Fri"
/// or "None" if no reminder is set.
String formatReminderSummary(int? hour, int? min, int daysBitmask) {
  if (hour == null || min == null) return 'None';

  // Format time
  final period = hour >= 12 ? 'PM' : 'AM';
  final displayHour = hour % 12 == 0 ? 12 : hour % 12;
  final displayMin = min.toString().padLeft(2, '0');
  final timeStr = '$displayHour:$displayMin $period';

  // Format days
  const dayAbbrevs = [
    (2, 'Mon'),
    (3, 'Tue'),
    (4, 'Wed'),
    (5, 'Thu'),
    (6, 'Fri'),
    (0, 'Sat'),
    (1, 'Sun'),
  ];

  final selectedDays = <String>[];
  for (final (bit, name) in dayAbbrevs) {
    if ((daysBitmask & (1 << bit)) != 0) {
      selectedDays.add(name);
    }
  }

  if (selectedDays.length == 7) {
    return '$timeStr — Every day';
  }

  return '$timeStr — ${selectedDays.join(', ')}';
}
