class Food{
  String? name;
  String? additional;
  int? calories;
  int? protein;
  int? carbs;
  int? fat;
  List<String>? serving_size;

  Food({this.name,this.additional,this.calories,this.protein,this.carbs,this.fat,this.serving_size});

  // data from server
  factory Food.fromMap(map){
    return Food(
      name: map['name'],
      additional : map['additional'],
      calories: map['calories'],
      protein: map['protein'],
      carbs: map['carbs'],
      fat : map['fat'],
      serving_size : map['serving_size']
    );
  }

  // sendig data to our server
  Map<String, dynamic> toMap(){
    return {
     'name' : name ,
      'additional' : additional,
      'calories' : calories,
      'protein' : protein,
      'carbs' : carbs,
      'fat' : fat,
      'serving_size' : serving_size
    };
  }
}