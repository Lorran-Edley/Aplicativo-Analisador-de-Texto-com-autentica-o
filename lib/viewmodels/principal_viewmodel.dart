import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../viewmodels/cadastro_viewmodel.dart';

class TelaCadastro extends StatelessWidget {
  TelaCadastro({super.key});

  final _formKey = GlobalKey<FormState>();
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CadastroViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Usuário'),
          centerTitle: true,
        ),
        body: Consumer<CadastroViewModel>(
          builder: (context, viewModel, child) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    // Nome Completo
                    TextFormField(
                      controller: viewModel.nomeController,
                      decoration: InputDecoration(
                        labelText: 'Nome Completo',
                        prefixIcon: const Icon(Icons.person),
                        suffixIcon: viewModel.isNomeValid
                            ? const Icon(Icons.check, color: Colors.green)
                            : const Icon(Icons.error, color: Colors.red),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nome completo é obrigatório';
                        }
                        if (!viewModel.isNomeValid) {
                          return 'Digite nome e sobrenome';
                        }
                        return null;
                      },
                      onChanged: (_) => viewModel.notifyListeners(),
                    ),
                    const SizedBox(height: 15),

                    // CPF
                    TextFormField(
                      controller: viewModel.cpfController,
                      inputFormatters: [_cpfMask],
                      decoration: InputDecoration(
                        labelText: 'CPF',
                        prefixIcon: const Icon(Icons.badge),
                        suffixIcon: viewModel.isCPFValid
                            ? const Icon(Icons.check, color: Colors.green)
                            : const Icon(Icons.error, color: Colors.red),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'CPF é obrigatório';
                        }
                        if (!viewModel.isCPFValid) {
                          return 'CPF inválido';
                        }
                        return null;
                      },
                      onChanged: (_) => viewModel.notifyListeners(),
                    ),
                    const SizedBox(height: 15),

                    // Data de Nascimento
                    InkWell(
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          viewModel.setDataNascimento(picked);
                        }
                      },
                      child: InputDecorator(
                        decoration: InputDecoration(
                          labelText: 'Data de Nascimento',
                          prefixIcon: const Icon(Icons.calendar_today),
                          suffixIcon: viewModel.isDataNascimentoValid
                              ? const Icon(Icons.check, color: Colors.green)
                              : const Icon(Icons.error, color: Colors.red),
                        ),
                        child: Text(
                          viewModel.dataNascimento != null
                              ? DateFormat('dd/MM/yyyy')
                                  .format(viewModel.dataNascimento!)
                              : 'Selecione uma data',
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Email
                    TextFormField(
                      controller: viewModel.emailController,
                      decoration: InputDecoration(
                        labelText: 'E-mail',
                        prefixIcon: const Icon(Icons.email),
                        suffixIcon: viewModel.isEmailValid
                            ? const Icon(Icons.check, color: Colors.green)
                            : const Icon(Icons.error, color: Colors.red),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'E-mail é obrigatório';
                        }
                        if (!viewModel.isEmailValid) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
                      onChanged: (_) => viewModel.notifyListeners(),
                    ),
                    const SizedBox(height: 15),

                    // Senha
                    TextFormField(
                      controller: viewModel.senhaController,
                      obscureText: !viewModel.senhaVisivel,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
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
                        if (!viewModel.isSenhaValid) {
                          return 'Senha não atende aos requisitos';
                        }
                        return null;
                      },
                      onChanged: (_) => viewModel.notifyListeners(),
                    ),
                    const SizedBox(height: 10),

                    // Validação visual da senha
                    _buildPasswordValidation(viewModel),
                    const SizedBox(height: 15),

                    // Confirmar Senha
                    TextFormField(
                      controller: viewModel.confirmarSenhaController,
                      obscureText: !viewModel.confirmarSenhaVisivel,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.confirmarSenhaVisivel
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: viewModel.toggleConfirmarSenhaVisibilidade,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Confirmação de senha é obrigatória';
                        }
                        if (!viewModel.isConfirmarSenhaValid) {
                          return 'As senhas não conferem';
                        }
                        return null;
                      },
                      onChanged: (_) => viewModel.notifyListeners(),
                    ),
                    const SizedBox(height: 20),

                    // Botão Cadastrar
                    ElevatedButton(
                      onPressed: viewModel.isFormValid && !viewModel.isLoading
                          ? () async {
                              if (_formKey.currentState!.validate()) {
                                final success = await viewModel.cadastrar();
                                if (success && context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Cadastro realizado com sucesso!'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                  Navigator.pop(context);
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
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: viewModel.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Cadastrar'),
                    ),

                    // Link para Login
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Já tem conta? Faça login'),
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

  Widget _buildPasswordValidation(CadastroViewModel viewModel) {
    final validation = viewModel.senhaValidation;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'A senha deve conter:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        _buildValidationItem(
            'Pelo menos 8 caracteres', validation['hasMinLength']!),
        _buildValidationItem(
            'Pelo menos uma letra maiúscula', validation['hasUpperCase']!),
        _buildValidationItem(
            'Pelo menos uma letra minúscula', validation['hasLowerCase']!),
        _buildValidationItem('Pelo menos um número', validation['hasNumber']!),
        _buildValidationItem(
            'Pelo menos um caractere especial', validation['hasSpecialChar']!),
      ],
    );
  }

  Widget _buildValidationItem(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isValid ? Colors.green : Colors.grey,
          size: 16,
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: isValid ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}
