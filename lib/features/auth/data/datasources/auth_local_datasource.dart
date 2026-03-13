import 'dart:async';

import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../models/user_model.dart';

/// Simulates authentication via local Isar DB.
/// No remote server or Firebase involved.
class AuthLocalDatasource {
  final Isar _isar;
  static const String _mockPassword = 'password123';

  // Holds the currently logged-in user's UID
  String? _currentUserUid;

  AuthLocalDatasource(this._isar);

  Future<UserModel> signInWithEmail(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 700));

    if (password != _mockPassword) {
      throw Exception('Wrong password. Use "password123" for demo.');
    }

    // Find or create user
    UserModel? user = await _isar.userModels.filter().emailEqualTo(email).findFirst();

    if (user == null) {
      // Auto-register new user
      user = UserModel()
        ..uid = const Uuid().v4()
        ..name = email.split('@').first
        ..email = email
        ..createdAt = DateTime.now();

      await _isar.writeTxn(() async {
        await _isar.userModels.put(user!);
      });
    }

    _currentUserUid = user.uid;
    return user;
  }

  Future<UserModel?> getCurrentUser() async {
    if (_currentUserUid == null) return null;
    return _isar.userModels.filter().uidEqualTo(_currentUserUid!).findFirst();
  }

  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUserUid = null;
  }
}
