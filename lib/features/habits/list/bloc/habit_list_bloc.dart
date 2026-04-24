import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../data/habit_repository.dart';
import '../../../../database/app_database.dart';

// --- Events ---

sealed class HabitListEvent extends Equatable {
  const HabitListEvent();

  @override
  List<Object?> get props => [];
}

/// Load or refresh the habit list.
class HabitListLoadRequested extends HabitListEvent {
  const HabitListLoadRequested();
}

// --- State ---

enum HabitListStatus { initial, loading, loaded, error }

class HabitListState extends Equatable {
  final HabitListStatus status;
  final List<Habit> habits;
  final String? errorMessage;

  const HabitListState({
    this.status = HabitListStatus.initial,
    this.habits = const [],
    this.errorMessage,
  });

  HabitListState copyWith({
    HabitListStatus? status,
    List<Habit>? habits,
    String? Function()? errorMessage,
  }) {
    return HabitListState(
      status: status ?? this.status,
      habits: habits ?? this.habits,
      errorMessage:
          errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, habits, errorMessage];
}

// --- BLoC ---

/// BLoC for the habit list screen.
///
/// Loads habits from the repository and provides them to the UI.
/// Refreshes automatically when navigating back from the create screen.
class HabitListBloc extends Bloc<HabitListEvent, HabitListState> {
  final HabitRepository habitRepository;

  HabitListBloc({required this.habitRepository})
      : super(const HabitListState()) {
    on<HabitListLoadRequested>(_onLoadRequested);
  }

  Future<void> _onLoadRequested(
    HabitListLoadRequested event,
    Emitter<HabitListState> emit,
  ) async {
    emit(state.copyWith(status: HabitListStatus.loading));
    try {
      final habits = await habitRepository.findAll();
      emit(state.copyWith(
        status: HabitListStatus.loaded,
        habits: habits,
        errorMessage: () => null,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HabitListStatus.error,
        errorMessage: () => 'Failed to load habits.',
      ));
    }
  }
}
