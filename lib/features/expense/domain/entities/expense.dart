import 'package:equatable/equatable.dart';

class Expense extends Equatable {
  final String id;
  final String groupId;
  final String title;
  final double totalAmount;
  final String paidByUserId;
  final SplitMode splitMode;
  final List<ExpenseItem> items;
  final List<SplitResult> splits;
  final String? receiptImagePath;
  final DateTime createdAt;

  const Expense({
    required this.id,
    required this.groupId,
    required this.title,
    required this.totalAmount,
    required this.paidByUserId,
    required this.splitMode,
    required this.items,
    required this.splits,
    this.receiptImagePath,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, groupId, title, totalAmount, paidByUserId];
}

enum SplitMode { equal, byItem, percentage, custom }

class ExpenseItem extends Equatable {
  final String id;
  final String name;
  final double price;
  final List<String> assignedToUserIds;

  const ExpenseItem({
    required this.id,
    required this.name,
    required this.price,
    required this.assignedToUserIds,
  });

  @override
  List<Object?> get props => [id, name, price, assignedToUserIds];
}

class SplitResult extends Equatable {
  final String userId;
  final double amount;
  final double paid;

  const SplitResult({
    required this.userId,
    required this.amount,
    required this.paid,
  });

  double get balance => paid - amount; // positive = over-paid, negative = owes

  @override
  List<Object?> get props => [userId, amount, paid];
}

class Balance extends Equatable {
  final String fromUserId;
  final String toUserId;
  final double amount;

  const Balance({
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
  });

  @override
  List<Object?> get props => [fromUserId, toUserId, amount];
}
