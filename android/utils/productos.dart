
enum SistemasOpetativos {ios,android}

final class Productos {

String name ;
String descripcion;
SistemasOpetativos categoria;
int cantidadStock;
double precio;

Productos({
  required this.name,
  required this.descripcion,
  required this.categoria,
  required this.cantidadStock,
  required this.precio
});

}

