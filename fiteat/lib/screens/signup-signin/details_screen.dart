import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/service/storage_service.dart';
import 'package:fiteat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  final _formKey = GlobalKey<FormState>();

  final weightEditingController = TextEditingController();
  final heightEditingController = TextEditingController();
  final genderEditingController = TextEditingController();
  final activityLevelEditingController = TextEditingController();
  final weeklyGoalEditingController = TextEditingController();
  final birthEditingController = TextEditingController();

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
      setState(() {
        print(loggedInUser.height);
        if (loggedInUser.height != 0.0) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        }
      });
    });
  }

  // string for displaying the error
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    
    final weightField = TextFormField(
      autofocus: false,
      controller: weightEditingController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value!.isEmpty) {
          return ("Current weight cannot be empty");
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
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Current weight in kg",
        hintStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );


    final heightField = TextFormField(
      autofocus: false,
      controller: heightEditingController,
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (value) {
        if (value!.isEmpty) {
          return ("Height cannot be empty");
        }
        return null;
      },
      onSaved: (value) {
        heightEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.height,
          color: Colors.white,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Current height in cm",
        hintStyle: TextStyle(color: Colors.white),
        errorStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );

    String? selectedValue = null;
    //activityLevel field
    final activityLevelField =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Activity Level ",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      SizedBox(
          width: width * 0.5,
          child: DropdownButtonFormField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              filled: true,
              fillColor: Colors.white,
              errorStyle: TextStyle(color: Colors.white),
            ),
            validator: (value) {
              if (value == null) {
                return ("Select Activity Level");
              }
              return null;
            },
            dropdownColor: Colors.white,
            value: selectedValue,
            onChanged: (String? newValue) {
              activityLevelEditingController.text = newValue!.toString();
              setState(() {
                selectedValue = newValue;
              });
            },
            items: activityLevel,
          )),
    ]);

    String? selectedGoal = null;
    //weeklyGoal field
    final weeklyGoalField =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Weekly Goal ",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      SizedBox(
          width: width * 0.51,
          child: DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
                errorStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null) {
                  return ("Select Weekly Goal");
                }
                return null;
              },
              dropdownColor: Colors.white,
              value: selectedGoal,
              onChanged: (String? newValue) {
                weeklyGoalEditingController.text = newValue!.toString();
                setState(() {
                  selectedGoal = newValue;
                });
              },
              items: weeklyGoal)),
    ]);

    String? selectedGender = null;
    //weeklyGoal field
    final genderField =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Select Gender",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      SizedBox(
          width: width * 0.51,
          child: DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
                errorStyle: TextStyle(color: Colors.white),
              ),
              validator: (value) {
                if (value == null) {
                  return ("Select Gender");
                }
                return null;
              },
              dropdownColor: Colors.white,
              value: selectedGender,
              onChanged: (String? newValue) {
                genderEditingController.text = newValue!.toString();
                setState(() {
                  selectedGender = newValue;
                });
              },
              items: gender)),
    ]);

    final datePicker = DatePickerWidget(
        color: Colors.white,
        userDate: 'Pick Date',
        buttonColor: const Color(0xFFfc7b78),
        dob : birthEditingController);

