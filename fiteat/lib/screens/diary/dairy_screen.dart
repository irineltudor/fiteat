// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/diary.dart';
import 'package:fiteat/model/exercise.dart';
import 'package:fiteat/model/food.dart';
import 'package:fiteat/screens/diary/add_exercises_screen.dart';
import 'package:fiteat/screens/diary/add_food_screen.dart';
import 'package:fiteat/screens/diary/diary_done.dart';
import 'package:fiteat/screens/diary/update_exercise_screen.dart';
import 'package:fiteat/screens/diary/update_food_screen.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/screens/more/more_screen.dart';
import 'package:fiteat/screens/statistics/statistics_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../model/user_model.dart';
import '../../service/storage_service.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({Key? key}) : super(key: key);

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final Storage storage = Storage();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  Diary diary = Diary();
  List<Meal> breakfastFood = [];
  List<Meal> lunchFood = [];
  List<Meal> dinnerFood = [];
  List<ExerciseData> exerciseDiary = [];

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
        .collection("diary")
        .doc(user!.uid)
        .get()
        .then((value) {
      diary = Diary.fromMap(value.data());
      final breakfast = diary.meals!['breakfast'];
      final lunch = diary.meals!['lunch'];
      final dinner = diary.meals!['dinner'];
      final exercise = diary.exercises!;

      breakfast?.forEach((string, value) => {
            FirebaseFirestore.instance
                .collection('food')
                .doc(string.toString())
                .get()
                .then((foodData) {
              Food food = Food.fromMap(foodData.data());

              breakfastFood.add(Meal(
                  food: food, foodQuantity: double.parse(value.toString())));
              setState(() {});
            }),
          });

      lunch?.forEach((string, value) => {
            FirebaseFirestore.instance
                .collection('food')
                .doc(string.toString())
                .get()
                .then((foodData) {
              Food food = Food.fromMap(foodData.data());

              lunchFood.add(Meal(
                  food: food, foodQuantity: double.parse(value.toString())));
              setState(() {});
            }),
          });

      dinner?.forEach((string, value) => {
            FirebaseFirestore.instance
                .collection('food')
                .doc(string.toString())
                .get()
                .then((foodData) {
              Food food = Food.fromMap(foodData.data());

              dinnerFood.add(Meal(
                  food: food, foodQuantity: double.parse(value.toString())));
              setState(() {});
            }),
          });

      exercise.forEach((string, value) => {
            FirebaseFirestore.instance
                .collection('exercises')
                .doc(string.toString())
                .get()
                .then((exerciseData) {
              Exercise exercise = Exercise.fromMap(exerciseData.data());

              exerciseDiary.add(ExerciseData(
                  exercise: exercise,
                  exerciseTime: double.parse(value.toString())));
              setState(() {});
            }),
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final addFoodButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(20),
      color: Colors.white,
      child: MaterialButton(
        splashColor: Colors.green,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          //In order to use go back
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddFoodScreen()));
        },
        child: const Text(
          "Add Food",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    final addExerciseButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(45),
      color: Colors.white,
      child: MaterialButton(
        splashColor: Colors.blue,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          //In order to use go back
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddExercisesScreen()));
        },
        child: const Text(
          "Add Exercise",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );


      final finishButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(45),
      color: Colors.green,
      child: MaterialButton(
        splashColor: Colors.blue,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          //In order to use go back
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DiaryDoneScreen(diary: diary)));
        },
        child: const Text(
          "Finish",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    if (diary.food == null || loggedInUser.activitylevel == null)
      return Container(
          color: Color(0xFFfc7b78),
          child: Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )));
    else {
      int goalCalories = loggedInUser.goalcalories! + diary.exercise!.toInt();
      int caloriesLeft = goalCalories - diary.food!.toInt();
      caloriesLeft = caloriesLeft < 0 ? 0 : caloriesLeft;
      int protein = ((goalCalories * 0.25) / 4).toInt();
      int carbs = ((goalCalories * 0.45) / 4).toInt();
      int fats = ((goalCalories * 0.3) / 9).toInt();

      int caloriesCurrent = diary.food!.toInt();
      int proteinCurrent = diary.protein!.toInt();
      int carbsCurrent = diary.carbs!.toInt();
      int fatsCurrent = diary.fats!.toInt();

      int proteinLeft = protein - diary.protein!.toInt();
      int carbsLeft = carbs - diary.carbs!.toInt();
      int fatsLeft = fats - diary.fats!.toInt();

      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 197, 201, 207),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: BottomNavigationBar(
              iconSize: 28,
              backgroundColor: Colors.black.withOpacity(0.1),
              currentIndex: 1,
              selectedIconTheme: const IconThemeData(
                color: Color(0xFFfc7b78),
              ),
              unselectedIconTheme: const IconThemeData(
                  color: Color.fromARGB(255, 197, 201, 207)),
              selectedItemColor: const Color(0xFFfc7b78),
              onTap: (value) {
                if (value == 0)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                if (value == 2)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const StatisticsScreen()));
                if (value == 3)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const MoreScreen()));
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.book,
                  ),
                  label: "Dairy",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.stacked_bar_chart,
                  ),
                  label: "Stats",
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.more,
                  ),
                  label: "More",
                ),
              ]),
        ),
        body: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              height: height * 0.2,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${loggedInUser.goalcalories}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Goal",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black45),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "-",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${diary.food!.toInt()}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Food",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black45),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "+",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${diary.exercise!.toInt()}",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  "Exercises",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black45),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            const Text(
                              "=",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "$caloriesLeft",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFFfc7b78)),
                                ),
                                Text(
                                  "Left",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black45),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        _CaloriesProgress(
                            progress: diary.food! / goalCalories,
                            progressColor: Color(0xFFfc7b78),
                            width: width * 0.8)
                      ],
                    ),
                  )),
            ),
            Positioned(
                top: height * 0.205,
                height: height * 0.55,
                left: 0,
                right: 0,
                child: ClipRRect(
                  child: CustomScrollView(
                    slivers: <Widget>[
                      const SliverAppBar(
                        expandedHeight: 5,
                        elevation: 5,
                        pinned: true,
                        backgroundColor: Colors.white,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(-30),
                          child: Text(''),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text(
                            'Breakfast',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                      SliverFixedExtentList(
                        itemExtent: 50.0,
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          if (breakfastFood.length != 0) {
                            final item = breakfastFood[index];
                            if(item.food.barcode != "0")
                            {
                            return Dismissible(
                              onDismissed: (direction) {
                                // Remove the item from the data source.

                                if (direction == DismissDirection.endToStart) {
                                  setState(() {
                                    removeFood(
                                        'breakfast', breakfastFood[index]);
                                    breakfastFood.removeAt(index);
                                  });
                                  // Then show a snackbar.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${item.food.name} deleted')));
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                      (context),
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateFoodScreen(
                                                  foodId: item.food.barcode!,
                                                  foodQuantity:
                                                      item.foodQuantity,
                                                  meal: 'breakfast')),
                                      (route) => false);
                                }
                              },
                              background: slideRightBackground(),
                              secondaryBackground: slideLeftBackground(),
                              key: Key(item.food.barcode.toString()),
                              child: Container(
                                color: Colors.white,
                                        Text(item.food.name!),
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment : Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.food.name!),
                                            Text(
                                              '${item.food.additional}, ${item.food.servingSize}',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment : Alignment.centerRight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text((item.food.calories! *
                                                    item.foodQuantity)
                                                .toInt()
                                                .toString()),
                                            Text(
                                              '${(item.foodQuantity).toStringAsFixed(1)}x',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                            }
                            else
                            {
                              return Dismissible(
                              onDismissed: (direction) {
                                
                                  // Remove the item from the data source.
                                  setState(() {
                                    removeFood('breakfast', breakfastFood[index]);
                                    breakfastFood.removeAt(index);
                                  });
                                  // Then show a snackbar.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${item.food.name} deleted')));
                                                   
                                
                              },
                              background: slideLeftBackground(),
                              key: Key(item.food.barcode.toString()),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment : Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.food.name!),
                                            Text(
                                              '${item.food.servingSize}',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment : Alignment.centerRight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text((item.food.calories! *
                                                    item.foodQuantity)
                                                .toInt()
                                                .toString()),
                                            Text(
                                              '${(item.foodQuantity).toStringAsFixed(0)} ',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                            }
                          }
                        }, childCount: breakfastFood.length),
                      ),
                      const SliverPadding(
                        padding: EdgeInsets.only(top: 25),
                        sliver: SliverAppBar(
                          elevation: 5,
                          pinned: true,
                          backgroundColor: Colors.white,
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(-30),
                            child: Text(''),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              'Lunch',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SliverFixedExtentList(
                        itemExtent: 50.0,
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          if (lunchFood.length != 0) {
                            final item = lunchFood[index];
                            if(item.food.barcode != "0")
                            {
                            return Dismissible(
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  // Remove the item from the data source.
                                  setState(() {
                                    removeFood('lunch', lunchFood[index]);
                                    lunchFood.removeAt(index);
                                  });
                                  // Then show a snackbar.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${item.food.name} deleted')));
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                      (context),
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateFoodScreen(
                                                  foodId: item.food.barcode!,
                                                  foodQuantity:
                                                      item.foodQuantity,
                                                  meal: 'lunch')),
                                      (route) => false);
                                }
                              },
                              background: slideRightBackground(),
                              secondaryBackground: slideLeftBackground(),
                              key: Key(item.food.barcode.toString()),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment : Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.food.name!),
                                            Text(
                                              '${item.food.additional}, ${item.food.servingSize}',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment : Alignment.centerRight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text((item.food.calories! *
                                                    item.foodQuantity)
                                                .toInt()
                                                .toString()),
                                            Text(
                                              '${(item.foodQuantity).toStringAsFixed(1)}x',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                            }
                            else
                            {
                              return Dismissible(
                              onDismissed: (direction) {
                                
                                  // Remove the item from the data source.
                                  setState(() {
                                    removeFood('lunch', lunchFood[index]);
                                    lunchFood.removeAt(index);
                                  });
                                  // Then show a snackbar.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${item.food.name} deleted')));
                                                   
                                
                              },
                              background: slideLeftBackground(),
                              key: Key(item.food.barcode.toString()),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment : Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.food.name!),
                                            Text(
                                              '${item.food.servingSize}',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment : Alignment.centerRight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text((item.food.calories! *
                                                    item.foodQuantity)
                                                .toInt()
                                                .toString()),
                                            Text(
                                              '${(item.foodQuantity).toStringAsFixed(0)} ',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                            }
                          }
                        }, childCount: lunchFood.length),
                      ),
                      const SliverPadding(
                        padding: EdgeInsets.only(top: 25),
                        sliver: SliverAppBar(
                          elevation: 5,
                          pinned: true,
                          backgroundColor: Colors.white,
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(-30),
                            child: Text(''),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              'Dinner',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SliverFixedExtentList(
                        itemExtent: 50.0,
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          if (dinnerFood.isNotEmpty) {
                            final item = dinnerFood[index];
                            if(item.food.barcode != "0")
                            {
                            return Dismissible(
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  // Remove the item from the data source.
                                  setState(() {
                                    removeFood('dinner', dinnerFood[index]);
                                    dinnerFood.removeAt(index);
                                  });
                                  // Then show a snackbar.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${item.food.name} deleted')));
                                } else {
                                  Navigator.pushAndRemoveUntil(
                                      (context),
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateFoodScreen(
                                                  foodId: item.food.barcode!,
                                                  foodQuantity:
                                                      item.foodQuantity,
                                                  meal: 'dinner')),
                                      (route) => false);                         
                                }
                              },
                              background: slideRightBackground(),
                              secondaryBackground: slideLeftBackground(),
                              key: Key(item.food.barcode.toString()),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment : Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.food.name!),
                                            Text(
                                              '${item.food.additional}, ${item.food.servingSize}',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment : Alignment.centerRight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text((item.food.calories! *
                                                    item.foodQuantity)
                                                .toInt()
                                                .toString()),
                                            Text(
                                              '${(item.foodQuantity).toStringAsFixed(1)}x',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                            }
                            else
                            {
                              return Dismissible(
                              onDismissed: (direction) {
                                
                                  // Remove the item from the data source.
                                  setState(() {
                                    removeFood('dinner', dinnerFood[index]);
                                    dinnerFood.removeAt(index);
                                  });
                                  // Then show a snackbar.
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              '${item.food.name} deleted')));
                                                   
                                
                              },
                              background: slideLeftBackground(),
                              key: Key(item.food.barcode.toString()),
                              child: Container(
                                color: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Align(
                                        alignment : Alignment.centerLeft,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(item.food.name!),
                                            Text(
                                              '${item.food.servingSize}',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment : Alignment.centerRight,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text((item.food.calories! *
                                                    item.foodQuantity)
                                                .toInt()
                                                .toString()),
                                            Text(
                                              '${(item.foodQuantity).toStringAsFixed(0)} ',
                                              style:
                                                  TextStyle(color: Colors.black45),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                            }
                          }
                        }, childCount: dinnerFood.length),
                      ),
                      const SliverPadding(
                        padding: EdgeInsets.only(top: 25),
                        sliver: SliverAppBar(
                          elevation: 5,
                          pinned: true,
                          backgroundColor: Colors.white,
                          bottom: PreferredSize(
                            preferredSize: Size.fromHeight(-30),
                            child: Text(''),
                          ),
                          flexibleSpace: FlexibleSpaceBar(
                            title: Text(
                              'Excercises',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      SliverFixedExtentList(
                        itemExtent: 50.0,
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                          if (exerciseDiary.length != 0) {
                            final item = exerciseDiary[index];
                            if(item.exercise.id != "0")
                            {
                            return Dismissible(
                              onDismissed: (direction) {

                                if(direction == DismissDirection.endToStart)
                                {
                                // Remove the item from the data source.
                                setState(() {
                                  removeExercise(exerciseDiary[index]);
                                  exerciseDiary.removeAt(index);
                                });
                                // Then show a snackbar.
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${item.exercise.name} deleted')));
                                }
                                else
                                {
                                                                      Navigator.pushAndRemoveUntil(
                                      (context),
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              UpdateExerciseScreen(
                                                  exerciseId : item.exercise.id!,
                                                  time :
                                                      item.exerciseTime,)),
                                      (route) => false);
                                }
                              },
                              background: slideRightBackground(),
                              secondaryBackground: slideLeftBackground(),
                              key: Key(item.exercise.id!),
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.exercise.name!),
                                        Text(
                                          '${item.exerciseTime ~/ 60}:${(item.exerciseTime % 60).toInt()}',
                                          style:
                                              TextStyle(color: Colors.black45),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: width * 0.5,
                                    ),
                                    Text((item.exerciseTime *
                                            (item.exercise.caloriesPerMinute! /
                                                60))
                                        .toInt()
                                        .toString())
                                  ],
                                ),
                              ),
                            );
                            }
                            else
                            {
                                                          return Dismissible(
                              onDismissed: (direction) {
                                // Remove the item from the data source.
                                setState(() {
                                  removeExercise(exerciseDiary[index]);
                                  exerciseDiary.removeAt(index);
                                });
                                // Then show a snackbar.
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            '${item.exercise.name} deleted')));

                              },
                              background: slideLeftBackground(),
                              key: Key(item.exercise.id!),
                              child: Container(
                                color: Colors.white,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(item.exercise.name!),
                                      ],
                                    ),
                                    SizedBox(
                                      width: width * 0.5,
                                    ),
                                    Text((item.exerciseTime *
                                            (item.exercise.caloriesPerMinute! /
                                                60))
                                        .toInt()
                                        .toString())
                                  ],
                                ),
                              ),
                            );
                            }
                          }
                        }, childCount: exerciseDiary.length),
                      ),
                    ],
                  ),
                )),
            Positioned(
                top: height * 0.766,
                left: 0,
                right: 0,
                height: height * 0.07,
                child: Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$proteinCurrent/$protein",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Protein",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "|",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$carbsCurrent/$carbs",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Carbo",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "|",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            " $fatsCurrent/$fats",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            "Fat",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      const Text(
                        "|",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$caloriesCurrent/$goalCalories",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFFfc7b78)),
                          ),
                          Text(
                            "Calories",
                            style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.black45),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
            Positioned(
              top: height * 0.830,
              left: 0,
              right: 0,
              height: height * 0.1,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    addFoodButton,
                    SizedBox(
                      width: 10,
                    ),
                    addExerciseButton,
                    SizedBox(
                      width: 10,
                    ),
                    finishButton,
                  ]),
            )
          ],
        ),
      );
    }
  }

  void removeFood(String s, Meal dinnerFood) async {
    ///Remember TO implement calories deletion
    double quantity = diary.meals![s]?[dinnerFood.food.barcode].toDouble();

    diary.meals![s]?.remove(dinnerFood.food.barcode);

    double calories = diary.food! - dinnerFood.food.calories! * quantity;
    double protein = diary.protein! - dinnerFood.food.protein! * quantity;
    double carbs = diary.carbs! - dinnerFood.food.carbs! * quantity;
    double fat = diary.fats! - dinnerFood.food.fat! * quantity;

    diary.food = calories < 0 ? 0 : calories;
    diary.protein = protein < 0 ? 0 : protein;
    diary.fats = fat < 0 ? 0 : fat;
    diary.carbs = carbs < 0 ? 0 : carbs;

    await FirebaseFirestore.instance
        .collection('diary')
        .doc(loggedInUser.uid)
        .set(diary.toMap());
  }

  void removeExercise(ExerciseData exerciseDiary) async {
    double time = diary.exercises?[exerciseDiary.exercise.id];
    diary.exercises?.remove(exerciseDiary.exercise.id);

    double exercise = diary.exercise! -
        (time / 60) * exerciseDiary.exercise.caloriesPerMinute!;

    diary.exercise = exercise < 0 ? 0 : exercise;

    await FirebaseFirestore.instance
        .collection('diary')
        .doc(loggedInUser.uid)
        .set(diary.toMap());
  }
}

class _CaloriesProgress extends StatelessWidget {
  final double progress, width;
  final Color progressColor;

  const _CaloriesProgress(
      {Key? key,
      required this.progress,
      required this.progressColor,
      required this.width})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double currentProgress = progress <= 1.0 ? progress : 1.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
                  width: width * currentProgress,
                  decoration: BoxDecoration(
                      color: progressColor,
                      borderRadius: BorderRadius.all(Radius.circular(8))),
                ),
              ],
            ),
            SizedBox(width: 10),
          ],
        )
      ],
    );
  }
}

class Meal {
  Food food;
  double foodQuantity;
  Meal({required this.food, required this.foodQuantity});
}

class ExerciseData {
  Exercise exercise;
  double exerciseTime;
  ExerciseData({required this.exercise, required this.exerciseTime});
}

Widget slideRightBackground() {
  return Container(
    color: Colors.blue,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            " Edit",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            " Delete",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.right,
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
