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
    await _firestore.collection('Productos').add({
      'nombre': nombre,
      'descripcion': descripcion,
      'sistemaOperativo': sistemaOperativo,
      'stock': stock,
      'precio': precio,
      'imageUrl': imageUrl,
    });
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

  // Obtener productos en tiempo real para mostrarlos en HomeScreen
  Stream<QuerySnapshot> getProductos() {
    return _firestore.collection('Productos').snapshots();
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

    await _firestore.collection('Productos').doc(id).update({
      'nombre': nombre,
      'descripcion': descripcion,
      'sistemaOperativo': sistemaOperativo,
      'stock': stock,
      'precio': precio,
      'imageUrl': imageUrl,
    });
  }

  // Eliminar un producto
  Future<void> deleteProduct(String id) async {
    await _firestore.collection('Productos').doc(id).delete();
  }
}
