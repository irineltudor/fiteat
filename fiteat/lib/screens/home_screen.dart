
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/screens/login_screen.dart';
import 'package:flutter/material.dart';

import '../model/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 181, 188, 192),
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
        child: BottomNavigationBar(
          iconSize: 28,
          selectedIconTheme: IconThemeData(
            color: Color(0xFF60a847),
          ),
          unselectedIconTheme: IconThemeData(color: Colors.grey),
          selectedItemColor: Color(0xFF60a847),
          items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
      
            ),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.book,
          ),
              label: "Dairy",),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.add,
          ),
              label: "Add",),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.stacked_bar_chart,
          ),
              label: "Stats",),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.more,
          ),
              label: "More",),
        ]),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            height: height * 0.35,
            left: 0,
            right: 0,
            child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: const Radius.circular(45),
                ),
                child: Container(
                  color: Colors.white,
                  )),
          )
        ],
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}
