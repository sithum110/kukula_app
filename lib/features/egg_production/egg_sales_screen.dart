import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/core/providers/egg_providers.dart';
import 'package:kukula_app/core/providers/finance_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/egg_production/egg_model.dart';
import 'package:kukula_app/features/finance/finance_model.dart';

const _uuid = Uuid();

class EggSalesScreen extends ConsumerStatefulWidget {
  const EggSalesScreen({super.key});

  @override
  ConsumerState<EggSalesScreen> createState() => _EggSalesScreenState();
}

class _EggSalesScreenState extends ConsumerState<EggSalesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Egg Sales'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.eggAccent,
          labelColor: AppColors.eggAccent,
          unselectedLabelColor: AppColors.textSecondaryDark,
          tabs: const [
            Tab(text: 'Record Sale'),
            Tab(text: 'Sales History'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _RecordSaleTab(),
          _SalesHistoryTab(),
        ],
      ),
    );
  }
}

// ── Record Sale Tab ───────────────────────────────────────────────────────
class _RecordSaleTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_RecordSaleTab> createState() => _RecordSaleTabState();
}

class _RecordSaleTabState extends ConsumerState<_RecordSaleTab> {
  final _formKey = GlobalKey<FormState>();
  EggDispositionType _saleType = EggDispositionType.sale;
  final _buyerCtrl = TextEditingController();
  final _qtyCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  bool _sellByTray = false;
  bool _isLoading = false;

  int get _eggCount {
    final raw = int.tryParse(_qtyCtrl.text) ?? 0;
    return _sellByTray ? raw * 30 : raw;
  }

  double get _totalAmount {
    final price = double.tryParse(_priceCtrl.text) ?? 0;
    if (_sellByTray) {
      return (int.tryParse(_qtyCtrl.text) ?? 0) * price;
    }
    return _eggCount * price;
  }

