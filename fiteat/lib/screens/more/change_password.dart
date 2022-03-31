import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/home/home_screen.dart';
import 'package:fiteat/widget/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  final _formKey = GlobalKey<FormState>();


 final TextEditingController currentPasswordEditingController = TextEditingController();
 final TextEditingController newPasswordEditingController = TextEditingController();
 final TextEditingController renewPasswordEditingController  = TextEditingController();
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


  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    final currentPasswordField = TextFormField(
      autofocus: false,
      controller: currentPasswordEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
       RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid password (min 6 characters)");
        }

        return null;
      },
      onSaved: (value) {
        currentPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.check, color: Colors.black),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Current Password",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );


    final newPasswordField = TextFormField(
      autofocus: false,
      controller: newPasswordEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
       RegExp regex = new RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("Password is required for login");
        }

        if (!regex.hasMatch(value)) {
          return ("Enter a valid password (min 6 characters)");
        }

        return null;
      },
      onSaved: (value) {
        newPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.vpn_key, color: Colors.black),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "New Password",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );


        final renewPasswordField = TextFormField(
      autofocus: false,
      controller: renewPasswordEditingController,
      style: const TextStyle(color: Colors.black),
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
          if (newPasswordEditingController.text !=
            renewPasswordEditingController.text) {
          return ("Passwords don't match");
        }

        return null;
      },
      onSaved: (value) {
        renewPasswordEditingController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.restart_alt, color: Colors.black),
        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        hintText: "Confirm Password",
        hintStyle: TextStyle(color: Colors.black),
        errorStyle: TextStyle(color: Colors.black),
        border: InputBorder.none,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            borderSide: BorderSide(color: Colors.black)),
      ),
    );
    

   final updateButton = Material(
      elevation: 5,
      color: const Color(0xFFfc7b78),
      child: MaterialButton(
        splashColor: Colors.white30,
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        onPressed: () {},
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
        title: const Text('Change Password', style: TextStyle(color: Colors.white)),
      ),
              bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: updateButton),
        body: Stack(
          children: [
            Positioned(
            top: height * 0.02,
            height: height * 0.78,
            left: height * 0.005,
            right: height * 0.005,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(45)),
                child: Container(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(36),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Column(
                            children: [
                              Text('Change your password: ' , 
                              style: TextStyle(color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w800),),
                              SizedBox(height: 20,),
                              currentPasswordField,
                              SizedBox(height: 20,),
                              newPasswordField,
                              SizedBox(height: 20,),
                              renewPasswordField,
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  postDetailsToFirestore() async {}
}
