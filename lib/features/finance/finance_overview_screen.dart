import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/core/providers/finance_providers.dart';
import 'package:kukula_app/core/theme/app_theme.dart';
import 'package:kukula_app/features/finance/finance_model.dart';

class FinanceOverviewScreen extends ConsumerStatefulWidget {
  const FinanceOverviewScreen({super.key});

  @override
  ConsumerState<FinanceOverviewScreen> createState() =>
      _FinanceOverviewScreenState();
}

class _FinanceOverviewScreenState
    extends ConsumerState<FinanceOverviewScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
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
        title: const Text('Finance'),
        bottom: TabBar(
          controller: _tab,
          indicatorColor: AppColors.success,
          labelColor: AppColors.success,
          unselectedLabelColor: AppColors.textSecondaryDark,
          tabs: const [
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('📊', style: TextStyle(fontSize: 14)),
              SizedBox(width: 4),
              Text('Overview'),
            ])),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('📋', style: TextStyle(fontSize: 14)),
              SizedBox(width: 4),
              Text('Transactions'),
            ])),
            Tab(child: Row(mainAxisSize: MainAxisSize.min, children: [
              Text('📈', style: TextStyle(fontSize: 14)),
              SizedBox(width: 4),
              Text('Breakdown'),
            ])),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _OverviewTab(),
          _TransactionsTab(),
          _BreakdownTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddTransactionSheet(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _AddTransactionSheet(),
    );
  }
}

// ── Overview Tab ───────────────────────────────────────────────────────────
class _OverviewTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(financeProvider.notifier);
    ref.watch(financeProvider);

    final netProfit = notifier.netProfit;
    final totalIncome = notifier.totalIncome;
    final totalExpense = notifier.totalExpense;
    final monthProfit = notifier.monthProfit;
    final monthIncome = notifier.monthIncome;
    final monthExpense = notifier.monthExpense;
    final dailyNet = notifier.last7DaysNet;

    final isProfit = netProfit >= 0;
    final isMonthProfit = monthProfit >= 0;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Net Profit Hero Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isProfit
                    ? [
                        AppColors.success.withValues(alpha: 0.85),
                        AppColors.success.withValues(alpha: 0.5),
                      ]
                    : [
                        AppColors.error.withValues(alpha: 0.85),
                        AppColors.error.withValues(alpha: 0.5),
                      ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text(isProfit ? '📈' : '📉',
                      style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text(
                    isProfit ? 'Profitable Farm!' : 'Running at a Loss',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70),
                  ),
                ]),
                const SizedBox(height: 8),
                Text(
                  '${isProfit ? '+' : ''}LKR ${netProfit.toStringAsFixed(0)}',
                  style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
                ),
                const Text('Net Profit (All Time)',
                    style: TextStyle(fontSize: 13, color: Colors.white70)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _MiniStat(
                        label: 'Total Income',
                        value: 'LKR ${totalIncome.toStringAsFixed(0)}',
                        color: Colors.white,
                      ),
                    ),
                    Expanded(
                      child: _MiniStat(
                        label: 'Total Expenses',
                        value: 'LKR ${totalExpense.toStringAsFixed(0)}',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // This Month
          _SectionLabel('📅 This Month'),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  emoji: '💰',
                  label: 'Income',
                  value: 'LKR ${monthIncome.toStringAsFixed(0)}',
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  emoji: '💸',
                  label: 'Expenses',
                  value: 'LKR ${monthExpense.toStringAsFixed(0)}',
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  emoji: isMonthProfit ? '📈' : '📉',
                  label: 'Net',
                  value:
                      '${isMonthProfit ? '+' : ''}LKR ${monthProfit.toStringAsFixed(0)}',
                  color: isMonthProfit ? AppColors.success : AppColors.error,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // 7-Day P&L Chart
          _SectionLabel('📊 Last 7 Days — Daily Net'),
          const SizedBox(height: 12),
          _DailyNetChart(dailyNet: dailyNet),
          const SizedBox(height: 20),

          // Quick recent transactions
          _SectionLabel('🕐 Recent Transactions'),
          const SizedBox(height: 10),
          Consumer(builder: (_, ref, __) {
            final txns = ref.watch(financeProvider).take(4).toList();
            return Column(
              children: txns
                  .map((t) => _TransactionTile(txn: t, compact: true))
                  .toList(),
            );
          }),
        ],
      ),
    );
  }
}

