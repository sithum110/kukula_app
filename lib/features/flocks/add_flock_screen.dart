import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/core/providers/farm_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/flocks/flock_model.dart';
import 'package:kukula_app/l10n/app_localizations.dart';

const _uuid = Uuid();

class AddFlockScreen extends ConsumerStatefulWidget {
  const AddFlockScreen({super.key});

  @override
  ConsumerState<AddFlockScreen> createState() => _AddFlockScreenState();
}

class _AddFlockScreenState extends ConsumerState<AddFlockScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _countController = TextEditingController();
  final _penController = TextEditingController();
  FlockPurpose _purpose = FlockPurpose.layer;
  DateTime _arrivalDate = DateTime.now();
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _countController.dispose();
    _penController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addFlock)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Purpose toggle
            Text('Flock Purpose', style: _labelStyle),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _PurposeCard(
                    icon: '🥚',
                    label: l10n.layer,
                    desc: 'Egg production',
                    color: AppColors.eggAccent,
                    selected: _purpose == FlockPurpose.layer,
                    onTap: () => setState(() => _purpose = FlockPurpose.layer),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PurposeCard(
                    icon: '🐔',
                    label: l10n.broiler,
                    desc: 'Broiler production',
                    color: AppColors.meatAccent,
                    selected: _purpose == FlockPurpose.broiler,
                    onTap: () => setState(() => _purpose = FlockPurpose.broiler),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Name
            _Label(l10n.flockName),
            const SizedBox(height: 8),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'e.g. Flock A — ISA Brown',
                prefixIcon: const Icon(Icons.label_outline),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Flock name is required' : null,
            ),
            const SizedBox(height: 16),

            // Breed
            _Label('${l10n.breed} (optional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _breedController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. ISA Brown, Lohmann Brown',
                prefixIcon: Icon(Icons.category_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Count
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

            // Pen / Location
            _Label('${l10n.pen} (optional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _penController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. House 1, East Pen',
                prefixIcon: Icon(Icons.home_work_outlined),
              ),
            ),
            const SizedBox(height: 16),

            // Arrival Date
            _Label(l10n.arrivalDate),
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
                      _formatDate(_arrivalDate),
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
              child: Text(l10n.cancel),
            ),
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
      builder: (context, child) => Theme(
        data: AppTheme.darkTheme,
        child: child!,
      ),
    );
    if (picked != null) setState(() => _arrivalDate = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 300));

    final count = int.parse(_countController.text.trim());
    final flock = FlockModel(
      id: _uuid.v4(),
      farmId: 'farm1',
      name: _nameController.text.trim(),
      breed: _breedController.text.trim().isEmpty ? null : _breedController.text.trim(),
      purpose: _purpose,
      currentCount: count,
      initialCount: count,
      pen: _penController.text.trim().isEmpty ? null : _penController.text.trim(),
      arrivalDate: _arrivalDate,
      status: FlockStatus.active,
      createdAt: DateTime.now(),
    );

    ref.read(flockListProvider.notifier).addFlock(flock);

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${flock.name} added successfully!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop();
    }
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')} / ${d.month.toString().padLeft(2, '0')} / ${d.year}';

  TextStyle get _labelStyle => const TextStyle(
      fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textSecondaryDark);
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondaryDark),
      );
}

class _PurposeCard extends StatelessWidget {
  final String icon;
  final String label;
  final String desc;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _PurposeCard({
    required this.icon,
    required this.label,
    required this.desc,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selected ? color.withValues(alpha: 0.12) : AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? color : AppColors.borderDark,
          width: selected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(icon, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 6),
                Text(label,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: selected ? color : AppColors.textPrimaryDark)),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondaryDark),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
