import 'package:analisador_texto/services/database_service.dart';
import 'package:analisador_texto/services/password_service.dart';
import 'package:analisador_texto/models/usuario.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();

  Future<Usuario?> cadastrarUsuario({
    required String nomeCompleto,
    required String cpf,
    required DateTime dataNascimento,
    required String email,
    required String senha,
  }) async {
    // Verificar se email já existe
    final usuarioExistente = await _databaseService.getUsuarioByEmail(email);
    if (usuarioExistente != null) {
      throw Exception('Email já cadastrado');
    }

    // Hash da senha
    final senhaHash = PasswordService.hashPassword(senha);

    // Criar usuário
    final usuario = Usuario(
      nomeCompleto: nomeCompleto,
      cpf: cpf,
      dataNascimento: dataNascimento,
      email: email,
      senhaHash: senhaHash,
    );

    // Salvar no banco
    final id = await _databaseService.insertUsuario(usuario);
    usuario.id = id;

    return usuario;
  }

  Future<Usuario?> login(String email, String senha) async {
    final senhaHash = PasswordService.hashPassword(senha);
    return await _databaseService.login(email, senhaHash);
  }

  static bool validarNomeCompleto(String nome) {
    final partes = nome.trim().split(' ');
    return partes.length >= 2 && partes.every((parte) => parte.length >= 2);
  }

  static bool validarCPF(String cpf) {
    // Remove caracteres não numéricos
    final cpfLimpo = cpf.replaceAll(RegExp(r'[^\d]'), '');
    return cpfLimpo.length == 11;
  }

  static bool validarEmail(String email) {
    return RegExp(
      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
    ).hasMatch(email);
  }
}
