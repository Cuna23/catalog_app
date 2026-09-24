import 'dart:async';

/// Delays running [action] until [milliseconds] have passed
/// since the last call. Used so the search box doesn't fire
/// an API call on every keystroke.
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({this.milliseconds = 500});

  void run(void Function() action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }

  void dispose() {
    _timer?.cancel();
  }
}