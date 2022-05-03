// import 'package:fiteat/screens/registration_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/diary/dairy_screen.dart';
import 'package:fiteat/screens/signup-signin/details_screen.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/screens/signup-signin/forgot_password_screen.dart';
import 'package:fiteat/screens/signup-signin/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:collection';

import '../../model/diary.dart';

class DiaryDoneScreen extends StatefulWidget {
  Diary diary;
  DiaryDoneScreen({Key? key, required this.diary}) : super(key: key);

  @override
  _DiaryDoneScreenState createState() => _DiaryDoneScreenState(diary: diary);
}

class _DiaryDoneScreenState extends State<DiaryDoneScreen> {
  //form key
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  Diary diary;
  //editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error
  String? errorMessage;

  _DiaryDoneScreenState({Key? key, required this.diary});

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

  @override
  Widget build(BuildContext context) {
    final doneButton = Material(
      elevation: 5,
      color: Colors.green,
      child: MaterialButton(
        splashColor: Colors.white,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {
          resetDiary();
        },
       shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft : Radius.circular(45),topRight: Radius.circular(45)),
            side: const BorderSide(color: Colors.white)),
        child: const Text(
          "Done",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    if (loggedInUser.activitylevel == null) {
      return Container(
          color: const Color(0xFFfc7b78),
          child: const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )));
    } else {
      int goalCalories = loggedInUser.goalcalories! + diary.exercise!.toInt();
      int caloriesLeft = goalCalories - diary.food!.toInt();
      double goal = loggedInUser.goal!.toDouble();
      double weight = loggedInUser.weight!.toDouble();
      String text = "";

      if ( -50 < caloriesLeft && caloriesLeft < 50)
      {
        double futureWeight = weight + goal*4;
        text="If every day were like today, \n in one month, you'd weigh \n ${futureWeight}";
      }
      else{
        text="You didn't complete your goal. \n Do you want to finish this day?";
      }


      return Scaffold(
        backgroundColor: Colors.green,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // passing this to our root
              Navigator.of(context).pop();
            },
          ),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: doneButton),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      text,
                      textAlign: TextAlign.center,
                      style : TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      )
                    ),
                  ],
                )),
              ),
            ),
          ),
        
      );
    }
  }

  void resetDiary() async{

    String uid = loggedInUser.uid!.toString();
    double exercise = 0;
    double food = 0;
    double fats = 0;
    double carbs = 0;
    double protein = 0;
    LinkedHashMap<String, double> exercises = LinkedHashMap();

    LinkedHashMap<String, double> breakfast = LinkedHashMap();
    LinkedHashMap<String, double> lunch = LinkedHashMap();
    LinkedHashMap<String, double> dinner = LinkedHashMap();
    LinkedHashMap<String, LinkedHashMap<String, double>> meals =
        LinkedHashMap();

    meals['breakfast'] = breakfast;
    meals['lunch'] = lunch;
    meals['dinner'] = dinner;

    Diary emptyDiary = Diary(
        uid: uid,
        exercise: exercise,
        food: food,
        fats: fats,
        carbs: carbs,
        protein: protein,
        exercises: exercises,
        meals: meals);

        await FirebaseFirestore.instance
        .collection('diary')
        .doc(loggedInUser.uid)
        .set(emptyDiary.toMap());

        Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const DiaryScreen()),
        (route) => false);
  }
}
