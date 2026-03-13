import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/group.dart';
import '../repositories/group_repository.dart';

// ─────────────────────────────────────────────
// CreateGroup
// ─────────────────────────────────────────────
class CreateGroup implements UseCase<Group, CreateGroupParams> {
  final GroupRepository repository;
  CreateGroup(this.repository);

  @override
  Future<Either<Failure, Group>> call(CreateGroupParams params) =>
      repository.createGroup(
        name: params.name,
        adminUserId: params.adminUserId,
        photoUrl: params.photoUrl,
      );
}

class CreateGroupParams {
  final String name;
  final String adminUserId;
  final String? photoUrl;
  const CreateGroupParams({required this.name, required this.adminUserId, this.photoUrl});
}

// ─────────────────────────────────────────────
// JoinGroup
// ─────────────────────────────────────────────
class JoinGroup implements UseCase<Group, JoinGroupParams> {
  final GroupRepository repository;
  JoinGroup(this.repository);

  @override
  Future<Either<Failure, Group>> call(JoinGroupParams params) =>
      repository.joinGroup(inviteCode: params.inviteCode, userId: params.userId);
}

class JoinGroupParams {
  final String inviteCode;
  final String userId;
  const JoinGroupParams({required this.inviteCode, required this.userId});
}

// ─────────────────────────────────────────────
// GetUserGroups
// ─────────────────────────────────────────────
class GetUserGroups implements UseCase<List<Group>, String> {
  final GroupRepository repository;
  GetUserGroups(this.repository);

  @override
  Future<Either<Failure, List<Group>>> call(String userId) =>
      repository.getUserGroups(userId);
}
