// import 'package:fiteat/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/screens/home_screen.dart';
import 'package:fiteat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  
  //form key
  final _formKey = GlobalKey<FormState>();

  //editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();


  // firebase
  final _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
   
   //email field
   final emailField = TextFormField(
     autofocus: false,
     controller: emailController,
     keyboardType: TextInputType.emailAddress,
      validator:(value)
      {
          if(value!.isEmpty)
          {
            return ("Please enter your email");
          }

          //reg ex for email valid
          if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value))
          {
            return ("Please eneter a valid email");
          }

          return null;
      } ,
    onSaved:(value){
      emailController.text = value!;
    } ,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.mail),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: "Email",
      border:  OutlineInputBorder(
        borderRadius:BorderRadius.circular(10), ),

    ),
   );






      //password field
   final passwordField = TextFormField(
     autofocus: false,
     obscureText: true,
     controller: passwordController,
     keyboardType: TextInputType.emailAddress,
     validator: (value)
     {
       RegExp regex = new RegExp(r'^.{6,}$');
       if(value!.isEmpty)
       {
         return ("Password is required for login");
       }

       if(!regex.hasMatch(value))
       {
          return("Enter a valid password (min 6 characters)");
       }

       return null;

     },
    onSaved:(value){
      passwordController.text = value!;
    } ,
    textInputAction: TextInputAction.done,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.vpn_key),
      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: "Password",
      border:  OutlineInputBorder(
        borderRadius:BorderRadius.circular(10) )
    ),
   );
  
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color:Colors.red,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width/1.5,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        } ,
        child: const Text("Login",
          textAlign: TextAlign.center,
          style:TextStyle(
          fontSize: 20,
          color:Colors.white,
          fontWeight: FontWeight.bold,
          ),),

        
 ),
    );
   
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color:Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center ,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 200,
                    child:Image.asset("assets/logo/fiteat_red.png",fit: BoxFit.contain,),
                    ),
                    SizedBox(height:45),

                    emailField,
                    SizedBox(height:20),

                    passwordField,
                    SizedBox(height:45),

                    loginButton,
                    SizedBox(height:15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Don't have an account? "),
                        GestureDetector(
                          onTap: (){
                             Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
                          },
                          child: Text("Sign up", style: TextStyle(
                            color:Colors.red,
                            fontWeight:FontWeight.w800,
                            fontSize: 15)),
                        )
                      ],
                    )],
                  ),
              ),
            ),
          ),
        )
      )
    );
  }

  //login 
  void signIn(String email,String password) async
  {
    if(_formKey.currentState!.validate())
    {
      await _auth.signInWithEmailAndPassword(email: email, password: password)
          .then((uid) => 
          {
            Fluttertoast.showToast(msg: "Login Succesful"),
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomeScreen())),
          })
          .catchError((e)
          {
            Fluttertoast.showToast(msg: e!.message);
          });
    }
  }
}