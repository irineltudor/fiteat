import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/diary/dairy_screen.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fiteat/model/diary.dart';
import 'package:fiteat/model/food.dart';

class QuickAddScreen extends StatefulWidget {
  const QuickAddScreen({Key? key}) : super(key: key);

  @override
  _QuickAddScreenState createState() => _QuickAddScreenState();
}

class _QuickAddScreenState extends State<QuickAddScreen> {
  final _auth = FirebaseAuth.instance;
  Food food = Food();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  final _formKey = GlobalKey<FormState>();

  final caloriesEditingController = TextEditingController();
  final mealEditingController = TextEditingController();

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
        .doc("0")
        .get()
        .then((value) {
      food = Food.fromMap(value.data());
      setState(() {});
    });
  }

  // string for displaying the error
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    //first name field
    final weightField = TextFormField(
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
          Icons.fastfood,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Calories",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.white)),
      ),
    );


    String? selectedMeal = null;

    final mealsField =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        "Meal",
        style: TextStyle(color: Colors.black, fontSize: 16),
      ),
      SizedBox(
        width: 10,
      ),
      SizedBox(
          width: width * 0.5,
          child: DropdownButtonFormField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder:OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(20),
                ), 
                filled: true,
                fillColor: Colors.white,
              ),
              validator: (value) => value == null ? "Select Meal" : null,
              dropdownColor: Colors.white,
              value: selectedMeal,
              onChanged: (String? newValue) {
                setState(() {
                  selectedMeal = newValue!;
                  mealEditingController.text = newValue;
                });
              },
              items: meals)),
    ]);

   final updateButton = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {
          addFoodToDiary(mealEditingController.text,caloriesEditingController.text);
        },
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
              height: height*0.4,
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
                      weightField,
                      SizedBox(height: 10,),
                      mealsField
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }

    void addFoodToDiary(String meal, String serving)  async{
     if(_formKey.currentState!.validate())
     {
       Diary diary;
       double quantity = double.parse(serving);
       String id = food.barcode!;
       double calories = food.calories! * quantity;
       double protein  = food.protein! * quantity;
       double carbs = food.carbs! * quantity;
       double fat = food.fat! * quantity;
       LinkedHashMap<String, double> element =  LinkedHashMap();
       element[id] = quantity;

       await FirebaseFirestore.instance
              .collection('diary')
              .doc(loggedInUser.uid)
              .get()
              .then((value)=>{
                  diary = Diary.fromMap(value.data()),
                  if(diary.meals![meal]?.containsKey(id) == true ){
                      diary.meals![meal]?.update(id, (value) => value + quantity)
                  } 
                  else
                  diary.meals![meal]?.addAll(element),
                  diary.food = diary.food! + calories,
                  diary.protein = diary.protein! + protein,
                  diary.fats = diary.fats! + fat,
                  diary.carbs = diary.carbs! + carbs,
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



List<DropdownMenuItem<String>> get meals {
  List<DropdownMenuItem<String>> mealsList = [
    DropdownMenuItem(child: Text("Breakfast"), value: "breakfast"),
    DropdownMenuItem(child: Text("Lunch"), value: "lunch"),
    DropdownMenuItem(child: Text("Dinner"), value: "dinner"),
  ];
  return mealsList;
}