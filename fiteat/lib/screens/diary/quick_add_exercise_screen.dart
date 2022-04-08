import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class QuickAddExerciseScreen extends StatefulWidget {
  const QuickAddExerciseScreen({Key? key}) : super(key: key);

  @override
  _QuickAddExerciseScreenState createState() => _QuickAddExerciseScreenState();
}

class _QuickAddExerciseScreenState extends State<QuickAddExerciseScreen> {
  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  final caloriesEditingController = TextEditingController();

  // string for displaying the error
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    //first name field
    final caloriesField = TextFormField(
      autofocus: false,
      controller: caloriesEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
      validator: (value) {
        RegExp regex = new RegExp(r'[+-]?([0-9]*[.])?[0-9]+');
        if (value!.isEmpty) {
          return ("Calories cannot be empty");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter valid calories");
        }

        return null;
      },
      onSaved: (value) {
        caloriesEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(
          Icons.sports,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Calories burned",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );

   final updateButton = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {},
        child: const Text(
          "Add Quick Calories",
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
        title: const Text('Quick Add', style: TextStyle(color: Colors.white)),
      ),
              bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: updateButton),
        body: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(45)),
            child: Container(
              height: height*0.2,
              width: width*0.9,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      caloriesField,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  postDetailsToFirestore() async {}
}



