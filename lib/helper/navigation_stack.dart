import 'package:locie/bloc/navigation_event.dart';

class NavigationStack {
  NavigationStack._internal() {
    _events = [];
  }
  static final NavigationStack _instance = NavigationStack._internal();
  List<NavigationEvent> _events;
  // NavigationBloc bloc;
  factory NavigationStack() {
    return _instance;
  }
  Map<String, NavigationEvent> routes = {};

  NavigationEvent current() {
    if (_events.isNotEmpty) {
      return _events[_events.length - 1];
    }
    return null;
  }

  void pop() {
    if (_events.isNotEmpty) {
      _events.removeAt(_events.length - 1);
      // bloc..add(current());
    }
  }

  void replace(NavigationEvent event) {
    _events[_events.length - 1] = event;
  }

  void pushList(List<NavigationEvent> events) {
    _events += events;
    // bloc..add(current());
  }

  int get length => _events.length;
  bool get isEmpty => _events.isEmpty;

  void push(NavigationEvent event) {
    _events.add(event);
    // //printcurrent());
    // bloc..add(current());
  }

  void pushString(String uri) {
    if (routes.containsKey(uri)) {
      push(routes[uri]);
    }
  }
}
