import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/screens/diary/dairy_screen.dart';
import 'package:fiteat/screens/home/news_screen.dart';
import 'package:fiteat/screens/more/more_screen.dart';
import 'package:fiteat/screens/signup-signin/login_screen.dart';
import 'package:fiteat/screens/statistics/statistics_screen.dart';
import 'package:fiteat/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../model/news.dart';
import '../../model/user_model.dart';

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
        .get()
        .then((value) {
        value.docs.forEach(
          (new_news) => {
            oneNews = News (),
            oneNews = News.fromMap(new_news.data()),
            news.add(oneNews)
            
          }
        );
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
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
            onTap: (value){
              if (value == 1) Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DiaryScreen()));
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

                      Row(
                        children: [
                          _RadialProgress(
                            width: width * 0.3,
                            height: width * 0.3,
                            progress: 0.7,
                          ),
                          SizedBox(width: 10 ),

                          Column(
                        mainAxisAlignment:  MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _MacrosProgress(macro: "Protein", left: 40 , progress: 0.6, progressColor: Color.fromARGB(255, 60, 10, 177),width:width*0.3 ,),
                          SizedBox(height: 10,),
                          _MacrosProgress(macro: "Carbs", left: 100 , progress: 0.3, progressColor: Colors.green,width:width*0.3),
                          SizedBox(height: 10,),
                          _MacrosProgress(macro: "Fat", left: 20 , progress: 0.8, progressColor: Colors.yellow,width:width*0.3),

                        ],
                      )
                        ],
                      ),
                      

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
                              for(int i=0;i < news.length ;i++)
                              _NewsCard(news: news[i],),
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
}

class _RadialProgress extends StatelessWidget {
  final double height, width, progress;

  const _RadialProgress({ Key? key,required this.height,required this.width ,required this.progress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _RadialPainter(progressProtein:0.3,progressFats: 0.1,progressCarbs: 0.4),
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
                color: Colors.black38
              )),
              TextSpan(text:"\n"),
              TextSpan(text : "kcal left",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black38
              ))
            ])
          ),
        ),
      ),
    );
  }
}

class _RadialPainter extends CustomPainter{
  final double progressProtein, progressCarbs,progressFats;

  _RadialPainter({required this.progressProtein,required this.progressCarbs,required this.progressFats,});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paintProtein = Paint()
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke
    ..color = Color.fromARGB(255, 60, 10, 177)
    ..strokeCap = StrokeCap.round;

    Paint paintCarbs = Paint()
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke
    ..color = Colors.green
    ..strokeCap = StrokeCap.square;

    Paint paintFat = Paint()
    ..strokeWidth = 10
    ..style = PaintingStyle.stroke
    ..color = Colors.yellow
    ..strokeCap = StrokeCap.round;

    Paint paintBlack = Paint()
    ..strokeWidth = 15
    ..style = PaintingStyle.stroke
    ..color = Colors.black12
    ..strokeCap = StrokeCap.round;

    Offset center = Offset(size.width/2 , size.height/2);

    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width/2), math.radians(-90), math.radians(-360), false, paintBlack);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width/2), math.radians(-90), math.radians(-360*progressProtein), false, paintProtein);
  
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width/2), math.radians(-90-360*(progressProtein+progressCarbs)), math.radians(-360*progressFats), false, paintFat);
    canvas.drawArc(Rect.fromCircle(center: center, radius: size.width/2), math.radians(-90-360*progressProtein), math.radians(-360*progressCarbs), false, paintCarbs);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
   return true;
  }

}

class _MacrosProgress extends StatelessWidget{
  final String macro;
  final int left;
  final double progress,width;
   final Color progressColor;

   const _MacrosProgress({Key? key, required this.macro,required this.left,required this.progress,required this.progressColor,required this.width}) : super(key:key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(macro.toUpperCase() , 
        style: TextStyle(fontSize:14,
        fontWeight: FontWeight.w700,
        ),
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment:MainAxisAlignment.spaceBetween ,
          children: <Widget>[
          Stack(
            children: [
              Container(
                height: 10,
                width: width,
                decoration: BoxDecoration(color:Colors.black12, borderRadius: BorderRadius.all(Radius.circular(8))),
                
              ),
              Container(
                height: 10,
                width: width*progress,
                decoration: BoxDecoration(color:progressColor, borderRadius: BorderRadius.all(Radius.circular(8))),
                
              ),
            ],
          ),
          SizedBox(width:10),

          Text("${left}g left")
        ],)

      ],
    );
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
            child: MaterialButton(
              splashColor: Colors.black26,
             shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(45),
            ),
                    onPressed: () =>{
                                    //In order to use go back
          Navigator.push(context, MaterialPageRoute
          (builder: (context) => NewsScreen(news: news)))
      },child: Column(
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
                              return Center(
                                child: Container(
                                  width: 150,
                                  height: 150,
                                  child: CircularProgressIndicator(color: Colors.grey,),),
                              );
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
            ),

    );
  }
}



