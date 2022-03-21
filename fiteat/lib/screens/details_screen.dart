import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
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
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.name,
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
        prefixIcon: Icon(Icons.scale,color: Colors.white,),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Current weight",
        hintStyle: TextStyle(color:Colors.white),
        errorStyle: TextStyle(color: Colors.white),
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
      style: const TextStyle(color: Colors.white),
      keyboardType: TextInputType.name,
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
        prefixIcon: Icon(Icons.check,color: Colors.white,),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Goal Weight",
        hintStyle: TextStyle(color:Colors.white),
        errorStyle: TextStyle(color: Colors.white),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );


    String? selectedValue = null;
    //activityLevel field
    final activityLevelField =  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      
      children : [
        Text("Activity Level "
        , style: TextStyle(color: Colors.white, fontSize: 16),),
        SizedBox(
          width: width * 0.5,
        child : DropdownButtonFormField(
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
                ),
                validator: (value) => value == null ? "Select activity level" : null,
                dropdownColor: Colors.white,
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: activityLevel)),]);

    //weeklyGoal field
    final weeklyGoalField =  Row(
      mainAxisAlignment: MainAxisAlignment.center,
      
      children : [
        Text("Weekly Goal "
        , style: TextStyle(color: Colors.white, fontSize: 16),),
        SizedBox(
          width: width * 0.51,
        child : DropdownButtonFormField(
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
                ),
                validator: (value) => value == null ? "Select activity level" : null,
                dropdownColor: Colors.white,
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: weeklyGoal)),]);

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
           Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
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
                    goalWeightField,
                    const SizedBox(height: 20),
                    activityLevelField,
                    const SizedBox(height: 20),
                    weeklyGoalField,
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

  postDetailsToFirestore() async {
  }
}


List<DropdownMenuItem<String>> get activityLevel{
  List<DropdownMenuItem<String>> activityLevelItems = [
    DropdownMenuItem(child: Text("Not Very Active"),value: "Not Very Active"),
    DropdownMenuItem(child: Text("Lightly Active"),value: "Lightly Active"),
    DropdownMenuItem(child: Text("Active"),value: "Active"),
    DropdownMenuItem(child: Text("Very Active"),value: "Very Active"),
  ];
  return activityLevelItems;
}

List<DropdownMenuItem<String>> get weeklyGoal{
  List<DropdownMenuItem<String>> weeklyGoalItems = [
    DropdownMenuItem(child: Text("Lose 0,2 kg per week"),value: "Lose 0,2 kg per week"),
    DropdownMenuItem(child: Text("Lose 0,5 kg per week"),value: "Lose 0,5 kg per week"),
    DropdownMenuItem(child: Text("Lose 0,8 kg per week"),value: "Lose 0,8 kg per week"),
    DropdownMenuItem(child: Text("Lose 1 kg per week"),value: "Lose 1 kg per week"),
    DropdownMenuItem(child: Text("Maintain weight"),value: "Maintain weight"),
    DropdownMenuItem(child: Text("Gain 0,2 kg per week"),value: "Gain 0,2 kg per week"),
    DropdownMenuItem(child: Text("Gain 0,5 kg per week"),value: "Gain 0,5 kg per week"),
  ];
  return weeklyGoalItems;
}