import 'package:shared_preferences/shared_preferences.dart';

/// Gerencia o token JWT localmente no dispositivo.
class AuthStorage {
  static const _keyAccess = 'access_token';
  static const _keyRefresh = 'refresh_token';

  /// Salva os dois tokens após login ou registro.
  static Future<void> salvarTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyAccess, accessToken);
    await prefs.setString(_keyRefresh, refreshToken);
  }

  /// Retorna o access token salvo (ou null se não estiver logado).
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyAccess);
  }

  /// Verifica se há sessão ativa.
  static Future<bool> estaLogado() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Limpa os tokens (logout).
  static Future<void> limpar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyAccess);
    await prefs.remove(_keyRefresh);
  }
}
