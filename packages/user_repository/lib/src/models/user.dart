import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable {
  final String userId;
  final String email;
  final String name;
  final String image;
  final String role;

  const MyUser({required this.userId, required this.email, required this.name, required this.image, required this.role});

  static const empty = MyUser(userId: '', email: '', name: '', image: '', role: '');

  MyUser copyWith({String? userId, String? email, String? name, String? image, String? role}) {
    return MyUser(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        name: name ?? this.name,
        image: image ?? this.image,
        role: role ?? this.role);
  }

  MyUserEntity toEntity() {
    return MyUserEntity(userId: userId, email: email, name: name, image: image, role: role);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        userId: entity.userId, email: entity.email, name: entity.name, image: entity.image, role: entity.role);
  }

  @override
  List<Object?> get props => [userId, email, name, image, role];
}