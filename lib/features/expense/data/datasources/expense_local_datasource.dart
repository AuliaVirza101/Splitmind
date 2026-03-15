import 'dart:async';
import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/expense.dart';
import '../models/expense_model.dart';

class ExpenseLocalDatasource {
  final Box<ExpenseModel> _expenseBox;
  ExpenseLocalDatasource(this._expenseBox);

  Future<ExpenseModel> createExpense(Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final model = _toModel(expense);
    await _expenseBox.put(model.uid, model);
    return model;
  }

  Future<List<ExpenseModel>> getGroupExpenses(String groupId) async {
    return _expenseBox.values.where((e) => e.groupId == groupId).toList();
  }

  Future<ExpenseModel?> getExpenseById(String uid) async {
    return _expenseBox.get(uid);
  }

  Future<void> deleteExpense(String uid) async {
    await _expenseBox.delete(uid);
  }

  Stream<List<ExpenseModel>> watchGroupExpenses(String groupId) {
    // Hive listenable emits on any change to the box
    return _expenseBox.watch().map((_) {
      return _expenseBox.values.where((e) => e.groupId == groupId).toList();
    });
  }

  ExpenseModel _toModel(Expense e) {
    return ExpenseModel()
      ..uid = e.id.isEmpty ? const Uuid().v4() : e.id
      ..groupId = e.groupId
      ..title = e.title
      ..totalAmount = e.totalAmount
      ..paidByUserId = e.paidByUserId
      ..splitModeStr = e.splitMode.name
      ..itemsJson = e.items
          .map((item) => jsonEncode({
                'id': item.id,
                'name': item.name,
                'price': item.price,
                'assignedToUserIds': item.assignedToUserIds,
              }))
          .toList()
      ..splitsJson = e.splits
          .map((s) => jsonEncode({
                'userId': s.userId,
                'amount': s.amount,
                'paid': s.paid,
              }))
          .toList()
      ..receiptImagePath = e.receiptImagePath
      ..createdAt = e.createdAt;
  }
}
