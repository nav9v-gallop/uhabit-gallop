import 'package:flutter/material.dart';
import '../../../../domain/models/habit.dart';

/// AlertDialog that prompts the user to choose between a Yes/No (boolean)
/// habit and a Measurable (numerical) habit.
///
/// Returns [HabitType.boolean] or [HabitType.numerical], or null if cancelled.
class HabitTypeDialog extends StatelessWidget {
  const HabitTypeDialog({super.key});

  static Future<HabitType?> show(BuildContext context) {
    return showDialog<HabitType>(
      context: context,
      builder: (context) => const HabitTypeDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create habit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a habit type',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          _HabitTypeOption(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF7CB342),
            title: 'Yes or No',
            description: 'Track whether you did it each day',
            onTap: () => Navigator.of(context).pop(HabitType.boolean),
          ),
          const SizedBox(height: 4),
          _HabitTypeOption(
            icon: Icons.bar_chart,
            iconColor: const Color(0xFF039BE5),
            title: 'Measurable',
            description:
                'Track a numerical value (e.g. minutes, glasses)',
            onTap: () => Navigator.of(context).pop(HabitType.numerical),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('CANCEL'),
        ),
      ],
    );
  }
}

class _HabitTypeOption extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _HabitTypeOption({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
