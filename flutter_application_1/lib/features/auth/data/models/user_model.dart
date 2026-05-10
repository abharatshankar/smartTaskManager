import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({required super.id, required super.username, required super.email});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] is int ? json['id'] as int : int.parse('${json['id']}'),
      username: (json['username'] ?? '') as String,
      email: (json['email'] ?? '') as String,
    );
  }
}
