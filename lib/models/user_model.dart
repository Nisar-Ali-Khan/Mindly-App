import 'package:equatable/equatable.dart';

enum UserRole { teen, parent }

class UserModel extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final UserRole role;
  final DateTime createdAt;
  final List<String> goals;
  final String? connectedTeenUid; // For parents
  final String? connectedParentUid; // For teens

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.role,
    required this.createdAt,
    this.goals = const [],
    this.connectedTeenUid,
    this.connectedParentUid,
  });

  UserModel copyWith({
    String? displayName,
    List<String>? goals,
    String? connectedTeenUid,
    String? connectedParentUid,
  }) {
    return UserModel(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      role: role,
      createdAt: createdAt,
      goals: goals ?? this.goals,
      connectedTeenUid: connectedTeenUid ?? this.connectedTeenUid,
      connectedParentUid: connectedParentUid ?? this.connectedParentUid,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'goals': goals,
      'connectedTeenUid': connectedTeenUid,
      'connectedParentUid': connectedParentUid,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      displayName: map['displayName'] ?? '',
      role: UserRole.values.byName(map['role'] ?? 'teen'),
      createdAt: DateTime.parse(map['createdAt']),
      goals: List<String>.from(map['goals'] ?? []),
      connectedTeenUid: map['connectedTeenUid'],
      connectedParentUid: map['connectedParentUid'],
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        role,
        createdAt,
        goals,
        connectedTeenUid,
        connectedParentUid,
      ];
}
