import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/group.dart';
import '../../domain/repositories/group_repository.dart';
import '../datasources/group_local_datasource.dart';
import '../models/group_model.dart';

class GroupRepositoryImpl implements GroupRepository {
  final GroupLocalDatasource local;
  GroupRepositoryImpl(this.local);

  @override
  Future<Either<Failure, Group>> createGroup({
    required String name,
    required String adminUserId,
    String? photoUrl,
  }) async {
    try {
      final model = await local.createGroup(
        name: name,
        adminUserId: adminUserId,
        photoUrl: photoUrl,
      );
      return Right(_toEntity(model));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Group>> joinGroup({
    required String inviteCode,
    required String userId,
  }) async {
    try {
      final model = await local.joinGroup(inviteCode: inviteCode, userId: userId);
      if (model == null) return Left(ServerFailure('Invalid invite code.'));
      return Right(_toEntity(model));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Group>>> getUserGroups(String userId) async {
    try {
      final models = await local.getUserGroups(userId);
      return Right(models.map(_toEntity).toList());
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Group>> getGroupById(String groupId) async {
    try {
      final model = await local.getGroupById(groupId);
      if (model == null) return Left(CacheFailure('Group not found.'));
      return Right(_toEntity(model));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  Group _toEntity(GroupModel m) => Group(
        id: m.uid,
        name: m.name,
        photoUrl: m.photoUrl,
        adminUserId: m.adminUserId,
        memberUserIds: m.memberUserIds,
        inviteCode: m.inviteCode,
        createdAt: m.createdAt,
      );
}
