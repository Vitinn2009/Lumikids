import 'package:flutter/material.dart';

class UserService {
  // Singleton
  static final UserService _instance = UserService._internal();

  factory UserService() => _instance;

  UserService._internal();

  // -------------------- VALIDAÇÕES DE E-MAIL --------------------

  String? validateEmail(String email) {
    final trimmed = email.trim();

    if (trimmed.isEmpty) {
      return 'Informe seu e-mail';
    }

    final emailRegex = RegExp(r'^[\w\-.]+@([\w\-]+\.)+[\w]{2,}$');
    if (!emailRegex.hasMatch(trimmed)) {
      return 'E-mail inválido';
    }

    // REMOVIDO: checagem de e-mail duplicado no Map local.
    // Agora quem verifica duplicidade é o backend (retorna 409).
    return null;
  }

  // -------------------- VALIDAÇÃO DE SENHA --------------------

  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Informe uma senha';
    }

    if (password.length < 6) {
      return 'A senha deve ter ao menos 6 caracteres';
    }

    return null;
  }

  bool passwordsMatch(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  // -------------------- VALIDAÇÃO DE NOME --------------------

  String? validateName(String name) {
    final trimmed = name.trim();

    if (trimmed.isEmpty) {
      return 'Informe seu nome';
    }

    if (RegExp(r'\d').hasMatch(trimmed)) {
      return 'O nome não pode conter números';
    }

    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(trimmed)) {
      return 'O nome não pode conter caracteres especiais';
    }

    if (!RegExp(r'^[a-zA-ZÀ-ÖØ-öø-ÿ\s]+$').hasMatch(trimmed)) {
      return 'Use apenas letras e espaços';
    }

    return null;
  }

  // -------------------- VALIDAÇÃO DE IDADE --------------------

  int calculateAge(DateTime birthDate) {
    final hoje = DateTime.now();
    int idade = hoje.year - birthDate.year;
    if (hoje.month < birthDate.month ||
        (hoje.month == birthDate.month && hoje.day < birthDate.day)) {
      idade--;
    }
    return idade;
  }

  String? validateAgeForResponsible(DateTime birthDate) {
    final idade = calculateAge(birthDate);
    if (idade < 18) {
      return 'Você precisa ter 18 anos ou mais para ser responsável';
    }
    return null;
  }

  // -------------------- LOGIN (validação local de campos) --------------------
  // Verifica apenas se os campos estão preenchidos.
  // A autenticação real acontece no backend.

  String? validateLogin(String email, String password) {
    final trimmedEmail = email.trim();

    if (trimmedEmail.isEmpty) {
      return 'Informe o e-mail';
    }

    if (password.isEmpty) {
      return 'Informe a senha';
    }

    return null;
  }

  // -------------------- RECUPERAÇÃO DE SENHA --------------------
  // Mantido para compatibilidade com EsqueciSenhaScreen.
  // A verificação real de existência do e-mail é feita pelo backend.

  bool emailExists(String email) {
    // Sempre retorna false localmente — o backend é quem sabe.
    return false;
  }
}