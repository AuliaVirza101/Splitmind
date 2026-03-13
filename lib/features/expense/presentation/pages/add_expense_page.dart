import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AddExpensePage extends StatefulWidget {
  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  String _selectedSplitMode = 'Equal';
  String _selectedPayer = 'Me';

  final _members = ['Me', 'Andi', 'Sari', 'Budi', 'Lisa'];
  final _splitModes = ['Equal', 'By Item', 'Percentage', 'Custom'];

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Expense'),
        actions: [
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
            label: const Text('Scan', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title field
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'What was this expense for?',
                prefixIcon: Icon(Icons.description_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Amount field
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '0',
                prefixIcon: Icon(Icons.payments_outlined),
                prefixText: 'Rp ',
                prefixStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),

            // Paid by
            Text('Paid by', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: _members.map((m) {
                final isSelected = m == _selectedPayer;
                return ChoiceChip(
                  label: Text(m),
                  selected: isSelected,
                  onSelected: (_) => setState(() => _selectedPayer = m),
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  labelStyle: TextStyle(
                    color: isSelected ? AppColors.primary : AppColors.textMedium,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Split mode
            Text('Split mode', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: _splitModes.map((mode) {
                final isSelected = mode == _selectedSplitMode;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton(
                      onPressed: () => setState(() => _selectedSplitMode = mode),
                      style: OutlinedButton.styleFrom(
                        backgroundColor:
                            isSelected ? AppColors.primary.withOpacity(0.1) : null,
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.divider,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        mode,
                        style: TextStyle(
                          fontSize: 11,
                          color: isSelected ? AppColors.primary : AppColors.textMedium,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Split preview
            Card(
              color: const Color(0xFFF0F9FF),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, size: 16, color: AppColors.info),
                        const SizedBox(width: 8),
                        Text('Split Preview',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: AppColors.info)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ..._members.map((m) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(m, style: Theme.of(context).textTheme.bodyMedium),
                              Text(
                                'Rp–',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Save button
            ElevatedButton(
              onPressed: () {
                // TODO: Wire with CreateExpense use case
                Navigator.pop(context);
              },
              child: const Text('Save Expense'),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
