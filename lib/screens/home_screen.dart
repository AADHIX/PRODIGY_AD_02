import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/todo_model.dart';
import '../providers/todo_provider.dart';
import '../widgets/todo_widgets.dart';
import 'add_todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;
  List<TodoModel> _searchResults = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchResults.clear();
    });
  }

  void _performSearch(String query) {
    final todoProvider = Provider.of<TodoProvider>(context, listen: false);
    setState(() {
      _searchResults = todoProvider.searchTodos(query);
    });
  }

  Future<void> _deleteTodo(TodoModel todo) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Todo'),
        content: Text('Are you sure you want to delete "${todo.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      await todoProvider.deleteTodo(todo.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Todo deleted successfully'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search todos...',
                  border: InputBorder.none,
                ),
                onChanged: _performSearch,
                autofocus: true,
              )
            : const Text('Todo App'),
        elevation: 0,
        actions: [
          if (_isSearching)
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: _stopSearch,
            )
          else
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _startSearch,
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              final todoProvider = Provider.of<TodoProvider>(context, listen: false);
              switch (value) {
                case 'clear_all':
                  _showClearAllDialog();
                  break;
                case 'sort_title':
                  todoProvider.setSorting('title');
                  break;
                case 'sort_priority':
                  todoProvider.setSorting('priority');
                  break;
                case 'sort_date':
                  todoProvider.setSorting('createdAt');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'sort_title',
                child: ListTile(
                  leading: Icon(Icons.sort_by_alpha),
                  title: Text('Sort by Title'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'sort_priority',
                child: ListTile(
                  leading: Icon(Icons.priority_high),
                  title: Text('Sort by Priority'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'sort_date',
                child: ListTile(
                  leading: Icon(Icons.date_range),
                  title: Text('Sort by Date'),
                  dense: true,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'clear_all',
                child: ListTile(
                  leading: Icon(Icons.clear_all, color: Colors.red),
                  title: Text('Clear All'),
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<TodoProvider>(
        builder: (context, todoProvider, child) {
          final todos = _isSearching ? _searchResults : todoProvider.todos;
          
          return Column(
            children: [
              // Statistics Card
              StatisticsCard(statistics: todoProvider.statistics),
              
              // Filter Chips
              if (!_isSearching)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      TodoFilterChip(
                        label: 'All',
                        isSelected: todoProvider.currentFilter == 'all',
                        onSelected: () => todoProvider.setFilter('all'),
                      ),
                      TodoFilterChip(
                        label: 'Pending',
                        isSelected: todoProvider.currentFilter == 'pending',
                        onSelected: () => todoProvider.setFilter('pending'),
                      ),
                      TodoFilterChip(
                        label: 'Completed',
                        isSelected: todoProvider.currentFilter == 'completed',
                        onSelected: () => todoProvider.setFilter('completed'),
                      ),
                    ],
                  ),
                ),
              
              // Todo List
              Expanded(
                child: todos.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        itemCount: todos.length,
                        itemBuilder: (context, index) {
                          final todo = todos[index];
                          return TodoCard(
                            todo: todo,
                            onToggle: () => todoProvider.toggleTodo(todo.id),
                            onEdit: () => _navigateToAddTodo(todo),
                            onDelete: () => _deleteTodo(todo),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTodo(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _isSearching ? Icons.search_off : Icons.task_alt,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            _isSearching ? 'No todos found' : 'No todos yet',
            style: const TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _isSearching 
                ? 'Try searching with different keywords'
                : 'Tap the + button to add your first todo',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddTodo([TodoModel? todo]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTodoScreen(todoToEdit: todo),
      ),
    );
  }

  Future<void> _showClearAllDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Todos'),
        content: const Text('Are you sure you want to delete all todos? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final todoProvider = Provider.of<TodoProvider>(context, listen: false);
      await todoProvider.clearAllTodos();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All todos cleared successfully'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}