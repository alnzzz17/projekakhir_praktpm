import 'package:shared_preferences/shared_preferences.dart';

import 'package:projekakhir_praktpm/models/user_model.dart';

class UserPresenter {
  final SharedPreferences prefs;

  UserPresenter(this.prefs);

  Future<bool> register(User user) async {
    try {
      // Simpan user ke SharedPreferences
      final users = prefs.getStringList('users') ?? [];
      users.add(user.toMap().toString());
      await prefs.setStringList('users', users);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<User?> login(String email, String password) async {
    final users = prefs.getStringList('users') ?? [];
    for (var userString in users) {
      final userMap = Map<String, dynamic>.from(userString as Map);
      final user = User.fromMap(userMap);
      if (user.email == email && user.password == password) {
        // Simpan status login
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('currentUserId', user.id);
        await prefs.setString('currentUsername', user.username);
        return user;
      }
    }
    return null;
  }

  Future<bool> logout() async {
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('currentUserId');
    await prefs.remove('currentUsername');
    return true;
  }

  Future<bool> isLoggedIn() async {
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<String?> getCurrentUserId() async {
    return prefs.getString('currentUserId');
  }

  Future<String?> getCurrentUsername() async {
    return prefs.getString('currentUsername');
  }
}