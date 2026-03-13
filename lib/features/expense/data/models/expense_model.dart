import 'package:isar/isar.dart';

part 'expense_model.g.dart';

enum SplitMode { equal, byItem, percentage, custom }

@collection
class ExpenseModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String uid;

  late String groupId;
  late String title;
  late double totalAmount;
  late String paidByUserId;
  late String splitModeStr; // Store enum as string
  
  late List<String> itemsJson;   // JSON-encoded List<ItemModel>
  late List<String> splitsJson;  // JSON-encoded List<SplitResultModel>
  
  String? receiptImagePath; // local file path
  late DateTime createdAt;
}

@embedded
class ItemData {
  late String id;
  late String name;
  late double price;
  late List<String> assignedToUserIds;
}

@embedded
class SplitData {
  late String userId;
  late double amount;
  late double paid;
}
