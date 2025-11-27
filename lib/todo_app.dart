import 'package:flutter/material.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  List<TodoItem> todos = [];
  final TextEditingController _todoController = TextEditingController();

  // Helper to calculate progress
  double get _progress {
    if (todos.isEmpty) return 0.0;
    int completed = todos.where((t) => t.isCompleted).length;
    return completed / todos.length;
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _addTodo() {
    String text = _todoController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        todos.add(TodoItem(text: text, isCompleted: false));
      });
      _todoController.clear();
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
    });
  }

  void _removeTodo(int index) {
    // 1. Capture the item before deleting for Undo functionality
    final deletedItem = todos[index];
    final deletedIndex = index;

    setState(() {
      todos.removeAt(index);
    });

    // 2. Show Snackbar with Undo
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1C1E26),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: Text(
          'Removed "${deletedItem.text}"',
          style: const TextStyle(color: Colors.white),
        ),
        action: SnackBarAction(
          label: 'RESTORE',
          textColor: const Color(0xFFC084FC),
          onPressed: () {
            setState(() {
              todos.insert(deletedIndex, deletedItem);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F1115), // Deep Dark Background
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Task Command",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white, letterSpacing: 1),
        ),
      ),
      body: Column(
        children: [
          // 1. Progress Header
          _buildProgressHeader(),

          // 2. Input Field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1E26), // Dark Surface
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _todoController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "What is your next objective?",
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.add_task, color: Colors.white.withOpacity(0.3)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                      onSubmitted: (_) => _addTodo(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFC084FC), Color(0xFF6366F1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    onPressed: _addTodo,
                    icon: const Icon(Icons.arrow_upward, color: Colors.white),
                    tooltip: 'Add Task',
                  ),
                ),
              ],
            ),
          ),

          // 3. The List
          Expanded(
            child: todos.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              itemCount: todos.length,
              itemBuilder: (context, index) {
                final todo = todos[index];
                return Dismissible(
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Icon(Icons.delete_outline, color: Colors.red[300]),
                  ),
                  onDismissed: (direction) => _removeTodo(index),
                  child: _buildTodoCard(todo, index),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2E3192), Color(0xFF1BFFFF)], // Cyber Blue Gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF2E3192).withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Mission Status",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${(_progress * 100).toInt()}%",
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: _progress,
                backgroundColor: Colors.black.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${todos.where((t) => t.isCompleted).length} / ${todos.length} objectives complete",
              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1E26),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.05)),
            ),
            child: Icon(Icons.check_circle_outline, size: 50, color: Colors.white.withOpacity(0.3)),
          ),
          const SizedBox(height: 20),
          Text(
            'All systems operational.',
            style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'No active tasks pending.',
            style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }

  Widget _buildTodoCard(TodoItem todo, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1E26), // Dark Card Surface
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: todo.isCompleted
                ? Colors.transparent
                : Colors.white.withOpacity(0.05)
        ),
        boxShadow: [
          if (!todo.isCompleted)
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: GestureDetector(
          onTap: () => _toggleTodo(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: todo.isCompleted ? const Color(0xFF34D399) : Colors.white.withOpacity(0.3),
                width: 2,
              ),
              color: todo.isCompleted ? const Color(0xFF34D399).withOpacity(0.2) : Colors.transparent,
              boxShadow: todo.isCompleted ? [
                BoxShadow(color: const Color(0xFF34D399).withOpacity(0.4), blurRadius: 8)
              ] : [],
            ),
            child: todo.isCompleted
                ? const Icon(Icons.check, size: 16, color: Color(0xFF34D399))
                : const Icon(Icons.circle, size: 16, color: Colors.transparent),
          ),
        ),
        title: Text(
          todo.text,
          style: TextStyle(
            fontSize: 16,
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            decorationColor: Colors.white.withOpacity(0.3),
            color: todo.isCompleted ? Colors.white.withOpacity(0.3) : Colors.white,
            fontWeight: todo.isCompleted ? FontWeight.normal : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class TodoItem {
  String text;
  bool isCompleted;

  TodoItem({required this.text, required this.isCompleted});
}