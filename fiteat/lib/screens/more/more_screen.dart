import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/screens/diary/dairy_screen.dart';
import 'package:fiteat/screens/more/change_password.dart';
import 'package:fiteat/screens/more/change_goal.dart';
import 'package:fiteat/screens/signup-signin/login_screen.dart';
import 'package:fiteat/screens/statistics/statistics_screen.dart';
import 'package:fiteat/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

import '../../model/news.dart';
import '../../model/user_model.dart';


import '../home/home_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  _MoreScreenState createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  final Storage storage = Storage();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List<News> news = [];
  News oneNews = News();

  

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

    FilePickerResult? result;
    final changePictureButton =  Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.black)),
        minWidth: MediaQuery.of(context).size.width / 2  ,
        onPressed: () async =>{
          result = await FilePicker.platform.pickFiles(allowMultiple: false,type: FileType.custom,allowedExtensions: ['jpg']),
          if(result == null){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No file selected"),)),
          }
          
        },
        child: FittedBox(
            child: Text(
              'Change Profile Picture',
              style: TextStyle(fontSize:16, color: Colors.black),
            ),
          ),
        ),
      );


    final changePassword=  Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.black)),
        minWidth: MediaQuery.of(context).size.width / 2  ,
        onPressed: () =>{

                                                       //In order to use go back
          Navigator.push(context, MaterialPageRoute
          (builder: (context) => ChangePasswordScreen()))
        },
        child: FittedBox(
            child: Text(
              'Change Password',
              style: TextStyle(fontSize:16, color: Colors.black),
            ),
          ),
        ),
      );

    final changeGoal =  Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white,
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.black)),
        minWidth: MediaQuery.of(context).size.width / 2  ,
        onPressed: () =>{
                                             //In order to use go back
          Navigator.push(context, MaterialPageRoute
          (builder: (context) => ChangeGoalScreen()))
        },
        child: FittedBox(
            child: Text(
              'Change Goal',
              style: TextStyle(fontSize:16, color: Colors.black),
            ),
          ),
        ),
      );

      final logoutButton =  Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: Colors.white)),
        minWidth: MediaQuery.of(context).size.width / 2  ,
        onPressed: () =>{
          logout(context)
        },
        child: FittedBox(
            child: Text(
              'Log out',
              style: TextStyle(fontSize:16, color: Colors.white),
            ),
          ),
        ),
      );


    if(loggedInUser.dob == null)
      return Container(
        color: Color(0xFFfc7b78),
        child: Center(child: CircularProgressIndicator(color: Colors.white,)));
    else
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 197, 201, 207),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfc7b78),
        elevation: 0,
        centerTitle: true,
        title: const Text('More', style: TextStyle(color: Colors.white)),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: BottomNavigationBar(
            iconSize: 28,
            currentIndex: 3,
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
              if (value == 1)
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const DiaryScreen()));

              if (value == 2) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const StatisticsScreen()));
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
        children: [
          Positioned(
            top: height * 0.02,
            height: height * 0.78,
            left: height * 0.005,
            right: height * 0.005,
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(45)),
                child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      SizedBox(height:height*0.01 ,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: width*0.2,
                            child: ClipOval(
                              child: FutureBuilder(
                                future: storage
                                    .getProfilePicture('${loggedInUser.uid}'),
                                builder: (BuildContext context,
                                    AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState ==
                                          ConnectionState.done &&
                                      snapshot.hasData) {
                                    return Image.network(
                                      snapshot.data!,
                                    );
                                  }
                                  if (snapshot.connectionState ==
                                          ConnectionState.waiting ||
                                      !snapshot.hasData) {
                                    return CircularProgressIndicator();
                                  }

                                  return Container();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                       Text("${loggedInUser.firstName}, ${loggedInUser.secondName}",
                        style:TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                          color: Colors.black
                        )),
                        SizedBox(height: 45,),
                        changePictureButton,
                        SizedBox(height: 15,),
                        changePassword,
                        SizedBox(height: 15,),
                        changeGoal,
                        SizedBox(height: 45,),
                        logoutButton
                    ])),
              ),
            ),
          ),
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
