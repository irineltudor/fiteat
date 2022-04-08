class Food{
  String? name;
  String? additional;
  double? calories;
  double? protein;
  double? carbs;
  double? fat;
  String? servingSize;
  String? barcode;

  Food({this.name,this.additional,this.calories,this.protein,this.carbs,this.fat,this.servingSize,this.barcode});

  // data from server
  factory Food.fromMap(map){
    return Food(
      name: map['name'],
      additional : map['additional'],
      calories: map['calories'].toDouble(),
      protein: map['protein'].toDouble(),
      carbs: map['carbs'].toDouble(),
      fat : map['fat'].toDouble(),
      servingSize : map['servingSize'],
      barcode : map['barcode']
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
      'servingSize' : servingSize,
      'barcode' : barcode
    };
  }
}