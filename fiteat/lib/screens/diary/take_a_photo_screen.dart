// ignore_for_file: unnecessary_const, deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'package:fiteat/screens/more/more_screen.dart';
import 'package:fiteat/service/storage_service.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/statistics.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class TakeAPhotoScreen extends StatefulWidget{
  const TakeAPhotoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CaptureImageState();
}

class _CaptureImageState extends State<TakeAPhotoScreen>{

  File? _profilePicture;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  Statistics statistics = Statistics(date: [],weight: []);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }


  Future<void> _pickImage(ImageSource source) async{
    XFile? selected  = await ImagePicker().pickImage(source: source);

    setState((){
      if(selected != null)
      _profilePicture = File(selected.path);
    });

  }

  void _clear(){
    setState(()=> _profilePicture = null );
  }

  Future<void> _cropImage() async{
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: _profilePicture!.path,
      compressFormat: ImageCompressFormat.png
    );

    setState(() {
      _profilePicture = croppedImage ?? _profilePicture;
    });
  }

@override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final photoButtons = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child : Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        IconButton(
          icon: const Icon(Icons.photo_camera,color: Colors.white,size: 30,),
          onPressed: () => _pickImage(ImageSource.camera),),
          SizedBox(width: width*0.3,),
          IconButton(
          icon: const Icon(Icons.photo_library,color: Colors.white,size: 30),
          onPressed: () => _pickImage(ImageSource.gallery,),)
    ],));

    if (loggedInUser.dob == null) {
      return Container(
          color: const Color(0xFFfc7b78),
          child: const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )));
    } else {
      return Scaffold(
          backgroundColor: const Color.fromARGB(255, 197, 201, 207),
          appBar: AppBar(
            backgroundColor: const Color(0xFFfc7b78),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            centerTitle: true,
            title: const Text('Food Photo', style: TextStyle(color: Colors.white)),
          ),
          bottomNavigationBar: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40)),
                  child: photoButtons,),
          body: Stack(
            children: [
              Positioned(
                top: height * 0.005,
                height: height * 0.815,
                left: height * 0.005,
                right: height * 0.005,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(const Radius.circular(45)),
                  child: Container(
                    color:Colors.white,
                    child: ListView(
                      children: [
                        if(_profilePicture != null) ... [
                          Image.file(_profilePicture!),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            
                            FlatButton(
                            onPressed: _cropImage, 
                            child: const Icon(Icons.crop)),
                            FlatButton(
                            onPressed: _clear, 
                            child: const Icon(Icons.refresh))
                          ],),
                  
                        ]
                      ],
                    ),
                  )
                ),
              ),
            ],
          ));
    }
  }
  
}

class Upload extends StatefulWidget{
  final File file;
  
  Upload({Key? key, required this.file}) : super (key: key);

  createState() => _UploadState();

}

class _UploadState extends State<Upload>{
  final storage = firebase_storage.FirebaseStorage.instance;
  User? user = FirebaseAuth.instance.currentUser;

  firebase_storage.UploadTask? _uploadTask;

  void _startUpload(){
    String filePath = 'user-profile/' + user!.uid + '.png';

    setState((){
    _uploadTask = storage.ref().child(filePath).putFile(widget.file);
    }
    );
  }


  @override
  Widget build(BuildContext context) {
      if(_uploadTask != null){

        

        return StreamBuilder<firebase_storage.TaskSnapshot>(
          stream: _uploadTask!.snapshotEvents,
          builder: (context,snapshot){
            var event = snapshot.data ?? null;

            double progressPercent = event != null?
                                  event.bytesTransferred/event.totalBytes : 0 ;

           if(progressPercent == 1)
           Future.delayed(const Duration(seconds: 1), (){
             Navigator.of(context).pushReplacement(MaterialPageRoute(
                 builder: (context) => const MoreScreen()));
           });
            

            return Column(
              children: [
                if(_uploadTask!.snapshot.state == firebase_storage.TaskState.success)
                  Text('Profile Pic Changed'),
                if(_uploadTask!.snapshot.state == firebase_storage.TaskState.paused)
                  FlatButton(onPressed:() => _uploadTask!.resume(),
                   child: Icon(Icons.play_arrow)),
                if(_uploadTask!.snapshot.state == firebase_storage.TaskState.running)
                   FlatButton(onPressed:() => _uploadTask!.pause(),
                   child: Icon(Icons.pause)),

                LinearProgressIndicator(value : progressPercent),
                Text('${(progressPercent*100).toStringAsFixed(2)}%'),



              ],
            );

          });

      }
      else
      {
        return FlatButton.icon(
          label: Text ('Set Profile Picture'),
          icon: Icon(Icons.cloud_upload),
          onPressed: _startUpload,);
      }
  }

}