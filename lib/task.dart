// schema

class Task {
  int id;
  String nombre;
  String estado;

  Task({required this.id, required this.nombre, required this.estado});

  Map<String, dynamic> toMap() {
    return {'id': id, 'nombre': nombre, 'estado': estado};
  }
}
