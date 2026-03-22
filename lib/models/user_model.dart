import '../core/constants/app_constants.dart';

class UserModel {
  final String id;
  final String name;
  final String role;
  final String? email;
  final bool isActive;

  UserModel({
    required this.id,
    required this.name,
    required this.role,
    this.email,
    this.isActive = true,
  });

  bool get isAdmin => role == AppConstants.roleAdmin;
  bool get isWaiter => role == AppConstants.roleWaiter;
  bool get isCashier => role == AppConstants.roleCashier;

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'role': role,
    'email': email,
    'is_active': isActive ? 1 : 0,
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    id: map['id'] ?? '',
    name: map['name'] ?? '',
    role: map['role'] ?? AppConstants.roleWaiter,
    email: map['email'],
    isActive: map['is_active'] == 1 || map['is_active'] == true,
  );
}
