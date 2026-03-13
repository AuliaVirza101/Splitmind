import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../models/group_model.dart';

class GroupLocalDatasource {
  final Isar _isar;
  GroupLocalDatasource(this._isar);

  Future<GroupModel> createGroup({
    required String name,
    required String adminUserId,
    String? photoUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500)); // simulated delay

    final group = GroupModel()
      ..uid = const Uuid().v4()
      ..name = name
      ..adminUserId = adminUserId
      ..memberUserIds = [adminUserId]
      ..inviteCode = _generateCode()
      ..photoUrl = photoUrl
      ..createdAt = DateTime.now();

    await _isar.writeTxn(() async {
      await _isar.groupModels.put(group);
    });

    return group;
  }

  Future<GroupModel?> joinGroup({required String inviteCode, required String userId}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final group = await _isar.groupModels.filter().inviteCodeEqualTo(inviteCode).findFirst();
    if (group == null) return null;

    if (!group.memberUserIds.contains(userId)) {
      group.memberUserIds = [...group.memberUserIds, userId];
      await _isar.writeTxn(() async {
        await _isar.groupModels.put(group);
      });
    }
    return group;
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    return _isar.groupModels.filter().memberUserIdsElementEqualTo(userId).findAll();
  }

  Future<GroupModel?> getGroupById(String groupId) async {
    return _isar.groupModels.filter().uidEqualTo(groupId).findFirst();
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = DateTime.now().millisecondsSinceEpoch;
    return List.generate(6, (i) => chars[(rand ~/ (i + 1)) % chars.length]).join();
  }
}
