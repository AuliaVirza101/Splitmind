import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analytics & Insights')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Total spending header
          _SummaryCard(context),
          const SizedBox(height: 20),

          // Spending breakdown title
          Text('This Month\'s Breakdown', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          _CategoryBars(context),
          const SizedBox(height: 20),

          // Leaderboard
          Text('Who Treats the Most 👑', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          _Leaderboard(context),
          const SizedBox(height: 20),

          // AI Insight card
          _AIInsightCard(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _SummaryCard(BuildContext context) {
    return Card(
      color: AppColors.primary.withOpacity(0.08),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const Icon(Icons.bar_chart_rounded, color: AppColors.primary, size: 32),
          const SizedBox(height: 8),
          Text('Total Group Spending', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(
            'Rp1.250.000',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                ),
          ),
          Text('March 2026', style: Theme.of(context).textTheme.bodyMedium),
        ]),
      ),
    );
  }

  Widget _CategoryBars(BuildContext context) {
    final categories = [
      {'label': '🍔 Food', 'pct': 0.65, 'amount': 'Rp812.500'},
      {'label': '🚗 Transport', 'pct': 0.20, 'amount': 'Rp250.000'},
      {'label': '🍿 Entertainment', 'pct': 0.10, 'amount': 'Rp125.000'},
      {'label': '🛍️ Shopping', 'pct': 0.05, 'amount': 'Rp62.500'},
    ];

    return Column(
      children: categories.map((cat) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(cat['label'] as String,
                      style: Theme.of(context).textTheme.bodyMedium),
                  Text(cat['amount'] as String,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(99),
                child: LinearProgressIndicator(
                  value: cat['pct'] as double,
                  minHeight: 8,
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _Leaderboard(BuildContext context) {
    final members = [
      {'rank': '🥇', 'name': 'Virza', 'amount': 'Rp550.000', 'count': '8 expenses'},
      {'rank': '🥈', 'name': 'Sari', 'amount': 'Rp320.000', 'count': '5 expenses'},
      {'rank': '🥉', 'name': 'Andi', 'amount': 'Rp220.000', 'count': '3 expenses'},
    ];

    return Column(
      children: members.map((m) {
        return Card(
          child: ListTile(
            leading: Text(m['rank'] as String, style: const TextStyle(fontSize: 24)),
            title: Text(m['name'] as String,
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(m['count'] as String,
                style: Theme.of(context).textTheme.bodyMedium),
            trailing: Text(
              m['amount'] as String,
              style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _AIInsightCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.15),
            AppColors.secondary.withOpacity(0.10),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.auto_awesome, color: AppColors.primary),
              const SizedBox(width: 8),
              Text('AI Weekly Insight',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '✨ This week your group spent 65% on food — mainly at restaurants. '
            'Virza has been the most generous, paying for 8 out of 16 expenses. '
            'Consider cooking at home next week — you could save up to Rp300.000! 🍳',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 12),
          Text(
            'Powered by Gemini AI',
            style:
                Theme.of(context).textTheme.labelSmall?.copyWith(color: AppColors.textLow),
          ),
        ],
      ),
    );
  }
}
