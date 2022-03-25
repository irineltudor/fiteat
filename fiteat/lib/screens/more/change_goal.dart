import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangeGoalScreen extends StatefulWidget {
  const ChangeGoalScreen({Key? key}) : super(key: key);

  @override
  _ChangeGoalScreenState createState() => _ChangeGoalScreenState();
}

class _ChangeGoalScreenState extends State<ChangeGoalScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final weightEditingController = TextEditingController();
  final goalWeightEditingController = TextEditingController();
  final activityLevelEditingController = TextEditingController();
  final weeklyGoalEditingController = TextEditingController();
  final confirmweeklyGoalEditingController = TextEditingController();

  // string for displaying the error
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    //first name field
    final weightField = TextFormField(
      autofocus: false,
      controller: weightEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        RegExp regex = new RegExp(r'[+-]?([0-9]*[.])?[0-9]+');
        if (value!.isEmpty) {
          return ("Current weight cannot be empty");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid weight");
        }

        return null;
      },
      onSaved: (value) {
        weightEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.scale,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Current weight",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );

    //second name field
    final goalWeightField = TextFormField(
      autofocus: false,
      controller: goalWeightEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        RegExp regex = new RegExp(r'[+-]?([0-9]*[.])?[0-9]+');
        if (value!.isEmpty) {
          return ("Goal Weight cannot be empty");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid weight");
        }

        return null;
      },
      onSaved: (value) {
        goalWeightEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.check,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Goal Weight",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );

    String? selectedValue = null;
    //activityLevel field
    final activityLevelField =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Activity Level ",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      SizedBox(
          width: width * 0.5,
          child: DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                                focusedBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
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
                });
              },
              items: activityLevel)),
    ]);

    String? selectedGoal = null;
    //weeklyGoal field
    final weeklyGoalField =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Weekly Goal ",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      SizedBox(
          width: width * 0.51,
          child: DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
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
        onPressed: () {},
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: updateButton),
        body: Stack(
          children: [
            Positioned(
            top: height * 0.02,
            height: height * 0.78,
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
                          const SizedBox(height: 45),
                          weightField,
                          const SizedBox(height: 20),
                          goalWeightField,
                          const SizedBox(height: 20),
                          activityLevelField,
                          const SizedBox(height: 20),
                          weeklyGoalField
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

  postDetailsToFirestore() async {}
}

List<DropdownMenuItem<String>> get activityLevel {
  List<DropdownMenuItem<String>> activityLevelItems = [
    DropdownMenuItem(child: Text("Not Very Active"), value: "Not Very Active"),
    DropdownMenuItem(child: Text("Lightly Active"), value: "Lightly Active"),
    DropdownMenuItem(child: Text("Active"), value: "Active"),
    DropdownMenuItem(child: Text("Very Active"), value: "Very Active"),
  ];
  return activityLevelItems;
}

List<DropdownMenuItem<String>> get weeklyGoal {
  List<DropdownMenuItem<String>> weeklyGoalItems = [
    DropdownMenuItem(
        child: Text("Lose 0,2 kg per week"), value: "Lose 0,2 kg per week"),
    DropdownMenuItem(
        child: Text("Lose 0,5 kg per week"), value: "Lose 0,5 kg per week"),
    DropdownMenuItem(
        child: Text("Lose 0,8 kg per week"), value: "Lose 0,8 kg per week"),
    DropdownMenuItem(
        child: Text("Lose 1 kg per week"), value: "Lose 1 kg per week"),
    DropdownMenuItem(child: Text("Maintain weight"), value: "Maintain weight"),
    DropdownMenuItem(
        child: Text("Gain 0,2 kg per week"), value: "Gain 0,2 kg per week"),
    DropdownMenuItem(
        child: Text("Gain 0,5 kg per week"), value: "Gain 0,5 kg per week"),
  ];
  return weeklyGoalItems;
}
