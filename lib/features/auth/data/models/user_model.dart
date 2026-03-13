import 'package:isar/isar.dart';

part 'user_model.g.dart';

@collection
class UserModel {
  Id id = Isar.autoIncrement; // Auto-incrementing ID for Isar

  @Index(unique: true, replace: true)
  late String uid; // UUID string used within the app logic

  late String name;
  late String email;
  String? avatarUrl;
  
  // Bank Info (Simplified as strings)
  String? bankName;
  String? bankAccountNumber;

  // Timestamps
  late DateTime createdAt;
}
