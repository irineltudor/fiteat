// ignore_for_file: unnecessary_const, deprecated_member_use

import 'dart:developer';

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

class ChangeGoalScreen extends StatefulWidget {
  const ChangeGoalScreen({Key? key}) : super(key: key);

  @override
  _ChangeGoalScreenState createState() => _ChangeGoalScreenState();
}

class _ChangeGoalScreenState extends State<ChangeGoalScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  Statistics statistics = Statistics(date: [],weight: []);

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  final weightEditingController = TextEditingController();
  final heightEditingController = TextEditingController();
  final activityLevelEditingController = TextEditingController();
  final weeklyGoalEditingController = TextEditingController();
  final confirmweeklyGoalEditingController = TextEditingController();
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

        FirebaseFirestore.instance
        .collection("statistics")
        .doc(user!.uid)
        .get()
        .then((value) {
      statistics = Statistics.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final weightField = TextFormField(
      autofocus: false,
      controller: weightEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
      validator: (value) {},
      onSaved: (value) {
        weightEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.scale,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Change current weight",
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

    final heightField = TextFormField(
      autofocus: false,
      controller: heightEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
      validator: (value) {},
      onSaved: (value) {
        heightEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.height,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Change current height",
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
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
      validator: (value) {},
      onSaved: (value) {
        caloriesEditingController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.food_bank,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Change calories for everyday",
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

    String? selectedValue = null;
    //activityLevel field
    final activityLevelField =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text(
        "Activity Level ",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      SizedBox(
          width: width * 0.5,
          child: DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) =>
                  value == null ? "Select activity level" : null,
              dropdownColor: Colors.white,
              value: selectedValue,
              onChanged: (String? newValue) {
                setState(() {
                  selectedValue = newValue!;
                  activityLevelEditingController.text = newValue;
                });
              },
              items: activityLevel)),
    ]);

    String? selectedGoal = null;
    //weeklyGoal field
    final weeklyGoalField =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Text(
        "Weekly Goal ",
        style: const TextStyle(color: Colors.black, fontSize: 16),
      ),
      SizedBox(
          width: width * 0.51,
          child: DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) =>
                  value == null ? "Select activity level" : null,
              dropdownColor: Colors.white,
              value: selectedGoal,
              onChanged: (String? newValue) {
                setState(() {
                  selectedGoal = newValue!;
                  weeklyGoalEditingController.text = newValue;
                });
              },
              items: weeklyGoal)),
    ]);

    final updateButton = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {
          updateDetails(
              weightEditingController.text,
              heightEditingController.text,
              activityLevelEditingController.text,
              weeklyGoalEditingController.text,
              caloriesEditingController.text,
              birthEditingControler.text);
        },
        child: const Text(
          "Update",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    String currentActivityLevel = "";

    String currentWeeklyGoal = "";

    switch (loggedInUser.activitylevel) {
      case 0:
        currentActivityLevel = "Not Very Active";
        break;

      case 1:
        currentActivityLevel = "Lightly Active";
        break;

      case 2:
        currentActivityLevel = "Active";
        break;

      case 3:
        currentActivityLevel = "Very Active";
        break;
    }


    switch (loggedInUser.goal.toString()) {
      case "-0.2":
        currentWeeklyGoal = "Lose 0,2 kg per week";
        break;

      case "-0.5":
        currentWeeklyGoal = "Lose 0,5 kg per week";
        break;

      case "-0.8":
        currentWeeklyGoal = "Lose 0,8 kg per week";
        break;

      case "-1.0":
        currentWeeklyGoal = "Lose 1 kg per week";
        break;

      case "0.0":
        currentWeeklyGoal = "Maintain weight";
        break;

      case "0.2":
        currentWeeklyGoal = "Gain 0,2 kg per week";
        break;

      case "0.5":
        currentWeeklyGoal = "Gain 0,5 kg per week";
        break;
    }

    if (loggedInUser.dob == null || statistics.uid == null) {
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
            title: const Text('Goal', style: TextStyle(color: Colors.white)),
          ),
          bottomNavigationBar: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(40)),
              child: updateButton),
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
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(36),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: [
                                Text(
                                    "Current calories : ${loggedInUser.goalcalories} calories"),
                                Text(
                                    "Current weight : ${loggedInUser.weight} kg"),
                                Text(
                                    "Current height : ${loggedInUser.height} cm"),
                                Text(
                                    "Current activity level : ${currentActivityLevel}"),
                                Text(
                                    "Current weekly goal: ${currentWeeklyGoal}"),
                              ],
                            ),
                            const SizedBox(height: 10),
                            caloriesField,
                            const SizedBox(height: 10),
                            weightField,
                            const SizedBox(height: 10),
                            heightField,
                            const SizedBox(height: 10),
                            activityLevelField,
                            const SizedBox(height: 10),
                            weeklyGoalField,
                            const SizedBox(height: 10),
                            DatePickerWidget(
                                color: Colors.black,
                                userDate: '${loggedInUser.dob}',
                                buttonColor: Colors.white,
                                dob: birthEditingControler),
                            const SizedBox(height: 10),
                                Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Activity level info",
                          style: TextStyle(color: Colors.black),
                        ),
                        MaterialButton(
                          child: const Icon(Icons.info, color: Colors.black),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  _infoPopUpDialog(context),
                            );
                          },
                        ),
                      ],
                    ),
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

  void updateDetails(String weight, String height, String activitylevel,
      String goal, String goalCaloriesSet, String dob) {
    loggedInUser.weight =
        weight == "" ? loggedInUser.weight : double.parse(weight);
    loggedInUser.height =
        height == "" ? loggedInUser.height : double.parse(height);
    loggedInUser.activitylevel = activitylevel == ""
        ? loggedInUser.activitylevel
        : int.parse(activitylevel);
    loggedInUser.goal = goal == "" ? loggedInUser.goal : double.parse(goal);

    DateTime today = DateTime.now();
    DateTime date = DateFormat('dd-MM-yyyy').parse(dob);

    int age = (today.difference(date).inDays / 365).floor();

    double BMR = 0;
    if (loggedInUser.gender == "Man") {
      BMR = 66.47 +
          (13.75 * double.parse(loggedInUser.weight.toString())) +
          (5.003 * double.parse(loggedInUser.height.toString())) -
          (6.755 * age);
    } else {
      BMR = 655.1 +
          (9.563 * double.parse(loggedInUser.weight.toString())) +
          (1.850 * double.parse(loggedInUser.height.toString())) -
          (4.676 * age);
    }
    double AMS = 0;
    switch (loggedInUser.activitylevel) {
      case 0:
        AMS = BMR * 1.2;
        break;

      case 1:
        AMS = BMR * 1.375;
        break;

      case 2:
        AMS = BMR * 1.55;
        break;

      case 3:
        AMS = BMR * 1.725;
        break;
    }

    AMS = AMS + 1000 * double.parse(loggedInUser.goal.toString());

    num goalCalories =
        goalCaloriesSet == "" ? AMS.round() : double.parse(goalCaloriesSet.toString());

    loggedInUser.goalcalories = goalCalories.toInt();

    firebaseFirestore
        .collection("users")
        .doc(loggedInUser.uid)
        .update(loggedInUser.toMap())
        .then((value) => Fluttertoast.showToast(msg : "Changes were updated"));

    if(weight != "")
    {
    addProgressToDiary(weight);
    }

    setState(() {});
  }

    void addProgressToDiary(String weight) async {
    DateTime today = DateTime.now();

    statistics.date.add(DateFormat('dd-MM-yyyy').format(today));
    statistics.weight.add(double.parse(weight));
    statistics.uid = user!.uid;

    loggedInUser.weight = double.parse(weight);



    await FirebaseFirestore.instance
        .collection("statistics")
        .doc(user!.uid)
        .set(statistics.toMap());

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set(loggedInUser.toMap());

  }
}

