import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/diary.dart';
import 'package:fiteat/model/exercise.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/diary/dairy_screen.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ExerciseScreen extends StatefulWidget {
  String exerciseId;
  ExerciseScreen({Key? key,required this.exerciseId}) : super(key: key);

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState(exerciseId:exerciseId);
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  Exercise exercise = Exercise();
  String exerciseId;

  final _formKey = GlobalKey<FormState>();

  final timeEditingController = TextEditingController();

  // string for displaying the error
  String? errorMessage;

  _ExerciseScreenState({Key? key,required this.exerciseId});

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
        .collection("exercises")
        .doc(exerciseId)
        .get()
        .then((value) {
      exercise = Exercise.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    //first name field
    final timeField = TextFormField(
      autofocus: false,
      controller: timeEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        RegExp regex = new RegExp(r'[+-]?([0-9]*[.])?[0-9]+');
        if (value!.isEmpty) {
          return ("Current time cannot be empty");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid time");
        }

        return null;
      },
      onSaved: (value) {
        timeEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.timelapse,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Time in seconds",
        hintStyle: TextStyle(color: Colors.black54),
        errorStyle: TextStyle(color: Colors.black),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),

      ),
        
    );

    final addExerciseButton = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {
            addExerciseToDiary(timeEditingController.text);

        },
        child: const Text(
          "Add Exercise",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );


    if ( exercise.name == null || loggedInUser.activitylevel == null)
      return Container(
          color: Color(0xFFfc7b78),
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )));
    else {
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
          title: const Text('Add Entry', style: TextStyle(color: Colors.white)),
        ),
        bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            child: addExerciseButton),
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(45)),
            child: Container(
              height: height * 0.6,
              width: width * 0.9,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        exercise.name!,
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      timeField,
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: width*0.031,),
                          Icon(
                            Icons.fireplace_rounded,
                            color: Colors.black,
                          ),
                          SizedBox(width: width*0.028,),
                          Text(
                            "Calories burned per minute : ${exercise.caloriesPerMinute!.toInt()}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
    }
  }



  void addExerciseToDiary(String time) async{
    if(_formKey.currentState!.validate())
    {
            Diary diary;
            String id = exercise.id!;
            double timeInSeconds = double.parse(time);
            double caloriesBurned = exercise.caloriesPerMinute! * (timeInSeconds/60);
            LinkedHashMap<String, double> element =  LinkedHashMap();
            element[id] = timeInSeconds;

            await FirebaseFirestore.instance
              .collection('diary')
              .doc(loggedInUser.uid)
              .get()
              .then((value)=>{
                  diary = Diary.fromMap(value.data()),
                  if(diary.exercises!.containsKey(id) == true ){
                      diary.exercises!.update(id, (value) => value + timeInSeconds)
                  } 
                  else
                  diary.exercises!.addAll(element),
                  diary.exercise = diary.exercise! + caloriesBurned,
                  FirebaseFirestore.instance.collection('diary')
                  .doc(loggedInUser.uid)
                  .set(diary.toMap())
              });
         Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const DiaryScreen()),
        (route) => false);

    }


  }
}
