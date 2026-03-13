import 'dart:convert';

import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/expense.dart';
import '../../domain/repositories/expense_repository.dart';
import '../datasources/expense_local_datasource.dart';
import '../models/expense_model.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDatasource local;
  ExpenseRepositoryImpl(this.local);

  @override
  Future<Either<Failure, Expense>> createExpense(Expense expense) async {
    try {
      final model = await local.createExpense(expense);
      return Right(_toEntity(model));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Expense>>> getGroupExpenses(String groupId) async {
    try {
      final models = await local.getGroupExpenses(groupId);
      return Right(models.map(_toEntity).toList());
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Expense>> getExpenseById(String expenseId) async {
    try {
      final model = await local.getExpenseById(expenseId);
      if (model == null) return Left(CacheFailure('Expense not found.'));
      return Right(_toEntity(model));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExpense(String expenseId) async {
    try {
      await local.deleteExpense(expenseId);
      return Right(unit);
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Stream<List<Expense>> watchGroupExpenses(String groupId) {
    return local.watchGroupExpenses(groupId).map(
          (models) => models.map(_toEntity).toList(),
        );
  }

  Expense _toEntity(ExpenseModel m) {
    final items = m.itemsJson.map((j) {
      final map = jsonDecode(j) as Map<String, dynamic>;
      return ExpenseItem(
        id: map['id'] as String,
        name: map['name'] as String,
        price: (map['price'] as num).toDouble(),
        assignedToUserIds: List<String>.from(map['assignedToUserIds'] as List),
      );
    }).toList();

    final splits = m.splitsJson.map((j) {
      final map = jsonDecode(j) as Map<String, dynamic>;
      return SplitResult(
        userId: map['userId'] as String,
        amount: (map['amount'] as num).toDouble(),
        paid: (map['paid'] as num).toDouble(),
      );
    }).toList();

    return Expense(
      id: m.uid,
      groupId: m.groupId,
      title: m.title,
      totalAmount: m.totalAmount,
      paidByUserId: m.paidByUserId,
      splitMode: SplitMode.values.firstWhere((e) => e.name == m.splitModeStr),
      items: items,
      splits: splits,
      receiptImagePath: m.receiptImagePath,
      createdAt: m.createdAt,
    );
  }
}
