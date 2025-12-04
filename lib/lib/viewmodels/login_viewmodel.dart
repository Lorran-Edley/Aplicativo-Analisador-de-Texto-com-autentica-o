import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/usuario.dart';

class LoginViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();

  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  // Estados
  bool _senhaVisivel = false;
  bool _isLoading = false;
  String? _errorMessage;
  Usuario? _usuarioLogado;

  // Getters
  bool get senhaVisivel => _senhaVisivel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Usuario? get usuarioLogado => _usuarioLogado;

  bool get isFormValid =>
      emailController.text.isNotEmpty && senhaController.text.isNotEmpty;

  // Métodos
  void toggleSenhaVisibilidade() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<Usuario?> login() async {
    if (!isFormValid) return null;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final usuario = await _authService.login(
        emailController.text.trim(),
        senhaController.text,
      );

      _isLoading = false;

      if (usuario == null) {
        _errorMessage = 'Email ou senha incorretos';
        notifyListeners();
        return null;
      }

      _usuarioLogado = usuario;
      notifyListeners();
      return usuario;
    } catch (e) {
      _errorMessage = 'Erro ao fazer login: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}
