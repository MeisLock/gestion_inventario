import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: 
        //Botón Menu 
        IconButton(
          onPressed:() {
            //Añafir lógica del Botón Menu
          }, 
          icon: const Icon(Icons.menu, color: Colors.black,)
        ),
        actions:[
        //Boton Perfil
        IconButton(
          onPressed: () {  }, 
          icon: const Icon(Icons.account_circle),)
        ],
        //Texto Menu Medio 
        title: const Text('Menu', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
        ),
        centerTitle: true,
  
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //Barra Buscadora
            Container(
              height: 46,
              decoration: BoxDecoration(
                color: Color(0xFFF3F4F6),//Rectificar debería ser + gris. Rectificar también el ancho no deberia tener tanta anchura
                borderRadius: BorderRadius.circular(30),
              ),
              
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar producto...',
                  hintStyle: TextStyle(color: const Color.fromARGB(181, 0, 0, 0)),
                  prefixIcon: Icon(Icons.search, color: const Color.fromARGB(255, 0, 0, 0)),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 13),
                ),
              ),
            ),

            const SizedBox(height: 4,),

            //Botón Filtro + Botón Nuevo(Añadir)
            Row(
              children: [
                SizedBox(width: 15,),

                OutlinedButton.icon(
                  onPressed:() {
                    //Añadir lógica boton filtro para abrir los filtro 
                  },
                  icon: Icon(Icons.filter_list, color: Color.fromARGB(255, 98, 98, 98),),
                  label: Text('Filtro', style: TextStyle(color: const Color.fromARGB(225, 0, 0, 0)),),
                  style:  OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    elevation: 3,
                    shadowColor: Colors.black,
                    backgroundColor: const Color.fromRGBO(247, 242, 250, 1),
                    shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size(0, 1),
                  ),
                  ),

                SizedBox(width: 170,),

                OutlinedButton.icon(
                  label: Text('Nuevo', style: TextStyle(color: const Color.fromARGB(225, 0, 0, 0)),),
                  icon: Icon(Icons.add, color: const Color.fromRGBO(8, 102, 255, 1)),
                  style:  OutlinedButton.styleFrom(
                    side: BorderSide.none,
                    elevation: 3,
                    shadowColor: Colors.black,
                    backgroundColor: const Color.fromRGBO(247, 242, 250, 1),
                    shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    minimumSize: Size(0, 1),
                  ),
                  onPressed:() {
                  //Añadir lógica boton Nuevo(Crear producto)
                  }, 
                )
              ],
            ),

            const SizedBox(height: 8,),

            //Cuadricula para mostrar productos
            Expanded(
              child: GridView.builder(
                clipBehavior: Clip.none,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  ),
                itemCount: ejemplo.length,//Se tiene que implementar con la base de Firebase
                itemBuilder: (context, index) {
                  var producto = ejemplo[index];
                  return ProductCard(
                    nombre : producto['nombre']!,
                    precio : producto['precio']!,
                  );
                },
              ),
            )
          ],
        ),
        ),

      
    );
  }
}
//Creamos clase ProducCard para el itemBuilder del Grid
//Tarjeta Producto
class ProductCard extends StatefulWidget {
  
  const ProductCard({
    super.key,
    required this.nombre,
    required this.precio
  });

  final String nombre;
  final String precio;


  @override
  State<ProductCard> createState() => _ProductCard(); 
}

class _ProductCard extends State<ProductCard>{
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 6,
            offset: Offset(0, 3)
          )
        ]
      ),
      //Imagen(Cambiar lógica al añadir Firebase)
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 220, 234, 245),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(12)
                  )
              ),
              child: Icon(
                Icons.image_outlined,
                color: Color.fromARGB(255, 147, 197, 216),
                size: 40,
              ),
            ),
            
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Nombre producto
                Text(
                  super.widget.nombre,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                  )
                ),

                const SizedBox(height: 4,),
                //Precio Producto
                Text(
                  super.widget.precio,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
    
  }
}

// Datos para probar el Grid, borrar cuando se implemente la base de datos de Firebase
List<Map<String, String>> ejemplo = [
  {'nombre': 'Apple iPhone 14 Pro',    'precio': '469 €'},
  {'nombre': 'Xiaomi Redmi Note 14',   'precio': '146,63 €'},
  {'nombre': 'Apple Iphone 15 Pro Max','precio': '745,42 €'},
  {'nombre': 'Google Pixel 8',         'precio': '260,00 €'},
  {'nombre': 'Samsung Galaxy S25',     'precio': '765,00 €'},
  {'nombre': 'Samsung Galaxy Note 9',  'precio': '269,99 €'},
  {'nombre': 'One Plus Nord 5',        'precio': '409,00 €'},
  {'nombre': 'Google Pixel 10',        'precio': '579,00 €'},
  {'nombre': 'Apple iPad Pro',         'precio': 'Desde 1.099 €'},
  {'nombre': 'Google Pixel 8',         'precio': '260,00 €'},
  {'nombre': 'Nothing Phone',          'precio': '550,00 €'},
  {'nombre': 'Apple iPhone Air',       'precio': '1039,00 €'},
];




