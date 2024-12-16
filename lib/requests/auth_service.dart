import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../common/storage_service.dart';
import '../requests/temporary_user_request.dart';

class AuthService with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isAuthenticated = false; // Состояние авторизации
  String? _userToken; // Токен пользователя

  // Проверка авторизации
  bool get isAuthenticated => _isAuthenticated;

  // Получение текущего токена
  String? get userToken => _userToken;

  // Инициализация сервиса (проверка сохраненного токена)
  Future<void> initialize() async {
    try {
      final token = await StorageService.getToken();
      if (token != null) {
        _userToken = token;
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      print('Error initializing AuthService: $e');
    }
  }

  // Анонимный вход через TemporaryUserRequest
  Future<void> loginAnonymously() async {
    try {
      final token = await TemporaryUserRequest.createTemporaryUser();
      if (token.isNotEmpty) {
        _userToken = token;
        _isAuthenticated = true;
        await StorageService.saveToken(token); // Сохраняем токен
        notifyListeners();
      }
    } catch (e) {
      print('Error during anonymous login: $e');
    }
  }

  // Вход с email и паролем
  Future<void> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        _userToken = token;
        _isAuthenticated = true;
        await StorageService.saveToken(token); // Сохраняем токен
        notifyListeners();
      }
    } catch (e) {
      print('Error during email/password login: $e');
      throw Exception('Failed to login with email and password.');
    }
  }

  // Регистрация нового пользователя
  Future<void> registerWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(userCredential);

      // Получаем текущего пользователя
      final User? user = userCredential.user;

      if (user != null) {
        final token = await user.getIdToken();
        if (token!.isNotEmpty) {
          _userToken = token;
          _isAuthenticated = true;
          await StorageService.saveToken(token); // Сохраняем токен
          notifyListeners();
        }
      } else {
        throw Exception('User object is null after registration');
      }
    } catch (e) {
      print('Error during registration: $e');
      throw Exception('Failed to register with email and password.');
    }
  }


  // Вход через Google
  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        throw Exception('Google sign-in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      final token = await userCredential.user?.getIdToken();
      if (token != null) {
        _userToken = token;
        _isAuthenticated = true;
        await StorageService.saveToken(token); // Сохраняем токен
        notifyListeners();
      }
    } catch (e) {
      print('Error during Google login: $e');
      throw Exception('Failed to login with Google.');
    }
  }

  // Выход из системы
  Future<void> logout() async {
    _isAuthenticated = false;
    _userToken = null;
    await StorageService.clearData(); // Очищаем данные
    notifyListeners();
  }
}
