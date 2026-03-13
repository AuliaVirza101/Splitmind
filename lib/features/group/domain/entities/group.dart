import 'package:equatable/equatable.dart';

class Group extends Equatable {
  final String id;
  final String name;
  final String? photoUrl;
  final String adminUserId;
  final List<String> memberUserIds;
  final String inviteCode;
  final DateTime createdAt;

  const Group({
    required this.id,
    required this.name,
    this.photoUrl,
    required this.adminUserId,
    required this.memberUserIds,
    required this.inviteCode,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, name, adminUserId, memberUserIds, inviteCode];
}
