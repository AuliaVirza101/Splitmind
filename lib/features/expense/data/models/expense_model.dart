import 'package:hive/hive.dart';

part 'expense_model.g.dart';

@HiveType(typeId: 2)
class ExpenseModel extends HiveObject {
  @HiveField(0)
  late String uid;

  @HiveField(1)
  late String groupId;

  @HiveField(2)
  late String title;

  @HiveField(3)
  late double totalAmount;

  @HiveField(4)
  late String paidByUserId;

  @HiveField(5)
  late String splitModeStr;

  @HiveField(6)
  late List<String> itemsJson;

  @HiveField(7)
  late List<String> splitsJson;

  @HiveField(8)
  String? receiptImagePath;

  @HiveField(9)
  late DateTime createdAt;
}
