// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/screens/diary/add_exercises_screen.dart';
import 'package:fiteat/screens/diary/add_food_screen.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/screens/more/more_screen.dart';
import 'package:fiteat/screens/statistics/statistics_screen.dart';
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
    int goal = 2500;
    int eaten = 1000;
    int exercises = 500;
    int caloriesLeft = goal - eaten + exercises;

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
          Navigator.push(context, MaterialPageRoute
          (builder: (context) =>const AddFoodScreen())); 
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
          Navigator.push(context, MaterialPageRoute
          (builder: (context) =>const AddExercisesScreen())); 
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
            unselectedIconTheme:
                const IconThemeData(color: Color.fromARGB(255, 197, 201, 207)),
            selectedItemColor: const Color(0xFFfc7b78),
            onTap: (value) {
              if (value == 0)
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const HomeScreen()));
              if (value == 2) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const StatisticsScreen()));
              if (value == 3) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const MoreScreen()));
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
                                "$goal",
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
                                "$eaten",
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
                                "$exercises",
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
                          progress: 0.8,
                          progressColor: Color(0xFFfc7b78),
                          width: width * 0.8)
                    ],
                  ),
                )),
          ),
          Positioned(
              top: height * 0.23,
              height: height * 0.6,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(45)),
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
                        return Container(
                          color:Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Food $index'),
                                  Text(
                                    'Company, 100g',
                                    style: TextStyle(color: Colors.black45),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: width * 0.5,
                              ),
                              Text("250")
                            ],
                          ),
                        );
                      }, childCount: 3),
                    ),

                    const SliverPadding(
                      padding: EdgeInsets.only(top: 25),
                      sliver : SliverAppBar(
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
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 50.0,
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Container(
                          color:Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Food $index'),
                                  Text(
                                    'Company, 100g',
                                    style: TextStyle(color: Colors.black45),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: width * 0.5,
                              ),
                              Text("250")
                            ],
                          ),
                        );
                      }, childCount: 3),
                    ),
                     const SliverPadding(
                      padding: EdgeInsets.only(top: 25),
                      sliver : SliverAppBar(
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
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 50.0,
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Container(
                          color:Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Food $index'),
                                  Text(
                                    'Company, 100g',
                                    style: TextStyle(color: Colors.black45),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: width * 0.5,
                              ),
                              Text("250")
                            ],
                          ),
                        );
                      }, childCount: 3),
                    ),
                     const SliverPadding(
                      padding: EdgeInsets.only(top: 25),
                      sliver : SliverAppBar(
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
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    SliverFixedExtentList(
                      itemExtent: 50.0,
                      delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                        return Container(
                          color:Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Excerise $index'),
                                  Text(
                                    '10:00',
                                    style: TextStyle(color: Colors.black45),
                                  )
                                ],
                              ),
                              SizedBox(
                                width: width * 0.5,
                              ),
                              Text("250")
                            ],
                          ),
                        );
                      }, childCount: 3),
                    ),
                  ],
                ),
              )),
          Positioned(
            top: height * 0.825,
            left: 0,
            right: 0,
            height: height * 0.1,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  addFoodButton,
                  SizedBox(
                    width: 50,
                  ),
                  addExerciseButton
                ]),
          )
        ],
      ),
    );
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
                  width: width * progress,
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
