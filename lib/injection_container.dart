import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
import 'features/settlement/data/models/settlement_model.dart';
import 'features/settlement/data/repositories/settlement_repository_impl.dart';
import 'features/settlement/domain/repositories/settlement_repository.dart';
import 'features/settlement/domain/usecases/settlement_usecases.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ---------------------------------------------------------------------------
  // Hive Database
  // ---------------------------------------------------------------------------
  await Hive.initFlutter();

  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(GroupModelAdapter());
  Hive.registerAdapter(ExpenseModelAdapter());
  Hive.registerAdapter(SettlementModelAdapter());

  final userBox = await Hive.openBox<UserModel>('users');
  final groupBox = await Hive.openBox<GroupModel>('groups');
  final expenseBox = await Hive.openBox<ExpenseModel>('expenses');
  final settlementBox = await Hive.openBox<SettlementModel>('settlements');

  // ---------------------------------------------------------------------------
  // Features - Auth
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => AuthLocalDatasource(userBox));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // ---------------------------------------------------------------------------
  // Features - Group
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => GroupLocalDatasource(groupBox));
  sl.registerLazySingleton<GroupRepository>(() => GroupRepositoryImpl(sl()));
  sl.registerLazySingleton(() => CreateGroup(sl()));
  sl.registerLazySingleton(() => JoinGroup(sl()));
  sl.registerLazySingleton(() => GetUserGroups(sl()));

  // ---------------------------------------------------------------------------
  // Features - Expense & Splitting
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => ExpenseLocalDatasource(expenseBox));
  sl.registerLazySingleton<ExpenseRepository>(() => ExpenseRepositoryImpl(sl()));
  sl.registerLazySingleton(() => CreateExpense(sl()));
  sl.registerLazySingleton(() => GetGroupExpenses(sl()));
  sl.registerLazySingleton(() => DeleteExpense(sl()));
  sl.registerLazySingleton(() => CalculateSplit());
  sl.registerLazySingleton(() => SimplifyDebts());

  // ---------------------------------------------------------------------------
  // Features - Settlement
  // ---------------------------------------------------------------------------
  sl.registerLazySingleton(() => SettlementLocalDatasource(settlementBox));
  sl.registerLazySingleton<SettlementRepository>(() => SettlementRepositoryImpl(sl()));
  sl.registerLazySingleton(() => CreateSettlement(sl()));
  sl.registerLazySingleton(() => ConfirmSettlement(sl()));
  sl.registerLazySingleton(() => GetGroupSettlements(sl()));
}
