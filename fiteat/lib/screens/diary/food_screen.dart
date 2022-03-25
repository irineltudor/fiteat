import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math_64.dart' as math;

import '../../model/user_model.dart';

class FoodScreen extends StatefulWidget {
  String foodId;
  FoodScreen({Key? key, required this.foodId}) : super(key: key);

  @override
  _FoodScreenState createState() => _FoodScreenState(foodId: foodId);
}

class _FoodScreenState extends State<FoodScreen> {
  final Storage storage = Storage();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  String foodId;
  final weightEditingController = TextEditingController();

  _FoodScreenState({Key? key, required this.foodId});

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
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    //first name field
    final numberOfServingsField =
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      SizedBox(
          width: width * 0.7,
          child: TextFormField(
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
                });
              },
              items: meals)),
    ]);

    final addFoodButton = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {},
        child: const Text(
          "Add Food to Diary",
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
        title: const Text('fiteat', style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: addFoodButton),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Center(
                          child: Text("Food name",
                              style: TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 26,
                                  color: Colors.black)),
                        ),
                        subtitle: Center(
                          child: Text("Food Company",
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
                            progress: 1,
                          ),
                          SizedBox(width: 40),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _MacrosProgress(
                                macro: "Protein",
                                left: 5,
                                progress: 0.6,
                                progressColor: Color.fromARGB(255, 60, 10, 177),
                                width: width * 0.3,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              _MacrosProgress(
                                  macro: "Carbs",
                                  left: 10,
                                  progress: 0.3,
                                  progressColor: Colors.green,
                                  width: width * 0.3),
                              SizedBox(
                                height: 10,
                              ),
                              _MacrosProgress(
                                  macro: "Fat",
                                  left: 3,
                                  progress: 0.8,
                                  progressColor: Colors.yellow,
                                  width: width * 0.3),
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          "Serving size : 100 gram",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      numberOfServingsField,
                      SizedBox(height: 20),
                      mealsField,
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class _RadialProgress extends StatelessWidget {
  final double height, width, progress;

  const _RadialProgress(
      {Key? key,
      required this.height,
      required this.width,
      required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(
          progressProtein: 0.25, progressFats: 0.18, progressCarbs: 0.55),
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(children: [
                TextSpan(
                    text: "250",
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
      ..strokeCap = StrokeCap.square;

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
        math.radians(-90 - 360 * progressProtein),
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
  final int left;
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
            Text("${left}g")
          ],
        )
      ],
    );
  }
}

List<DropdownMenuItem<String>> get meals {
  List<DropdownMenuItem<String>> mealsList = [
    DropdownMenuItem(child: Text("Breakfast"), value: "Breakfast"),
    DropdownMenuItem(child: Text("Lunch"), value: "Lunch"),
    DropdownMenuItem(child: Text("Dinner"), value: "Dinner"),
  ];
  return mealsList;
}
