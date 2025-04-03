import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dreamflow/models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _resetCode;
  String? _resetEmail;

  User? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get resetCode => _resetCode;
  String? get resetEmail => _resetEmail;

  // Storage Keys
  static const _userKey = 'user_data';
  static const _usersListKey = 'users_list';

  AuthProvider() {
    _loadUserFromStorage();
  }

  Future<void> _loadUserFromStorage() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);

      if (userJson != null) {
        final userData = jsonDecode(userJson);
        _user = User.fromJson(userData);
      }
    } catch (e) {
      debugPrint('Erro ao carregar usuário: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersListKey) ?? [];

      // Simple password check (not secure, just for demo)
      final validUser = usersJson.map((userStr) {
        final userData = jsonDecode(userStr);
        return {
          'user': User.fromJson(userData),
          'password': userData['password'],
        };
      }).firstWhere(
        (userMap) =>
            userMap['user'].email == email &&
            userMap['password'] == password,
        orElse: () => {'user': null, 'password': null},
      );

      if (validUser['user'] != null) {
        _user = validUser['user'];
        await prefs.setString(_userKey, jsonEncode(_user!.toJson()));
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Email ou senha inválidos';
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Erro ao realizar login: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signup(String nome, String email, String password,
      String telefone, {String? fotoPerfil}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersListKey) ?? [];

      // Check if email already exists
      bool emailExists = usersJson.any((userStr) {
        final userData = jsonDecode(userStr);
        return userData['email'] == email;
      });

      if (emailExists) {
        _errorMessage = 'Este email já está cadastrado';
        notifyListeners();
        return false;
      }

      // Create new user
      final newUser = User(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nome: nome,
        email: email,
        telefone: telefone,
        fotoPerfil: fotoPerfil,
      );

      // Add password to user data for storage
      final userDataWithPassword = {
        ...newUser.toJson(),
        'password': password,
      };

      // Update users list
      usersJson.add(jsonEncode(userDataWithPassword));
      await prefs.setStringList(_usersListKey, usersJson);

      // Auto login after signup
      _user = newUser;
      await prefs.setString(_userKey, jsonEncode(newUser.toJson()));

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao criar conta: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      _user = null;
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao fazer logout: $e');
    }
  }

  Future<bool> updateUserProfile(User updatedUser) async {
    if (_user == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      // Update current user
      _user = updatedUser;
      await prefs.setString(_userKey, jsonEncode(_user!.toJson()));

      // Update user in the users list
      final usersJson = prefs.getStringList(_usersListKey) ?? [];
      final updatedUsersList = usersJson.map((userStr) {
        final userData = jsonDecode(userStr);
        final user = User.fromJson(userData);

        if (user.id == updatedUser.id) {
          // Preserve the password when updating user in list
          return jsonEncode({
            ...updatedUser.toJson(),
            'password': userData['password'],
          });
        }
        return userStr;
      }).toList();

      await prefs.setStringList(_usersListKey, updatedUsersList);

      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Erro ao atualizar perfil: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para solicitar recuperação de senha
  Future<bool> requestPasswordReset(String email) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersListKey) ?? [];

      // Verificar se o e-mail existe
      bool emailExists = usersJson.any((userStr) {
        final userData = jsonDecode(userStr);
        return userData['email'] == email;
      });

      if (!emailExists) {
        _errorMessage = 'E-mail não encontrado';
        notifyListeners();
        return false;
      }

      // Gerar código de recuperação de 6 dígitos
      final code = (100000 + DateTime.now().microsecond % 900000).toString();
      _resetCode = code;
      _resetEmail = email;

      // Em um app real, enviaríamos o código por e-mail aqui
      // Simulando sucesso do envio de e-mail
      await Future.delayed(const Duration(seconds: 2));

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao solicitar recuperação de senha: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para validar código e redefinir senha
  Future<bool> resetPassword(String code, String newPassword) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (_resetCode == null || _resetEmail == null) {
      _errorMessage = 'Nenhuma solicitação de recuperação de senha ativa';
      _isLoading = false;
      notifyListeners();
      return false;
    }

    try {
      // Verificar se o código corresponde
      if (code != _resetCode) {
        _errorMessage = 'Código de verificação inválido';
        notifyListeners();
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final usersJson = prefs.getStringList(_usersListKey) ?? [];

      // Atualizar a senha do usuário
      final updatedUsersList = usersJson.map((userStr) {
        final userData = jsonDecode(userStr);
        if (userData['email'] == _resetEmail) {
          // Atualizar a senha
          userData['password'] = newPassword;
          return jsonEncode(userData);
        }
        return userStr;
      }).toList();

      await prefs.setStringList(_usersListKey, updatedUsersList);

      // Limpar dados de reset
      _resetCode = null;
      _resetEmail = null;

      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Erro ao redefinir senha: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método para atualizar a imagem de perfil
  Future<bool> updateProfileImage(String imageBase64) async {
    if (_user == null) return false;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedUser = _user!.copyWith(fotoPerfil: imageBase64);
      return await updateUserProfile(updatedUser);
    } catch (e) {
      _errorMessage = 'Erro ao atualizar foto de perfil: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}