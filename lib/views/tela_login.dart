import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/login_viewmodel.dart';
import 'tela_principal.dart';
import 'tela_cadastro.dart';

class TelaLogin extends StatelessWidget {
  TelaLogin({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
        ),
        body: Consumer<LoginViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo/Header
                    const Icon(
                      Icons.analytics,
                      size: 80,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Analisador de Texto',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Email
                    TextFormField(
                      controller: viewModel.emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-mail é obrigatório';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),

                    // Senha
                    TextFormField(
                      controller: viewModel.senhaController,
                      obscureText: !viewModel.senhaVisivel,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.senhaVisivel
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: viewModel.toggleSenhaVisibilidade,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Senha é obrigatória';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Botão Entrar
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: viewModel.isFormValid && !viewModel.isLoading
                            ? () async {
                                if (_formKey.currentState!.validate()) {
                                  final usuario = await viewModel.login();
                                  if (usuario != null && context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TelaPrincipal(usuario: usuario),
                                      ),
                                    );
                                  } else if (viewModel.errorMessage != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(viewModel.errorMessage!),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: viewModel.isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text('Entrar'),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Link para Cadastro
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TelaCadastro(),
                          ),
                        );
                      },
                      child: const Text('Ainda não tem conta? Cadastre-se'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
