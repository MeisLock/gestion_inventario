import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;
String imageUrl = "a";

Future<bool> uploadImage(File image) async {
 
  final String nameFile = image.path.split("/").last; //
  Reference ref = storage.ref().child("imagenes de telefonos").child(nameFile);   //guarda la imagen en la carpeta imagenes de telefonos con el nombre del archivo

  final UploadTask uploadTask = ref.putFile(image);


  final TaskSnapshot snapshot = await uploadTask.whenComplete(()=> true); //es un comprobador de si se ha subido la imagen
 

  final String url =await snapshot.ref.getDownloadURL();  //guarda la url de la imagen
  imageUrl = url;

  return false;

}