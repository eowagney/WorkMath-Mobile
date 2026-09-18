// lib/services/ai_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiService {
  static String get apiKey => dotenv.env['GROQ_API_KEY'] ?? '';

  static const String url = "https://api.groq.com/openai/v1/chat/completions";

  static const String systemPrompt = '''
Você é a assistente do WorkMatch.

Você precisa coletar obrigatoriamente:

1. Título do serviço
2. Especialidade do serviço
3. Descrição detalhada
4. Cidade
5. Estado

Faça perguntas uma por vez.

Quando tiver todos os dados, responda EXATAMENTE:

DADOS_COLETADOS:{"titulo":"...","especialidade":"...","descricao":"...","cidade":"...","estado":"XX"}

Sem nenhum texto adicional.
''';

  static Future<String> enviarMensagem(
      List<Map<String, String>> historico) async {
    if (apiKey.isEmpty) {
      throw Exception(
        'GROQ_API_KEY não encontrada no arquivo .env',
      );
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'model': 'openai/gpt-oss-120b',
        'messages': [
          {
            'role': 'system',
            'content': systemPrompt,
          },
          ...historico,
        ],
        'temperature': 0.7,
        'max_tokens': 512,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(
        'Erro Groq (${response.statusCode}): ${response.body}',
      );
    }

    return data['choices'][0]['message']['content'];
  }

  static Map<String, dynamic>? extrairDados(String texto) {
    final regex = RegExp(
      r'DADOS_COLETADOS:(\{.*\})',
      dotAll: true,
    );

    final match = regex.firstMatch(texto);

    if (match == null) {
      return null;
    }

    try {
      return jsonDecode(match.group(1)!);
    } catch (_) {
      return null;
    }
  }
}
