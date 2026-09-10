import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:kukula_app/core/providers/batch_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/meat_batches/batch_model.dart';
import 'package:kukula_app/l10n/app_localizations.dart';

const _uuid = Uuid();

class MeatSalesScreen extends ConsumerStatefulWidget {
  const MeatSalesScreen({super.key});

  @override
  ConsumerState<MeatSalesScreen> createState() => _MeatSalesScreenState();
}

class _MeatSalesScreenState extends ConsumerState<MeatSalesScreen>
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
    final batches = ref.watch(batchListProvider);
    final sales = ref.watch(meatSalesProvider);
    final l10n = AppLocalizations.of(context);
    final growingBatches =
        batches.where((b) => b.status == BatchStatus.growing).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.meatSale),
        bottom: TabBar(
          controller: _tab,
          tabs: const [
            Tab(text: 'Add Sale'),
            Tab(text: 'Sales History'),
          ],
          indicatorColor: AppColors.meatAccent,
          labelColor: AppColors.meatAccent,
          unselectedLabelColor: AppColors.textSecondaryDark,
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _AddSaleTab(batches: growingBatches),
          _SalesHistoryTab(sales: sales, batches: batches),
        ],
      ),
    );
  }
}

// ── Add Sale Tab ──────────────────────────────────────────────────────────
class _AddSaleTab extends ConsumerStatefulWidget {
  final List<BatchModel> batches;
  const _AddSaleTab({required this.batches});

  @override
  ConsumerState<_AddSaleTab> createState() => _AddSaleTabState();
}

class _AddSaleTabState extends ConsumerState<_AddSaleTab> {
  final _formKey = GlobalKey<FormState>();
  BatchModel? _selectedBatch;
  BroilerSaleType _saleType = BroilerSaleType.liveBird;
  final _buyerCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();   // birds count (both)
  final _weightCtrl = TextEditingController();     // live weight kg (live bird)
  final _priceCtrl = TextEditingController();      // price/kg or price/bird
  final _notesCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  bool _isLoading = false;

  double get _total {
    if (_saleType == BroilerSaleType.liveBird) {
      final kg = double.tryParse(_weightCtrl.text) ?? 0;
      final p = double.tryParse(_priceCtrl.text) ?? 0;
      return kg * p;
    } else {
      final q = int.tryParse(_quantityCtrl.text) ?? 0;
      final p = double.tryParse(_priceCtrl.text) ?? 0;
      return q * p;
    }
  }

