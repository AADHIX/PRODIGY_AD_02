import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo_model.dart';

class TodoService {
  static const String _boxName = 'todos';
  late Box<TodoModel> _box;

  // Initialize Hive and open box
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TodoModelAdapter());
    _box = await Hive.openBox<TodoModel>(_boxName);
  }

  // Get all todos
  List<TodoModel> getAllTodos() {
    return _box.values.toList();
  }

  // Get todos with filtering and sorting
  List<TodoModel> getTodos({
    bool? isCompleted,
    String sortBy = 'createdAt', // 'createdAt', 'priority', 'title'
    bool ascending = false,
  }) {
    var todos = _box.values.toList();

    // Filter by completion status
    if (isCompleted != null) {
      todos = todos.where((todo) => todo.isCompleted == isCompleted).toList();
    }

    // Sort todos
    todos.sort((a, b) {
      int comparison = 0;
      switch (sortBy) {
        case 'title':
          comparison = a.title.compareTo(b.title);
          break;
        case 'priority':
          comparison = b.priority.compareTo(a.priority); // High to Low by default
          break;
        case 'createdAt':
        default:
          comparison = a.createdAt.compareTo(b.createdAt);
          break;
      }
      return ascending ? comparison : -comparison;
    });

    return todos;
  }

  // Add new todo
  Future<void> addTodo(TodoModel todo) async {
    await _box.put(todo.id, todo);
  }

  // Update todo
  Future<void> updateTodo(TodoModel todo) async {
    await _box.put(todo.id, todo);
  }

  // Delete todo
  Future<void> deleteTodo(String id) async {
    await _box.delete(id);
  }

  // Toggle todo completion
  Future<void> toggleTodo(String id) async {
    final todo = _box.get(id);
    if (todo != null) {
      final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
      await _box.put(id, updatedTodo);
    }
  }

  // Clear all todos
  Future<void> clearAllTodos() async {
    await _box.clear();
  }

  // Get todo statistics
  Map<String, int> getStatistics() {
    final todos = getAllTodos();
    return {
      'total': todos.length,
      'completed': todos.where((todo) => todo.isCompleted).length,
      'pending': todos.where((todo) => !todo.isCompleted).length,
      'highPriority': todos.where((todo) => todo.priority == 2).length,
    };
  }

  // Stream of todos for real-time updates
  Stream<List<TodoModel>> watchTodos() {
    return _box.watch().map((_) => getAllTodos());
  }

  // Close the box
  Future<void> close() async {
    await _box.close();
  }
}