//sign up button
    final letsGoButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.black54,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: const BorderSide(color: Colors.white)),
        minWidth: MediaQuery.of(context).size.width / 1.5,
        onPressed: () {
          print("HERE : ${loggedInUser.email}");
          // Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => const HomeScreen()));
          updateDetails(weightEditingController.text, heightEditingController.text,genderEditingController.text,activityLevelEditingController.text,weeklyGoalEditingController.text,birthEditingController.text);
        },
        child: const Text(
          "Let's Go",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );


    if(loggedInUser.uid == null)
      return Container(
        color: Color(0xFFfc7b78),
        child: Center(child: CircularProgressIndicator(color: Colors.white,)));
    else
    return Scaffold(
        backgroundColor: const Color(0xFFfc7b78),
        body: Center(
            child: SingleChildScrollView(
          child: Container(
            color: const Color(0xFFfc7b78),
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
                    heightField,
                    const SizedBox(height: 20),
                    genderField,
                    const SizedBox(height: 20),
                    activityLevelField,
                    const SizedBox(height: 20),
                    weeklyGoalField,
                    const SizedBox(height: 20),
                    datePicker,
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Activity level info",
                          style: TextStyle(color: Colors.white),
                        ),
                        MaterialButton(
                          child: Icon(Icons.info, color: Colors.white),
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
                    const SizedBox(height: 25),
                    letsGoButton,
                    const SizedBox(height: 15)
                  ],
                ),
              ),
            ),
          ),
        )));
  }

  void updateDetails(String weight, String height, String gender,
      String activitylevel, String goal, String dob) {
    if (_formKey.currentState!.validate()) {

     DateTime today = DateTime.now();
     DateTime date = new DateFormat('dd-MM-yyyy').parse(dob);

     int age = (today.difference(date).inDays / 365).floor() ;


      loggedInUser.dob = dob;
      loggedInUser.gender = gender;
      loggedInUser.weight = double.parse(weight);
      loggedInUser.height = double.parse(height);
      loggedInUser.activitylevel = int.parse(activitylevel);
      loggedInUser.goal = double.parse(goal);

      double BMR = 0;
      if (gender == "Man") {
        BMR = 66.47 +
            (13.75 * double.parse(weight)) +
            (5.003 * double.parse(height)) - (6.755 * age);
      } else {
        BMR = 655.1 +
            (9.563 * double.parse(weight)) +
            (1.850 * double.parse(height)) - (4.676 * age);
      }
      double AMS = 0;
      switch (int.parse(activitylevel)) {
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

      AMS = AMS - 1000 * double.parse(goal);

      int goalCalories = AMS.round();

      loggedInUser.goalcalories = goalCalories;

      firebaseFirestore.collection("users").doc(loggedInUser.uid).update(loggedInUser.toMap());

      Navigator.pushAndRemoveUntil(
          (context),
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false);
    }
  }
}

List<DropdownMenuItem<String>> get activityLevel {
  List<DropdownMenuItem<String>> activityLevelItems = [
    DropdownMenuItem(child: Text("Not Very Active"), value: "0"),
    DropdownMenuItem(child: Text("Lightly Active"), value: "1"),
    DropdownMenuItem(child: Text("Active"), value: "2"),
    DropdownMenuItem(child: Text("Very Active"), value: "3"),
  ];
  return activityLevelItems;
}

List<DropdownMenuItem<String>> get gender {
  List<DropdownMenuItem<String>> genderItems = [
    DropdownMenuItem(child: Text("Man"), value: "Man"),
    DropdownMenuItem(child: Text("Woman"), value: "Woman"),
  ];
  return genderItems;
}

List<DropdownMenuItem<String>> get weeklyGoal {
  List<DropdownMenuItem<String>> weeklyGoalItems = [
    DropdownMenuItem(child: Text("Lose 0,2 kg per week"), value: "-0.2"),
    DropdownMenuItem(child: Text("Lose 0,5 kg per week"), value: "-0.5"),
    DropdownMenuItem(child: Text("Lose 0,8 kg per week"), value: "-0.8"),
    DropdownMenuItem(child: Text("Lose 1 kg per week"), value: "-1"),
    DropdownMenuItem(child: Text("Maintain weight"), value: "0"),
    DropdownMenuItem(child: Text("Gain 0,2 kg per week"), value: "0.2"),
    DropdownMenuItem(child: Text("Gain 0,5 kg per week"), value: "0.5"),
  ];
  return weeklyGoalItems;
}

Widget _infoPopUpDialog(BuildContext context) {
  return new AlertDialog(
    title: const Text("Activity Level :"),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
}
