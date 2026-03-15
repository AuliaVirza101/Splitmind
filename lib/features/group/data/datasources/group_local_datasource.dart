import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../models/group_model.dart';

class GroupLocalDatasource {
  final Box<GroupModel> _groupBox;
  GroupLocalDatasource(this._groupBox);

  Future<GroupModel> createGroup({
    required String name,
    required String adminUserId,
    String? photoUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final group = GroupModel()
      ..uid = const Uuid().v4()
      ..name = name
      ..adminUserId = adminUserId
      ..memberUserIds = [adminUserId]
      ..inviteCode = _generateCode()
      ..photoUrl = photoUrl
      ..createdAt = DateTime.now();

    await _groupBox.put(group.uid, group);
    return group;
  }

  Future<GroupModel?> joinGroup({required String inviteCode, required String userId}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    GroupModel? group;
    for (final g in _groupBox.values) {
      if (g.inviteCode == inviteCode) {
        group = g;
        break;
      }
    }
    if (group == null) return null;

    if (!group.memberUserIds.contains(userId)) {
      group.memberUserIds = [...group.memberUserIds, userId];
      await group.save();
    }
    return group;
  }

  Future<List<GroupModel>> getUserGroups(String userId) async {
    return _groupBox.values.where((g) => g.memberUserIds.contains(userId)).toList();
  }

  Future<GroupModel?> getGroupById(String groupId) async {
    return _groupBox.get(groupId);
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = DateTime.now().millisecondsSinceEpoch;
    return List.generate(6, (i) => chars[(rand ~/ (i + 1)) % chars.length]).join();
  }
}
