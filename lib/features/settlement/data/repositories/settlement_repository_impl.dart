import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/settlement.dart';
import '../../domain/repositories/settlement_repository.dart';
import '../datasources/settlement_local_datasource.dart';
import '../models/settlement_model.dart';

class SettlementRepositoryImpl implements SettlementRepository {
  final SettlementLocalDatasource local;
  SettlementRepositoryImpl(this.local);

  @override
  Future<Either<Failure, Settlement>> createSettlement(Settlement settlement) async {
    try {
      final model = await local.createSettlement(settlement);
      return Right(_toEntity(model));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Settlement>> confirmSettlement(String settlementId) async {
    try {
      final model = await local.confirmSettlement(settlementId);
      if (model == null) return Left(CacheFailure('Settlement not found.'));
      return Right(_toEntity(model));
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Settlement>>> getGroupSettlements(String groupId) async {
    try {
      final models = await local.getGroupSettlements(groupId);
      return Right(models.map(_toEntity).toList());
    } catch (e) {
      return Left(LocalDatabaseFailure(e.toString()));
    }
  }

  Settlement _toEntity(SettlementModel m) => Settlement(
        id: m.uid,
        groupId: m.groupId,
        fromUserId: m.fromUserId,
        toUserId: m.toUserId,
        amount: m.amount,
        proofImagePath: m.proofImagePath,
        createdAt: m.createdAt,
        confirmedAt: m.confirmedAt,
      );
}
