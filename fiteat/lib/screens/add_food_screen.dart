import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/screens/dairy_screen.dart';
import 'package:fiteat/screens/login_screen.dart';
import 'package:fiteat/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../model/food.dart';
import '../model/news.dart';
import '../model/user_model.dart';

import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';

import '../widget/search_widget.dart';
import 'statistics_screen.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final Storage storage = Storage();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List<Food> news = [];
  Food food = Food();
  String query = '';

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
        .doc("food-id")
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


  final scanBarcode = Container(
          width: width * 0.4,
          margin: const EdgeInsets.only(
            right: 20,
            bottom: 10,
          ),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.white,
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 15,),
                Icon(Icons.qr_code_scanner_rounded,color : const Color(0xFFfc7b78),size: 35,),
                SizedBox(height: 10,),
                Text("Scan Barcode", 
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: const Color(0xFFfc7b78)
                        ),),
              SizedBox(height: 15,),
                
              ]),
            ),

    );

      final quickAdd = Container(
          width: width * 0.4,
         
          margin: const EdgeInsets.only(
            right: 20,
            bottom: 10,
          ),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(30)),
             color: Colors.white,
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 15,),
                Icon(Icons.fast_forward_rounded ,color : const Color(0xFFfc7b78),size: 35,),
                SizedBox(height: 10,),
                Text("Quick Add", 
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                        color: const Color(0xFFfc7b78)
                        ),),
              SizedBox(height: 15,),
                
              ]),
            ),

    );

  final createFoodButton = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {
        },
        child: const Text(
          "Create Food",
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
          title: const Text('fiteat',style:TextStyle(color : Colors.white)),
        ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: createFoodButton
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            height: height * 0.12,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildSearch()
                ],
              ),
            ),
          ),
          Positioned(
            top: height * 0.12,
            height: height * 0.16,
            left: 0,
            right: 0,
            child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
                              SizedBox(width: width*0.05,),
                              scanBarcode,
                              quickAdd
                      ],
                    )),
        
            Positioned(
            top: height * 0.27,
            height: height * 0.54,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context,index){
                        final newfood = food;

                        return buildFood(food);
                      })),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSearch() {
    return SearchWidget(text:query ,hintText:'Search for food',onChanged: searchFood );
  
  }
  Widget buildFood(Food food){ 
    return ListTile(
    title : Text('Food Name'),
    subtitle: Text('Info'),
  );
  }

  void searchFood(String query){

  }
  

}




