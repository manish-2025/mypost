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

  UserEntity({
    required this.name,
    required this.mobile,
    required this.occupation,
    required this.email,
    required this.image,
    required this.birthDay,
  });

  UserEntity copyWith({
    String? name,
    String? mobile,
    String? occupation,
    String? email,
    String? image,
    String? birthDay,
  }) {
    return UserEntity(
      name: name ?? this.name,
      mobile: mobile ?? this.mobile,
      occupation: occupation ?? this.occupation,
      email: email ?? this.email,
      image: image ?? this.image,
      birthDay: birthDay ?? this.birthDay,
    );
  }
}