  @override
  void dispose() {
    _buyerCtrl.dispose();
    _quantityCtrl.dispose();
    _weightCtrl.dispose();
    _priceCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // ── Sale Type Subsection ──────────────────────────────────────
          const Text('Sale Type',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondaryDark)),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _SaleTypeCard(
              type: BroilerSaleType.liveBird,
              selected: _saleType == BroilerSaleType.liveBird,
              onTap: () => setState(() {
                _saleType = BroilerSaleType.liveBird;
                _priceCtrl.clear();
                _quantityCtrl.clear();
                _weightCtrl.clear();
              }),
            )),
            const SizedBox(width: 10),
            Expanded(child: _SaleTypeCard(
              type: BroilerSaleType.dressedMeat,
              selected: _saleType == BroilerSaleType.dressedMeat,
              onTap: () => setState(() {
                _saleType = BroilerSaleType.dressedMeat;
                _priceCtrl.clear();
                _quantityCtrl.clear();
                _weightCtrl.clear();
              }),
            )),
          ]),
          const SizedBox(height: 20),

          // ── Batch selector ────────────────────────────────────────────
          _Label('Select Batch'),
          const SizedBox(height: 8),
          DropdownButtonFormField<BatchModel>(
            value: _selectedBatch,
            dropdownColor: AppColors.cardDark2,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.set_meal_outlined),
              hintText: 'Choose a batch',
            ),
            items: widget.batches
                .map((b) => DropdownMenuItem(
                      value: b,
                      child: Text(
                        '${b.name} (${b.currentCount} birds)',
                        style: const TextStyle(color: AppColors.textPrimaryDark),
                      ),
                    ))
                .toList(),
            onChanged: (b) => setState(() => _selectedBatch = b),
            validator: (v) => v == null ? 'Please select a batch' : null,
          ),
          const SizedBox(height: 16),

          // ── Buyer ─────────────────────────────────────────────────────
          _Label('Buyer Name (optional)'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _buyerCtrl,
            textCapitalization: TextCapitalization.words,
            decoration: const InputDecoration(
              hintText: 'e.g. Kamal Perera',
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),
          const SizedBox(height: 16),

          // ── Dynamic fields by sale type ───────────────────────────────
          if (_saleType == BroilerSaleType.liveBird) ...[
            // LIVE BIRD: birds + live weight + price/kg
            _Label('Number of Birds'),
            const SizedBox(height: 8),
            TextFormField(
              controller: _quantityCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                hintText: '50',
                prefixIcon: Icon(Icons.numbers),
                suffixText: 'birds',
              ),
              onChanged: (_) => setState(() {}),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Required';
                final n = int.tryParse(v);
                if (n == null || n <= 0) return 'Invalid';
                if (_selectedBatch != null && n > _selectedBatch!.currentCount) {
                  return 'Exceeds batch (${_selectedBatch!.currentCount})';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _Label('Total Live Weight'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _weightCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: '125.0',
                      suffixText: 'kg',
                      prefixIcon: Icon(Icons.scale_outlined),
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _Label('Price / kg (LKR)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: '350',
                      prefixText: 'LKR ',
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ]),
              ),
            ]),
            // Avg weight per bird hint
            if (_quantityCtrl.text.isNotEmpty && _weightCtrl.text.isNotEmpty) ...[
              const SizedBox(height: 6),
              Builder(builder: (_) {
                final birds = int.tryParse(_quantityCtrl.text) ?? 0;
                final kg = double.tryParse(_weightCtrl.text) ?? 0;
                if (birds > 0 && kg > 0) {
                  return Text(
                    '📊 Avg: ${(kg / birds).toStringAsFixed(2)} kg/bird',
                    style: const TextStyle(fontSize: 12, color: AppColors.info),
                  );
                }
                return const SizedBox();
              }),
            ],
          ] else ...[
            // DRESSED MEAT: birds + price/bird
            Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _Label('Quantity (birds)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _quantityCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      hintText: '50',
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      final n = int.tryParse(v);
                      if (n == null || n <= 0) return 'Invalid';
                      if (_selectedBatch != null && n > _selectedBatch!.currentCount) {
                        return 'Exceeds stock';
                      }
                      return null;
                    },
                  ),
                ]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _Label('Price / bird (LKR)'),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: const InputDecoration(
                      hintText: '1200',
                      prefixText: 'LKR ',
                    ),
                    onChanged: (_) => setState(() {}),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Required';
                      if (double.tryParse(v) == null) return 'Invalid';
                      return null;
                    },
                  ),
                ]),
              ),
            ]),
          ],

          // ── Live Total ────────────────────────────────────────────────
          if (_total > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _saleType == BroilerSaleType.liveBird
                        ? '${_weightCtrl.text} kg × LKR ${_priceCtrl.text}/kg'
                        : '${_quantityCtrl.text} birds × LKR ${_priceCtrl.text}',
                    style: const TextStyle(
                        color: AppColors.textSecondaryDark, fontSize: 13)),
                  Text(
                    'LKR ${_total.toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 18,
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
            decoration: const InputDecoration(hintText: 'Any additional notes...'),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: _isLoading ? null : _save,
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.meatAccent),
            child: _isLoading
                ? const SizedBox(
                    height: 20, width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(_saleType == BroilerSaleType.liveBird
                    ? '🐔 Record Live Bird Sale'
                    : '🥩 Record Dressed Sale'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _selectedBatch == null) return;
    setState(() => _isLoading = true);

    final qty = int.parse(_quantityCtrl.text);

    final MeatSaleModel sale;
    if (_saleType == BroilerSaleType.liveBird) {
      final weightKg = double.parse(_weightCtrl.text);
      final pricePerKg = double.parse(_priceCtrl.text);
      sale = MeatSaleModel(
        id: _uuid.v4(),
        batchId: _selectedBatch!.id,
        farmId: 'farm1',
        saleType: BroilerSaleType.liveBird,
        quantityBirds: qty,
        liveWeightKg: weightKg,
        pricePerKg: pricePerKg,
        totalAmount: weightKg * pricePerKg,
        buyerName: _buyerCtrl.text.trim().isEmpty ? null : _buyerCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        date: _date,
      );
    } else {
      final pricePerBird = double.parse(_priceCtrl.text);
      sale = MeatSaleModel(
        id: _uuid.v4(),
        batchId: _selectedBatch!.id,
        farmId: 'farm1',
        saleType: BroilerSaleType.dressedMeat,
        quantityBirds: qty,
        pricePerBird: pricePerBird,
        totalAmount: qty * pricePerBird,
        buyerName: _buyerCtrl.text.trim().isEmpty ? null : _buyerCtrl.text.trim(),
        notes: _notesCtrl.text.trim().isEmpty ? null : _notesCtrl.text.trim(),
        date: _date,
      );
    }

    ref.read(meatSalesProvider.notifier).addSale(sale);
    ref.read(batchListProvider.notifier).reduceBirds(
        _selectedBatch!.id, qty, reason: 'sale');

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _saleType == BroilerSaleType.liveBird
                ? '✅ Live sale: $qty birds · ${_weightCtrl.text} kg — LKR ${sale.totalAmount.toStringAsFixed(0)}'
                : '✅ Dressed sale: $qty birds — LKR ${sale.totalAmount.toStringAsFixed(0)}'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      _formKey.currentState!.reset();
      setState(() {
        _selectedBatch = null;
        _buyerCtrl.clear();
        _quantityCtrl.clear();
        _weightCtrl.clear();
        _priceCtrl.clear();
        _notesCtrl.clear();
      });
    }
  }
}

