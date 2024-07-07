import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class Message {
  final String content;
  final DateTime timestamp;
  bool isImportant;

  Message({
    required this.content,
    required this.timestamp,
    this.isImportant = false,
  });
}

class MessagesProvider extends ChangeNotifier {
  List<Message> _messages = [];

  List<Message> get messages => _messages;

  void addMessage(Message message) {
    _messages.add(message);
    notifyListeners();
  }

  void removeMessage(int index) {
    _messages.removeAt(index);
    notifyListeners();
  }

  void toggleImportant(int index) {
    _messages[index].isImportant = !_messages[index].isImportant;
    notifyListeners();
  }

  List<Message> getImportantMessages() {
    return _messages.where((message) => message.isImportant).toList();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MessagesProvider(),
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

  @override
  void initState() {
    cargaMessages();
    super.initState();
  }

  cargaMessages() async {
    // Simula la carga de mensajes desde una base de datos
    // Aquí puedes integrar tu lógica de base de datos
    setState(() {
      // Mensaje de prueba inicial
    });
  }

  @override
  Widget build(BuildContext context) {
    var messagesProvider = Provider.of<MessagesProvider>(context);

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
                      var newMessage = Message(
                        content: _controller.text,
                        timestamp: DateTime.now(),
                      );
                      messagesProvider.addMessage(newMessage);
                      _controller.clear();
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
      body: Consumer<MessagesProvider>(
        builder: (context, messagesProvider, child) {
          return ListView.builder(
            itemCount: messagesProvider.messages.length,
            itemBuilder: (context, index) {
              var message = messagesProvider.messages[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(
                    message.content,
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    message.timestamp.toString(),
                    style: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          message.isImportant ? Icons.star : Icons.star_border,
                          color: message.isImportant ? Colors.amber : null,
                        ),
                        onPressed: () {
                          messagesProvider.toggleImportant(index);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          messagesProvider.removeMessage(index);
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

class ImportantMessagesPage extends StatelessWidget {
  const ImportantMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    var messagesProvider = Provider.of<MessagesProvider>(context);
    var importantMessages = messagesProvider.getImportantMessages();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajes Importantes'),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 23.0,
        ),
      ),
      body: ListView.builder(
        itemCount: importantMessages.length,
        itemBuilder: (context, index) {
          var message = importantMessages[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(
                message.content,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                message.timestamp.toString(),
                style: TextStyle(fontSize: 14.0, color: Colors.black),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  messagesProvider.removeMessage(index);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
