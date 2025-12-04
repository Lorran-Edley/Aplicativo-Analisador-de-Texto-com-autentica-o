import 'dart:convert';
import 'package:crypto/crypto.dart';

class PasswordService {
  static String hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static bool validatePassword(String password) {
    // Verifica se tem pelo menos uma letra maiúscula
    bool hasUpperCase = RegExp(r'[A-Z]').hasMatch(password);

    // Verifica se tem pelo menos uma letra minúscula
    bool hasLowerCase = RegExp(r'[a-z]').hasMatch(password);

    // Verifica se tem pelo menos um número
    bool hasNumber = RegExp(r'[0-9]').hasMatch(password);

    // Verifica se tem pelo menos um caractere especial
    bool hasSpecialChar = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password);

    return hasUpperCase && hasLowerCase && hasNumber && hasSpecialChar;
  }

  static Map<String, bool> getPasswordValidationStatus(String password) {
    return {
      'hasUpperCase': RegExp(r'[A-Z]').hasMatch(password),
      'hasLowerCase': RegExp(r'[a-z]').hasMatch(password),
      'hasNumber': RegExp(r'[0-9]').hasMatch(password),
      'hasSpecialChar': RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password),
      'hasMinLength': password.length >= 8,
    };
  }
}
