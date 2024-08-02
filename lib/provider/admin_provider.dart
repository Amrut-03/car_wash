import 'dart:convert';
import 'package:car_wash/features/planner/model/admin.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthState {
  final Admin? admin;
  final bool isLoggedIn;

  AuthState({
    this.admin,
    this.isLoggedIn = false,
  });
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState()) {
    _loadAuthState();
  }

  Future<void> _loadAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final adminJson = prefs.getString('admin');
    if (adminJson != null) {
      final Map<String, dynamic> data = jsonDecode(adminJson);
      final admin = Admin.fromJson(data);
      state = AuthState(admin: admin, isLoggedIn: true);
    }
  }

  Future<void> login(Admin admin) async {
    state = AuthState(admin: admin, isLoggedIn: true);
    final prefs = await SharedPreferences.getInstance();
    final adminJson = jsonEncode(admin.toJson());
    await prefs.setString('admin', adminJson);
  }

  Future<void> logout() async {
    state = AuthState();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('admin');
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
