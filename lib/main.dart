import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

void main() {
  runApp(const AnalisadorTextoApp());
}

class AnalisadorTextoApp extends StatelessWidget {
  const AnalisadorTextoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analisador de Texto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const TelaLogin(),
    );
  }
}

// ========== TELA DE LOGIN ==========
class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _senhaVisivel = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              const SizedBox(height: 40),

              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite seu e-mail';
                  }
                  if (!value.contains('@')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Senha
              TextFormField(
                controller: _senhaController,
                obscureText: !_senhaVisivel,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _senhaVisivel = !_senhaVisivel;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Digite sua senha';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Botão Entrar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              _isLoading = true;
                            });

                            // Simular login
                            Future.delayed(const Duration(seconds: 1), () {
                              setState(() {
                                _isLoading = false;
                              });

                              // Navegar para tela principal
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TelaPrincipal(
                                    nomeUsuario: 'Usuário Teste',
                                  ),
                                ),
                              );
                            });
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('ENTRAR'),
                ),
              ),
              const SizedBox(height: 20),

              // Link para Cadastro
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TelaCadastro(),
                    ),
                  );
                },
                child: const Text('Ainda não tem conta? Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== TELA DE CADASTRO ==========
class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  State<TelaCadastro> createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  final _formKey = GlobalKey<FormState>();
  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  DateTime? _dataNascimento;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Nome Completo
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome completo é obrigatório';
                  }
                  if (value.split(' ').length < 2) {
                    return 'Digite nome e sobrenome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // CPF
              TextFormField(
                controller: _cpfController,
                inputFormatters: [_cpfMask],
                decoration: const InputDecoration(
                  labelText: 'CPF',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CPF é obrigatório';
                  }
                  final cpfLimpo = value.replaceAll(RegExp(r'[^\d]'), '');
                  if (cpfLimpo.length != 11) {
                    return 'CPF inválido (deve ter 11 dígitos)';
                  }
                  return null;
                },
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
                    setState(() {
                      _dataNascimento = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data de Nascimento',
                    prefixIcon: Icon(Icons.calendar_today),
                    border: OutlineInputBorder(),
                  ),
                  child: Text(
                    _dataNascimento != null
                        ? DateFormat('dd/MM/yyyy').format(_dataNascimento!)
                        : 'Selecione uma data',
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Email
              TextFormField(
                controller: _emailController,
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
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),

              // Senha
              TextFormField(
                controller: _senhaController,
                obscureText: !_senhaVisivel,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _senhaVisivel ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _senhaVisivel = !_senhaVisivel;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Senha é obrigatória';
                  }
                  if (value.length < 8) {
                    return 'Mínimo 8 caracteres';
                  }

                  // Validações avançadas
                  bool hasUpperCase = RegExp(r'[A-Z]').hasMatch(value);
                  bool hasLowerCase = RegExp(r'[a-z]').hasMatch(value);
                  bool hasNumber = RegExp(r'[0-9]').hasMatch(value);
                  bool hasSpecialChar =
                      RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value);

                  if (!hasUpperCase) return 'Precisa de uma letra maiúscula';
                  if (!hasLowerCase) return 'Precisa de uma letra minúscula';
                  if (!hasNumber) return 'Precisa de um número';
                  if (!hasSpecialChar)
                    return 'Precisa de um caractere especial';

                  return null;
                },
                onChanged: (_) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 10),

              // Validação visual da senha
              _buildPasswordValidation(),
              const SizedBox(height: 15),

              // Confirmar Senha
              TextFormField(
                controller: _confirmarSenhaController,
                obscureText: !_confirmarSenhaVisivel,
                decoration: InputDecoration(
                  labelText: 'Confirmar Senha',
                  prefixIcon: const Icon(Icons.lock_outline),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _confirmarSenhaVisivel
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme sua senha';
                  }
                  if (value != _senhaController.text) {
                    return 'As senhas não conferem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Botão Cadastrar
              ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isLoading = true;
                          });

                          // Simular cadastro
                          Future.delayed(const Duration(seconds: 2), () {
                            setState(() {
                              _isLoading = false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text('Cadastro realizado com sucesso!'),
                                backgroundColor: Colors.green,
                              ),
                            );

                            Navigator.pop(context);
                          });
                        }
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('CADASTRAR'),
              ),

              const SizedBox(height: 15),

              // Voltar para Login
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('← Voltar para Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordValidation() {
    final senha = _senhaController.text;

    final validacoes = {
      'Mínimo 8 caracteres': senha.length >= 8,
      'Pelo menos uma letra maiúscula': RegExp(r'[A-Z]').hasMatch(senha),
      'Pelo menos uma letra minúscula': RegExp(r'[a-z]').hasMatch(senha),
      'Pelo menos um número': RegExp(r'[0-9]').hasMatch(senha),
      'Pelo menos um caractere especial':
          RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(senha),
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'A senha deve conter:',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        ...validacoes.entries.map((entry) {
          return Row(
            children: [
              Icon(
                entry.value ? Icons.check_circle : Icons.radio_button_unchecked,
                color: entry.value ? Colors.green : Colors.grey,
                size: 16,
              ),
              const SizedBox(width: 5),
              Text(
                entry.key,
                style: TextStyle(
                  fontSize: 12,
                  color: entry.value ? Colors.green : Colors.grey,
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}

// ========== TELA PRINCIPAL ==========
class TelaPrincipal extends StatefulWidget {
  final String nomeUsuario;

  const TelaPrincipal({super.key, required this.nomeUsuario});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final TextEditingController _textController = TextEditingController();
  String _resultado = '';

  void _analisarTexto() {
    final texto = _textController.text.trim();

    if (texto.isEmpty) {
      setState(() {
        _resultado = 'Por favor, digite um texto para analisar.';
      });
      return;
    }

    // Análise do texto
    final palavras =
        texto.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    final caracteres = texto.length;
    final palavrasContagem = palavras.length;
    final caracteresSemEspaco = texto.replaceAll(RegExp(r'\s'), '').length;

    final vogais = texto
        .toLowerCase()
        .replaceAll(RegExp(r'[^aeiouáéíóúãõâêîôûàèìòù]'), '')
        .length;
    final consoantes = texto
        .toLowerCase()
        .replaceAll(RegExp(r'[^bcdfghjklmnpqrstvwxyz]'), '')
        .length;

    // Contar frequência de palavras
    final frequencia = <String, int>{};
    for (var palavra in palavras) {
      final p = palavra.toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
      if (p.isNotEmpty) {
        frequencia[p] = (frequencia[p] ?? 0) + 1;
      }
    }

    // Ordenar por frequência
    final palavrasMaisFrequentes = frequencia.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Formatar resultado
    final resultadoFormatado = '''
📊 ANÁLISE DE TEXTO
====================

📝 Texto analisado (primeiros 100 caracteres):
"${texto.length > 100 ? '${texto.substring(0, 100)}...' : texto}"

📈 ESTATÍSTICAS:
• Total de caracteres: $caracteres
• Caracteres (sem espaços): $caracteresSemEspaco
• Total de palavras: $palavrasContagem
• Vogais: $vogais
• Consoantes: $consoantes
• Espaços: ${texto.length - caracteresSemEspaco}

🏆 PALAVRAS MAIS FREQUENTES:
${palavrasMaisFrequentes.take(5).map((e) => '• "${e.key}": ${e.value} vez${e.value > 1 ? 'es' : ''}').join('\n')}
''';

    setState(() {
      _resultado = resultadoFormatado;
    });

    // Navegar para tela de resultados
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaResultados(
          textoOriginal: texto,
          resultado: resultadoFormatado,
        ),
      ),
    );
  }

  void _limparTexto() {
    _textController.clear();
    setState(() {
      _resultado = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, ${widget.nomeUsuario.split(' ').first}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Área de entrada de texto
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText:
                      'Digite ou cole seu texto aqui...\n\nExemplo: "Flutter é um framework incrível para desenvolvimento de aplicativos móveis, web e desktop."',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Botões de ação
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _analisarTexto,
                    icon: const Icon(Icons.analytics),
                    label: const Text('Analisar Texto'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: _limparTexto,
                  icon: const Icon(Icons.delete),
                  label: const Text('Limpar'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 20),
                    backgroundColor: Colors.red,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Pré-visualização do resultado
            if (_resultado.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _resultado,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ========== TELA DE RESULTADOS ==========
class TelaResultados extends StatelessWidget {
  final String textoOriginal;
  final String resultado;

  const TelaResultados({
    super.key,
    required this.textoOriginal,
    required this.resultado,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resultados da Análise'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Texto original
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '📝 TEXTO ORIGINAL',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      textoOriginal,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '(${textoOriginal.length} caracteres, ${textoOriginal.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).length} palavras)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Resultados da análise
            Expanded(
              child: Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '📊 ANÁLISE COMPLETA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: SingleChildScrollView(
                          child: SelectableText(
                            resultado,
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Botões de ação
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Simular compartilhamento
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Resultados prontos para compartilhar!'),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    icon: const Icon(Icons.share),
                    label: const Text('Compartilhar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Simular cópia
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Resultados copiados para a área de transferência!'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy),
                    label: const Text('Copiar'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
