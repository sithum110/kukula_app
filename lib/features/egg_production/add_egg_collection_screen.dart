import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/core/providers/egg_providers.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/egg_production/egg_model.dart';
import 'package:kukula_app/features/flocks/flock_model.dart';
import 'package:kukula_app/l10n/app_localizations.dart';

const _uuid = Uuid();

class AddEggCollectionScreen extends ConsumerStatefulWidget {
  const AddEggCollectionScreen({super.key});

  @override
  ConsumerState<AddEggCollectionScreen> createState() =>
      _AddEggCollectionScreenState();
}

class _AddEggCollectionScreenState
    extends ConsumerState<AddEggCollectionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _totalCtrl = TextEditingController();
  final _brokenCtrl = TextEditingController(text: '0');
  final _gradeACtrl = TextEditingController();
  final _gradeBCtrl = TextEditingController();
  final _gradeCCtrl = TextEditingController();
  final _collectorCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  String? _selectedFlockId;
  bool _isLoading = false;
  bool _useGrading = false;

  // Live calculated good eggs
  int get _goodEggs {
    final total = int.tryParse(_totalCtrl.text) ?? 0;
    final broken = int.tryParse(_brokenCtrl.text) ?? 0;
    return (total - broken).clamp(0, total);
  }

  @override
  void dispose() {
    _totalCtrl.dispose();
    _brokenCtrl.dispose();
    _gradeACtrl.dispose();
    _gradeBCtrl.dispose();
    _gradeCCtrl.dispose();
    _collectorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final flocks = ref.watch(flockListProvider);
    final layerFlocks =
        flocks.where((f) => f.isLayer && f.status == FlockStatus.active).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addEggCollection),
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
            // Date picker
            _Label(l10n.collectionDate),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                    Text(_formatDate(_date),
                        style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.textPrimaryDark)),
                    const Spacer(),
                    const Icon(Icons.chevron_right,
                        color: AppColors.textHintDark, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Flock selector (optional)
            if (layerFlocks.isNotEmpty) ...[
              _Label('${l10n.flock} (optional)'),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _selectedFlockId,
                dropdownColor: AppColors.cardDark2,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.egg_outlined),
                  hintText: 'Farm-wide (all flocks)',
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Farm-wide (all flocks)',
                        style: TextStyle(color: AppColors.textPrimaryDark)),
                  ),
                  ...layerFlocks.map((f) => DropdownMenuItem(
                        value: f.id,
                        child: Text(f.name,
                            style: const TextStyle(
                                color: AppColors.textPrimaryDark)),
                      )),
                ],
                onChanged: (v) => setState(() => _selectedFlockId = v),
              ),
              const SizedBox(height: 16),
            ],

            // Total eggs
            _Label(l10n.totalEggs),
            const SizedBox(height: 8),
            TextFormField(
              controller: _totalCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: 'e.g. 350',
                prefixIcon: Icon(Icons.egg_outlined),
                suffixText: 'eggs',
              ),
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Total is required';
                if (int.tryParse(v) == null || int.parse(v) <= 0) {
                  return 'Enter a valid number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Broken eggs
            _Label(l10n.brokenEggs),
            const SizedBox(height: 8),
            TextFormField(
              controller: _brokenCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '0',
                prefixIcon: Icon(Icons.broken_image_outlined),
                suffixText: 'eggs',
              ),
              onChanged: (_) => setState(() {}),
              validator: (v) {
                final broken = int.tryParse(v ?? '') ?? 0;
                final total = int.tryParse(_totalCtrl.text) ?? 0;
                if (broken > total) return 'Cannot exceed total';
                return null;
              },
            ),

            // Good eggs live counter
            if (_goodEggs > 0) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Good Eggs',
                        style: TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: 13)),
                    Text(
                      '$_goodEggs eggs · ${_goodEggs ~/ 30} trays',
                      style: const TextStyle(
                          color: AppColors.success,
                          fontSize: 15,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Grade toggle
            Row(
              children: [
                const Expanded(
                  child: Text('Enable Grading (A / B / C)',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondaryDark)),
                ),
                Switch(
                  value: _useGrading,
                  activeColor: AppColors.eggAccent,
                  onChanged: (v) => setState(() => _useGrading = v),
                ),
              ],
            ),

            if (_useGrading) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _GradeField(
                        ctrl: _gradeACtrl,
                        label: 'Grade A',
                        color: AppColors.success),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _GradeField(
                        ctrl: _gradeBCtrl,
                        label: 'Grade B',
                        color: AppColors.warning),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _GradeField(
                        ctrl: _gradeCCtrl,
                        label: 'Grade C',
                        color: AppColors.error),
                  ),
                ],
              ),
            ],

            const SizedBox(height: 16),

            // Collected by
            _Label(l10n.collectedBy),
            const SizedBox(height: 8),
            TextFormField(
              controller: _collectorCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. Nimal',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Collector name required' : null,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.eggAccent),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(l10n.saveCollection),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
                onPressed: () => context.pop(), child: Text(l10n.cancel)),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(data: AppTheme.darkTheme, child: child!),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 300));

    final total = int.parse(_totalCtrl.text);
    final broken = int.parse(_brokenCtrl.text.isEmpty ? '0' : _brokenCtrl.text);
    final gradeA = _useGrading ? int.tryParse(_gradeACtrl.text) : null;
    final gradeB = _useGrading ? int.tryParse(_gradeBCtrl.text) : null;
    final gradeC = _useGrading ? int.tryParse(_gradeCCtrl.text) : null;

    final record = EggRecordModel(
      id: _uuid.v4(),
      farmId: 'farm1',
      flockId: _selectedFlockId,
      date: _date,
      totalEggs: total,
      brokenEggs: broken,
      gradeA: gradeA,
      gradeB: gradeB,
      gradeC: gradeC,
      collectedBy: _collectorCtrl.text.trim(),
      createdAt: DateTime.now(),
    );

    ref.read(eggRecordListProvider.notifier).addRecord(record);
    ref.read(eggStockProvider.notifier).addEggs(record.goodEggs);

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '✅ ${record.goodEggs} eggs recorded · ${record.traysCount} trays added to stock'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  String _formatDate(DateTime d) =>
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

class _GradeField extends StatelessWidget {
  final TextEditingController ctrl;
  final String label;
  final Color color;

  const _GradeField(
      {required this.ctrl, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        const SizedBox(height: 4),
        TextFormField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0',
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: color, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
