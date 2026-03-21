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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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

            SizedBox(height: 10,),

            //Botón Filtro + Botón Nuevo(Añadir)
            Row(
              children: [
                OutlinedButton.icon(//Tiene que ser la variante OutlinedButton.icon para que acepte más de un Widget
                  onPressed:() {
                    //Añadir lógica boton filtro para abrir los filtro 
                  },
                  icon: Icon(Icons.filter_list, color: Color(0xFF626262),),
                  label: Text('Filtro', style: TextStyle(color: const Color.fromARGB(225, 0, 0, 0)),),
                  
                  ),

                  SizedBox(width: 160,),

                OutlinedButton.icon(
                  onPressed:() {
                  //Añadir lógica boton Nuevo
                }, 
                label: Text('Nuevo', style: TextStyle(color: const Color.fromARGB(225, 0, 0, 0)),),
                icon: Icon(Icons.add, color: const Color.fromRGBO(8, 102, 255, 1)),
                )
              ],
            )
          ],
        ),
        ),
    );
  }
}
