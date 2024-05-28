import 'package:flutter/material.dart';
import 'package:mai_f/repo/auth/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier {
  final _repo = AuthRepository();

  bool _isLogin = false;

  bool get isLogin => _isLogin;

  void checkUserLogin() {
    _isLogin = _repo.isLogin();
    notifyListeners();
  }

  AuthResponse? _authResponse;
  AuthResponse get authResponse => _authResponse ?? AuthResponse();

  void onSignUp(String password, String email,
      {required Function() success, required Function(dynamic) failed}) async {
    try {
      final response = await _repo.onSignUpWithEmail(password, email);
      _authResponse = response;
      _isLogin = true;
      fetchUserInfo();
      success();
    } catch (e) {
      failed("Error signing up: $e");
    }
    notifyListeners();
  }

  void signInWithGoogleWeb(
      {required Function() success, required Function(dynamic) failed}) async {
    try {
      await _repo.supabase.client.auth.signInWithOAuth(OAuthProvider.google,
          redirectTo: 'http://localhost:3000/#/main');
    } catch (e) {
      failed("Error try to signin with Google $e");
      return;
    }
    notifyListeners();
  }

  void signOut(
      {required Function() success, required Function(dynamic) failed}) async {
    checkUserLogin();
    try {
      if (_isLogin) {
        await _repo.signOut();
      }
      success();
    } catch (e) {
      failed("Error signing out: $e");
    }
    notifyListeners();
  }

  void signInWithGoogle({
    required Function() success,
    required Function(dynamic) failed,
  }) async {
    try {
      final response = await _repo.onSingUpWithGoogle();
      if (response.user != null) {
        _authResponse = response;
        fetchUserInfo();
        success();
      }
    } catch (e) {
      failed("Error signing in with Google: $e");
      return;
    }
    notifyListeners();
  }

  void onCheckScreenAuth(
      {required Function() auth, required Function() unAuth}) {
    checkUserLogin();
    if (_isLogin) {
      auth();
    } else {
      unAuth();
    }
  }

  User? _userInfo;
  User? get userInfo => _userInfo;

  Future<void> fetchUserInfo() async {
    try {
      final user = _repo.supabase.client.auth.currentUser;
      if (user != null) {
        print("Fetched user info: ${user.id}"); // Debug print
        _userInfo = user;
      } else {
        print("User not found or not logged in");
      }
    } catch (e) {
      print("Error fetching user info: $e");
    }
    notifyListeners();
  }
}
