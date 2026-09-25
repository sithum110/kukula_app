import 'package:flutter/foundation.dart';

// ── Subscription Plan ──────────────────────────────────────────────────────
enum SubscriptionPlan { free, premium }

// ── Billing Service ────────────────────────────────────────────────────────
// This is a stub implementation ready for Google Play Billing integration.
// Replace with in_app_purchase plugin calls when Google Play Console is set up.
class BillingService {
  // Google Play product IDs (register these in Play Console)
  static const String _monthlyProductId = 'kukula_premium_monthly';
  static const String _yearlyProductId = 'kukula_premium_yearly';
  static const String _lifetimeProductId = 'kukula_premium_lifetime';

  // Pricing (displayed in UI — actual price comes from Play Store)
  static const Map<String, PricingInfo> pricing = {
    _monthlyProductId: PricingInfo(
      id: _monthlyProductId,
      label: 'Monthly',
      price: 'LKR 290',
      period: '/month',
      description: 'Billed monthly. Cancel anytime.',
      isPopular: false,
    ),
    _yearlyProductId: PricingInfo(
      id: _yearlyProductId,
      label: 'Yearly',
      price: 'LKR 2,490',
      period: '/year',
      description: 'Save 28% vs monthly. Best value!',
      isPopular: true,
    ),
    _lifetimeProductId: PricingInfo(
      id: _lifetimeProductId,
      label: 'Lifetime',
      price: 'LKR 4,900',
      period: 'one-time',
      description: 'Pay once, use forever.',
      isPopular: false,
    ),
  };

  static List<PricingInfo> get plans => pricing.values.toList();

  // ── Purchase (stub — integrate in_app_purchase here) ─────────────────────
  static Future<BillingResult> purchase(String productId) async {
    // TODO: Integrate Google Play Billing
    // final purchaseParam = PurchaseParam(productDetails: ...);
    // await InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    debugPrint('[BillingService] Purchase requested for $productId — stub');
    return const BillingResult(success: false, message: 'Google Play Billing not yet configured. Add google-services.json and configure Play Console.');
  }

  // ── Restore purchases ─────────────────────────────────────────────────────
  static Future<bool> restorePurchases() async {
    // TODO: InAppPurchase.instance.restorePurchases();
    debugPrint('[BillingService] Restore purchases — stub');
    return false;
  }

  // ── Check subscription status ─────────────────────────────────────────────
  static Future<bool> checkPremiumStatus() async {
    // TODO: Query purchase stream for active subscriptions
    return false;
  }
}

// ── Pricing Info ───────────────────────────────────────────────────────────
class PricingInfo {
  final String id;
  final String label;
  final String price;
  final String period;
  final String description;
  final bool isPopular;

  const PricingInfo({
    required this.id,
    required this.label,
    required this.price,
    required this.period,
    required this.description,
    required this.isPopular,
  });
}

// ── Billing Result ─────────────────────────────────────────────────────────
class BillingResult {
  final bool success;
  final String? message;
  const BillingResult({required this.success, this.message});
}

// ── Premium Feature List ───────────────────────────────────────────────────
const List<PremiumFeature> premiumFeatures = [
  PremiumFeature(
    icon: '📊',
    title: 'PDF Reports',
    description: 'Generate and share detailed farm reports',
  ),
  PremiumFeature(
    icon: '☁️',
    title: 'Google Drive Backup',
    description: 'Auto-backup to Google Drive, restore from any device',
  ),
  PremiumFeature(
    icon: '👥',
    title: 'Up to 5 Workers',
    description: 'Invite your farm staff to manage records',
  ),
  PremiumFeature(
    icon: '🐔',
    title: 'Unlimited Flocks & Batches',
    description: 'No cap on the number of active flocks or batches',
  ),
  PremiumFeature(
    icon: '📅',
    title: 'Full History',
    description: 'Access all records without time limits',
  ),
  PremiumFeature(
    icon: '📈',
    title: 'Advanced Charts & P&L',
    description: 'Detailed profit/loss analysis and trend charts',
  ),
];

class PremiumFeature {
  final String icon;
  final String title;
  final String description;
  const PremiumFeature({
    required this.icon,
    required this.title,
    required this.description,
  });
}
