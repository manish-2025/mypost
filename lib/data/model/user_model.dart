// ignore_for_file: prefer_collection_literals, annotate_overrides, overridden_fields

import 'package:mypost/data/entity/user_entity/user_entity.dart';

class UserModel {
  final UserEntity userData;

  UserModel({required this.userData});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(userData: UserData.fromJson(json));
  }

  Map<String, dynamic> toJson() {
    return userData is UserData
        ? (userData as UserData).toJson()
        : throw Exception('userData must be a UserData instance to serialize');
  }
}

class UserData extends UserEntity {
  String name;
  String mobile;
  String occupation;
  String email;
  String image;
  String birthDay;

  UserData({
    required this.name,
    required this.mobile,
    required this.occupation,
    required this.email,
    required this.image,
    required this.birthDay,
  }) : super(
         name: name,
         mobile: mobile,
         occupation: occupation,
         email: email,
         image: image,
         birthDay: birthDay,
       );

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      mobile: json['mobile'],
      occupation: json['occupation'],
      email: json['email'],
      image: json['image'],
      birthDay: json['birthDay'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'mobile': mobile,
      'occupation': occupation,
      'email': email,
      'image': image,
      'birthDay': birthDay,
    };
  }
}
