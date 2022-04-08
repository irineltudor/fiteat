import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteat/model/statistics.dart';
import 'package:fiteat/model/user_model.dart';
import 'package:fiteat/screens/diary/dairy_screen.dart';
import 'package:fiteat/screens/more/more_screen.dart';
import 'package:fiteat/screens/signup-signin/login_screen.dart';
import 'package:fiteat/screens/statistics/add_progress_screen.dart';
import 'package:fiteat/service/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/news.dart';
import '../../model/user_model.dart';

import '../home/home_screen.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({Key? key}) : super(key: key);

  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  final Storage storage = Storage();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();
  Statistics statistics = Statistics(date: [], weight: []);

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

    final addProgressButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(45),
      color: Colors.white,
      child: MaterialButton(
        splashColor: const Color(0xFFfc7b78),
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width / 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          //In order to use go back
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddProgressScreen()));
        },
        child: const Text(
          "Add Progress",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );

    //DateFormat('dd-MM-yyyy').parse(dob);
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
          centerTitle: true,
          title: const Text('Progress', style: TextStyle(color: Colors.white)),
        ),
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
          child: BottomNavigationBar(
              iconSize: 28,
              currentIndex: 2,
              selectedIconTheme: const IconThemeData(
                color: Color(0xFFfc7b78),
              ),
              unselectedIconTheme: const IconThemeData(
                  color: Color.fromARGB(255, 197, 201, 207)),
              selectedItemColor: const Color(0xFFfc7b78),
              onTap: (value) {
                if (value == 0)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen()));
                if (value == 1)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const DiaryScreen()));
                if (value == 3)
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const MoreScreen()));
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: height * 0.7,
                padding: EdgeInsets.all(20),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Your weight",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: charts.TimeSeriesChart(
                            _getWeightData(),
                            animate: true,
                            dateTimeFactory:
                                const charts.LocalDateTimeFactory(),
                            defaultRenderer: charts.LineRendererConfig(),
                            customSeriesRenderers: [
                              charts.PointRendererConfig()
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              addProgressButton,
            ],
          ),
        ),
      );
    }
  }

  List<charts.Series<WeightData, DateTime>> _getWeightData() {
    List<WeightData> data = [];

    for (int i = 0; i < statistics.weight.length; i++) {
      WeightData newData = WeightData(
          DateFormat('dd-MM-yyyy').parse(statistics.date[i]),
          statistics.weight[i]);

      data.add(newData);
    }

    List<charts.Series<WeightData, DateTime>> series = [
      charts.Series(
          id: "Sales",
          data: data,
          domainFn: (WeightData series, _) => series.date,
          measureFn: (WeightData series, _) => series.weight,
          colorFn: (WeightData series, _) =>
              charts.MaterialPalette.blue.shadeDefault)
    ];

    return series;
  }
}

class WeightData {
  final date;
  final double weight;

  WeightData(this.date, this.weight);
}
