enum TransactionType { income, expense }

enum FinanceCategory {
  // Income
  eggSales,
  meatSales,
  otherIncome,
  // Expense
  feedCost,
  medicineCost,
  labourCost,
  utilities,
  equipment,
  transport,
  otherExpense;

  String get label {
    switch (this) {
      case FinanceCategory.eggSales: return 'Egg Sales';
      case FinanceCategory.meatSales: return 'Broiler Sales';
      case FinanceCategory.otherIncome: return 'Other Income';
      case FinanceCategory.feedCost: return 'Feed Cost';
      case FinanceCategory.medicineCost: return 'Medicine / Vet';
      case FinanceCategory.labourCost: return 'Labour / Wages';
      case FinanceCategory.utilities: return 'Utilities';
      case FinanceCategory.equipment: return 'Equipment';
      case FinanceCategory.transport: return 'Transport';
      case FinanceCategory.otherExpense: return 'Other Expense';
    }
  }

  String get emoji {
    switch (this) {
      case FinanceCategory.eggSales: return '🥚';
      case FinanceCategory.meatSales: return '🐔';
      case FinanceCategory.otherIncome: return '💵';
      case FinanceCategory.feedCost: return '🌾';
      case FinanceCategory.medicineCost: return '💊';
      case FinanceCategory.labourCost: return '👷';
      case FinanceCategory.utilities: return '💡';
      case FinanceCategory.equipment: return '🔧';
      case FinanceCategory.transport: return '🚚';
      case FinanceCategory.otherExpense: return '📝';
    }
  }

  TransactionType get type {
    switch (this) {
      case FinanceCategory.eggSales:
      case FinanceCategory.meatSales:
      case FinanceCategory.otherIncome:
        return TransactionType.income;
      default:
        return TransactionType.expense;
    }
  }
}

class FinanceTransactionModel {
  final String id;
  final String farmId;
  final TransactionType type;
  final FinanceCategory category;
  final double amount;
  final String? description;
  final String? reference;
  final DateTime date;
  final DateTime createdAt;

  const FinanceTransactionModel({
    required this.id,
    required this.farmId,
    required this.type,
    required this.category,
    required this.amount,
    this.description,
    this.reference,
    required this.date,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'farmId': farmId,
    'type': type.name,
    'category': category.name,
    'amount': amount,
    'description': description,
    'reference': reference,
    'date': date.toIso8601String(),
    'createdAt': createdAt.toIso8601String(),
  };

  factory FinanceTransactionModel.fromJson(Map<String, dynamic> j) =>
      FinanceTransactionModel(
        id: j['id'] as String,
        farmId: (j['farmId'] as String?) ?? 'farm1',
        type: TransactionType.values.firstWhere(
            (e) => e.name == j['type'], orElse: () => TransactionType.income),
        category: FinanceCategory.values.firstWhere(
            (e) => e.name == j['category'],
            orElse: () => FinanceCategory.otherIncome),
        amount: (j['amount'] as num).toDouble(),
        description: j['description'] as String?,
        reference: j['reference'] as String?,
        date: DateTime.parse(j['date'] as String),
        createdAt: DateTime.parse(j['createdAt'] as String),
      );
}
