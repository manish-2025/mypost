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
  String businessName;
  String businessLogo;

  UserData({
    required this.name,
    required this.mobile,
    required this.occupation,
    required this.email,
    required this.image,
    required this.birthDay,
    required this.businessName,
    required this.businessLogo,
  }) : super(
         name: name,
         mobile: mobile,
         occupation: occupation,
         email: email,
         image: image,
         birthDay: birthDay,
         businessName: businessName,
         businessLogo: businessLogo,
       );

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      name: json['name'],
      mobile: json['mobile'],
      occupation: json['occupation'],
      email: json['email'],
      image: json['image'],
      birthDay: json['birthDay'],
      businessName: json['businessName'],
      businessLogo: json['businessLogo'],
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
