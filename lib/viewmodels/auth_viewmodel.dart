import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';

class AuthViewModel extends ChangeNotifier {
  // Login yo'q — hamma default "waiter" sifatida ishlaydi
  // Faqat admin paroli orqali admin panelga kirish mumkin
  UserModel _currentUser = UserModel(
    id: 'default',
    name: 'Ofitsiant',
    role: AppConstants.roleWaiter,
  );

  String _language = AppConstants.defaultLanguage;

  UserModel get currentUser => _currentUser;
  String get language => _language;
  bool get isLoggedIn => true; // Doim true — login yo'q

  AuthViewModel() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _language =
        prefs.getString(AppConstants.prefLanguage) ??
        AppConstants.defaultLanguage;
    notifyListeners();
  }

  // AppWrapper dan chaqirish uchun public metod
  Future<void> loadLanguage() async {
    await _loadLanguage();
  }

  Future<void> toggleLanguage() async {
    _language = _language == 'uz' ? 'kr' : 'uz';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefLanguage, _language);
    notifyListeners();
  }

  // Foydalanuvchi nomini o'zgartirish (optsional)
  void setUserName(String name) {
    _currentUser = UserModel(
      id: _currentUser.id,
      name: name,
      role: _currentUser.role,
    );
    notifyListeners();
  }

  // Admin paroli tekshirish — faqat admin panelga kirish uchun
  Future<bool> checkAdminPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPassword =
        prefs.getString(AppConstants.prefAdminPassword) ??
        AppConstants.defaultAdminPassword;
    return password == savedPassword;
  }

  // Admin parolini yangilash
  Future<void> updateAdminPassword(String newPassword) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.prefAdminPassword, newPassword);
  }

  // Logout — login yo'qligi sababli faqat tilni tiklaydi
  Future<void> logout() async {
    _currentUser = UserModel(
      id: 'default',
      name: 'Ofitsiant',
      role: AppConstants.roleWaiter,
    );
    notifyListeners();
  }
}
