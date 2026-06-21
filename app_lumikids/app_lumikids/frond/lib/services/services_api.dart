import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_storage.dart';

class ApiService {
  // Vamos usar o (SUBIR CÓDIGO DO BACK PARA FACILITAR) 10.0.2.2 para emulador Android, ou o IP da sua máquina para celular físico
static const String _baseUrl = 'http://localhost:8000/api/v1';
  // Monta o cabeçalho com o token salvo
  Future<Map<String, String>> _headersAuth() async {
    final token = await AuthStorage.getAccessToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ─── LOGIN ────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    final resposta = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (resposta.statusCode == 200) {
      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
      // Salva o token automaticamente após o login
      await AuthStorage.salvarTokens(
        accessToken: dados['access_token'],
        refreshToken: dados['refresh_token'],
      );
      return dados;
    } else {
      final erro = jsonDecode(resposta.body);
      throw Exception(erro['detail'] ?? 'Erro ao fazer login');
    }
  }

  // ─── REGISTRAR CONTA ──────────────────────────────────────────────────────
  Future<Map<String, dynamic>> registrar({
    required String nome,
    required String email,
    required String senha,
    required String confirmarSenha,
    required String dataNascimento,
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
      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
      // Salva o token automaticamente após o registro
      await AuthStorage.salvarTokens(
        accessToken: dados['access_token'],
        refreshToken: dados['refresh_token'],
      );
      return dados;
    } else {
      final erro = jsonDecode(resposta.body);
      throw Exception(erro['detail'] ?? 'Erro ao criar conta');
    }
  }

  // ─── CRIAR PERFIL CRIANÇA ─────────────────────────────────────────────────
  // CORREÇÃO: rota correta é /children/ (não /criancas)
  // CORREÇÃO: envia o token de autenticação no cabeçalho
  Future<Map<String, dynamic>> criarPerfilCrianca({
    required String nome,
    required String dataNascimento,
  }) async {
    final resposta = await http.post(
      Uri.parse('$_baseUrl/children/'),
      headers: await _headersAuth(),
      body: jsonEncode({'nome': nome, 'data_nascimento': dataNascimento}),
    );

    if (resposta.statusCode == 200 || resposta.statusCode == 201) {
      return jsonDecode(resposta.body) as Map<String, dynamic>;
    } else {
      final erro = jsonDecode(resposta.body);
      throw Exception(erro['detail'] ?? 'Erro ao criar perfil');
    }
  }

  // ─── ESQUECI SENHA ────────────────────────────────────────────────────────
  Future<void> esqueciSenha({required String email}) async {
    final resposta = await http.post(
      Uri.parse('$_baseUrl/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (resposta.statusCode != 202) {
      final erro = jsonDecode(resposta.body);
      throw Exception(erro['detail'] ?? 'Erro ao solicitar recuperação');
    }
  }

  // ─── LOGOUT ───────────────────────────────────────────────────────────────
  Future<void> logout() async {
    await AuthStorage.limpar();
  }
}