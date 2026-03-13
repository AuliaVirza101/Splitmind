import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/group.dart';

abstract class GroupRepository {
  Future<Either<Failure, Group>> createGroup({
    required String name,
    required String adminUserId,
    String? photoUrl,
  });

  Future<Either<Failure, Group>> joinGroup({
    required String inviteCode,
    required String userId,
  });

  Future<Either<Failure, List<Group>>> getUserGroups(String userId);

  Future<Either<Failure, Group>> getGroupById(String groupId);
}
