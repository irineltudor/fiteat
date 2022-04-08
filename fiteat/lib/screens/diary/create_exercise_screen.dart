import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/exercise.dart';
import 'package:fiteat/model/food.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CreateExerciseScreen extends StatefulWidget {
  const CreateExerciseScreen({Key? key}) : super(key: key);

  @override
  _CreateExerciseScreenState createState() => _CreateExerciseScreenState();
}

class _CreateExerciseScreenState extends State<CreateExerciseScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  final nameEditingController = TextEditingController();
  final caloriesEditingController = TextEditingController();

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
        hintText: "Calories burned per minute",
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

    final createExerciseButton = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {
          createExercise(nameEditingController.text,caloriesEditingController.text);
        },
        child: const Text(
          "Create Exercise",
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
            title: const Text('Create Exercise', style: TextStyle(color: Colors.white)),
          ),
          bottomNavigationBar: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40)),
              child: createExerciseButton),
          body: Stack(
            children: [
              Positioned(
                top: height * 0.005,
                height: height * 0.815,
                left: height * 0.005,
                right: height * 0.005,
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
                            caloriesField,
                                
                          ],
                          
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

  createExercise(String name, String calories) async{

      String id = "";
      Exercise exercise = Exercise();
    
    await firebaseFirestore.collection('exercises').get().then((value) =>{id = (value.size).toString(),
    exercise = new Exercise(name: name, caloriesPerMinute : double.parse(calories),id: id),
    firebaseFirestore.collection('exercises').doc(id).set(exercise.toMap())}
    );
    
    Navigator.of(context).pop();
  
    
    }

}
