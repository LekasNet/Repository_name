import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../requests/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleAnonymousLogin(AuthService authService) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await authService.loginAnonymously();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleEmailLogin(AuthService authService) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await authService.loginWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleGoogleLogin(AuthService authService) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await authService.loginWithGoogle();
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _handleRegistration(AuthService authService) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await authService.registerWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              // Поля для email и пароля
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 16),

              // Кнопка входа с email и паролем
              ElevatedButton(
                onPressed: () => _handleEmailLogin(authService),
                child: const Text('Login with Email'),
              ),

              // Кнопка регистрации
              ElevatedButton(
                onPressed: () => _handleRegistration(authService),
                child: const Text('Register with Email'),
              ),

              // Кнопка входа через Google
              ElevatedButton(
                onPressed: () => _handleGoogleLogin(authService),
                child: const Text('Login with Google'),
              ),

              // Кнопка анонимного входа
              ElevatedButton(
                onPressed: () => _handleAnonymousLogin(authService),
                child: const Text('Continue Without Account'),
              ),

              // Сообщение об ошибке
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
