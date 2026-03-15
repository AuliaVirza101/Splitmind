import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  late String uid;

  @HiveField(1)
  late String name;

  @HiveField(2)
  late String email;

  @HiveField(3)
  String? avatarUrl;

  @HiveField(4)
  String? bankName;

  @HiveField(5)
  String? bankAccountNumber;

  @HiveField(6)
  late DateTime createdAt;
}
