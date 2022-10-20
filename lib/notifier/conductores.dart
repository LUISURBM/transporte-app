// The StateNotifier class that will be passed to our StateNotifierProvider.
// This class should not expose state outside of its "state" property, which means
// no public getters/properties!
// The public methods on this class will be what allow the UI to modify the state.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:transporte_app/model/conductor.dart';
import 'package:transporte_app/service/db.dart';

class ConductoresNotifier extends StateNotifier<List<Conductor>> {
  // We initialize the list of todos to an empty list
  ConductoresNotifier(): super([]);

  // Let's allow the UI to add todos.
  void addTodo(Conductor todo) {
    // Since our state is immutable, we are not allowed to do `state.add(todo)`.
    // Instead, we should create a new list of todos which contains the previous
    // items and the new one.
    // Using Dart's spread operator here is helpful!
    state = [...state, todo];
    // No need to call "notifyListeners" or anything similar. Calling "state ="
    // will automatically rebuild the UI when necessary.
  }

  // Let's allow removing todos
  void removeTodo(String cedula) {
    // Again, our state is immutable. So we're making a new list instead of
    // changing the existing list.
    state = [
      for (final todo in state)
        if (todo.cedula != cedula) todo,
    ];
  }

}