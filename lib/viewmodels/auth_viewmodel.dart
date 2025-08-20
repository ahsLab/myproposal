import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  User? _user;
  User? get user => _user;
  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // Diğer ViewModel'lere current user ID'sini iletmek için callback
  Function(String)? onUserChanged;

  AuthViewModel() {
    _initAuth();
  }

  void _initAuth() {
    _authService.user.listen((User? user) {
      _user = user;
      _isLoading = false;
      
      // User değiştiğinde callback'i çağır
      if (onUserChanged != null) {
        if (user != null) {
          onUserChanged!(user.uid);
        } else {
          onUserChanged!('');
        }
      }
      
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _user = await _authService.signIn(email, password);
    
    // Login başarılıysa callback'i çağır
    if (_user != null && onUserChanged != null) {
      onUserChanged!(_user!.uid);
    }
    
    notifyListeners();
    return _user != null;
  }

  Future<bool> register(String email, String password) async {
    _user = await _authService.signUp(email, password);
    
    // Register başarılıysa callback'i çağır
    if (_user != null && onUserChanged != null) {
      onUserChanged!(_user!.uid);
    }
    
    notifyListeners();
    return _user != null;
  }

  void logout() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }
}
