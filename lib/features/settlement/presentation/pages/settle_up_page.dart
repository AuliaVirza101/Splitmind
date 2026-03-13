import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';

class SettleUpPage extends StatefulWidget {
  final String fromUser;
  final String toUser;
  final double amount;

  const SettleUpPage({
    super.key,
    this.fromUser = 'Andi',
    this.toUser = 'Virza',
    this.amount = 32000,
  });

  @override
  State<SettleUpPage> createState() => _SettleUpPageState();
}

class _SettleUpPageState extends State<SettleUpPage> {
  bool _isLoading = false;
  bool _isConfirmed = false;

  Future<void> _handleSettle() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _isConfirmed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settle Up')),
      body: _isConfirmed ? _buildSuccessState(context) : _buildSettleForm(context),
    );
  }

  Widget _buildSettleForm(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary card
          Card(
            color: AppColors.primary.withOpacity(0.05),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.primary.withOpacity(0.15),
                    child: Text(
                      widget.fromUser[0],
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('${widget.fromUser} owes ${widget.toUser}',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Rp${widget.amount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Payment method info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance, color: AppColors.primary),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Transfer to', style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      '${widget.toUser} · BCA 1234567890',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Proof upload
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Payment Proof (Optional)'),
          ),
          const Spacer(),

          // Confirm button
          ElevatedButton(
            onPressed: _isLoading ? null : _handleSettle,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
            ),
            child: _isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Text('Mark as Paid'),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildSuccessState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/empty_all_settled.png', height: 200),
            const SizedBox(height: 24),
            Text(
              'Payment Marked! 🎉',
              style: Theme.of(context).textTheme.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Waiting for ${widget.toUser} to confirm.',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: AppColors.textLow),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => context.go('/home'),
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