  @override
  void dispose() {
    _buyerCtrl.dispose();
    _qtyCtrl.dispose();
    _priceCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stock = ref.watch(eggStockProvider);

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Stock reminder
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.eggAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: AppColors.eggAccent.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Text('📦', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Text(
                  'Available: $stock eggs  ·  ${stock ~/ 30} trays',
                  style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.eggAccent,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Transaction type
          _Label('Transaction Type'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: EggDispositionType.values.map((t) {
              return ChoiceChip(
                label: Text(_typeLabel(t)),
                selected: _saleType == t,
                onSelected: (_) => setState(() => _saleType = t),
                selectedColor: AppColors.eggAccent.withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: _saleType == t
                      ? AppColors.eggAccent
                      : AppColors.textSecondaryDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          if (_saleType == EggDispositionType.sale) ...[
            _Label('Buyer Name (optional)'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _buyerCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. Saman Stores',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Sell by tray toggle
          Row(
            children: [
              const Expanded(
                child: Text('Sell by Tray (30 eggs)',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryDark)),
              ),
              Switch(
                value: _sellByTray,
                activeColor: AppColors.eggAccent,
                onChanged: (v) => setState(() => _sellByTray = v),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Label(_sellByTray ? 'Quantity (trays)' : 'Quantity (eggs)'),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _qtyCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: _sellByTray ? '10' : '300',
                        suffixText: _sellByTray ? 'trays' : 'eggs',
                      ),
                      onChanged: (_) => setState(() {}),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Required';
                        final n = int.tryParse(v);
                        if (n == null || n <= 0) return 'Invalid';
                        if (_eggCount > stock) return 'Exceeds stock';
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              if (_saleType == EggDispositionType.sale) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label(_sellByTray ? 'Price/Tray' : 'Price/Egg (LKR)'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _priceCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: const InputDecoration(
                          hintText: '28',
                          prefixText: 'LKR ',
                        ),
                        onChanged: (_) => setState(() {}),
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Required';
                          if (double.tryParse(v) == null) return 'Invalid';
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),

          // Live total
          if (_totalAmount > 0 && _saleType == EggDispositionType.sale) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Total Amount',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryDark)),
                      if (_sellByTray)
                        Text(
                          '${_qtyCtrl.text.isEmpty ? 0 : _qtyCtrl.text} trays = $_eggCount eggs',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textHintDark),
                        ),
                    ],
                  ),
                  Text(
                    'LKR ${_totalAmount.toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          _Label('Notes (optional)'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _notesCtrl,
            maxLines: 2,
            decoration:
                const InputDecoration(hintText: 'Any additional info...'),
          ),
          const SizedBox(height: 28),

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
                : const Text('Record Transaction'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    final sale = EggSaleModel(
      id: _uuid.v4(),
      farmId: 'farm1',
      saleType: _saleType,
      quantity: _eggCount,
      pricePerUnit: _saleType == EggDispositionType.sale
          ? double.tryParse(_priceCtrl.text)
          : null,
      totalAmount: _saleType == EggDispositionType.sale ? _totalAmount : null,
      buyerName: _buyerCtrl.text.trim().isEmpty ? null : _buyerCtrl.text.trim(),
      notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
      date: DateTime.now(),
    );

    ref.read(eggSaleListProvider.notifier).addSale(sale);
    ref.read(eggStockProvider.notifier).removeEggs(_eggCount);

    // ── Auto-create finance income entry for egg sales ─────────────────────────────
    if (_saleType == EggDispositionType.sale && _totalAmount > 0) {
      final buyer = sale.buyerName != null ? ' — ${sale.buyerName}' : '';
      ref.read(financeProvider.notifier).addTransaction(
        FinanceTransactionModel(
          id: _uuid.v4(),
          farmId: 'farm1',
          type: TransactionType.income,
          category: FinanceCategory.eggSales,
          amount: _totalAmount,
          description: 'Egg sale: $_eggCount eggs$buyer',
          date: DateTime.now(),
          createdAt: DateTime.now(),
        ),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
      final msg = _saleType == EggDispositionType.sale
          ? '✅ Sale of $_eggCount eggs — LKR ${_totalAmount.toStringAsFixed(0)}'
          : '✅ ${_typeLabel(_saleType)}: $_eggCount eggs recorded';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _formKey.currentState!.reset();
      setState(() {
        _saleType = EggDispositionType.sale;
        _buyerCtrl.clear();
        _qtyCtrl.clear();
        _priceCtrl.clear();
        _notesCtrl.clear();
      });
    }
  }

  String _typeLabel(EggDispositionType t) {
    switch (t) {
      case EggDispositionType.sale: return '💰 Sale';
      case EggDispositionType.personalUse: return '🏠 Own Use';
      case EggDispositionType.hatching: return '🐣 Hatching';
      case EggDispositionType.wastage: return '🗑️ Wastage';
    }
  }
}

// ── Sales History Tab ─────────────────────────────────────────────────────
class _SalesHistoryTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sales = ref.watch(eggSaleListProvider);
    final notifier = ref.read(eggSaleListProvider.notifier);

    if (sales.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🥚', style: TextStyle(fontSize: 56)),
            SizedBox(height: 12),
            Text('No transactions yet',
                style: TextStyle(
                    fontSize: 16, color: AppColors.textSecondaryDark)),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Revenue summary
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Revenue',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondaryDark)),
                    ],
                  ),
                ),
                Text(
                  'LKR ${notifier.totalRevenue.toStringAsFixed(0)}',
                  style: const TextStyle(
                      color: AppColors.success,
                      fontSize: 20,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: sales.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) {
              final s = sales[i];
              final isSale = s.saleType == EggDispositionType.sale;

              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSale
                            ? AppColors.success.withValues(alpha: 0.12)
                            : AppColors.info.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(_typeEmoji(s.saleType),
                            style: const TextStyle(fontSize: 18)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${s.quantity} eggs · ${s.traysCount} trays',
                            style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimaryDark,
                                fontSize: 14),
                          ),
                          Text(
                            '${_typeLabel(s.saleType)}${s.buyerName != null ? ' · ${s.buyerName}' : ''}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondaryDark),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (s.totalAmount != null)
                          Text(
                            'LKR ${s.totalAmount!.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                                fontSize: 15),
                          ),
                        Text(
                          '${s.date.day}/${s.date.month}/${s.date.year}',
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.textHintDark),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  String _typeEmoji(EggDispositionType t) {
    switch (t) {
      case EggDispositionType.sale: return '💰';
      case EggDispositionType.personalUse: return '🏠';
      case EggDispositionType.hatching: return '🐣';
      case EggDispositionType.wastage: return '🗑️';
    }
  }

  String _typeLabel(EggDispositionType t) {
    switch (t) {
      case EggDispositionType.sale: return 'Sale';
      case EggDispositionType.personalUse: return 'Personal Use';
      case EggDispositionType.hatching: return 'Hatching';
      case EggDispositionType.wastage: return 'Wastage';
    }
  }
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
