import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lato/db.dart'; // MODELO // CONTROLADOR
import 'package:flutter_lato/task.dart';

void main() {
  runApp(const MyApp());
}

// class Message {
//   final String content;
//   final DateTime timestamp;
//   bool isImportant;

//   Message({
//     required this.content,
//     required this.timestamp,
//     this.isImportant = false,
//   });
// }

// class MessagesProvider extends ChangeNotifier {
//   List<Message> _messages = [];

//   List<Message> get messages => _messages;

//   void addMessage(Message message) {
//     _messages.add(message);
//     notifyListeners();
//   }

//   void removeMessage(int index) {
//     _messages.removeAt(index);
//     notifyListeners();
//   }

//   void toggleImportant(int index) {
//     _messages[index].isImportant = !_messages[index].isImportant;
//     notifyListeners();
//   }

//   List<Message> getImportantMessages() {
//     return _messages.where((message) => message.isImportant).toList();
//   }
// }

// Creamos el tipo Task para usarlo en la variable que sera cada item de tarea
class TaskContextItem {
  final String title;
  bool completed;

  TaskContextItem({required this.title, this.completed = false});
}

// Creamos el provider Tasks que es el equivalente al contexto en React, nos petmite
// guardar informacion en el componente y acceder a ella, ChangeNotifier nos permite
// disparar un trigger cuando se modifica el provider, entonces podemos actualizar
// la lista de tareas al agregar o eliminar una
class TasksProvider extends ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TasksProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chat with me',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: Color.fromARGB(255, 34, 54, 72),
          appBarTheme: const AppBarTheme(
            color: Color.fromARGB(255, 9, 36, 62),
            iconTheme: IconThemeData(color: Colors.white),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/messages': (context) => const MessageList(),
          '/important': (context) => const ImportantMessagesPage(),
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 34, 54, 72),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Chat\n with\n  me',
              style: TextStyle(
                fontSize: 80.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/messages');
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageList extends StatefulWidget {
  const MessageList({super.key});

  @override
  _MessageListState createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  TextEditingController _controller = TextEditingController();

  // @override
  // void initState() {
  //   cargaMessages();
  //   super.initState();
  // }

  // cargaMessages() async {
  //   // Simula la carga de mensajes desde una base de datos
  //   // Aquí puedes integrar tu lógica de base de datos
  //   setState(() {
  //     // Mensaje de prueba inicial
  //   });
  // }

  List<Task> tasks = [];

  @override
  void initState() {
    cargaTaks();
    super.initState();
  }

  cargaTaks() async {
    List<Task> auxTask = await DB.tasks();

    setState(() {
      tasks = auxTask;
    });
  }

  bool intToBool(int value) {
    return value != 0;
  }

  @override
  Widget build(BuildContext context) {
    // var messagesProvider = Provider.of<MessagesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with me'),
        titleTextStyle: TextStyle(
          fontSize: 25.0,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star),
            color: Colors.amber,
            onPressed: () {
              Navigator.pushNamed(context, '/important');
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Nuevo mensaje'),
              content: Container(
                width: double.maxFinite,
                child: TextField(
                  controller: _controller,
                  maxLines: null, // Permite múltiples líneas
                  keyboardType: TextInputType.multiline,
                  textAlign:
                      TextAlign.center, // Centra el texto dentro del TextField
                  decoration: const InputDecoration(
                    labelText: 'Escribe tu mensaje...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      DB.insert(Task(
                          nombre: _controller.text,
                          estado: 0,
                          time: DateTime.now().toString(),
                          id: DateTime.now().millisecondsSinceEpoch % 1000000));
                      _controller.clear();
                      cargaTaks();

                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Enviar'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 9, 36, 62),
        foregroundColor: Colors.white,
      ),
      body: Consumer<TasksProvider>(
        builder: (context, TasksProvider, child) {
          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              // var message = messagesProvider.messages[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    tasks[index].nombre,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    tasks[index].time,
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          intToBool(tasks[index].estado)
                              ? Icons.star
                              : Icons.star_border,
                          color: intToBool(tasks[index].estado)
                              ? Colors.amber
                              : null,
                        ),
                        onPressed: () {
                          DB.update(Task(
                              nombre: tasks[index].nombre,
                              estado: intToBool(tasks[index].estado) ? 0 : 1,
                              time: tasks[index].time,
                              id: tasks[index].id));
                          _controller.clear();
                          cargaTaks();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          DB.delete(Task(
                              nombre: tasks[index].nombre,
                              estado: tasks[index].estado,
                              time: tasks[index].time,
                              id: tasks[index].id));
                          _controller.clear();
                          cargaTaks();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ImportantMessagesPage extends StatefulWidget {
  const ImportantMessagesPage({super.key});

  @override
  _ImportantMessagesPageState createState() => _ImportantMessagesPageState();
}

class _ImportantMessagesPageState extends State<ImportantMessagesPage> {
  List<Task> tasks = [];

  @override
  void initState() {
    cargaTaks();
    super.initState();
  }

  cargaTaks() async {
    List<Task> auxTask = await DB.tasks();

    setState(() {
      tasks = auxTask;
    });
  }

  bool intToBool(int value) {
    return value != 0;
  }

  @override
  Widget build(BuildContext context) {
    // var messagesProvider = Provider.of<MessagesProvider>(context);
    // var importantMessages = messagesProvider.getImportantMessages();

    List<Task> filteredTasks = tasks.where((task) => task.estado == 1).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes Importantes'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23.0,
        ),
      ),
      body: Consumer<TasksProvider>(
        builder: (context, TasksProvider, child) {
          return ListView.builder(
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              // var message = messagesProvider.messages[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    filteredTasks[index].nombre,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    filteredTasks[index].time,
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          intToBool(filteredTasks[index].estado)
                              ? Icons.star
                              : Icons.star_border,
                          color: intToBool(filteredTasks[index].estado)
                              ? Colors.amber
                              : null,
                        ),
                        onPressed: () {
                          DB.update(Task(
                              nombre: filteredTasks[index].nombre,
                              estado: intToBool(filteredTasks[index].estado)
                                  ? 0
                                  : 1,
                              time: filteredTasks[index].time,
                              id: filteredTasks[index].id));
                          cargaTaks();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          DB.delete(Task(
                              nombre: filteredTasks[index].nombre,
                              estado: filteredTasks[index].estado,
                              time: filteredTasks[index].time,
                              id: filteredTasks[index].id));
                          cargaTaks();
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
