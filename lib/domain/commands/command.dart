/// Base interface for all commands in the command pattern.
abstract class Command {
  /// Executes the command. Returns a result value if applicable.
  Future<void> run();
}

/// Runs commands and notifies listeners on completion.
class CommandRunner {
  final List<CommandListener> _listeners = [];

  /// Executes a command and notifies all listeners.
  Future<void> run(Command command) async {
    await command.run();
    for (final listener in _listeners) {
      listener.onCommandFinished(command);
    }
  }

  void addListener(CommandListener listener) {
    _listeners.add(listener);
  }

  void removeListener(CommandListener listener) {
    _listeners.remove(listener);
  }
}

/// Listener interface for command completion events.
abstract class CommandListener {
  void onCommandFinished(Command command);
}
