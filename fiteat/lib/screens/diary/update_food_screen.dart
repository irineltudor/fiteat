import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/diary.dart';
import 'package:fiteat/model/food.dart';
import 'package:fiteat/screens/diary/dairy_screen.dart';
import 'package:fiteat/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vector_math/vector_math_64.dart' as math;

import '../../model/user_model.dart';

class UpdateFoodScreen extends StatefulWidget {
  String foodId;
  double foodQuantity;
  String meal;
  UpdateFoodScreen({Key? key, required this.foodId, required this.foodQuantity,required this.meal})
      : super(key: key);

  @override
  _UpdateFoodScreenState createState() =>
      _UpdateFoodScreenState(foodId: foodId, foodQuantity: foodQuantity,meal : meal);
}

class _UpdateFoodScreenState extends State<UpdateFoodScreen> {
  final Storage storage = Storage();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String foodId;
  String meal;
  Food food = Food();
  Diary diary = Diary();
  double foodQuantity;

  //form key
  final _formKey = GlobalKey<FormState>();
  final servingEditingController = TextEditingController();
  final mealEditingController = TextEditingController();

  _UpdateFoodScreenState(
      {Key? key, required this.foodId, required this.foodQuantity,required this.meal});

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
        .doc(foodId)
        .get()
        .then((value) {
      food = Food.fromMap(value.data());
      setState(() {});
    });


  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    //first name field
    final numberOfServingsField =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          width: width * 0.7,
          child: TextFormField(
            autofocus: false,
            controller: servingEditingController,
            style: const TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))
            ],
            validator: (value) {
              RegExp regex = new RegExp(r'[+-]?([0-9]*[.])?[0-9]+');
              if (value!.isEmpty) {
                return ("Number of servings cannot be empty");
              }

              return null;
            },
            onSaved: (value) {
              servingEditingController.text = value!;
            },
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              prefixIcon: Icon(
                Icons.food_bank,
                color: Colors.black,
              ),
              contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
              hintText: "Number of servings",
              hintStyle: TextStyle(color: Colors.black),
              errorStyle: TextStyle(color: Colors.black),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  borderSide: BorderSide(color: Colors.black)),
            ),
          ))
    ]);

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
                focusedBorder: OutlineInputBorder(
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

    final updateFoodButton = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {
          updateFoodToDiary(
              mealEditingController.text, servingEditingController.text);
        },
        child: const Text(
          "Update Food",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    if (food.name == null ||
        loggedInUser.uid == null ||
        diary.uid != null )
      return Container(
          color: Color(0xFFfc7b78),
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )));
    else {
      double total = food.fat! * 9 + food.carbs! * 4 + food.protein! * 4;
      double progressFats = food.fat! * 9 / total;
      double progressCarbs = food.carbs! * 4 / total;
      double progressProtein = food.protein! * 4 / total;

      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 197, 201, 207),
        appBar: AppBar(
          backgroundColor: const Color(0xFFfc7b78),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  (context),
                  MaterialPageRoute(builder: (context) => const DiaryScreen()),
                  (route) => false);
            },
          ),
          centerTitle: true,
          title: const Text('fiteat', style: TextStyle(color: Colors.white)),
        ),
        bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
            child: updateFoodButton),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              height: height * 0.8,
              left: 0,
              right: 0,
              child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: const Radius.circular(45),
                  ),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                        top: 30, left: 32, right: 32, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ListTile(
                          title: Center(
                            child: Text(food.name!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 26,
                                    color: Colors.black)),
                          ),
                          subtitle: Center(
                            child: Text(food.additional!,
                                style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: Colors.grey)),
                          ),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _RadialProgress(
                              width: width * 0.25,
                              height: width * 0.25,
                              calories: food.calories!.toDouble(),
                              progressCarbs: progressCarbs,
                              progressFats: progressFats,
                              progressProtein: progressProtein,
                            ),
                            SizedBox(width: 40),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _MacrosProgress(
                                  macro: "Protein",
                                  left: food.protein!.toDouble(),
                                  progress: progressProtein,
                                  progressColor:
                                      Color.fromARGB(255, 60, 10, 177),
                                  width: width * 0.3,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                _MacrosProgress(
                                    macro: "Carbs",
                                    left: food.carbs!.toDouble(),
                                    progress: progressCarbs,
                                    progressColor: Colors.green,
                                    width: width * 0.3),
                                SizedBox(
                                  height: 10,
                                ),
                                _MacrosProgress(
                                    macro: "Fat",
                                    left: food.fat!.toDouble(),
                                    progress: progressFats,
                                    progressColor: Colors.yellow,
                                    width: width * 0.3),
                              ],
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                "Serving size : ${food.servingSize}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            Text(
                            "Current serving : $foodQuantity",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            
                          ),
                          Text(
                            "Current meal : $meal",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                            
                          ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              numberOfServingsField,
                              SizedBox(height: 20),
                              mealsField,
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      );
    }
  }

  void updateFoodToDiary(String newMeal, String newServing) async {
    if (_formKey.currentState!.validate()) {
      Diary diary;
      double quantity = double.parse(newServing);
      String id = food.barcode!;
      double calories = food.calories! * quantity;
      double protein = food.protein! * quantity;
      double carbs = food.carbs! * quantity;
      double fat = food.fat! * quantity;
      LinkedHashMap<String, double> element = LinkedHashMap();
      element[id] = quantity;



      await FirebaseFirestore.instance
          .collection('diary')
          .doc(loggedInUser.uid)
          .get()
          .then((value) => {
                diary = Diary.fromMap(value.data()),
                diary.meals![meal]?.remove(id),
                diary.meals![newMeal]?.addAll(element),
                diary.food = diary.food! + calories - food.calories!*foodQuantity,
                diary.protein = diary.protein! + protein - food.protein!*foodQuantity,
                diary.fats = diary.fats! + fat - food.fat!*foodQuantity,
                diary.carbs = diary.carbs! + carbs - food.carbs!*foodQuantity,
                FirebaseFirestore.instance
                    .collection('diary')
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

class _RadialProgress extends StatelessWidget {
  final double height,
      width,
      progressProtein,
      progressFats,
      progressCarbs,
      calories;

  const _RadialProgress(
      {Key? key,
      required this.height,
      required this.width,
      required this.progressProtein,
      required this.progressFats,
      required this.progressCarbs,
      required this.calories})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
          progressProtein: progressProtein,
          progressFats: progressFats,
          progressCarbs: progressCarbs),
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: calories.toInt().toString(),
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black38)),
                TextSpan(text: "\n"),
                TextSpan(
                    text: "kcal",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black38))
              ])),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter {
  final double progressProtein, progressCarbs, progressFats;

  _RadialPainter({
    required this.progressProtein,
    required this.progressCarbs,
    required this.progressFats,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintProtein = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..color = Color.fromARGB(255, 60, 10, 177)
      ..strokeCap = StrokeCap.round;

    Paint paintCarbs = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..color = Colors.green
      ..strokeCap = StrokeCap.square;

    Paint paintFat = Paint()
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..color = Colors.yellow
      ..strokeCap = StrokeCap.square;

    Paint paintBlack = Paint()
      ..strokeWidth = 15
      ..style = PaintingStyle.stroke
      ..color = Colors.black12
      ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width / 2, size.height / 2);

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90), math.radians(-360), false, paintBlack);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(-360 * progressProtein),
        false,
        paintProtein);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-360 * progressProtein - 90),
        math.radians(-360 * progressCarbs),
        false,
        paintCarbs);

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90 - 360 * (progressProtein + progressCarbs)),
        math.radians(-360 * progressFats),
        false,
        paintFat);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _MacrosProgress extends StatelessWidget {
  final String macro;
  final double left;
  final double progress, width;
  final Color progressColor;

  const _MacrosProgress(
      {Key? key,
      required this.macro,
      required this.left,
      required this.progress,
      required this.progressColor,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          macro.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: 10,
                  width: width,
                  decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
                Container(
                  height: 10,
                  width: width * progress,
                  decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
              ],
            ),
            SizedBox(width: 10),
            Text("${left.toStringAsFixed(1)} g")
          ],
        )
      ],
    );
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
