import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/settlement.dart';

abstract class SettlementRepository {
  Future<Either<Failure, Settlement>> createSettlement(Settlement settlement);
  Future<Either<Failure, Settlement>> confirmSettlement(String settlementId);
  Future<Either<Failure, List<Settlement>>> getGroupSettlements(String groupId);
}
