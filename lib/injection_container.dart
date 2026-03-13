import 'package:get_it/get_it.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/models/user_model.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/auth_usecases.dart';
import 'features/auth/domain/usecases/sign_in_with_email.dart';
import 'features/expense/data/models/expense_model.dart';
import 'features/group/data/models/group_model.dart';
import 'features/settlement/data/models/settlement_model.dart';

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
  // Data sources
  sl.registerLazySingleton(() => AuthLocalDatasource(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => SignInWithEmail(sl()));
  sl.registerLazySingleton(() => GetCurrentUser(sl()));
  sl.registerLazySingleton(() => SignOut(sl()));

  // ---------------------------------------------------------------------------
  // Features - Group (To be wired in Sprint 2)
  // ---------------------------------------------------------------------------

  // ---------------------------------------------------------------------------
  // Features - Expense & Splitting (To be wired in Sprint 2)
  // ---------------------------------------------------------------------------
}
