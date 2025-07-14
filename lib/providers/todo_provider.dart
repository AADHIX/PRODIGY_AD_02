import 'package:flutter/foundation.dart';
import '../models/todo_model.dart';
import '../services/todo_service.dart';

class TodoProvider extends ChangeNotifier {
  final TodoService _todoService = TodoService();
  // List<TodoModel> _todos = []; // Removed unused field
  String _currentFilter = 'all'; // 'all', 'completed', 'pending'
  String _sortBy = 'createdAt';
  bool _ascending = false;

  // Getters
  List<TodoModel> get todos => _getFilteredTodos();
  String get currentFilter => _currentFilter;
  String get sortBy => _sortBy;
  bool get ascending => _ascending;
  Map<String, int> get statistics => _todoService.getStatistics();

  // Initialize the provider
  Future<void> init() async {
    await _todoService.init();
    _loadTodos();
  }

  // Load todos from Hive
  void _loadTodos() {
    // _todos = _todoService.getAllTodos(); // No longer needed
    notifyListeners();
  }

  // Get filtered todos based on current filter
  List<TodoModel> _getFilteredTodos() {
    bool? isCompleted;
    if (_currentFilter == 'completed') {
      isCompleted = true;
    } else if (_currentFilter == 'pending') {
      isCompleted = false;
    }

    return _todoService.getTodos(
      isCompleted: isCompleted,
      sortBy: _sortBy,
      ascending: _ascending,
    );
  }

  // Add new todo
  Future<void> addTodo(TodoModel todo) async {
    await _todoService.addTodo(todo);
    _loadTodos();
  }

  // Update todo
  Future<void> updateTodo(TodoModel todo) async {
    await _todoService.updateTodo(todo);
    _loadTodos();
  }

  // Delete todo
  Future<void> deleteTodo(String id) async {
    await _todoService.deleteTodo(id);
    _loadTodos();
  }

  // Toggle todo completion
  Future<void> toggleTodo(String id) async {
    await _todoService.toggleTodo(id);
    _loadTodos();
  }

  // Clear all todos
  Future<void> clearAllTodos() async {
    await _todoService.clearAllTodos();
    _loadTodos();
  }

  // Set filter
  void setFilter(String filter) {
    _currentFilter = filter;
    notifyListeners();
  }

  // Set sorting
  void setSorting(String sortBy, {bool? ascending}) {
    _sortBy = sortBy;
    if (ascending != null) {
      _ascending = ascending;
    }
    notifyListeners();
  }

  // Search todos
  List<TodoModel> searchTodos(String query) {
    if (query.isEmpty) return todos;
    
    return todos.where((todo) {
      return todo.title.toLowerCase().contains(query.toLowerCase()) ||
             todo.description.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  @override
  void dispose() {
    _todoService.close();
    super.dispose();
  }
}