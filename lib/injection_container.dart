import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/models/user_model.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/domain/usecases/sign_in_with_email.dart';
import 'features/expense/data/datasources/expense_local_datasource.dart';
import 'features/expense/data/models/expense_model.dart';
import 'features/expense/data/repositories/expense_repository_impl.dart';
import 'features/expense/domain/repositories/expense_repository.dart';
import 'features/expense/domain/usecases/expense_usecases.dart';
import 'features/group/data/datasources/group_local_datasource.dart';
import 'features/group/data/models/group_model.dart';
import 'features/group/data/repositories/group_repository_impl.dart';
import 'features/group/domain/repositories/group_repository.dart';
import 'features/group/domain/usecases/group_usecases.dart';
import 'features/settlement/data/datasources/settlement_local_datasource.dart';
import 'features/settlement/data/repositories/settlement_repository_impl.dart';
import 'features/settlement/domain/repositories/settlement_repository.dart';
import 'features/settlement/domain/usecases/settlement_usecases.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ---------------------------------------------------------------------------
  // Isar Database
  // ---------------------------------------------------------------------------
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [
      UserModelSchema,
      GroupModelSchema,
      ExpenseModelSchema,
      SettlementModelSchema,
    ],
    directory: dir.path,
  );
  sl.registerSingleton<Isar>(isar);

  // ---------------------------------------------------------------------------
  // Features - Auth
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => AuthLocalDatasource(sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // ---------------------------------------------------------------------------
  // Features - Group
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => GroupLocalDatasource(sl()));
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl(sl()));
  sl.registerLazySingleton(() => CreateGroup(sl()));
  sl.registerLazySingleton(() => JoinGroup(sl()));
  sl.registerLazySingleton(() => GetUserGroups(sl()));

  // ---------------------------------------------------------------------------
  // Features - Expense & Splitting
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => ExpenseLocalDatasource(sl()));
  sl.registerLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(sl()));
  sl.registerLazySingleton(() => CreateExpense(sl()));
  sl.registerLazySingleton(() => GetGroupExpenses(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
  sl.registerLazySingleton(() => CalculateSplit());
  sl.registerLazySingleton(() => SimplifyDebts());

  // ---------------------------------------------------------------------------
  // Features - Settlement
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => SettlementLocalDatasource(sl()));
  sl.registerLazySingleton<SettlementRepository>(() => SettlementRepositoryImpl(sl()));
  sl.registerLazySingleton(() => CreateSettlement(sl()));
  sl.registerLazySingleton(() => ConfirmSettlement(sl()));
  sl.registerLazySingleton(() => GetGroupSettlements(sl()));
}
