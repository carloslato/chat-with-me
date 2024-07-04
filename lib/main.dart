// Importar librerias nativas de flutter, material para usar los componentes de la interfaz
// provider para almacenar estados y compartirlos entre widgets
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_lato/db.dart'; // MODELO // CONTROLADOR
import 'package:flutter_lato/task.dart';

// Inicio de la aplicacion
// Usamos const en muchas declaraciones por que VSCODE nos recomendo que era
// bueno para el rendimiento
void main() {
  runApp(const MyApp());
}

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

// El widget principal los demas widgets que funcionaran como paginas seran hijos
// de este componente
class MyApp extends StatelessWidget {
  const MyApp({super.key});

// la directiva override se usa para sobreescribir una propiedad heredada de la clase
// padre o interfaz. con widget build generamos el contenidos del widget
  @override
  Widget build(BuildContext context) {
    // Definimos el provider principal y 2 propiedades importantes
    // create para poder usar el TaksProvider dentro de los widgets hijos,
    // esto es equuivalente a CreateContext en REACT,
    // y por ultimo routes, para que los widgets hijos funciones como paginas
    // con rutas que podemos linkear a botones o enlaces en otros widgets
    return ChangeNotifierProvider(
      create: (context) => TasksProvider(),
      child: MaterialApp(
        title: 'Aplicacion Basica',
        home: const HomePage(),
        routes: {
          '/home': (context) => const HomePage(),
          '/second': (context) => const SecondPage(),
          '/taks': (context) => const TaskList(),
        },
      ),
    );
  }
}

// La pagina principal, aqui conservamos el widget de la app
// por defecto de flutter, contiene un contador que incrementa cuando presionamos un boton
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  // similar a otros frameworks definimos una funcionar para modificar el estado
  // del contador, que simplemente aumenta su valor en uno
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagina Principal'),
      ),
      // Drawer es un componente de MATERIAL UI que consiste en un contenedor desplegable
      // que se abre desde el costado de la pantalla y podemos agregar elementos andentro
      // dentro hemos agregado una lista de elementos que son botones que abren las otras paginas
      // usando el onTap para detectar el click y Navigator.popAndPush named para abrir la
      // pagina seleccionada
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu de Navegacion'),
            ),
            ListTile(
              title: const Text('Pagina Principal'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/home');
              },
            ),
            ListTile(
              title: const Text('Segunda Pagina'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/second');
              },
            ),
            ListTile(
              title: const Text('Tareas'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/taks');
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hola! Has presionado el boton estas veces:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            // onPressed es un evento similar al onClick de javascript, que ejecuta una funcion cuando
            // presionamos el boton
            ElevatedButton(
              onPressed: _incrementCounter,
              child: const Text('Incrementar Contador'),
            ),
          ],
        ),
      ),
    );
  }
}

// En esta segunda pagina, es igual que la primera, pero simplemente dejamos un texto plano
// se creo para probar que  funcionaba el router
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segunda Pagina'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Menu de Navegacion'),
            ),
            ListTile(
              title: const Text('Pagina Principal'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/home');
              },
            ),
            ListTile(
              title: const Text('Segunda Pagina'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/second');
              },
            ),
            ListTile(
              title: const Text('Tareas'),
              onTap: () {
                Navigator.popAndPushNamed(context, '/taks');
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text('Bienvenido a la segunda pagina!'),
      ),
    );
  }
}

// widget de la pagina 3, la lista de tareas
class TaskList extends StatefulWidget {
  // constructor de la clase
  const TaskList({super.key});
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // creamos un controller de tipo TextEditing que es un componente de flutter para un
  // input de texto
  TextEditingController _controller = TextEditingController();

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

  @override
  Widget build(BuildContext context) {
    // guardamos en una variable el provider que definimos anterioemente
    // var tasksProvider = Provider.of<TasksProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista de tareas'),
        ),
        // imprimimos el mismo menu que las otras paginas
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Menu de Navegacion'),
              ),
              ListTile(
                title: const Text('Pagina Principal'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/home');
                },
              ),
              ListTile(
                title: const Text('Segunda Pagina'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/second');
                },
              ),
              ListTile(
                title: const Text('Tareas'),
                onTap: () {
                  Navigator.popAndPushNamed(context, '/taks');
                },
              ),
            ],
          ),
        ),
        // En el contenido del componente tenemos 2 elementos
        // Padding con el input de texto para agregar nuevas tareas
        // el evento onPressed agrega el contenido del input a la lista de tareas y limpia el input

        // Expanded contiene la lista de tareas existentes
        // El componente Consumer permite que la lista se actualice cuando se agrega un
        // elemento, y cada elementos mostrado de la lista contiene un boton que elimina esa tarea de la lista
        // usando tasksProvider.removeTask(index);
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Nueva tarea',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        // tasksProvider.addTask(Task(title: _controller.text));
                        DB.insert(Task(
                            nombre: _controller.text,
                            estado: 'pending',
                            id: DateTime.now().millisecondsSinceEpoch %
                                1000000));
                        _controller.clear();
                        cargaTaks();
                      }
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: Consumer<TasksProvider>(
                builder: (context, tasksProvider, child) {
                  // Aqui usamos el componente ListView como si fuera un forEach
                  // para imprimir tantos elementos existan en tasksProvider
                  // utilizamos el parametro index dentro de itemBuilder poder
                  // identificar el elemento que debemos eliminar como removeTask
                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(tasks[index].nombre),
                        trailing: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            // tasksProvider.removeTask(index);
                            DB.delete(tasks[index]);
                            cargaTaks();
                          },
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }
}
