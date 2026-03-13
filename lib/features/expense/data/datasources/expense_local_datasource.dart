import 'dart:convert';

import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/expense.dart';
import '../models/expense_model.dart';

class ExpenseLocalDatasource {
  final Isar _isar;
  ExpenseLocalDatasource(this._isar);

  Future<ExpenseModel> createExpense(Expense expense) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final model = _toModel(expense);
    await _isar.writeTxn(() async {
      await _isar.expenseModels.put(model);
    });
    return model;
  }

  Future<List<ExpenseModel>> getGroupExpenses(String groupId) async {
    return _isar.expenseModels.filter().groupIdEqualTo(groupId).findAll();
  }

  Future<ExpenseModel?> getExpenseById(String uid) async {
    return _isar.expenseModels.filter().uidEqualTo(uid).findFirst();
  }

  Future<void> deleteExpense(String uid) async {
    await _isar.writeTxn(() async {
      final model = await _isar.expenseModels.filter().uidEqualTo(uid).findFirst();
      if (model != null) await _isar.expenseModels.delete(model.id);
    });
  }

  Stream<List<ExpenseModel>> watchGroupExpenses(String groupId) {
    return _isar.expenseModels
        .filter()
        .groupIdEqualTo(groupId)
        .watch(fireImmediately: true);
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
