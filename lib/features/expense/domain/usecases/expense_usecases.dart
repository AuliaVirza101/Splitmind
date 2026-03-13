import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/expense.dart';
import '../repositories/expense_repository.dart';

// ─────────────────────────────────────────────
// CreateExpense
// ─────────────────────────────────────────────
class CreateExpense implements UseCase<Expense, Expense> {
  final ExpenseRepository repository;
  CreateExpense(this.repository);

  @override
  Future<Either<Failure, Expense>> call(Expense params) =>
      repository.createExpense(params);
}

// ─────────────────────────────────────────────
// GetGroupExpenses
// ─────────────────────────────────────────────
class GetGroupExpenses implements UseCase<List<Expense>, String> {
  final ExpenseRepository repository;
  GetGroupExpenses(this.repository);

  @override
  Future<Either<Failure, List<Expense>>> call(String groupId) =>
      repository.getGroupExpenses(groupId);
}

// ─────────────────────────────────────────────
// DeleteExpense
// ─────────────────────────────────────────────
class DeleteExpense implements UseCase<Unit, String> {
  final ExpenseRepository repository;
  DeleteExpense(this.repository);

  @override
  Future<Either<Failure, Unit>> call(String expenseId) =>
      repository.deleteExpense(expenseId);
}

// ─────────────────────────────────────────────
// CalculateSplit ⭐ Core Algorithm
// ─────────────────────────────────────────────
class CalculateSplit {
  List<SplitResult> call({
    required Expense expense,
    required List<String> memberIds,
  }) {
    switch (expense.splitMode) {
      case SplitMode.equal:
        return _equalSplit(expense, memberIds);
      case SplitMode.byItem:
        return _byItemSplit(expense);
      case SplitMode.percentage:
      case SplitMode.custom:
        // Already calculated in splits list
        return expense.splits;
    }
  }

  List<SplitResult> _equalSplit(Expense expense, List<String> memberIds) {
    if (memberIds.isEmpty) return [];
    final perPerson = expense.totalAmount / memberIds.length;
    return memberIds.map((userId) {
      final paid = userId == expense.paidByUserId ? expense.totalAmount : 0.0;
      return SplitResult(userId: userId, amount: double.parse(perPerson.toStringAsFixed(2)), paid: paid);
    }).toList();
  }

  List<SplitResult> _byItemSplit(Expense expense) {
    final Map<String, double> owedMap = {};
    for (final item in expense.items) {
      if (item.assignedToUserIds.isEmpty) continue;
      final perUser = item.price / item.assignedToUserIds.length;
      for (final uid in item.assignedToUserIds) {
        owedMap[uid] = (owedMap[uid] ?? 0) + perUser;
      }
    }
    return owedMap.entries.map((e) {
      final paid = e.key == expense.paidByUserId ? expense.totalAmount : 0.0;
      return SplitResult(userId: e.key, amount: double.parse(e.value.toStringAsFixed(2)), paid: paid);
    }).toList();
  }
}

// ─────────────────────────────────────────────
// SimplifyDebts ⭐⭐ Min-Cash-Flow Algorithm
// ─────────────────────────────────────────────
class SimplifyDebts {
  List<Balance> call(List<Balance> rawDebts) {
    // Compute net balance per user
    final Map<String, double> net = {};
    for (final debt in rawDebts) {
      net[debt.fromUserId] = (net[debt.fromUserId] ?? 0) - debt.amount;
      net[debt.toUserId] = (net[debt.toUserId] ?? 0) + debt.amount;
    }

    final debtors = net.entries.where((e) => e.value < -0.01).toList()
      ..sort((a, b) => a.value.compareTo(b.value)); // most negative first
    final creditors = net.entries.where((e) => e.value > 0.01).toList()
      ..sort((a, b) => b.value.compareTo(a.value)); // most positive first

    final result = <Balance>[];
    int d = 0, c = 0;
    final debtorAmounts = debtors.map((e) => e.value.abs()).toList();
    final creditorAmounts = creditors.map((e) => e.value).toList();

    while (d < debtors.length && c < creditors.length) {
      final settle = debtorAmounts[d] < creditorAmounts[c]
          ? debtorAmounts[d]
          : creditorAmounts[c];

      result.add(Balance(
        fromUserId: debtors[d].key,
        toUserId: creditors[c].key,
        amount: double.parse(settle.toStringAsFixed(2)),
      ));

      debtorAmounts[d] -= settle;
      creditorAmounts[c] -= settle;

      if (debtorAmounts[d] < 0.01) d++;
      if (creditorAmounts[c] < 0.01) c++;
    }

    return result;
  }
}
