import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String name;
  final String gender;
  final int age;
  final int height;
  final int weight;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  factory UserModel.fromJson(String id, Map<String, dynamic> json) => UserModel(
        id: id,
        email: json['email'],
        name: json['name'],
        gender: json['gender'],
        age: json['age'],
        height: json['height'],
        weight: json['weight'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'name': name,
        'gender': gender,
        'age': age,
        'height': height,
        'weight': weight,
      };

  @override
  List<Object?> get props => [id, email, name, gender, age, height, weight];
}