// ── Transactions Tab ───────────────────────────────────────────────────────
class _TransactionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(financeProvider.notifier);
    final txns = ref.watch(financeProvider);
    final grouped = notifier.groupedByDate;

    if (txns.isEmpty) {
      return const _EmptyState(
        emoji: '💳',
        title: 'No Transactions',
        subtitle: 'Tap + to add your first income or expense.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: grouped.length,
      itemBuilder: (_, i) {
        final dateKey = grouped.keys.toList()[i];
        final dayTxns = grouped[dateKey]!;
        final dayIncome = dayTxns
            .where((t) => t.type == TransactionType.income)
            .fold(0.0, (s, t) => s + t.amount);
        final dayExpense = dayTxns
            .where((t) => t.type == TransactionType.expense)
            .fold(0.0, (s, t) => s + t.amount);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              _DateChip(label: dateKey),
              const SizedBox(width: 8),
              if (dayIncome > 0)
                Text('+LKR ${dayIncome.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.success)),
              if (dayExpense > 0) ...[
                const Text(' / ',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textHintDark)),
                Text('-LKR ${dayExpense.toStringAsFixed(0)}',
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.error)),
              ],
            ]),
            const SizedBox(height: 8),
            ...dayTxns.map((t) => _TransactionTile(txn: t)),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }
}

