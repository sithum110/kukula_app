import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kukula_app/features/auth/login/login_screen.dart';
import 'package:kukula_app/features/auth/login/sign_up_screen.dart';
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
import 'package:kukula_app/features/settings/subscription_screen.dart';

// Route name constants
class AppRoutes {
  static const languageSelect   = '/';
  static const welcome          = '/welcome';
  static const accountDetails   = '/account-details';
  static const farmSetup        = '/farm-setup';
  static const dashboard        = '/dashboard';
  static const alertCenter      = '/alerts';
  static const flocks           = '/flocks';
  static const addFlock         = '/flocks/add';
  static const eggs             = '/eggs';
  static const addEggCollection = '/eggs/add';
  static const eggSales         = '/eggs/sales';
  static const batches          = '/batches';
  static const addBatch         = '/batches/add';
  static const meatSales        = '/batches/sales';
  static const feeding          = '/feeding';
  static const health           = '/health';
  static const finance          = '/finance';
  static const stock            = '/stock';
  static const reports          = '/reports';
  static const users            = '/users';
  static const backup           = '/backup';
  static const settings         = '/settings';
  static const login            = '/login';
  static const signUp           = '/signup';
  static const subscription     = '/subscription';
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.welcome,
    redirect: (context, state) async {
      final loc = state.matchedLocation;

      // Routes that are always accessible (login, signup, onboarding)
      const authRoutes = {
        AppRoutes.languageSelect,
        AppRoutes.welcome,
        AppRoutes.accountDetails,
        AppRoutes.farmSetup,
        AppRoutes.login,
        AppRoutes.signUp,
      };
      final isAuthRoute = authRoutes.contains(loc);

      try {
        // Check both Firebase auth state AND farm onboarding progress.
        // SharedPreferences alone is not sufficient — a user whose Firebase
        // session expired but still has 'farmName' saved must be sent back
        // to the welcome screen to sign in again.
        final firebaseUser = FirebaseAuth.instance.currentUser;
        final prefs = await SharedPreferences.getInstance();
        final hasOnboarded = prefs.getString('farmName') != null;

        // Not signed in → always redirect to welcome (even if onboarded)
        if (firebaseUser == null && !isAuthRoute) return AppRoutes.welcome;

        // Signed in + onboarded + trying to visit an auth screen → dashboard
        if (firebaseUser != null && hasOnboarded && isAuthRoute) {
          return AppRoutes.dashboard;
        }

        // Signed in but not onboarded + trying to visit a protected route
        if (firebaseUser != null && !hasOnboarded && !isAuthRoute) {
          return AppRoutes.welcome;
        }
      } catch (_) {}

      return null; // let the route proceed normally
    },
    routes: [
      // ── Auth & Onboarding ───────────────────────────────────────────────
      GoRoute(path: AppRoutes.login,
          builder: (c, s) => const LoginScreen()),
      GoRoute(path: AppRoutes.signUp,
          builder: (c, s) => const SignUpScreen()),
      GoRoute(path: AppRoutes.languageSelect,
          builder: (c, s) => const LanguageSelectScreen()),
      GoRoute(path: AppRoutes.welcome,
          builder: (c, s) => const WelcomeScreen()),
      GoRoute(path: AppRoutes.accountDetails,
          builder: (c, s) => const AccountDetailsScreen()),
      GoRoute(path: AppRoutes.farmSetup,
          builder: (c, s) => const FarmSetupScreen()),

      // ── Dashboard & Alerts ──────────────────────────────────────────────
      GoRoute(path: AppRoutes.dashboard,
          builder: (c, s) => const DashboardScreen()),
      GoRoute(path: AppRoutes.alertCenter,
          builder: (c, s) => const AlertCenterScreen()),

      // ── Flocks — parent with add/detail as children ─────────────────────
      GoRoute(
        path: AppRoutes.flocks,
        builder: (c, s) => const FlockListScreen(),
        routes: [
          GoRoute(
            path: 'add',   // resolves to /flocks/add
            builder: (c, s) => const AddFlockScreen(),
          ),
          GoRoute(
            path: ':id',   // resolves to /flocks/:id
            builder: (c, s) => const FlockListScreen(),
          ),
        ],
      ),

      // ── Eggs — parent with add/sales as children ────────────────────────
      GoRoute(
        path: AppRoutes.eggs,
        builder: (c, s) => const EggCollectionLogScreen(),
        routes: [
          GoRoute(
            path: 'add',    // resolves to /eggs/add
            builder: (c, s) => const AddEggCollectionScreen(),
          ),
          GoRoute(
            path: 'sales',  // resolves to /eggs/sales
            builder: (c, s) => const EggSalesScreen(),
          ),
        ],
      ),

      // ── Batches — parent with add/sales as children ─────────────────────
      GoRoute(
        path: AppRoutes.batches,
        builder: (c, s) => const BatchListScreen(),
        routes: [
          GoRoute(
            path: 'add',    // resolves to /batches/add
            builder: (c, s) => const AddBatchScreen(),
          ),
          GoRoute(
            path: 'sales',  // resolves to /batches/sales
            builder: (c, s) => const MeatSalesScreen(),
          ),
          GoRoute(
            path: ':id',    // resolves to /batches/:id
            builder: (c, s) => const BatchListScreen(),
          ),
        ],
      ),

      // ── Other top-level screens ─────────────────────────────────────────
      GoRoute(path: AppRoutes.feeding,
          builder: (c, s) => const FeedLogScreen()),
      GoRoute(path: AppRoutes.health,
          builder: (c, s) => const HealthLogScreen()),
      GoRoute(path: AppRoutes.finance,
          builder: (c, s) => const FinanceOverviewScreen()),
      GoRoute(path: AppRoutes.stock,
          builder: (c, s) => const StockOverviewScreen()),
      GoRoute(path: AppRoutes.reports,
          builder: (c, s) => const ReportsHubScreen()),
      GoRoute(path: AppRoutes.users,
          builder: (c, s) => const UserListScreen()),
      GoRoute(path: AppRoutes.backup,
          builder: (c, s) => const BackupScreen()),
      GoRoute(path: AppRoutes.settings,
          builder: (c, s) => const SettingsScreen()),
      GoRoute(path: AppRoutes.subscription,
          builder: (c, s) => const SubscriptionScreen()),
    ],
  );
});
