import 'package:flutter/material.dart';

void main() {
  runApp(const AppTareas());
}

class AppTareas extends StatelessWidget {
  const AppTareas({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Editar Usuario',
      theme: ThemeData(
        primarySwatch: const MaterialColor(
          0xFF2E7D32, // Valor hexadecimal
          <int, Color>{
            50: Color(0xFFE8F5E9),
            100: Color(0xFFC8E6C9),
            200: Color(0xFFA5D6A7),
            300: Color(0xFF81C784),
            400: Color(0xFF66BB6A),
            500: Color(0xFF4CAF50),
            600: Color(0xFF43A047),
            700: Color(0xFF388E3C),
            800: Color(0xFF2E7D32), // Valor principal más oscuro
            900: Color(0xFF1B5E20),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  final List<TodoItem> _todos = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tareas'),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (context, index) {
          final todo = _todos[index];
          return Padding(
            padding: const EdgeInsets.only(
                top: 8.0,
                right: 8.0,
                left: 8.0,
                bottom: 1.0), // Agrega espacio uniforme
            child: Container(
              color: const Color.fromARGB(255, 225, 247, 227),
              child: ListTile(
                title: Text(
                  todo.title,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                    fontWeight:
                        todo.isCompleted ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  todo.isCompleted ? todo.description : todo.description,
                  style: TextStyle(
                    decoration: todo.isCompleted
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteTodo(index);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editTodo(index);
                      },
                    ),
                    Checkbox(
                      value: _todos[index].isCompleted,
                      onChanged: (value) {
                        setState(() {
                          _todos[index].isCompleted = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTodo,
        child: const Icon(
          Icons
              .add_task_sharp, // Puedes cambiar 'Icons.star' por otro icono predefinido
          size: 36.0, // Ajusta el tamaño según tus preferencias
        ),
      ),
    );
  }

  //Funciones
  void _addTodo() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TodoDetailScreen()),
    );

    if (result != null) {
      setState(() {
        _todos.add(result);
      });
    }
  }

  void _editTodo(int index) async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        final todo = _todos[index];
        return AlertDialog(
          title: const Text('Editar Tarea'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: todo.title,
                onChanged: (value) {
                  todo.title = value;
                },
                decoration: const InputDecoration(labelText: 'Título'),
              ),
              TextFormField(
                initialValue: todo.description,
                onChanged: (value) {
                  todo.description = value;
                },
                decoration: const InputDecoration(labelText: 'Descripción'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, null);
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, todo);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (result != null) {
      setState(() {
        _todos[index] = result;
      });
    }
  }

  void _deleteTodo(int index) {
    setState(() {
      _todos.removeAt(index);
    });
  }
}

class TodoDetailScreen extends StatefulWidget {
  final TodoItem? todo;

  const TodoDetailScreen({super.key, this.todo});

  @override
  // ignore: library_private_types_in_public_api
  _TodoDetailScreenState createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late bool _isCompleted;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.todo?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.todo?.description ?? '');
    _isCompleted = widget.todo?.isCompleted ?? false;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todo == null ? 'Nueva Tarea' : 'Editar Tarea'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Título'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _saveTodo();
              },
              child: const Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }

  //Funciones
  void _saveTodo() {
    final title = _titleController.text;
    final description = _descriptionController.text;

    if (title.isNotEmpty) {
      final result = TodoItem(
        title: title,
        description: description,
        isCompleted: _isCompleted,
      );

      Navigator.pop(context, result);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('El título no puede estar vacío.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

class TodoItem {
  //Variables
  String title;
  String description;
  bool isCompleted;

  TodoItem({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}