// ── Sale Type Card ─────────────────────────────────────────────────────────
class _SaleTypeCard extends StatelessWidget {
  final BroilerSaleType type;
  final bool selected;
  final VoidCallback onTap;
  const _SaleTypeCard({required this.type, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.meatAccent.withValues(alpha: 0.15)
              : AppColors.cardDark2,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.meatAccent : AppColors.borderDark,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(type.emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(height: 6),
          Text(type.label,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: selected ? AppColors.meatAccent : AppColors.textPrimaryDark)),
          const SizedBox(height: 3),
          Text(type.description,
              style: const TextStyle(fontSize: 10, color: AppColors.textHintDark),
              maxLines: 2,
              overflow: TextOverflow.ellipsis),
        ]),
      ),
    );
  }
}

// ── Sales History Tab ─────────────────────────────────────────────────────
class _SalesHistoryTab extends StatelessWidget {
  final List<MeatSaleModel> sales;
  final List<BatchModel> batches;
  const _SalesHistoryTab({required this.sales, required this.batches});

  @override
  Widget build(BuildContext context) {
    if (sales.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🐔', style: TextStyle(fontSize: 56)),
            SizedBox(height: 12),
            Text('No sales recorded yet',
                style: TextStyle(fontSize: 16, color: AppColors.textSecondaryDark)),
          ],
        ),
      );
    }

    final totalRevenue = sales.fold(0.0, (s, sale) => s + sale.totalAmount);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Revenue',
                    style: TextStyle(
                        color: AppColors.textSecondaryDark,
                        fontWeight: FontWeight.w600)),
                Text('LKR ${totalRevenue.toStringAsFixed(0)}',
                    style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 18,
                        fontWeight: FontWeight.w700)),
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
              final sale = sales[sales.length - 1 - i]; // newest first
              final batch = batches.firstWhere(
                (b) => b.id == sale.batchId,
                orElse: () => batches.first,
              );
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDark),
                ),
                child: Row(
                  children: [
                    Text(
                      sale.saleType.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Text('${sale.quantityBirds} birds',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimaryDark)),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.meatAccent.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(sale.saleType.label,
                                  style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.meatAccent)),
                            ),
                          ]),
                          Text(
                            '${batch.name}${sale.buyerName != null ? ' • ${sale.buyerName}' : ''}',
                            style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSecondaryDark),
                          ),
                          if (sale.saleType == BroilerSaleType.liveBird &&
                              sale.liveWeightKg != null)
                            Text(
                              '${sale.liveWeightKg!.toStringAsFixed(1)} kg @ LKR ${sale.pricePerKg?.toStringAsFixed(0)}/kg',
                              style: const TextStyle(
                                  fontSize: 11, color: AppColors.textSecondaryDark),
                            ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'LKR ${sale.totalAmount.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.success,
                              fontSize: 15),
                        ),
                        Text(
                          sale.saleType == BroilerSaleType.liveBird
                              ? 'Live weight'
                              : '@ LKR ${sale.pricePerBird?.toStringAsFixed(0) ?? '-'}/bird',
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
