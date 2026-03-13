import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class GroupDetailPage extends StatelessWidget {
  const GroupDetailPage({super.key});

  // Demo data
  static const _demoExpenses = [
    {'title': 'Makan Siang di Padang', 'amount': 185000.0, 'paidBy': 'Virza', 'date': '12 Mar'},
    {'title': 'Es Kopi', 'amount': 75000.0, 'paidBy': 'Andi', 'date': '12 Mar'},
    {'title': 'Grab ke Mall', 'amount': 45000.0, 'paidBy': 'Sari', 'date': '11 Mar'},
  ];

  static const _demoBalances = [
    {'from': 'Andi', 'to': 'Virza', 'amount': 32000.0},
    {'from': 'Sari', 'to': 'Virza', 'amount': 18000.0},
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nongkrong Jumat'),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_outlined),
              onPressed: () => _showInviteDialog(context),
            ),
          ],
          bottom: const TabBar(
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textLow,
            indicatorColor: AppColors.primary,
            tabs: [
              Tab(text: 'Expenses', icon: Icon(Icons.receipt_long, size: 20)),
              Tab(text: 'Balances', icon: Icon(Icons.balance, size: 20)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildExpenseTab(context),
            _buildBalanceTab(context),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => context.push('/add-expense'),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: const Text('Add Expense'),
        ),
      ),
    );
  }

  Widget _buildExpenseTab(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _demoExpenses.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final e = _demoExpenses[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: const Icon(Icons.receipt, color: AppColors.primary),
            ),
            title: Text(e['title'] as String, style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text('Paid by ${e['paidBy']} · ${e['date']}',
                style: Theme.of(context).textTheme.bodyMedium),
            trailing: Text(
              'Rp${(e['amount'] as double).toStringAsFixed(0)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBalanceTab(BuildContext context) {
    if (_demoBalances.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty_all_settled.png', height: 160),
            const SizedBox(height: 16),
            Text('All settled! 🎉', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text('No outstanding debts in this group.',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary card
        Card(
          color: AppColors.primary.withOpacity(0.05),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const Icon(Icons.auto_awesome, color: AppColors.primary, size: 28),
                const SizedBox(height: 8),
                Text('Simplified Debts', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  '${_demoBalances.length} transactions to settle everything',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textLow),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Balance list
        ..._demoBalances.map((b) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFEE2E2),
                    child: Icon(Icons.arrow_forward, color: AppColors.error),
                  ),
                  title: Text('${b['from']} → ${b['to']}'),
                  trailing: Text(
                    'Rp${(b['amount'] as double).toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onTap: () {
                    // TODO: Settle up flow
                  },
                ),
              ),
            )),
      ],
    );
  }

  void _showInviteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Invite Friends'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Share this code with your friends:'),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'ABC123',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  letterSpacing: 4,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(ctx),
            icon: const Icon(Icons.copy, size: 18),
            label: const Text('Copy'),
          ),
        ],
      ),
    );
  }
}