class _TransactionTile extends ConsumerWidget {
  final FinanceTransactionModel txn;
  final bool compact;
  const _TransactionTile({required this.txn, this.compact = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isIncome = txn.type == TransactionType.income;

    return Dismissible(
      key: Key(txn.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(13),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      onDismissed: (_) {
        ref.read(financeProvider.notifier).deleteTransaction(txn.id);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction deleted'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: EdgeInsets.all(compact ? 10 : 13),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(13),
          border: Border.all(
            color: isIncome
                ? AppColors.success.withValues(alpha: 0.2)
                : AppColors.error.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isIncome
                    ? AppColors.success.withValues(alpha: 0.12)
                    : AppColors.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(txn.category.emoji,
                    style: const TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(txn.category.label,
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryDark)),
                  if (txn.description != null)
                    Text(txn.description!,
                        style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondaryDark),
                        overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${isIncome ? '+' : '-'}LKR ${txn.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isIncome ? AppColors.success : AppColors.error),
                ),
                Text(
                  '${txn.date.day}/${txn.date.month}',
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textHintDark),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Breakdown Tab ──────────────────────────────────────────────────────────
class _BreakdownTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(financeProvider.notifier);
    ref.watch(financeProvider);

    final incomeBreakdown = notifier.topIncomeCategories;
    final expenseBreakdown = notifier.topExpenseCategories;
    final totalIncome = notifier.totalIncome;
    final totalExpense = notifier.totalExpense;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Income breakdown
          _SectionLabel('💰 Income Sources'),
          const SizedBox(height: 12),
          if (incomeBreakdown.isEmpty)
            const _EmptyCard(label: 'No income recorded')
          else
            ...incomeBreakdown.map((e) => _BreakdownBar(
                  emoji: e.key.emoji,
                  label: e.key.label,
                  amount: e.value,
                  total: totalIncome,
                  color: AppColors.success,
                )),
          const SizedBox(height: 24),

          // Expense breakdown
          _SectionLabel('💸 Expense Breakdown'),
          const SizedBox(height: 12),
          if (expenseBreakdown.isEmpty)
            const _EmptyCard(label: 'No expenses recorded')
          else
            ...expenseBreakdown.map((e) => _BreakdownBar(
                  emoji: e.key.emoji,
                  label: e.key.label,
                  amount: e.value,
                  total: totalExpense,
                  color: AppColors.error,
                )),
          const SizedBox(height: 24),

          // Profit margin
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderDark),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('📊 Profit Margin',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryDark)),
                const SizedBox(height: 12),
                if (totalIncome > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Margin',
                          style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondaryDark)),
                      Text(
                        '${((notifier.netProfit / totalIncome) * 100).toStringAsFixed(1)}%',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: notifier.netProfit >= 0
                              ? AppColors.success
                              : AppColors.error,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (notifier.netProfit / totalIncome)
                          .clamp(0.0, 1.0),
                      backgroundColor: AppColors.error.withValues(alpha: 0.3),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.success),
                      minHeight: 10,
                    ),
                  ),
                ] else
                  const Text('No income data',
                      style: TextStyle(color: AppColors.textHintDark)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BreakdownBar extends StatelessWidget {
  final String emoji;
  final String label;
  final double amount;
  final double total;
  final Color color;

  const _BreakdownBar({
    required this.emoji,
    required this.label,
    required this.amount,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final pct = total > 0 ? (amount / total).clamp(0.0, 1.0) : 0.0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimaryDark,
                        fontWeight: FontWeight.w500)),
              ),
              Text(
                'LKR ${amount.toStringAsFixed(0)}',
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryDark),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 36,
                child: Text(
                  '${(pct * 100).toStringAsFixed(0)}%',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textHintDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: AppColors.borderDark,
              valueColor: AlwaysStoppedAnimation<Color>(
                  color.withValues(alpha: 0.7)),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

// ── 7-Day Chart ────────────────────────────────────────────────────────────
class _DailyNetChart extends StatelessWidget {
  final List<double> dailyNet;
  const _DailyNetChart({required this.dailyNet});

  @override
  Widget build(BuildContext context) {
    final maxAbs = dailyNet.map((v) => v.abs()).reduce((a, b) => a > b ? a : b);
    final days = ['6d', '5d', '4d', '3d', '2d', 'Yest', 'Today'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _Legend(color: AppColors.success, label: 'Profit'),
              const SizedBox(width: 12),
              _Legend(color: AppColors.error, label: 'Loss'),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(dailyNet.length, (i) {
                final val = dailyNet[i];
                final barPct = maxAbs > 0 ? val.abs() / maxAbs : 0.0;
                final isPos = val >= 0;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Amount label
                        if (val != 0)
                          Text(
                            val.abs() >= 1000
                                ? '${(val.abs() / 1000).toStringAsFixed(1)}k'
                                : val.abs().toStringAsFixed(0),
                            style: TextStyle(
                                fontSize: 9,
                                color: isPos
                                    ? AppColors.success
                                    : AppColors.error),
                          ),
                        const SizedBox(height: 2),
                        // Bar
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400 + i * 60),
                          curve: Curves.easeOut,
                          height: val == 0 ? 4 : (barPct * 90).clamp(4, 90),
                          decoration: BoxDecoration(
                            color: isPos
                                ? AppColors.success
                                    .withValues(alpha: 0.75)
                                : AppColors.error.withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Day label
                        Text(days[i],
                            style: const TextStyle(
                                fontSize: 9,
                                color: AppColors.textHintDark)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Add Transaction Sheet ──────────────────────────────────────────────────
class _AddTransactionSheet extends ConsumerStatefulWidget {
  const _AddTransactionSheet();

  @override
  ConsumerState<_AddTransactionSheet> createState() =>
      _AddTransactionSheetState();
}

class _AddTransactionSheetState
    extends ConsumerState<_AddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  TransactionType _type = TransactionType.income;
  FinanceCategory? _category;
  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  bool _isLoading = false;

  List<FinanceCategory> get _categories => FinanceCategory.values
      .where((c) => c.type == _type)
      .toList();

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderDark,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text('Add Transaction',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryDark)),
              const SizedBox(height: 16),

              // Income / Expense toggle
              Row(children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _type = TransactionType.income;
                      _category = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _type == TransactionType.income
                            ? AppColors.success.withValues(alpha: 0.2)
                            : AppColors.cardDark2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _type == TransactionType.income
                              ? AppColors.success
                              : AppColors.borderDark,
                        ),
                      ),
                      child: Center(
                        child: Text('💰 Income',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: _type == TransactionType.income
                                    ? AppColors.success
                                    : AppColors.textSecondaryDark)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _type = TransactionType.expense;
                      _category = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _type == TransactionType.expense
                            ? AppColors.error.withValues(alpha: 0.2)
                            : AppColors.cardDark2,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _type == TransactionType.expense
                              ? AppColors.error
                              : AppColors.borderDark,
                        ),
                      ),
                      child: Center(
                        child: Text('💸 Expense',
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: _type == TransactionType.expense
                                    ? AppColors.error
                                    : AppColors.textSecondaryDark)),
                      ),
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 14),

              // Category selector
              const _Label('Category'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _categories.map((cat) {
                  final selected = _category == cat;
                  final color = _type == TransactionType.income
                      ? AppColors.success
                      : AppColors.error;
                  return GestureDetector(
                    onTap: () => setState(() => _category = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 7),
                      decoration: BoxDecoration(
                        color: selected
                            ? color.withValues(alpha: 0.15)
                            : AppColors.cardDark2,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? color
                              : AppColors.borderDark,
                        ),
                      ),
                      child: Text(
                        '${cat.emoji} ${cat.label}',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: selected
                                ? color
                                : AppColors.textSecondaryDark),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 14),

              // Amount
              const _Label('Amount (LKR)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountCtrl,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  hintText: '5000',
                  prefixText: 'LKR ',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Required';
                  if (double.tryParse(v) == null || double.parse(v) <= 0) {
                    return 'Invalid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Description
              const _Label('Description (optional)'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descCtrl,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  hintText: 'e.g. 100 trays @ LKR 50/egg',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: 12),

              // Date
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.cardDark2,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderDark),
                  ),
                  child: Row(children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 18, color: AppColors.textSecondaryDark),
                    const SizedBox(width: 10),
                    Text(
                      '${_date.day}/${_date.month}/${_date.year}',
                      style: const TextStyle(
                          color: AppColors.textPrimaryDark, fontSize: 14),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _isLoading ? null : _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _type == TransactionType.income
                      ? AppColors.success
                      : AppColors.error,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text(_type == TransactionType.income
                        ? 'Add Income'
                        : 'Add Expense'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(data: AppTheme.darkTheme, child: child!),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _isLoading = true);

    final txn = FinanceTransactionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      farmId: 'farm1',
      type: _type,
      category: _category!,
      amount: double.parse(_amountCtrl.text),
      description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
      date: _date,
      createdAt: DateTime.now(),
    );

    ref.read(financeProvider.notifier).addTransaction(txn);

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);
      final isIncome = _type == TransactionType.income;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              '${isIncome ? '✅ Income' : '💸 Expense'}: LKR ${txn.amount.toStringAsFixed(0)} — ${_category!.label}'),
          backgroundColor:
              isIncome ? AppColors.success : AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }
}

// ── Shared Widgets ─────────────────────────────────────────────────────────
class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.8))),
          Text(value,
              style: TextStyle(
                  fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        ],
      );
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  const _StatCard({required this.emoji, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(
                    fontSize: 10, color: AppColors.textSecondaryDark)),
            const SizedBox(height: 2),
            Text(value,
                style: TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w700, color: color),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ],
        ),
      );
}

class _DateChip extends StatelessWidget {
  final String label;
  const _DateChip({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.success)),
      );
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel(this.label);
  @override
  Widget build(BuildContext context) => Text(label,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryDark));
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondaryDark));
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 10, height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppColors.textSecondaryDark)),
        ],
      );
}

class _EmptyCard extends StatelessWidget {
  final String label;
  const _EmptyCard({required this.label});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDark),
        ),
        child: Center(
            child: Text(label,
                style: const TextStyle(color: AppColors.textHintDark))),
      );
}

class _EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  const _EmptyState(
      {required this.emoji, required this.title, required this.subtitle});
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(title,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryDark)),
            const SizedBox(height: 8),
            Text(subtitle,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(color: AppColors.textSecondaryDark)),
          ],
        ),
      );
}
