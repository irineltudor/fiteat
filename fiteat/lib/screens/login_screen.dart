// import 'package:fiteat/screens/registration_screen.dart';
import 'package:flutter/material.dart';

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


  @override
  Widget build(BuildContext context) {
   
   //email field
   final emailField = TextFormField(
     autofocus: false,
     controller: emailController,
     keyboardType: TextInputType.emailAddress,
    //  validator: (){},
    onSaved:(value){
      emailController.text = value!;
    } ,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.mail),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: "Email",
      border:  OutlineInputBorder(
        borderRadius:BorderRadius.circular(10) )
    ),
   );






      //password field
   final passwordField = TextFormField(
     autofocus: false,
     obscureText: true,
     controller: passwordController,
     keyboardType: TextInputType.emailAddress,
    //  validator: (){},
    onSaved:(value){
      passwordController.text = value!;
    } ,
    textInputAction: TextInputAction.done,
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.password),
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
        onPressed: () {} ,
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
                    child:Image.asset("assets/logo/fiteat_white.png",fit: BoxFit.contain,),
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
                            // Navigator.push(context, MaterialPageRoute(builder: (context)=>RegistrationScreen()));
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
}