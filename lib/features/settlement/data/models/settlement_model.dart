import 'package:isar/isar.dart';

part 'settlement_model.g.dart';

@collection
class SettlementModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  late String groupId;
  late String fromUserId;
  late String toUserId;
  late double amount;
  String? proofImagePath; // local file path

  late DateTime createdAt;
  DateTime? confirmedAt; // null = not yet confirmed
}
