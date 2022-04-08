class Exercise{
  String? name;
  double? caloriesPerMinute;
  String? id;
  Exercise({this.name,this.caloriesPerMinute,this.id});
  // data from server
  factory Exercise.fromMap(map){
    return Exercise(
      name: map['name'],
      caloriesPerMinute: map['caloriesPerMinute'].toDouble(),
      id : map['id']

    );
  }

  // sendig data to our server
  Map<String, dynamic> toMap(){
    return {
     'name' : name ,
     'caloriesPerMinute' : caloriesPerMinute,
     'id' : id
    };
  }
}