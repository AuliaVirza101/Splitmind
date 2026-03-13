import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDatasource localDatasource;

  AuthRepositoryImpl(this.localDatasource);

  @override
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final userModel = await localDatasource.signInWithEmail(email, password);
      return Right(_toEntity(userModel));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    // For demo: auto-login as a mock Google user
    try {
      final userModel = await localDatasource.signInWithEmail(
        'demo@gmail.com',
        'password123',
      );
      return Right(_toEntity(userModel));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final userModel = await localDatasource.getCurrentUser();
      if (userModel == null) {
        return Left(CacheFailure('No user logged in.'));
      }
      return Right(_toEntity(userModel));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    try {
      await localDatasource.signOut();
      return const Right(unit);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  User _toEntity(UserModel model) => User(
        id: model.uid,
        name: model.name,
        email: model.email,
        avatarUrl: model.avatarUrl,
        bankName: model.bankName,
        bankAccountNumber: model.bankAccountNumber,
      );
}
