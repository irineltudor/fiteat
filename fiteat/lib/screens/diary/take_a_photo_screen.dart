// ignore_for_file: unnecessary_const, deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:fiteat/screens/diary/food_screen.dart';
import 'package:image/image.dart' as Img;
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
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

import '../../model/food.dart';

class TakeAPhotoScreen extends StatefulWidget{
  const TakeAPhotoScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CaptureImageState();
}

class _CaptureImageState extends State<TakeAPhotoScreen>{

  File? _foodPhoto;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List<Food> allFoods = [];

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

        FirebaseFirestore.instance
        .collection("food")
        .get()
        .then((value) {
          Food food;
            value.docs.forEach(
              (db_food) => {
              food = Food.fromMap(db_food.data()),
              allFoods.add(food)

              }
            );
      setState(() {});
    });

  }


  Future<void> _pickImage(ImageSource source) async{
    XFile? selected  = await ImagePicker().pickImage(source: source);

    setState((){
      if(selected != null)
      _foodPhoto = File(selected.path);
    });

  }

  void _clear(){
    setState(()=> _foodPhoto = null );
  }

  Future<void> _cropImage() async{
    File? croppedImage = await ImageCropper().cropImage(
      sourcePath: _foodPhoto!.path,
      compressFormat: ImageCompressFormat.png
    );

    setState(() {
      _foodPhoto = croppedImage ?? _foodPhoto;
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

    if (loggedInUser.dob == null || allFoods.isEmpty ) {
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
                        if(_foodPhoto != null) ... [
                          Image.file(_foodPhoto!),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                            
                            FlatButton(
                            onPressed: _cropImage, 
                            child: const Icon(Icons.crop)),
                            FlatButton(
                            onPressed: _clear, 
                            child: const Icon(Icons.delete))
                          ],),
                          Recognize(file : _foodPhoto!, foods : allFoods),
                  
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

class Recognize extends StatefulWidget{
  final File file;
  final List<Food> foods;
  
  const Recognize({Key? key, required this.file,required this.foods}) : super (key: key);

  @override
  // ignore: no_logic_in_create_state
  createState() => _RecognizeState(file : file, foods: foods);

}

class _RecognizeState extends State<Recognize>{
  final storage = firebase_storage.FirebaseStorage.instance;
  User? user = FirebaseAuth.instance.currentUser;
  final File file;
  final List<Food> foods;
  Food food=Food();

 
  _RecognizeState({required this.file,required this.foods});
  Future<void> _startRecognize() async {
    

    FirebaseModelDownloader.instance
    .getModel(
        "FoodRecognition",
        FirebaseModelDownloadType.localModel,
        FirebaseModelDownloadConditions(
          iosAllowsCellularAccess: true,
          iosAllowsBackgroundDownloading: false,
          androidChargingRequired: false,
          androidWifiRequired: false,
          androidDeviceIdleRequired: false,
        )
    )
    .then((customModel) async {
      final localModelPath = customModel.file;
      final interpreter = await tfl.Interpreter.fromFile(localModelPath);

      var dictionary = {0: 'macarons',
                        1: 'french toast',
                        2: 'lobster bisque',
                        3: 'prime rib',
                        4: 'pork chop',
                        5: 'baby back ribs'};


    var _inputShape = interpreter.getInputTensor(0).shape;
    var _inputType = interpreter.getInputTensor(0).type;
    var _outputShape = interpreter.getOutputTensor(0).shape;
    var _outputType = interpreter.getOutputTensor(0).type;

    var _outputBuffer = TensorBuffer.createFixedSize(_outputShape, _outputType);

    var _probabilityProcessor =
          TensorProcessorBuilder().add(NormalizeOp(0, 255)).build();

    //Start the image process
    var _inputImage = TensorImage(_inputType);

    Img.Image imageInput = Img.decodeImage(file.readAsBytesSync())!;
    _inputImage.loadImage(imageInput);

    int cropSize = min(_inputImage.height, _inputImage.width);
    _inputImage = ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(
            _inputShape[1], _inputShape[2], ResizeMethod.NEAREST_NEIGHBOUR))
        .add(NormalizeOp(0, 1))
        .build()
        .process(_inputImage);
      
    interpreter.run(_inputImage.buffer,_outputBuffer.getBuffer());
    var output = _outputBuffer.buffer.asFloat32List();
    double mx = 0;
    var index = 0;
    for (int  i = 0 ; i < output.length ;i ++)
    {
      if(mx < output[i])
      {
          mx = output[i];
          index = i;
      }
    }
    
   var foodName = dictionary[index];
   List<Food> searchedFoods = searchFood(foodName!);

   if(searchedFoods.isNotEmpty)
   { food = searchedFoods[0];
    setState(() {});
   }

    });
  }

    List<Food> searchFood(String query) {
    final searchFoods = foods.where((food){
      final foodName = food.name!.toLowerCase();
      final search = query.toLowerCase();
      return foodName.contains(search);
    }).toList();
    return searchFoods;
  }


  @override
  Widget build(BuildContext context) {

    if(food.barcode == null)
    {
        return FlatButton.icon(
          label: Text ('Find'),
          icon: Icon(Icons.search),
          onPressed: _startRecognize,); 
    }
    else
    {
      return FlatButton.icon(
          label: Text ('${food.name}'),
          icon: Icon(Icons.add),
          onPressed: () => {
              Navigator.push(context, MaterialPageRoute
            (builder: (context) => FoodScreen(foodId: food.barcode!)))
          }); 
      
    }
  }


  

}