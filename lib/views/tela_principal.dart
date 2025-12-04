import 'package:flutter/material.dart';
import 'package:analisador_texto/models/usuario.dart';
import 'tela_resultados.dart';

class TelaPrincipal extends StatefulWidget {
  final Usuario usuario;

  const TelaPrincipal({super.key, required this.usuario});

  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final TextEditingController _textController = TextEditingController();
  String _resultado = '';

  void _analisarTexto() {
    final texto = _textController.text;

    if (texto.isEmpty) {
      setState(() {
        _resultado = 'Por favor, digite um texto para analisar.';
      });
      return;
    }

    // Análise do texto
    final palavras = texto.split(' ');
    final caracteres = texto.length;
    final palavrasContagem = palavras.length;
    final caracteresSemEspaco = texto.replaceAll(' ', '').length;
    final vogais = _contarVogais(texto);
    final consoantes = _contarConsoantes(texto);
    final linhaUnica = texto.replaceAll('\n', ' ');

    // Formatar resultado
    final resultadoFormatado = '''
Texto analisado: "${linhaUnica.length > 50 ? '${linhaUnica.substring(0, 50)}...' : linhaUnica}"

=== ESTATÍSTICAS ===
• Total de caracteres: $caracteres
• Caracteres (sem espaços): $caracteresSemEspaco
• Total de palavras: $palavrasContagem
• Vogais: $vogais
• Consoantes: $consoantes

=== PALAVRAS DETECTADAS ===
${_listarPalavrasUnicas(palavras)}
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

  int _contarVogais(String texto) {
    final vogais = RegExp(r'[aeiouáéíóúãõâêîôûàèìòùAEIOUÁÉÍÓÚÃÕÂÊÎÔÛÀÈÌÒÙ]');
    return vogais.allMatches(texto).length;
  }

  int _contarConsoantes(String texto) {
    final consoantes = RegExp(r'[bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]');
    return consoantes.allMatches(texto).length;
  }

  String _listarPalavrasUnicas(List<String> palavras) {
    final mapaFrequencia = <String, int>{};

    for (var palavra in palavras) {
      final palavraLimpa =
          palavra.trim().toLowerCase().replaceAll(RegExp(r'[^\w]'), '');
      if (palavraLimpa.isNotEmpty) {
        mapaFrequencia[palavraLimpa] = (mapaFrequencia[palavraLimpa] ?? 0) + 1;
      }
    }

    final listaOrdenada = mapaFrequencia.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return listaOrdenada.take(10).map((entry) {
      return '• "${entry.key}": ${entry.value} vez${entry.value > 1 ? 'es' : ''}';
    }).join('\n');
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
        title:
            Text('Bem-vindo, ${widget.usuario.nomeCompleto.split(' ').first}!'),
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
                  hintText: 'Digite ou cole seu texto aqui...',
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

            // Área de resultado (pré-visualização)
            if (_resultado.isNotEmpty)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey[300]),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      _resultado,
                      style: const TextStyle(fontFamily: 'monospace'),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
