import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/core/providers/auth_provider.dart';
import 'package:kukula_app/core/providers/finance_providers.dart';
import 'package:kukula_app/core/providers/livestock_trading_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/finance/finance_model.dart';
import 'package:kukula_app/features/livestock_trading/livestock_trading_model.dart';

const _uuid = Uuid();
final _moneyFmt = NumberFormat('#,##0.00');
final _dateFmt  = DateFormat('dd MMM yyyy');

// ═══════════════════════════════════════════════════════════════════════════════
// LIVESTOCK TRADING SCREEN — Purchases Only
// ═══════════════════════════════════════════════════════════════════════════════
class LivestockTradingScreen extends ConsumerWidget {
  const LivestockTradingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final purchases = ref.watch(livestockPurchaseProvider);

    final totalSpent  = purchases.fold(0.0, (s, p) => s + p.totalCostLKR);
    final totalBirds  = purchases.fold(0, (s, p) => s + p.quantity);
    final totalWeightKg = purchases.fold(0.0, (s, p) => s + p.totalLiveWeightKg);

    return Scaffold(
      backgroundColor: AppColors.surfaceDark,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Livestock Purchases',
            style: TextStyle(
                color: AppColors.textPrimaryDark,
                fontSize: 20,
                fontWeight: FontWeight.w700)),
        iconTheme: const IconThemeData(color: AppColors.textPrimaryDark),
      ),
      body: Column(
        children: [
          // ── Summary Strip ────────────────────────────────────────────────
          _SummaryStrip(
            totalSpent: totalSpent,
            totalBirds: totalBirds,
            totalWeightKg: totalWeightKg,
          ),
          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: purchases.isEmpty
                ? const _EmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
                    itemCount: purchases.length,
                    itemBuilder: (_, i) =>
                        _PurchaseCard(purchase: purchases[i]),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => const _AddPurchaseSheet(),
        ),
        backgroundColor: const Color(0xFFFF8C00),
        icon: const Icon(Icons.add_shopping_cart_outlined),
        label: const Text('Record Purchase',
            style: TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

// ── Summary Strip ─────────────────────────────────────────────────────────────
class _SummaryStrip extends StatelessWidget {
  final double totalSpent, totalWeightKg;
  final int totalBirds;
  const _SummaryStrip(
      {required this.totalSpent,
      required this.totalBirds,
      required this.totalWeightKg});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A0A00), Color(0xFF3D1F00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFFF8C00).withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          _Stat('Total Spent',
              'Rs. ${_moneyFmt.format(totalSpent)}', Colors.redAccent.shade100),
          _Divider(),
          _Stat('Birds Bought', '$totalBirds birds', Colors.amber.shade200),
          _Divider(),
          _Stat('Live Weight',
              '${totalWeightKg.toStringAsFixed(1)} kg', Colors.orange.shade200),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label, value;
  final Color color;
  const _Stat(this.label, this.value, this.color);
  @override
  Widget build(BuildContext context) => Expanded(
        child: Column(
          children: [
            Text(label,
                style: const TextStyle(
                    color: AppColors.textSecondaryDark,
                    fontSize: 11,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text(value,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w800),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      width: 1, height: 32, color: const Color(0xFFFF8C00).withValues(alpha: 0.25));
}

// ── Purchase Card ─────────────────────────────────────────────────────────────
class _PurchaseCard extends ConsumerWidget {
  final LivestockPurchaseModel purchase;
  const _PurchaseCard({required this.purchase});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Bird type emoji badge
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF8C00).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(purchase.birdType.emoji,
                    style: const TextStyle(fontSize: 22)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(purchase.birdType.label,
                        style: const TextStyle(
                            color: AppColors.textPrimaryDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                    Text('From: ${purchase.supplierName}',
                        style: const TextStyle(
                            color: AppColors.textSecondaryDark,
                            fontSize: 13)),
                    if (purchase.breed != null)
                      Text('Breed: ${purchase.breed}',
                          style: const TextStyle(
                              color: AppColors.textHintDark, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('Rs. ${_moneyFmt.format(purchase.totalCostLKR)}',
                      style: const TextStyle(
                          color: Color(0xFFFF8C00),
                          fontWeight: FontWeight.w800,
                          fontSize: 15)),
                  Text(_dateFmt.format(purchase.purchaseDate),
                      style: const TextStyle(
                          color: AppColors.textHintDark, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: AppColors.borderDark, height: 1),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 6,
            children: [
              _Badge(Icons.set_meal_outlined,
                  '${purchase.quantity} birds'),
              _Badge(Icons.scale_outlined,
                  '${purchase.totalLiveWeightKg.toStringAsFixed(1)} kg'),
              _Badge(Icons.attach_money_outlined,
                  'Rs.${purchase.pricePerKg.toStringAsFixed(0)}/kg'),
              if (purchase.supplierPhone != null)
                _Badge(Icons.phone_outlined, purchase.supplierPhone!),
            ],
          ),
          if (purchase.notes != null && purchase.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(purchase.notes!,
                style: const TextStyle(
                    color: AppColors.textHintDark, fontSize: 12,
                    fontStyle: FontStyle.italic)),
          ],
          // Finance tag
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.receipt_long_outlined,
                    size: 12, color: Colors.redAccent),
                SizedBox(width: 4),
                Text('Auto-logged as Expense',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _Badge(this.icon, this.label);
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: AppColors.textHintDark),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textHintDark, fontSize: 12)),
        ],
      );
}

// ── Empty State ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🐓', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 16),
              const Text('No Purchases Yet',
                  style: TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text(
                'Tap + to record buying live birds\nfrom another farmer.\nIt will auto-log as an expense.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: AppColors.textSecondaryDark, fontSize: 14),
              ),
            ],
          ),
        ),
      );
}

