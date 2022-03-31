import 'dart:ffi';

class UserModel{
  String? uid;
  String? email;
  String? firstName;
  String? secondName;
  String? gender;
  String? dob;
  double? weight;
  double? height;
  int? activitylevel;
  double? goal;
  int? goalcalories;

  UserModel({this.uid,this.email,this.firstName,this.secondName,this.gender,this.dob,this.weight,this.height,this.activitylevel,this.goal,this.goalcalories});

  // data from server
  factory UserModel.fromMap(map){
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName : map['firstName'],
      secondName: map['secondName'],
      gender: map['gender'],
      dob: map['dob'],
      weight: map['weight'].toDouble(),
      height : map['height'].toDouble(),
      activitylevel: map['activitylevel'],
      goal: map['goal'].toDouble(),
      goalcalories: map['goalcalories']
    );
  }

  // sendig data to our server
  Map<String, dynamic> toMap(){
    return {
      'uid' : uid,
      'email': email,
      'firstName': firstName,
      'secondName': secondName,
      'gender' : gender,
      'dob' : dob,
      'weight': weight,
      'height': height,
      'activitylevel': activitylevel,
      'goal' : goal,
      'goalcalories' : goalcalories,
    };
  }
}