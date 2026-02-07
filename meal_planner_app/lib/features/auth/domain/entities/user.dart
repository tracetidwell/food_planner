import 'package:equatable/equatable.dart';

/// User entity
class User extends Equatable {
  final String id;
  final String email;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.email,
    required this.createdAt,
  });

  @override
  List<Object> get props => [id, email, createdAt];

  @override
  String toString() => 'User(id: $id, email: $email)';
}
