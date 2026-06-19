import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://SEU_IP:8000';

  // ─── LOGIN ────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final resposta = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'senha': senha,
      }),
    );

    if (resposta.statusCode == 200) {
      return jsonDecode(resposta.body) as Map<String, dynamic>;
    } else {
      throw Exception('Erro ao fazer login: ${resposta.body}');
    }
  }

  // ─── REGISTRAR CONTA ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> registrar({
    required String nome,
    required String email,
    required String senha,
    required String confirmarSenha,
    required String dataNascimento, // formato: yyyy-MM-dd
  }) async {
    final resposta = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'email': email,
        'senha': senha,
        'confirmar_senha': confirmarSenha,
        'data_nascimento': dataNascimento,
      }),
    );

    if (resposta.statusCode == 201) {
      return jsonDecode(resposta.body) as Map<String, dynamic>;
    } else {
      throw Exception('Erro ao criar conta: ${resposta.body}');
    }
  }

  // ─── CRIAR PERFIL CRIANÇA ─────────────────────────────────────────────────
  Future<Map<String, dynamic>> criarPerfilCrianca({
    required String nome,
    required String dataNascimento, // formato: yyyy-MM-dd
  }) async {
    final resposta = await http.post(
      Uri.parse('$_baseUrl/criancas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nome': nome,
        'data_nascimento': dataNascimento,
      }),
    );

    if (resposta.statusCode == 200 || resposta.statusCode == 201) {
      return jsonDecode(resposta.body) as Map<String, dynamic>;
    } else {
      throw Exception('Erro ao criar perfil: ${resposta.body}');
    }
  }
}