// ═══════════════════════════════════════════════════════════════════════════════
// ADD PURCHASE BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════════════════════
class _AddPurchaseSheet extends ConsumerStatefulWidget {
  const _AddPurchaseSheet();

  @override
  ConsumerState<_AddPurchaseSheet> createState() => _AddPurchaseSheetState();
}

class _AddPurchaseSheetState extends ConsumerState<_AddPurchaseSheet> {
  final _formKey          = GlobalKey<FormState>();
  final _supplierNameCtrl = TextEditingController();
  final _supplierPhoneCtrl = TextEditingController();
  final _quantityCtrl     = TextEditingController();
  final _weightCtrl       = TextEditingController();
  final _pricePerKgCtrl   = TextEditingController();
  final _breedCtrl        = TextEditingController();
  final _notesCtrl        = TextEditingController();

  LivestockBirdType _birdType = LivestockBirdType.broilerChicken;
  DateTime _purchaseDate = DateTime.now();
  bool _loading = false;

  @override
  void dispose() {
    _supplierNameCtrl.dispose();
    _supplierPhoneCtrl.dispose();
    _quantityCtrl.dispose();
    _weightCtrl.dispose();
    _pricePerKgCtrl.dispose();
    _breedCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  double get _liveTotal {
    final w = double.tryParse(_weightCtrl.text) ?? 0;
    final p = double.tryParse(_pricePerKgCtrl.text) ?? 0;
    return w * p;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);

    final uid      = ref.read(currentUidProvider);
    final qty      = int.parse(_quantityCtrl.text.trim());
    final weightKg = double.parse(_weightCtrl.text.trim());
    final priceKg  = double.parse(_pricePerKgCtrl.text.trim());
    final totalCost = weightKg * priceKg;

    // ── 1. Save livestock purchase ──────────────────────────────────────────
    final purchase = LivestockPurchaseModel(
      id: _uuid.v4(),
      farmId: uid,
      supplierName: _supplierNameCtrl.text.trim(),
      supplierPhone: _supplierPhoneCtrl.text.trim().isNotEmpty
          ? _supplierPhoneCtrl.text.trim()
          : null,
      birdType: _birdType,
      breed: _breedCtrl.text.trim().isNotEmpty ? _breedCtrl.text.trim() : null,
      quantity: qty,
      totalLiveWeightKg: weightKg,
      pricePerKg: priceKg,
      totalCostLKR: totalCost,
      notes: _notesCtrl.text.trim().isNotEmpty ? _notesCtrl.text.trim() : null,
      purchaseDate: _purchaseDate,
      createdAt: DateTime.now(),
    );

    ref.read(livestockPurchaseProvider.notifier).addPurchase(purchase);

    // ── 2. Auto-log as EXPENSE in finance ──────────────────────────────────
    ref.read(financeProvider.notifier).addTransaction(
      FinanceTransactionModel(
        id: _uuid.v4(),
        farmId: uid,
        type: TransactionType.expense,
        category: FinanceCategory.livestockPurchase,
        amount: totalCost,
        description:
            '${_birdType.label} purchase — $qty birds, ${weightKg.toStringAsFixed(1)} kg '
            '@ Rs.${priceKg.toStringAsFixed(0)}/kg '
            'from ${_supplierNameCtrl.text.trim()}',
        reference: purchase.id,
        date: _purchaseDate,
        createdAt: DateTime.now(),
      ),
    );

    if (mounted) {
      setState(() => _loading = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '✅ Purchase recorded & Rs.${_moneyFmt.format(totalCost)} logged as expense'),
          backgroundColor: const Color(0xFFFF8C00),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.fromLTRB(
          20, 16, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                      color: AppColors.borderDark,
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 16),
              const Text('🛒  Record Livestock Purchase',
                  style: TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontSize: 19,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              const Text(
                  'Will auto-log as expense in Finance',
                  style: TextStyle(
                      color: Colors.redAccent, fontSize: 12)),
              const SizedBox(height: 20),

              // ── Bird Type Chips ─────────────────────────────────────
              _sheetLabel('Bird Type'),
              const SizedBox(height: 8),
              SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: LivestockBirdType.values.map((type) {
                    final sel = _birdType == type;
                    return GestureDetector(
                      onTap: () => setState(() => _birdType = type),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: sel
                              ? const Color(0xFFFF8C00)
                              : AppColors.cardDark2,
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                              color: sel
                                  ? const Color(0xFFFF8C00)
                                  : AppColors.borderDark),
                        ),
                        child: Text('${type.emoji} ${type.label}',
                            style: TextStyle(
                                color: sel
                                    ? Colors.white
                                    : AppColors.textSecondaryDark,
                                fontSize: 13,
                                fontWeight: FontWeight.w600)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              // ── Supplier ──────────────────────────────────────────────
              _sheetLabel('Supplier Name *'),
              const SizedBox(height: 8),
              _field(_supplierNameCtrl,
                  hint: 'Farmer / seller name',
                  icon: Icons.person_outline,
                  capitalization: TextCapitalization.words,
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Required' : null),
              const SizedBox(height: 12),
              _sheetLabel('Supplier Phone (optional)'),
              const SizedBox(height: 8),
              _field(_supplierPhoneCtrl,
                  hint: 'e.g. 077 123 4567',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 16),

              // ── Quantity + Weight ──────────────────────────────────────
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sheetLabel('No. of Birds *'),
                      const SizedBox(height: 8),
                      _field(_quantityCtrl,
                          hint: '100',
                          icon: Icons.numbers_outlined,
                          keyboardType: TextInputType.number,
                          onChanged: (_) => setState(() {}),
                          validator: (v) =>
                              (v == null || int.tryParse(v.trim()) == null)
                                  ? 'Required'
                                  : null),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sheetLabel('Total Live Wt (kg) *'),
                      const SizedBox(height: 8),
                      _field(_weightCtrl,
                          hint: '150.0',
                          icon: Icons.scale_outlined,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => setState(() {}),
                          validator: (v) =>
                              (v == null || double.tryParse(v.trim()) == null)
                                  ? 'Required'
                                  : null),
                    ],
                  ),
                ),
              ]),
              const SizedBox(height: 12),

              // ── Price per kg ──────────────────────────────────────────
              _sheetLabel('Price per kg (Rs.) *'),
              const SizedBox(height: 8),
              _field(_pricePerKgCtrl,
                  hint: 'e.g. 450',
                  icon: Icons.attach_money_outlined,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (_) => setState(() {}),
                  validator: (v) =>
                      (v == null || double.tryParse(v.trim()) == null)
                          ? 'Required'
                          : null),

              // ── Live total preview ─────────────────────────────────────
              if (_liveTotal > 0) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: Colors.redAccent.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Cost',
                          style: TextStyle(
                              color: AppColors.textSecondaryDark,
                              fontSize: 13)),
                      Text('Rs. ${_moneyFmt.format(_liveTotal)}',
                          style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 17,
                              fontWeight: FontWeight.w800)),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 12),

              // ── Breed + Notes ─────────────────────────────────────────
              _sheetLabel('Breed (optional)'),
              const SizedBox(height: 8),
              _field(_breedCtrl,
                  hint: 'e.g. Ross 308, Cobb 500',
                  icon: Icons.info_outline),
              const SizedBox(height: 12),
              _sheetLabel('Notes (optional)'),
              const SizedBox(height: 8),
              _field(_notesCtrl,
                  hint: 'Any extra info...',
                  icon: Icons.notes_outlined,
                  maxLines: 2),
              const SizedBox(height: 12),

              // ── Date picker ───────────────────────────────────────────
              _DateRow(
                date: _purchaseDate,
                onChanged: (d) => setState(() => _purchaseDate = d),
              ),
              const SizedBox(height: 20),

              // ── Save button ───────────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _loading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C00),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: _loading
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Save & Log as Expense',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────
Widget _sheetLabel(String text) => Text(text,
    style: const TextStyle(
        color: AppColors.textSecondaryDark,
        fontSize: 13,
        fontWeight: FontWeight.w600));

