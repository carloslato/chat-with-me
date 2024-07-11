// schema

class Task {
  int id;
  String nombre;
  int estado;
  String time;

  Task(
      {required this.id,
      required this.nombre,
      required this.estado,
      required this.time});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'estado': estado, 'time': time};
  }
}
