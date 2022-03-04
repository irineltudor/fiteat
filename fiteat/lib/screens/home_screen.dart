import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/screens/login_screen.dart';
import 'package:fiteat/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../model/news.dart';
import '../model/user_model.dart';

import 'package:vector_math/vector_math_64.dart' as math;
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

      FirebaseFirestore.instance
        .collection("news")
        .doc("news-id")
        .get()
        .then((value) {
      oneNews = News.fromMap(value.data());
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 197, 201, 207),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
        child: BottomNavigationBar(
            iconSize: 28,
            selectedIconTheme: const IconThemeData(
              color: Color(0xFFfc7b78),
            ),
            unselectedIconTheme:
                const IconThemeData(color: Color.fromARGB(255, 197, 201, 207)),
            selectedItemColor: const Color(0xFFfc7b78),
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
                  Icons.add,
                ),
                label: "Add",
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
            height: height * 0.35,
            left: 0,
            right: 0,
            child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  bottom: const Radius.circular(45),
                ),
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(top: 30, left: 32 , right: 32, bottom:10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          "${DateFormat("EEEE").format(DateTime.now())}, ${DateFormat("d MMMM").format(DateTime.now())}",
                        style:TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.grey
                        )),
                        subtitle: Text("Hello, ${loggedInUser.firstName}",
                        style:TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                          color: Colors.black
                        )),
                        trailing: ClipOval(
                          child: FutureBuilder(
                                              future: storage.getProfilePicture('${loggedInUser.uid}'),
                                              builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                          if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
                              {
                                return Image.network(snapshot.data!,);
                              }
                            if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                              return CircularProgressIndicator();
                            }
                                          
                            return Container();
                                              },
                                  
                                          
                                            ),
                        ),
                      ),
                      SizedBox(height:5),
                      _RadialProgress(
                        width: height * 0.18,
                        height: height * 0.18,
                        progress: 0.7,
                      )
                    ],
                  ) ,
                )),
          ),
          Positioned(
            top: height * 0.38,
            left: 0,
            right: 0,
            child: Container(
                height: height*0.56,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 8,
                        left: 32,
                        right: 16,
                      ),
                      child: Text("NEWS",
                          style: TextStyle(
                            color: Colors.blueGrey,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          )),
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                            child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: 32,
                              ),
                              for(int i=0;i < 4 ;i++)
                              _NewsCard(news: oneNews,),
                      ],
                    )),),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),),
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

class _RadialProgress extends StatelessWidget {
  final double height, width, progress;

  const _RadialProgress({ Key? key,required this.height,required this.width ,required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(progress: 0.7),
      child: Container(
        height: height,
        width: width,
        child: Center(
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(children: [
              TextSpan(text: "531",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFfc7b78)
              )),
              TextSpan(text:"\n"),
              TextSpan(text : "kcal left",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFfc7b78)
              ))
            ])
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter{
  final double progress;

  _RadialPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke
    ..color = Color(0xFFfc7b78)
    ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width/2 , size.height/2);

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width/2), math.radians(-90), math.radians(-360*progress), false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
   return true;
  }

}

class _NewsCard extends StatelessWidget{
  final News news;
  final Storage storage = Storage();

  _NewsCard({Key? key, required this.news}) :super(key: key);
  

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
          width: width * 0.75,
          margin: const EdgeInsets.only(
            right: 20,
            bottom: 10,
          ),
          child: Material(
            borderRadius: BorderRadius.all(Radius.circular(45)),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Flexible(
                  fit:FlexFit.tight,
                  child:  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(45)),
                    child: FutureBuilder(
                      future: storage.downloadURL('${news.image}'),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
                        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData)
                            {
                              return Image.network(snapshot.data!,
                              width:300,
                              fit: BoxFit.fitWidth);
                            }
                          if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
                            return Container(
                              width: 300,
                              child: CircularProgressIndicator());
                          }
                  
                          return Container();
                      },
                                
                  
                    ),
                  ),
                ),
                Flexible(
                  fit:FlexFit.tight,
                  child: Padding(
                    padding: const EdgeInsets.only(left:15.0,right: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:[
                      const SizedBox(
                        height: 10,
                      ),
                      Text("${news.title} - ${news.type}", 
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 19,
                        color: Colors.black
                        ),),
                      Text("${news.summary} this text is here just to help me for summary", 
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: Colors.black45
                        ),),
                      const SizedBox(
                        height: 16,
                      )

                      ]),
                  ),)
              ]),
            ),

    );
  }
}



