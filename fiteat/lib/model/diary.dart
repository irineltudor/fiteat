import 'dart:collection';

import 'package:flutter/rendering.dart';

class Diary {
  String? uid;
  double? exercise;
  double? food;
  double? fats;
  double? carbs;
  double? protein;
  Map<String, dynamic>? exercises;
  Map<String, Map<String, dynamic>>? meals;
  Diary(
      {this.uid,
      this.exercise,
      this.food,
      this.fats,
      this.carbs,
      this.protein,
      this.exercises,
      this.meals});

  // data from server
  factory Diary.fromMap(map) {
    return Diary(
        uid: map['uid'],
        exercise: map['exercise'].toDouble(),
        food: map['food'].toDouble(),
        protein: map['protein'].toDouble(),
        carbs: map['carbs'].toDouble(),
        fats: map['fats'].toDouble(),
        exercises: Map<String, dynamic>.from(map['exercises']),
        meals:Map<String, Map<String, dynamic>>.from(map['meals'])
        );
  }

  // sendig data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'exercise': exercise,
      'food': food,
      'protein': protein,
      'carbs': carbs,
      'fats': fats,
      'exercises': exercises,
      'meals': meals
    };
  }
}
