import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Demo data
  static const _demoGroups = [
    {'name': 'Nongkrong Jumat', 'members': 5, 'balance': -45000.0},
    {'name': 'Kos Gang Mangga', 'members': 4, 'balance': 12000.0},
    {'name': 'Road Trip Bandung', 'members': 7, 'balance': 0.0},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/mascot.png', height: 32),
            const SizedBox(width: 8),
            const Text('SplitMind'),
          ],
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary,
              child: Icon(Icons.person, size: 18, color: Colors.white),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _demoGroups.isEmpty ? _buildEmptyState(context) : _buildGroupList(context),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateGroupDialog(context),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.group_add),
        label: const Text('New Group'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty_no_groups.png', height: 180),
            const SizedBox(height: 24),
            Text(
              'No groups yet',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Create a group to start splitting bills with friends!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupList(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _demoGroups.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final group = _demoGroups[index];
        final balance = group['balance'] as double;
        return _GroupCard(
          name: group['name'] as String,
          memberCount: group['members'] as int,
          balance: balance,
          onTap: () => context.push('/group-detail'),
        );
      },
    );
  }

  void _showCreateGroupDialog(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Create New Group', style: Theme.of(ctx).textTheme.headlineMedium),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Group name (e.g., Nongkrong Jumat)',
                prefixIcon: Icon(Icons.group),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                // TODO: Wire with CreateGroup use case
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  final String name;
  final int memberCount;
  final double balance;
  final VoidCallback onTap;

  const _GroupCard({
    required this.name,
    required this.memberCount,
    required this.balance,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color balanceColor;
    String balanceLabel;
    IconData balanceIcon;

    if (balance > 0) {
      balanceColor = AppColors.secondary;
      balanceLabel = '+Rp${balance.toStringAsFixed(0)}';
      balanceIcon = Icons.arrow_upward;
    } else if (balance < 0) {
      balanceColor = AppColors.error;
      balanceLabel = '-Rp${balance.abs().toStringAsFixed(0)}';
      balanceIcon = Icons.arrow_downward;
    } else {
      balanceColor = AppColors.textLow;
      balanceLabel = 'Settled ✓';
      balanceIcon = Icons.check_circle_outline;
    }

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Group avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                child: Text(
                  name[0].toUpperCase(),
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Group info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$memberCount members',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLow,
                          ),
                    ),
                  ],
                ),
              ),
              // Balance
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(balanceIcon, size: 16, color: balanceColor),
                  const SizedBox(height: 2),
                  Text(
                    balanceLabel,
                    style: TextStyle(
                      color: balanceColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
