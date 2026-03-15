import 'dart:async';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';

class AuthLocalDatasource {
  final Box<UserModel> _userBox;
  static const String _mockPassword = 'password123';

  String? _currentUserUid;

  AuthLocalDatasource(this._userBox);

  Future<UserModel> signInWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 700));

    if (password != _mockPassword) {
      throw Exception('Wrong password. Use "password123" for demo.');
    }

    // Find or create user
    UserModel? user;
    for (final u in _userBox.values) {
      if (u.email == email) {
        user = u;
        break;
      }
    }

    if (user == null) {
      user = UserModel()
        ..uid = const Uuid().v4()
        ..name = email.split('@').first
        ..email = email
        ..createdAt = DateTime.now();

      await _userBox.put(user.uid, user);
    }

    _currentUserUid = user.uid;
    return user;
  }

  Future<UserModel?> getCurrentUser() async {
    if (_currentUserUid == null) return null;
    return _userBox.get(_currentUserUid);
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUserUid = null;
  }
}
