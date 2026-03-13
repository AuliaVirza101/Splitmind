import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/settlement.dart';
import '../models/settlement_model.dart';

class SettlementLocalDatasource {
  final Isar _isar;
  SettlementLocalDatasource(this._isar);

  Future<SettlementModel> createSettlement(Settlement settlement) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final model = SettlementModel()
      ..uid = const Uuid().v4()
      ..groupId = settlement.groupId
      ..fromUserId = settlement.fromUserId
      ..toUserId = settlement.toUserId
      ..amount = settlement.amount
      ..proofImagePath = settlement.proofImagePath
      ..createdAt = settlement.createdAt;

    await _isar.writeTxn(() async {
      await _isar.settlementModels.put(model);
    });
    return model;
  }

  Future<SettlementModel?> confirmSettlement(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final model = await _isar.settlementModels.filter().uidEqualTo(uid).findFirst();
    if (model == null) return null;
    model.confirmedAt = DateTime.now();
    await _isar.writeTxn(() async {
      await _isar.settlementModels.put(model);
    });
    return model;
  }

  Future<List<SettlementModel>> getGroupSettlements(String groupId) async {
    return _isar.settlementModels.filter().groupIdEqualTo(groupId).findAll();
  }
}
