import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kukula_app/features/auth/onboarding/language_select_screen.dart';
import 'package:kukula_app/features/auth/onboarding/welcome_screen.dart';
import 'package:kukula_app/features/auth/onboarding/account_details_screen.dart';
import 'package:kukula_app/features/auth/onboarding/farm_setup_screen.dart';
import 'package:kukula_app/features/dashboard/dashboard_screen.dart';
import 'package:kukula_app/features/dashboard/alert_center_screen.dart';
import 'package:kukula_app/features/flocks/flock_list_screen.dart';
import 'package:kukula_app/features/flocks/add_flock_screen.dart';
import 'package:kukula_app/features/egg_production/egg_collection_log_screen.dart';
import 'package:kukula_app/features/egg_production/add_egg_collection_screen.dart';
import 'package:kukula_app/features/egg_production/egg_sales_screen.dart';
import 'package:kukula_app/features/meat_batches/batch_list_screen.dart';
import 'package:kukula_app/features/meat_batches/add_batch_screen.dart';
import 'package:kukula_app/features/meat_batches/meat_sales_screen.dart';
import 'package:kukula_app/features/feeding/feed_log_screen.dart';
import 'package:kukula_app/features/health/health_log_screen.dart';
import 'package:kukula_app/features/finance/finance_overview_screen.dart';
import 'package:kukula_app/features/stock/stock_overview_screen.dart';
import 'package:kukula_app/features/reports/reports_hub_screen.dart';
import 'package:kukula_app/features/users/user_list_screen.dart';
import 'package:kukula_app/features/backup/backup_screen.dart';
import 'package:kukula_app/features/settings/settings_screen.dart';

// Route name constants
class AppRoutes {
  static const languageSelect = '/';
  static const welcome = '/welcome';
  static const accountDetails = '/account-details';
  static const farmSetup = '/farm-setup';
  static const dashboard = '/dashboard';
  static const alertCenter = '/alerts';
  static const flocks = '/flocks';
  static const addFlock = '/flocks/add';
  static const eggs = '/eggs';
  static const addEggCollection = '/eggs/add';
  static const eggSales = '/eggs/sales';
  static const batches = '/batches';
  static const addBatch = '/batches/add';
  static const meatSales = '/batches/sales';
  static const feeding = '/feeding';
  static const health = '/health';
  static const finance = '/finance';
  static const stock = '/stock';
  static const reports = '/reports';
  static const users = '/users';
  static const backup = '/backup';
  static const settings = '/settings';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.languageSelect,
    routes: [
      GoRoute(
        path: AppRoutes.languageSelect,
        builder: (context, state) => const LanguageSelectScreen(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.accountDetails,
        builder: (context, state) => const AccountDetailsScreen(),
      ),
      GoRoute(
        path: AppRoutes.farmSetup,
        builder: (context, state) => const FarmSetupScreen(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.alertCenter,
        builder: (context, state) => const AlertCenterScreen(),
      ),
      GoRoute(
        path: AppRoutes.flocks,
        builder: (context, state) => const FlockListScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.flocks}/:id',
        builder: (context, state) => const FlockListScreen(), // TODO: FlockDetailScreen
      ),
      GoRoute(
        path: AppRoutes.addFlock,
        builder: (context, state) => const AddFlockScreen(),
      ),
      GoRoute(
        path: AppRoutes.eggs,
        builder: (context, state) => const EggCollectionLogScreen(),
      ),
      GoRoute(
        path: AppRoutes.addEggCollection,
        builder: (context, state) => const AddEggCollectionScreen(),
      ),
      GoRoute(
        path: AppRoutes.eggSales,
        builder: (context, state) => const EggSalesScreen(),
      ),
      GoRoute(
        path: AppRoutes.batches,
        builder: (context, state) => const BatchListScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.batches}/:id',
        builder: (context, state) => const BatchListScreen(), // TODO: BatchDetailScreen
      ),
      GoRoute(
        path: AppRoutes.addBatch,
        builder: (context, state) => const AddBatchScreen(),
      ),
      GoRoute(
        path: AppRoutes.meatSales,
        builder: (context, state) => const MeatSalesScreen(),
      ),
      GoRoute(
        path: AppRoutes.feeding,
        builder: (context, state) => const FeedLogScreen(),
      ),
      GoRoute(
        path: AppRoutes.health,
        builder: (context, state) => const HealthLogScreen(),
      ),
      GoRoute(
        path: AppRoutes.finance,
        builder: (context, state) => const FinanceOverviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.stock,
        builder: (context, state) => const StockOverviewScreen(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        builder: (context, state) => const ReportsHubScreen(),
      ),
      GoRoute(
        path: AppRoutes.users,
        builder: (context, state) => const UserListScreen(),
      ),
      GoRoute(
        path: AppRoutes.backup,
        builder: (context, state) => const BackupScreen(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});
