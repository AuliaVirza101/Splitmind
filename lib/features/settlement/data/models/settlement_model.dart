import 'package:hive/hive.dart';

part 'settlement_model.g.dart';

@HiveType(typeId: 3)
class SettlementModel extends HiveObject {
  @HiveField(0)
  late String uid;

  @HiveField(1)
  late String groupId;

  @HiveField(2)
  late String fromUserId;

  @HiveField(3)
  late String toUserId;

  @HiveField(4)
  late double amount;

  @HiveField(5)
  String? proofImagePath;

  @HiveField(6)
  late DateTime createdAt;

  @HiveField(7)
  DateTime? confirmedAt;
}
