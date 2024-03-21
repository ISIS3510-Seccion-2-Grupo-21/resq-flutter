import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
	final String userId;
	final String email;
	final String name;
  final String? photoUrl;
  final String? role;

	const MyUserEntity({
		required this.userId,
		required this.email,
		required this.name,
    this.photoUrl,
    this.role
	});

	Map<String, Object?> toDocument() {
		return {
			'userId': userId,
			'email': email,
			'name': name,
      'photoUrl': photoUrl,
      'role': role
		};
	}

	static MyUserEntity fromDocument(Map<String, dynamic> doc) {
		return MyUserEntity(
			userId: doc['userId'], 
			email: doc['email'], 
			name: doc['name'],
      photoUrl: doc['photoUrl'],
      role: doc['role']
		);
	}

	@override
	List<Object?> get props => [userId, email, name, photoUrl, role];

}