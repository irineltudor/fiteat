class Statistics{
  String? uid;
  List<dynamic> date;
  List<dynamic> weight;
  Statistics({this.uid,required this.date,required this.weight});
  // data from server
  factory Statistics.fromMap(map){
    return Statistics(
      uid: map['uid'],
      date: map['date'],
      weight: map['weight']

    );
  }

  // sendig data to our server
  Map<String, dynamic> toMap(){
    return {
     'uid' : uid,
     'date' : date,
     'weight' : weight,
    };
  }
}