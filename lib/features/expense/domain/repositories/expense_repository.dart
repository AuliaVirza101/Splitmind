import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/expense.dart';

abstract class ExpenseRepository {
  Future<Either<Failure, Expense>> createExpense(Expense expense);
  Future<Either<Failure, List<Expense>>> getGroupExpenses(String groupId);
  Future<Either<Failure, Expense>> getExpenseById(String expenseId);
  Future<Either<Failure, Unit>> deleteExpense(String expenseId);
  Stream<List<Expense>> watchGroupExpenses(String groupId);
}