List<DropdownMenuItem<String>> get activityLevel {
  List<DropdownMenuItem<String>> activityLevelItems = [
    const DropdownMenuItem(child: Text("Not Very Active"), value: "0"),
    const DropdownMenuItem(child: Text("Lightly Active"), value: "1"),
    const DropdownMenuItem(child: Text("Active"), value: "2"),
    const DropdownMenuItem(child: Text("Very Active"), value: "3"),
  ];
  return activityLevelItems;
}

List<DropdownMenuItem<String>> get weeklyGoal {
  List<DropdownMenuItem<String>> weeklyGoalItems = [
    const DropdownMenuItem(child: Text("Lose 0,2 kg per week"), value: "-0.2"),
    const DropdownMenuItem(child: Text("Lose 0,5 kg per week"), value: "-0.5"),
    const DropdownMenuItem(child: Text("Lose 0,8 kg per week"), value: "-0.8"),
    const DropdownMenuItem(child: Text("Lose 1 kg per week"), value: "-1"),
    const DropdownMenuItem(child: Text("Maintain weight"), value: "0"),
    const DropdownMenuItem(child: Text("Gain 0,2 kg per week"), value: "0.2"),
    const DropdownMenuItem(child: Text("Gain 0,5 kg per week"), value: "0.5"),
  ];
  return weeklyGoalItems;
}


Widget _infoPopUpDialog(BuildContext context) {
  return AlertDialog(
    title: const Text("Activity Level :"),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        Text(
          "Not Very Active - Sedentary ",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 10),
        Text(
          "Lightly Active - 30 minutes of exercises",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 10),
        Text(
          "Active - 1 hour and 45 minutes of exercises",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 10),
        Text(
          "Very Active - 4 hours and 15 minutes of excercises",
          style: TextStyle(fontSize: 14),
        ),
      ],
    ),
    actions: <Widget>[
      FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}
