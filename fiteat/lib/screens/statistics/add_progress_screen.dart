import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/statistics.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/screens/statistics/statistics_screen.dart';
import 'package:fiteat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class AddProgressScreen extends StatefulWidget {
  const AddProgressScreen({Key? key}) : super(key: key);

  @override
  _AddProgressScreenState createState() => _AddProgressScreenState();
}

class _AddProgressScreenState extends State<AddProgressScreen> {
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  Statistics statistics = Statistics(date: [],weight: []);

  final _formKey = GlobalKey<FormState>();

  final weightEditingController = TextEditingController();

  // string for displaying the error
  String? errorMessage;


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
        .collection("statistics")
        .doc(user!.uid)
        .get()
        .then((value) {
      statistics = Statistics.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    //first name field
    final weightField = TextFormField(
      autofocus: false,
      controller: weightEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
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
          Icons.scale,
          color: Colors.black,
        ),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Current weight",
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
        onPressed: () {
          addProgressToDiary(weightEditingController.text);
        },
        child: const Text(
          "Update",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

      if (loggedInUser.uid == null || statistics.uid == null) {
        return Container(
          color: const Color(0xFFfc7b78),
          child: const Center(
              child: CircularProgressIndicator(
            color: Colors.white,
          )));
      } else {
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
        title: const Text('Progress', style: TextStyle(color: Colors.white)),
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
                      weightField,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
    }
  }



  void addProgressToDiary(String weight) async {
    DateTime today = DateTime.now();

    statistics.date.add(DateFormat('dd-MM-yyyy').format(today));
    statistics.weight.add(double.parse(weight));
    statistics.uid = user!.uid;

    loggedInUser.weight = double.parse(weight);



    await FirebaseFirestore.instance
        .collection("statistics")
        .doc(user!.uid)
        .set(statistics.toMap());

    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .set(loggedInUser.toMap());
    
            Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const StatisticsScreen()),
        (route) => false);

  }
}



