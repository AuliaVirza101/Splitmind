import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/settlement.dart';
import '../repositories/settlement_repository.dart';

class CreateSettlement implements UseCase<Settlement, Settlement> {
  final SettlementRepository repository;
  CreateSettlement(this.repository);
  @override
  Future<Either<Failure, Settlement>> call(Settlement params) =>
      repository.createSettlement(params);
}

class ConfirmSettlement implements UseCase<Settlement, String> {
  final SettlementRepository repository;
  ConfirmSettlement(this.repository);
  @override
  Future<Either<Failure, Settlement>> call(String settlementId) =>
      repository.confirmSettlement(settlementId);
}

class GetGroupSettlements implements UseCase<List<Settlement>, String> {
  final SettlementRepository repository;
  GetGroupSettlements(this.repository);
  @override
  Future<Either<Failure, List<Settlement>>> call(String groupId) =>
      repository.getGroupSettlements(groupId);
}
