import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:projekakhir_praktpm/models/user_model.dart';
import 'package:projekakhir_praktpm/utils/shared_prefs.dart';

class UserPresenter extends ChangeNotifier {
  UserPresenter();

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<void> register(User user) async {
    try {
      await SharedPrefsService().init();

      final usersJsonStrings = SharedPrefsService().prefs.getStringList('all_registered_users') ?? [];
      List<User> users = usersJsonStrings.map((s) => User.fromJson(jsonDecode(s))).toList();

      if (users.any((u) => u.username == user.username || u.email == user.email)) {
        throw Exception('Username or email already exists.');
      }

      users.add(user);
      final updatedUsersJsonStrings = users.map((u) => jsonEncode(u.toJson())).toList();
      await SharedPrefsService().prefs.setStringList('all_registered_users', updatedUsersJsonStrings);

      await SharedPrefsService().saveUser(user);
      _currentUser = user;
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      await SharedPrefsService().init();
      final usersJsonStrings = SharedPrefsService().prefs.getStringList('all_registered_users') ?? [];
      final List<User> users = usersJsonStrings.map((s) => User.fromJson(jsonDecode(s))).toList();

      User? foundUser;
      for (var user in users) {
        if (user.email == email && user.password == password) {
          foundUser = user;
          break;
        }
      }

      if (foundUser != null) {
        await SharedPrefsService().saveUser(foundUser);
        _currentUser = foundUser;
        notifyListeners();
        return foundUser;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await SharedPrefsService().logout();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<User?> getLoggedInUser() async {
    try {
      await SharedPrefsService().init();
      _currentUser = await SharedPrefsService().getCurrentUser();
      return _currentUser;
    } catch (e) {
      print('Error getting logged in user: $e');
      return null;
    }
  }
}