import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/core/providers/batch_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/meat_batches/batch_model.dart';
import 'package:kukula_app/l10n/app_localizations.dart';

const _uuid = Uuid();

class AddBatchScreen extends ConsumerStatefulWidget {
  const AddBatchScreen({super.key});

  @override
  ConsumerState<AddBatchScreen> createState() => _AddBatchScreenState();
}

class _AddBatchScreenState extends ConsumerState<AddBatchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _countController = TextEditingController();
  final _supplierController = TextEditingController();
  DateTime _arrivalDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _countController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addBatch),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.meatAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.meatAccent.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Text('🐔', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('New Broiler Batch',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.meatAccent)),
                      Text('Broiler production batch',
                          style: TextStyle(
                              fontSize: 12, color: AppColors.textSecondaryDark)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            _Label('Batch Name'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. Batch Jan 2026',
                prefixIcon: Icon(Icons.label_outline),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Batch name is required' : null,
            ),
            const SizedBox(height: 16),

            _Label('Breed / Strain (optional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _breedController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. Cobb 500, Ross 308',
                prefixIcon: Icon(Icons.category_outlined),
              ),
            ),
            const SizedBox(height: 16),

            _Label(l10n.initialCount),
            const SizedBox(height: 8),
            TextFormField(
              controller: _countController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 500',
                prefixIcon: Icon(Icons.numbers),
                suffixText: 'birds',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Count is required';
                if (int.tryParse(v) == null || int.parse(v) <= 0) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            _Label('Supplier / Hatchery (optional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _supplierController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. Lanka Hatchery',
                prefixIcon: Icon(Icons.store_outlined),
              ),
            ),
            const SizedBox(height: 16),

            _Label('Arrival / Placement Date'),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppColors.cardDark2,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        color: AppColors.textSecondaryDark, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      _fmt(_arrivalDate),
                      style: const TextStyle(
                          fontSize: 15, color: AppColors.textPrimaryDark),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right,
                        color: AppColors.textHintDark, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.meatAccent),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(l10n.save),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
                onPressed: () => context.pop(),
                child: Text(l10n.cancel)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _arrivalDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(data: AppTheme.darkTheme, child: child!),
    );
    if (picked != null) setState(() => _arrivalDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300));

    final count = int.parse(_countController.text.trim());
    final batch = BatchModel(
      id: _uuid.v4(),
      farmId: 'farm1',
      name: _nameController.text.trim(),
      breed: _breedController.text.trim().isEmpty ? null : _breedController.text.trim(),
      arrivalDate: _arrivalDate,
      initialCount: count,
      currentCount: count,
      supplier: _supplierController.text.trim().isEmpty
          ? null
          : _supplierController.text.trim(),
      status: BatchStatus.growing,
      createdAt: DateTime.now(),
    );

    ref.read(batchListProvider.notifier).addBatch(batch);

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${batch.name} added!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      // Navigate back to batch list
      context.pop();
    }
  }

  String _fmt(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} / ${d.month.toString().padLeft(2, '0')} / ${d.year}';
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondaryDark));
}
