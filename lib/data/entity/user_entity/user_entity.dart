import 'package:hive/hive.dart';
part 'user_entity.g.dart';

@HiveType(typeId: 1)
class UserEntity extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String mobile;
  @HiveField(2)
  final String occupation;
  @HiveField(3)
  final String email;
  @HiveField(4)
  final String image;
  @HiveField(5)
  final String birthDay;
  @HiveField(6)
  final String businessLogo;
  @HiveField(7)
  final String businessName;

  UserEntity({
    required this.name,
    required this.mobile,
    required this.occupation,
    required this.email,
    required this.image,
    required this.birthDay,
    required this.businessName,
    required this.businessLogo,
  });

  UserEntity copyWith({
    String? name,
    String? mobile,
    String? occupation,
    String? email,
    String? image,
    String? birthDay,
    String? businessName,
    String? businessLogo,
  }) {
    return UserEntity(
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      occupation: occupation ?? this.occupation,
      email: email ?? this.email,
      image: image ?? this.image,
      birthDay: birthDay ?? this.birthDay,
      businessName: businessName ?? this.businessName,
      businessLogo: businessLogo ?? this.businessLogo,
    );
  }
}
