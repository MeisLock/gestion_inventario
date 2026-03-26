import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<bool> uploadImage(File image) async {
 
  print(image.path);
  final String nameFile = image.path.split("/").last;

  Reference ref = storage.ref().child("imagenes de telefonos").child(nameFile);
  final UploadTask uploadTask = ref.putFile(image);
  print(uploadTask);

  final TaskSnapshot snapshot = await uploadTask.whenComplete(()=> true);
  print(snapshot);

  final String url =await snapshot.ref.getDownloadURL();
  print(url);

  return false;

}