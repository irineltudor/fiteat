import 'dart:developer';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage{
  final firebase_storage.FirebaseStorage storage = 
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(
    String filePath,
    String fileName,
  )async{
    File file = File(filePath);

    try{
      await storage.ref('test/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e){
      print(e);
    }

  }


  Future<firebase_storage.ListResult> listFiles() async{
    firebase_storage.ListResult results = await storage.ref('test').listAll();

    results.items.forEach((firebase_storage.Reference ref){
      print('found file: $ref');
    });

    return results;
  }

  Future<String> downloadURL(String imageName) async{
    String downloadURL = await storage.ref('test/${imageName}').getDownloadURL();

    return downloadURL;
  }

  Future<String> getProfilePicture(String uid) async{
    String imageUrl = 'user-profile/' + uid + '.png';
    String error = "";
    String downloadURL = "";
    try{
    await storage.ref(imageUrl).getDownloadURL();
    } on firebase_storage.FirebaseException catch(myError)
    { 
      switch (myError.code)
      {
        case 'object-not-found':
        error = myError.toString();
      }
      

    }
    
  if(error == "")
  {
    downloadURL= await storage.ref(imageUrl).getDownloadURL();
  }
  else{
    
    downloadURL = await storage.ref("user-profile/profile.png").getDownloadURL();

  }


    return downloadURL;
  }

}