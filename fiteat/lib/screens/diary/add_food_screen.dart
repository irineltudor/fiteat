import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/screens/diary/create_food_screen.dart';
import 'package:fiteat/screens/diary/dairy_screen.dart';
import 'package:fiteat/screens/diary/food_screen.dart';
import 'package:fiteat/screens/diary/quick_add_screen.dart';
import 'package:fiteat/screens/signup-signin/login_screen.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:fiteat/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../model/food.dart';
import '../../model/news.dart';
import '../../model/user_model.dart';

import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';

import '../../widget/search_widget.dart';
import '../statistics/statistics_screen.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({Key? key}) : super(key: key);

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final Storage storage = Storage();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  List<Food> allFoods = [];
  List<Food> searchedFoods = [];
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
        .get()
        .then((value) {
          Food food;
            value.docs.forEach(
              (db_food) => {
              food = Food.fromMap(db_food.data()),
              allFoods.add(food)

              }
            );
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
        child: MaterialButton(
          onPressed: () async {

          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                                                   "#ff6666", "Cancel", false, ScanMode.DEFAULT);
          print(barcodeScanRes);


          // remember i was here  app passed NULL surface
          if(allFoods.where((element) => element.barcode == barcodeScanRes).toList().isNotEmpty )
          {

          Navigator.push(context, MaterialPageRoute
          (builder: (context) => FoodScreen(foodId: barcodeScanRes)));

          }
          else{
          Navigator.push(context, MaterialPageRoute
          (builder: (context) => CreateFoodScreen(code: barcodeScanRes)));
          }
          


          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Icon(
                  Icons.qr_code_scanner_rounded,
                  color: const Color(0xFFfc7b78),
                  size: 35,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Scan Barcode",
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: const Color(0xFFfc7b78)),
                ),
                SizedBox(
                  height: 15,
                ),
              ]),
        ),
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
        child: MaterialButton(
          onPressed: () {

         //In order to use go back
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const QuickAddScreen()));
          },
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  height: 15,
                ),
                Icon(
                  Icons.fast_forward_rounded,
                  color: const Color(0xFFfc7b78),
                  size: 35,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Quick Add",
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: const Color(0xFFfc7b78)),
                ),
                SizedBox(
                  height: 15,
                ),
              ]),
        ),
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
           //In order to use go back
          Navigator.push(context, MaterialPageRoute
          (builder: (context) => CreateFoodScreen(code : ""))); 
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

    if( loggedInUser.activitylevel == null)
      return Container(
        color: Color(0xFFfc7b78),
        child: Center(child: CircularProgressIndicator(color: Colors.white,)));
    else
    {
    if(query == '')
    {
          searchedFoods = allFoods;
    }
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
          child: createFoodButton),
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
                children: [buildSearch()],
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
                  SizedBox(
                    width: width * 0.05,
                  ),
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
                          itemCount: searchedFoods.length,
                          itemBuilder: (context, index) {
                            return buildFood(searchedFoods[index]);
                          })),
                ],
              ),
            ),
          )
        ],
      ),
    );
    }
  }

  Widget buildSearch() {
    return SearchWidget(
        text: query, hintText: 'Search for food', onChanged: searchFood);
  }

  Widget buildFood(Food food) {
    if(food.additional == 'quickAdd') {
      return SizedBox.shrink();
    }
    return MaterialButton(
      splashColor: Colors.grey,
      onPressed: () { 
                            //In order to use go back
          Navigator.push(context, MaterialPageRoute
          (builder: (context) => FoodScreen(foodId: food.barcode!))); 
       },
      child: ListTile(
        title: Text(food.name!),
        subtitle: Text(food.additional!),
      ),
    );
  }

  void searchFood(String query) {
    final searchFoods = allFoods.where((food){
      final foodName = food.name!.toLowerCase();
      final search = query.toLowerCase();
      return foodName.contains(search);
    }).toList();

    setState(() {
      this.query = query;
      this.searchedFoods = searchFoods;
    });
  }
}
