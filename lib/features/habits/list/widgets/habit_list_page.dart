import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../database/app_database.dart';
import '../../../../domain/models/habit.dart' as domain;
import '../../../../domain/models/palette_color.dart';
import '../../data/habit_repository.dart';
import '../../edit/widgets/habit_type_dialog.dart';
import '../bloc/habit_list_bloc.dart';

/// The main habit list screen.
///
/// Shows all habits ordered by position, with a FAB (+) that triggers
/// the type picker dialog for creating a new habit.
class HabitListPage extends StatelessWidget {
  const HabitListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HabitListBloc(
        habitRepository: HabitRepositoryImpl(
          database: AppDatabase.instance,
        ),
      )..add(const HabitListLoadRequested()),
      child: const _HabitListView(),
    );
  }
}

class _HabitListView extends StatelessWidget {
  const _HabitListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Habits'),
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<HabitListBloc, HabitListState>(
        builder: (context, state) {
          switch (state.status) {
            case HabitListStatus.initial:
            case HabitListStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case HabitListStatus.error:
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.errorMessage ?? 'Something went wrong.',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context
                          .read<HabitListBloc>()
                          .add(const HabitListLoadRequested()),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            case HabitListStatus.loaded:
              if (state.habits.isEmpty) {
                return const Center(
                  child: Text(
                    'No habits yet.\nTap + to create one!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF757575),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: state.habits.length,
                itemBuilder: (context, index) {
                  final habit = state.habits[index];
                  return _HabitCard(habit: habit);
                },
              );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFD32F2F),
        foregroundColor: Colors.white,
        onPressed: () => _onFabPressed(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _onFabPressed(BuildContext context) async {
    final habitType = await HabitTypeDialog.show(context);
    if (habitType == null || !context.mounted) return;

    final typeParam = habitType == domain.HabitType.numerical
        ? 'numerical'
        : 'boolean';

    final result = await context.push<bool>(
      '/habits/create?type=$typeParam',
    );

    // Refresh the list if a habit was created
    if (result == true && context.mounted) {
      context.read<HabitListBloc>().add(const HabitListLoadRequested());
    }
  }
}

class _HabitCard extends StatelessWidget {
  final Habit habit;

  const _HabitCard({required this.habit});

  @override
  Widget build(BuildContext context) {
    final color = PaletteColor.getColor(habit.color);
    final isNumerical = habit.type == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Color bar
            Container(
              width: 4,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 12),
            // Habit info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _formatFrequency(habit.freqNum, habit.freqDen),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF757575),
                    ),
                  ),
                ],
              ),
            ),
            // Type indicator
            if (isNumerical)
              Icon(Icons.bar_chart, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  String _formatFrequency(int num, int den) {
    if (den == 1 && num == 1) return 'Every day';
    if (den == 7 && num == 1) return 'Every week';
    if (den == 30 && num == 1) return 'Every month';
    if (den == 7) return '$num× per week';
    if (den == 30) return '$num× per month';
    if (num == 1) return 'Every $den days';
    return '$num× per $den days';
  }
}
