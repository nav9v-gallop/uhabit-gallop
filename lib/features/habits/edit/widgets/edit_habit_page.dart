import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/habit.dart';
import '../../../../domain/models/palette_color.dart';
import '../bloc/edit_habit_bloc.dart';
import '../bloc/edit_habit_event.dart';
import '../bloc/edit_habit_state.dart';
import 'color_picker_field.dart';
import 'frequency_picker.dart';
import 'measurement_section.dart';
import 'reminder_picker_dialog.dart';

/// Full-screen scrollable form for creating (or editing) a habit.
///
/// The AppBar is themed with the currently selected habit color and
/// dynamically updates when the user picks a new color.
class EditHabitPage extends StatefulWidget {
  final HabitType habitType;

  const EditHabitPage({super.key, required this.habitType});

  @override
  State<EditHabitPage> createState() => _EditHabitPageState();
}

class _EditHabitPageState extends State<EditHabitPage> {
  late TextEditingController _nameController;
  late TextEditingController _questionController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _questionController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _questionController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop(EditHabitState state) async {
    if (!state.hasChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Keep editing'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditHabitBloc, EditHabitState>(
      listener: (context, state) {
        if (state.status == EditHabitStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == EditHabitStatus.failure &&
            state.saveError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.saveError!)),
          );
        }
      },
      builder: (context, state) {
        final habitColor = PaletteColor.getColor(state.color);
        final bloc = context.read<EditHabitBloc>();

        return PopScope(
          canPop: !state.hasChanges,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            final shouldPop = await _onWillPop(state);
            if (shouldPop && context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: habitColor,
              foregroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () async {
                  if (!state.hasChanges) {
                    Navigator.of(context).pop();
                    return;
                  }
                  final shouldPop = await _onWillPop(state);
                  if (shouldPop && context.mounted) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              title: const Text('Create habit'),
              actions: [
                TextButton(
                  onPressed: state.status == EditHabitStatus.saving
                      ? null
                      : () =>
                          bloc.add(const EditHabitSaveRequested()),
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: state.status == EditHabitStatus.saving
                          ? Colors.white54
                          : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            body: state.status == EditHabitStatus.saving
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Name field
                        _buildTextField(
                          controller: _nameController,
                          label: 'Name',
                          errorText: state.nameError,
                          onChanged: (v) =>
                              bloc.add(EditHabitNameChanged(v)),
                        ),
                        const SizedBox(height: 18),

                        // Question field
                        _buildTextField(
                          controller: _questionController,
                          label: 'Question (optional)',
                          hintText:
                              'e.g. Did you meditate today?',
                          onChanged: (v) =>
                              bloc.add(EditHabitQuestionChanged(v)),
                        ),
                        const SizedBox(height: 18),

                        // Description field
                        _buildTextField(
                          controller: _descriptionController,
                          label: 'Description (optional)',
                          hintText: 'Add details about this habit...',
                          onChanged: (v) =>
                              bloc.add(EditHabitDescriptionChanged(v)),
                        ),
                        const SizedBox(height: 18),

                        // Measurement section (numerical only)
                        if (state.habitType == HabitType.numerical) ...[
                          MeasurementSection(
                            targetValue: state.targetValue,
                            unit: state.unit,
                            targetType: state.targetType,
                            colorIndex: state.color,
                            targetValueError: state.targetValueError,
                            onTargetValueChanged: (v) => bloc.add(
                              EditHabitTargetValueChanged(v),
                            ),
                            onUnitChanged: (v) =>
                                bloc.add(EditHabitUnitChanged(v)),
                            onTargetTypeChanged: (v) => bloc.add(
                              EditHabitTargetTypeChanged(v),
                            ),
                          ),
                          const SizedBox(height: 18),
                        ],

                        // Frequency picker
                        FrequencyPicker(
                          freqNum: state.freqNum,
                          freqDen: state.freqDen,
                          colorIndex: state.color,
                          onChanged: (value) => bloc.add(
                            EditHabitFrequencyChanged(
                              value.$1,
                              value.$2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 18),

                        // Color picker
                        ColorPickerField(
                          selectedIndex: state.color,
                          onColorSelected: (index) =>
                              bloc.add(EditHabitColorChanged(index)),
                        ),
                        const SizedBox(height: 16),

                        // Reminder section
                        Text(
                          'REMINDER',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: habitColor,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildReminderRow(context, state, bloc),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hintText,
    String? errorText,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Color(0xFF757575)),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 12,
            ),
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFFBDBDBD)),
            errorText: errorText,
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildReminderRow(
    BuildContext context,
    EditHabitState state,
    EditHabitBloc bloc,
  ) {
    final hasReminder = state.hasReminder;
    final summary = formatReminderSummary(
      state.reminderHour,
      state.reminderMin,
      state.reminderDays,
    );

    return Semantics(
      label: 'Reminder: $summary',
      child: InkWell(
        onTap: () async {
          final result = await ReminderPickerDialog.show(
            context,
            habitColorIndex: state.color,
            initialHour: state.reminderHour,
            initialMinute: state.reminderMin,
            initialDaysBitmask: state.reminderDays,
          );
          if (result != null) {
            bloc.add(EditHabitReminderChanged(
              result.hour,
              result.minute,
              result.daysBitmask,
            ));
          }
        },
        borderRadius: BorderRadius.circular(4),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Row(
            children: [
              Icon(
                hasReminder
                    ? Icons.notifications_active
                    : Icons.notifications_none,
                color: const Color(0xFF757575),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  summary,
                  style: TextStyle(
                    fontSize: 16,
                    color: hasReminder
                        ? const Color(0xFF212121)
                        : const Color(0xFF757575),
                  ),
                ),
              ),
              if (hasReminder)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {
                    bloc.add(
                      const EditHabitReminderChanged(null, null, 127),
                    );
                  },
                  tooltip: 'Clear reminder',
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(
                    minWidth: 48,
                    minHeight: 48,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
