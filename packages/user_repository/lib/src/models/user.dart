import 'package:equatable/equatable.dart';
import '../entities/entities.dart';

class MyUser extends Equatable {
  final String userId;
  final String email;
  final String name;
  final String? photoUrl;
  final String? role;

  const MyUser({required this.userId, required this.email, required this.name, this.photoUrl, this.role});

  static const empty = MyUser(userId: '', email: '', name: '', photoUrl: null, role: null);

  MyUser copyWith({String? userId, String? email, String? name, String? photoUrl, String? role}) {
    return MyUser(
        userId: userId ?? this.userId,
        email: email ?? this.email,
        name: name ?? this.name,
        photoUrl: photoUrl ?? this.photoUrl,
        role: role ?? this.role);
  }

  MyUserEntity toEntity() {
    return MyUserEntity(userId: userId, email: email, name: name, photoUrl: photoUrl, role: role);
  }

  static MyUser fromEntity(MyUserEntity entity) {
    return MyUser(
        userId: entity.userId, email: entity.email, name: entity.name, photoUrl: entity.photoUrl, role: entity.role);
  }

  @override
  List<Object?> get props => [userId, email, name, photoUrl, role];
}
