import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/settlement.dart';
import '../models/settlement_model.dart';

class SettlementLocalDatasource {
  final Box<SettlementModel> _settlementBox;
  SettlementLocalDatasource(this._settlementBox);

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

    await _settlementBox.put(model.uid, model);
    return model;
  }

  Future<SettlementModel?> confirmSettlement(String uid) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final model = _settlementBox.get(uid);
    if (model == null) return null;
    model.confirmedAt = DateTime.now();
    await model.save();
    return model;
  }

  Future<List<SettlementModel>> getGroupSettlements(String groupId) async {
    return _settlementBox.values.where((s) => s.groupId == groupId).toList();
  }
}
