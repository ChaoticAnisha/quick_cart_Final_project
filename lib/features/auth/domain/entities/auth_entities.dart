import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String? id;
  final String name;
  final String email;
  final String? phone;
  final String? profilePicture;

  const AuthEntity({
    this.id,
    required this.name,
    required this.email,
    this.phone,
    this.profilePicture,
  });

  @override
  List<Object?> get props => [id, name, email, phone, profilePicture];
}
