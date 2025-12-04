import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/password_service.dart';

class CadastroViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();

  // Controllers
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController =
      TextEditingController();

  // Estados
  DateTime? _dataNascimento;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  DateTime? get dataNascimento => _dataNascimento;
  bool get senhaVisivel => _senhaVisivel;
  bool get confirmarSenhaVisivel => _confirmarSenhaVisivel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Validadores em tempo real
  Map<String, bool> get senhaValidation =>
      PasswordService.getPasswordValidationStatus(senhaController.text);

  bool get isNomeValid => AuthService.validarNomeCompleto(nomeController.text);

  bool get isCPFValid => AuthService.validarCPF(cpfController.text);

  bool get isEmailValid => AuthService.validarEmail(emailController.text);

  bool get isDataNascimentoValid => _dataNascimento != null;

  bool get isSenhaValid =>
      PasswordService.validatePassword(senhaController.text);

  bool get isConfirmarSenhaValid =>
      senhaController.text == confirmarSenhaController.text &&
      confirmarSenhaController.text.isNotEmpty;

  bool get isFormValid =>
      isNomeValid &&
      isCPFValid &&
      isDataNascimentoValid &&
      isEmailValid &&
      isSenhaValid &&
      isConfirmarSenhaValid;

  // Métodos
  void setDataNascimento(DateTime data) {
    _dataNascimento = data;
    notifyListeners();
  }

  void toggleSenhaVisibilidade() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }

  void toggleConfirmarSenhaVisibilidade() {
    _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
    notifyListeners();
  }

  void setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<bool> cadastrar() async {
    if (!isFormValid) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authService.cadastrarUsuario(
        nomeCompleto: nomeController.text.trim(),
        cpf: cpfController.text,
        dataNascimento: _dataNascimento!,
        email: emailController.text.trim(),
        senha: senhaController.text,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }
}
