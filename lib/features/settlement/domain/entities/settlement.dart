import 'package:equatable/equatable.dart';

class Settlement extends Equatable {
  final String id;
  final String groupId;
  final String fromUserId;
  final String toUserId;
  final double amount;
  final String? proofImagePath;
  final DateTime createdAt;
  final DateTime? confirmedAt;

  const Settlement({
    required this.id,
    required this.groupId,
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    this.proofImagePath,
    required this.createdAt,
    this.confirmedAt,
  });

  bool get isConfirmed => confirmedAt != null;

  @override
  List<Object?> get props => [id, fromUserId, toUserId, amount, confirmedAt];
}
