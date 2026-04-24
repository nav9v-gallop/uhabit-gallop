import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../features/habits/list/widgets/habit_list_page.dart';
import '../features/habits/edit/widgets/edit_habit_page.dart';
import '../features/habits/edit/bloc/edit_habit_bloc.dart';
import '../features/habits/edit/bloc/edit_habit_event.dart';
import '../features/habits/edit/bloc/edit_habit_state.dart';
import '../features/habits/data/habit_repository.dart';
import '../database/app_database.dart';

final appRouter = GoRouter(
  initialLocation: '/habits',
  routes: [
    GoRoute(
      path: '/habits',
      builder: (context, state) => const HabitListPage(),
      routes: [
        GoRoute(
          path: 'create',
          builder: (context, state) {
            final typeParam = state.uri.queryParameters['type'] ?? 'boolean';
            final habitType =
                typeParam == 'numerical' ? HabitType.numerical : HabitType.boolean;
            return BlocProvider(
              create: (context) => EditHabitBloc(
                habitRepository: HabitRepositoryImpl(
                  database: AppDatabase.instance,
                ),
                habitType: habitType,
              ),
              child: EditHabitPage(habitType: habitType),
            );
          },
        ),
      ],
    ),
  ],
);
