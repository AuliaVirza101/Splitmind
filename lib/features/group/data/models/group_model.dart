import 'package:hive/hive.dart';

part 'group_model.g.dart';

@HiveType(typeId: 1)
class GroupModel extends HiveObject {
  @HiveField(0)
  late String uid;

  @HiveField(1)
  late String name;

  @HiveField(2)
  String? photoUrl;

  @HiveField(3)
  late String adminUserId;

  @HiveField(4)
  late List<String> memberUserIds;

  @HiveField(5)
  late String inviteCode;

  @HiveField(6)
  late DateTime createdAt;
}
