import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';
import '../models/user.dart';
import 'post_service.dart';

// ENHANCEMENT 1: signs in against the API and keeps the user on the device.
class UserService {
  static const _stringKeys = [
    'username',
    'email',
    'firstName',
    'lastName',
    'gender',
    'image',
    'accessToken',
    'refreshToken',
  ];

  // Posts the credentials to /auth/login and saves the user that comes back.
  Future<User> loginUser(String username, String password) async {
    final response = await http.post(
      Uri.parse('$host/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 60,
      }),
    );

    if (response.statusCode == 200) {
      final user = User.fromJson(jsonDecode(response.body));
      await saveUserData(user);
      return user;
    }

    // A bad login answers {"message": "Invalid credentials"}; show that.
    String message = 'Login failed';
    try {
      message = jsonDecode(response.body)['message'] ?? message;
    } catch (_) {}
    throw Exception(message);
  }

  // Writes each field of the user into SharedPreferences.
  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('id', user.id);
    await prefs.setString('username', user.username);
    await prefs.setString('email', user.email);
    await prefs.setString('firstName', user.firstName);
    await prefs.setString('lastName', user.lastName);
    await prefs.setString('gender', user.gender);
    await prefs.setString('image', user.image);
    await prefs.setString('accessToken', user.accessToken);
    await prefs.setString('refreshToken', user.refreshToken);
  }

  // Reads the saved fields back as a map User.fromJson understands.
  Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'id': prefs.getInt('id') ?? 0,
      for (final key in _stringKeys) key: prefs.getString(key) ?? '',
    };
  }

  // The saved user as a model.
  Future<User> getUser() async => User.fromJson(await getUserData());

  // True while an access token is on the device.
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getString('accessToken') ?? '').isNotEmpty;
  }

  // ENHANCEMENT 2: forgets the session, but not the theme preference.
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in ['id', ..._stringKeys, 'likedPosts']) {
      await prefs.remove(key);
    }
    PostService.likedIds.clear();
  }

  // Every user keyed by id, so the feed gets its names and avatars in one call.
  Future<Map<int, User>> getUsers() async {
    final uri = Uri.parse(
      '$host/users?limit=0&select=id,username,firstName,lastName,image',
    );
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List usersJson = jsonDecode(response.body)['users'] ?? [];
      return {for (final u in usersJson) u['id'] as int: User.fromJson(u)};
    }
    throw Exception('Failed to load users: ${response.statusCode}');
  }
}
