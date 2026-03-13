import 'package:isar/isar.dart';

part 'group_model.g.dart';

@collection
class GroupModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  late String name;
  String? photoUrl;

  late String adminUserId;
  late List<String> memberUserIds;
  late String inviteCode;
  late DateTime createdAt;
}