Widget _field(
  TextEditingController ctrl, {
  String hint = '',
  IconData icon = Icons.edit_outlined,
  TextInputType? keyboardType,
  int maxLines = 1,
  TextCapitalization capitalization = TextCapitalization.none,
  ValueChanged<String>? onChanged,
  FormFieldValidator<String>? validator,
}) =>
    TextFormField(
      controller: ctrl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      textCapitalization: capitalization,
      onChanged: onChanged,
      style: const TextStyle(color: AppColors.textPrimaryDark),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.textHintDark),
        prefixIcon: Icon(icon, color: AppColors.textHintDark, size: 20),
        filled: true,
        fillColor: AppColors.cardDark2,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderDark)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.borderDark)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFFFF8C00), width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.error)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
      validator: validator,
    );

class _DateRow extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  const _DateRow({required this.date, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          builder: (ctx, child) => Theme(
            data: Theme.of(ctx).copyWith(
              colorScheme: const ColorScheme.dark(
                  primary: Color(0xFFFF8C00),
                  surface: AppColors.cardDark),
            ),
            child: child!,
          ),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.cardDark2,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined,
                color: AppColors.textHintDark, size: 18),
            const SizedBox(width: 10),
            Text('Purchase Date: ${_dateFmt.format(date)}',
                style: const TextStyle(
                    color: AppColors.textPrimaryDark, fontSize: 14)),
            const Spacer(),
            const Icon(Icons.chevron_right,
                color: AppColors.textHintDark, size: 18),
          ],
        ),
      ),
    );
  }
}
