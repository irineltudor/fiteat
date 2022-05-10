import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/food.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'add_food_screen.dart';

class CreateFoodScreen extends StatefulWidget {
  String code;
  CreateFoodScreen({Key? key,required this.code}) : super(key: key);

  @override
  _CreateFoodScreenState createState() => _CreateFoodScreenState(code : code);
}

class _CreateFoodScreenState extends State<CreateFoodScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String code;

  _CreateFoodScreenState({Key? key, required this.code});
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  final nameEditingController = TextEditingController();
  final additionalEditingController = TextEditingController();
  final caloriesEditingController = TextEditingController();
  final proteinEditingController = TextEditingController();
  final carbsEditingController = TextEditingController();
  final fatEditingController = TextEditingController();
  final servingSizeEditingController = TextEditingController();
  final barcodeEditingController = TextEditingController();

  TextEditingController birthEditingControler = new TextEditingController();

  // string for displaying the error
  String? errorMessage;

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
      birthEditingControler.text = loggedInUser.dob.toString();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    if ( code != "" )
    {
      barcodeEditingController.text = code;
    }

    final nameField = TextFormField(
      autofocus: false,
      controller: nameEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("name cannot be empty");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid name(min 3 characters)");
        }

        return null;
      },
      onSaved: (value) {
        nameEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.food_bank,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Name",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );


      final additionalField = TextFormField(
      autofocus: false,
      controller: additionalEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.name,
      validator: (value) {
      },
      onSaved: (value) {
        additionalEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.info,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Additional Info",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );
    
    final caloriesField = TextFormField(
      autofocus: false,
      controller: caloriesEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {},
      onSaved: (value) {
        caloriesEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.cookie,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Calories per serving",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );
    
    final proteinField = TextFormField(
      autofocus: false,
      controller: proteinEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
      validator: (value) {},
      onSaved: (value) {
        proteinEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.fastfood,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Proteins per serving",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );

    
    
    final carbsField = TextFormField(
      autofocus: false,
      controller: carbsEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
      validator: (value) {},
      onSaved: (value) {
        carbsEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.fastfood,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Carbs per serving",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );


    final fatField = TextFormField(
      autofocus: false,
      controller: fatEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
      validator: (value) {},
      onSaved: (value) {
        fatEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.fastfood,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Fats per serving",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );

    final servingSizeField = TextFormField(
      autofocus: false,
      controller: servingSizeEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.name,
      validator: (value) {
        RegExp regex = new RegExp(r'^.{3,}$');
        if (value!.isEmpty) {
          return ("Serving size cannot be empty");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid serving size(min 3 characters)");
        }

        return null;
      },
      onSaved: (value) {
        servingSizeEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.scale,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Serving Size",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );

   final barCodeField = TextFormField(
      autofocus: false,
      controller: barcodeEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      validator: (value) {
      },
      onSaved: (value) {
        barcodeEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.qr_code,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Bar code",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
  
    );

    final createFoodButton = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {
          createFood(nameEditingController.text,additionalEditingController.text,caloriesEditingController.text,proteinEditingController.text,carbsEditingController.text,fatEditingController.text,servingSizeEditingController.text,barcodeEditingController.text);
        },
        child: const Text(
          "Create Food",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );


    if (loggedInUser.dob == null) {
      return Container(
          color: Color(0xFFfc7b78),
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )));
    } else {
      return Scaffold(
          backgroundColor: const Color.fromARGB(255, 197, 201, 207),
          resizeToAvoidBottomInset: true,
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
            title: const Text('Create food', style: TextStyle(color: Colors.white)),
          ),
          bottomNavigationBar: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40)),
              child: createFoodButton),
          body: Stack(
            children: [
              Positioned(
                top: height * 0.005,
                height: height * 0.815,
                left: height * 0.005,
                right: height * 0.005,
                child: Center(
                  child: SingleChildScrollView(
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(45)),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(36),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                const SizedBox(height: 10),
                                nameField,
                                const SizedBox(height: 10),
                                additionalField,
                                const SizedBox(height: 10),
                                caloriesField,
                                const SizedBox(height: 10),
                                proteinField,
                                const SizedBox(height: 10),
                                carbsField,
                                const SizedBox(height: 10),
                                fatField,
                                const SizedBox(height: 10),
                                servingSizeField,
                                const SizedBox(height: 10),
                                barCodeField
                                    
                              ],
                              
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ));
    }
  }

  void createFood (String name, String additional, String calories, String protein, String carbs, String fat, String servingSize, String barcode) async{
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Food food = Food();
    if( barcode == "")
    {
      await firebaseFirestore.collection('food').get().then((value) => { barcode = (value.size.toInt() + 1).toString(),
      food =  Food(name:name ,additional: additional, calories: double.parse(calories),protein: double.parse(protein),carbs: double.parse(carbs),fat:double.parse(fat),servingSize: servingSize,barcode: barcode),
      firebaseFirestore.collection('food').doc(barcode).set(food.toMap())});
    }
    else{
    Food  food =  Food(name:name ,additional: additional, calories: double.parse(calories),protein: double.parse(protein),carbs: double.parse(carbs),fat:double.parse(fat),servingSize: servingSize,barcode: barcode);
    await firebaseFirestore.collection('food').doc(barcode).set(food.toMap());
    }

    



        Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const AddFoodScreen()),
        (route) => false);
  }


}
