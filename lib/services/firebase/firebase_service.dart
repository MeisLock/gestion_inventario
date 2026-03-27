import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Subir imagen a Firebase Storage y obtener URL
  Future<String> uploadImage(File imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('Productos/$fileName.jpg');
    await ref.putFile(imageFile);
    return await ref.getDownloadURL();
  }

  // 🔹 Guardar un producto en Firestore
  Future<void> addProduct({
    required String nombre,
    required String descripcion,
    required String sistemaOperativo,
    required int stock,
    required double precio,
    required String imageUrl,
  }) async {
    final docRef = await _firestore.collection('Productos').add({
      'nombre': nombre,
      'descripcion': descripcion,
      'sistemaOperativo': sistemaOperativo,
      'stock': stock,
      'precio': precio,
      'imageUrl': imageUrl,
    });
    await registrarMovimiento(
      productoId: docRef.id,
      nombreProducto: nombre,
      tipo: 'creacion',
      stockAnterior: 0,
      stockNuevo: stock,
      cantidad: stock,
      descripcion: 'Producto creado',
    );
  }

  Future<void> addProducto({
    required String nombre,
    required String descripcion,
    required String sistemaOperativo,
    required int stock,
    required double precio,
    required String imageUrl,
  }) async {
    await addProduct(
      nombre: nombre,
      descripcion: descripcion,
      sistemaOperativo: sistemaOperativo,
      stock: stock,
      precio: precio,
      imageUrl: imageUrl,
    );
  }

  //Guardar usuario en Firestore al registrarse
  Future<void> guardarUsuario({
    required String uid,
    required String nombre,
    required String apellidos,
    required String email,
    required DateTime fechaNacimiento,
  }) async {
    await _firestore.collection('usuarios').doc(uid).set({
      'nombre': nombre,
      'apellidos': apellidos,
      'email': email,
      'fechaNacimiento': Timestamp.fromDate(fechaNacimiento),
      'fechaRegistro': FieldValue.serverTimestamp(),
    });
  }

  // Registrar movimiento de stock / producto
  Future<void> registrarMovimiento({
    required String productoId,
    required String nombreProducto,
    required String tipo,
    required int stockAnterior,
    required int stockNuevo,
    required int cantidad,
    required String descripcion,
  }) async {
    await _firestore.collection('movimientos').add({
      'productoId': productoId,
      'nombreProducto': nombreProducto,
      'tipo': tipo,
      'stockAnterior': stockAnterior,
      'stockNuevo': stockNuevo,
      'cantidad': cantidad,
      'descripcion': descripcion ?? '',
      'fecha': FieldValue.serverTimestamp(),
    });
  }

  // Obtener productos en tiempo real para mostrarlos en HomeScreen
  Stream<QuerySnapshot> getProductos() {
    return _firestore.collection('Productos').snapshots();
  }

  // Obtener historial de movimientos
  Stream<QuerySnapshot> getMovimientos() {
    return _firestore
        .collection('movimientos')
        .orderBy('fecha', descending: true)
        .snapshots();
  }

  // Actulizar el stock de un producto
  Future<void> updateProduct({
    required String id,
    required String nombre,
    required String descripcion,
    required String sistemaOperativo,
    required int stock,
    required double precio,
    required String imageUrl,
  }) async {
    final doc = await _firestore.collection('Productos').doc(id).get();

    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;
    final int stockAnterior = (data['stock'] as num?)?.toInt() ?? 0;

    await _firestore.collection('Productos').doc(id).update({
      'nombre': nombre,
      'descripcion': descripcion,
      'sistemaOperativo': sistemaOperativo,
      'stock': stock,
      'precio': precio,
      'imageUrl': imageUrl,
    });
    final int diferencia = stock - stockAnterior;

    String tipo = 'edicion';
    String descripcionMovimiento = 'Producto editado';

    if (diferencia > 0) {
      tipo = 'entrada';
      descripcionMovimiento = 'Entrada de stock';
    } else if (diferencia < 0) {
      tipo = 'salida';
      descripcionMovimiento = 'Salida de stock';
    }

    await registrarMovimiento(
      productoId: id,
      nombreProducto: nombre,
      tipo: tipo,
      stockAnterior: stockAnterior,
      stockNuevo: stock,
      cantidad: diferencia,
      descripcion: descripcionMovimiento,
    );
  }

  // Eliminar un producto
  Future<void> deleteProduct(String id) async {
    final doc = await _firestore.collection('Productos').doc(id).get();

    if (!doc.exists) return;

    final data = doc.data() as Map<String, dynamic>;
    final String nombre = (data['nombre'] ?? 'Producto').toString();
    final int stockActual = (data['stock'] as num?)?.toInt() ?? 0;

    await _firestore.collection('Productos').doc(id).delete();
    await registrarMovimiento(
      productoId: id,
      nombreProducto: nombre,
      tipo: 'eliminacion',
      stockAnterior: stockActual,
      stockNuevo: 0,
      cantidad: -stockActual,
      descripcion: 'Producto eliminado',
    );
  }
}
