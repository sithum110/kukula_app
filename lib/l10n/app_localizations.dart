import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_si.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('si')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Easy Poultry Manager'**
  String get appName;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Easy Poultry Manager'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your farm smarter, not harder'**
  String get welcomeSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @farmName.
  ///
  /// In en, this message translates to:
  /// **'Farm Name'**
  String get farmName;

  /// No description provided for @farmLocation.
  ///
  /// In en, this message translates to:
  /// **'Farm Location (optional)'**
  String get farmLocation;

  /// No description provided for @continueBtn.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueBtn;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @sinhala.
  ///
  /// In en, this message translates to:
  /// **'සිංහල'**
  String get sinhala;

  /// No description provided for @chooseFarmType.
  ///
  /// In en, this message translates to:
  /// **'What type of farm do you manage?'**
  String get chooseFarmType;

  /// No description provided for @eggFarm.
  ///
  /// In en, this message translates to:
  /// **'Egg Farm'**
  String get eggFarm;

  /// No description provided for @eggFarmDesc.
  ///
  /// In en, this message translates to:
  /// **'I raise layer hens for egg production'**
  String get eggFarmDesc;

  /// No description provided for @meatFarm.
  ///
  /// In en, this message translates to:
  /// **'Meat Farm'**
  String get meatFarm;

  /// No description provided for @meatFarmDesc.
  ///
  /// In en, this message translates to:
  /// **'I raise broiler chickens for meat & sale'**
  String get meatFarmDesc;

  /// No description provided for @bothFarms.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get bothFarms;

  /// No description provided for @bothFarmsDesc.
  ///
  /// In en, this message translates to:
  /// **'My farm produces both eggs and meat'**
  String get bothFarmsDesc;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @flocks.
  ///
  /// In en, this message translates to:
  /// **'Flocks'**
  String get flocks;

  /// No description provided for @eggs.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get eggs;

  /// No description provided for @batches.
  ///
  /// In en, this message translates to:
  /// **'Batches'**
  String get batches;

  /// No description provided for @feeding.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get feeding;

  /// No description provided for @finance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get finance;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @users.
  ///
  /// In en, this message translates to:
  /// **'Users'**
  String get users;

  /// No description provided for @backup.
  ///
  /// In en, this message translates to:
  /// **'Backup'**
  String get backup;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @alerts.
  ///
  /// In en, this message translates to:
  /// **'Alerts'**
  String get alerts;

  /// No description provided for @noAlerts.
  ///
  /// In en, this message translates to:
  /// **'No alerts right now'**
  String get noAlerts;

  /// No description provided for @premiumFeature.
  ///
  /// In en, this message translates to:
  /// **'Premium Feature'**
  String get premiumFeature;

  /// No description provided for @upgradeToUnlock.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to unlock this feature'**
  String get upgradeToUnlock;

  /// No description provided for @upgradeToPremium.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeToPremium;

  /// No description provided for @freeLimit.
  ///
  /// In en, this message translates to:
  /// **'You\'ve reached the free plan limit'**
  String get freeLimit;

  /// No description provided for @addFlock.
  ///
  /// In en, this message translates to:
  /// **'Add Flock'**
  String get addFlock;

  /// No description provided for @addBatch.
  ///
  /// In en, this message translates to:
  /// **'Add Batch'**
  String get addBatch;

  /// No description provided for @flockName.
  ///
  /// In en, this message translates to:
  /// **'Flock Name'**
  String get flockName;

  /// No description provided for @breed.
  ///
  /// In en, this message translates to:
  /// **'Breed'**
  String get breed;

  /// No description provided for @arrivalDate.
  ///
  /// In en, this message translates to:
  /// **'Arrival / Hatch Date'**
  String get arrivalDate;

  /// No description provided for @initialCount.
  ///
  /// In en, this message translates to:
  /// **'Initial Bird Count'**
  String get initialCount;

  /// No description provided for @pen.
  ///
  /// In en, this message translates to:
  /// **'Pen / Location'**
  String get pen;

  /// No description provided for @layer.
  ///
  /// In en, this message translates to:
  /// **'Layer'**
  String get layer;

  /// No description provided for @broiler.
  ///
  /// In en, this message translates to:
  /// **'Broiler'**
  String get broiler;

  /// No description provided for @purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @addEggCollection.
  ///
  /// In en, this message translates to:
  /// **'Add Egg Collection'**
  String get addEggCollection;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @totalEggs.
  ///
  /// In en, this message translates to:
  /// **'Total Eggs Collected'**
  String get totalEggs;

  /// No description provided for @brokenEggs.
  ///
  /// In en, this message translates to:
  /// **'Broken Eggs'**
  String get brokenEggs;

  /// No description provided for @collectedBy.
  ///
  /// In en, this message translates to:
  /// **'Collected By'**
  String get collectedBy;

  /// No description provided for @traysCount.
  ///
  /// In en, this message translates to:
  /// **'Trays (1 tray = 30 eggs)'**
  String get traysCount;

  /// No description provided for @eggGrading.
  ///
  /// In en, this message translates to:
  /// **'Egg Grading (optional)'**
  String get eggGrading;

  /// No description provided for @gradeA.
  ///
  /// In en, this message translates to:
  /// **'Grade A'**
  String get gradeA;

  /// No description provided for @gradeB.
  ///
  /// In en, this message translates to:
  /// **'Grade B'**
  String get gradeB;

  /// No description provided for @gradeC.
  ///
  /// In en, this message translates to:
  /// **'Grade C'**
  String get gradeC;

  /// No description provided for @eggSales.
  ///
  /// In en, this message translates to:
  /// **'Egg Sales'**
  String get eggSales;

  /// No description provided for @addEggSale.
  ///
  /// In en, this message translates to:
  /// **'Add Egg Sale'**
  String get addEggSale;

  /// No description provided for @buyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer Name'**
  String get buyer;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @pricePerUnit.
  ///
  /// In en, this message translates to:
  /// **'Price per Unit (LKR)'**
  String get pricePerUnit;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @eggStock.
  ///
  /// In en, this message translates to:
  /// **'Egg Stock'**
  String get eggStock;

  /// No description provided for @currentStock.
  ///
  /// In en, this message translates to:
  /// **'Current Stock'**
  String get currentStock;

  /// No description provided for @addBirdMortality.
  ///
  /// In en, this message translates to:
  /// **'Record Bird Mortality'**
  String get addBirdMortality;

  /// No description provided for @cause.
  ///
  /// In en, this message translates to:
  /// **'Cause'**
  String get cause;

  /// No description provided for @count.
  ///
  /// In en, this message translates to:
  /// **'Count'**
  String get count;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @addFeedLog.
  ///
  /// In en, this message translates to:
  /// **'Add Feed Entry'**
  String get addFeedLog;

  /// No description provided for @feedType.
  ///
  /// In en, this message translates to:
  /// **'Feed Type'**
  String get feedType;

  /// No description provided for @quantityKg.
  ///
  /// In en, this message translates to:
  /// **'Quantity (kg)'**
  String get quantityKg;

  /// No description provided for @costPerKg.
  ///
  /// In en, this message translates to:
  /// **'Cost per kg (LKR)'**
  String get costPerKg;

  /// No description provided for @feedStock.
  ///
  /// In en, this message translates to:
  /// **'Feed Stock'**
  String get feedStock;

  /// No description provided for @lowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get lowStock;

  /// No description provided for @addHealthRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Health Record'**
  String get addHealthRecord;

  /// No description provided for @vaccination.
  ///
  /// In en, this message translates to:
  /// **'Vaccination'**
  String get vaccination;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// No description provided for @treatment.
  ///
  /// In en, this message translates to:
  /// **'Treatment'**
  String get treatment;

  /// No description provided for @observation.
  ///
  /// In en, this message translates to:
  /// **'Observation'**
  String get observation;

  /// No description provided for @vaccineName.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Name'**
  String get vaccineName;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name'**
  String get medicineName;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @nextDue.
  ///
  /// In en, this message translates to:
  /// **'Next Due Date'**
  String get nextDue;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount (LKR)'**
  String get amount;

  /// No description provided for @profitLoss.
  ///
  /// In en, this message translates to:
  /// **'Profit / Loss'**
  String get profitLoss;

  /// No description provided for @totalIncome.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get totalIncome;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get generateReport;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @backupNow.
  ///
  /// In en, this message translates to:
  /// **'Backup Now'**
  String get backupNow;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @lastBackup.
  ///
  /// In en, this message translates to:
  /// **'Last Backup'**
  String get lastBackup;

  /// No description provided for @googleDriveBackup.
  ///
  /// In en, this message translates to:
  /// **'Google Drive Backup'**
  String get googleDriveBackup;

  /// No description provided for @localBackup.
  ///
  /// In en, this message translates to:
  /// **'Local Backup'**
  String get localBackup;

  /// No description provided for @inviteWorker.
  ///
  /// In en, this message translates to:
  /// **'Invite Worker'**
  String get inviteWorker;

  /// No description provided for @removeUser.
  ///
  /// In en, this message translates to:
  /// **'Remove User'**
  String get removeUser;

  /// No description provided for @owner.
  ///
  /// In en, this message translates to:
  /// **'Owner'**
  String get owner;

  /// No description provided for @worker.
  ///
  /// In en, this message translates to:
  /// **'Worker'**
  String get worker;

  /// No description provided for @todaysCollection.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Collection'**
  String get todaysCollection;

  /// No description provided for @eggStockOnHand.
  ///
  /// In en, this message translates to:
  /// **'Eggs on Hand'**
  String get eggStockOnHand;

  /// No description provided for @activeFlocksCount.
  ///
  /// In en, this message translates to:
  /// **'Active Flocks'**
  String get activeFlocksCount;

  /// No description provided for @activeBatchesCount.
  ///
  /// In en, this message translates to:
  /// **'Active Batches'**
  String get activeBatchesCount;

  /// No description provided for @totalBirds.
  ///
  /// In en, this message translates to:
  /// **'Total Birds'**
  String get totalBirds;

  /// No description provided for @recentSales.
  ///
  /// In en, this message translates to:
  /// **'Recent Sales'**
  String get recentSales;

  /// No description provided for @financeSnapshot.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get financeSnapshot;

  /// No description provided for @feedStockStatus.
  ///
  /// In en, this message translates to:
  /// **'Feed Stock'**
  String get feedStockStatus;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @farmSettings.
  ///
  /// In en, this message translates to:
  /// **'Farm Settings'**
  String get farmSettings;

  /// No description provided for @subscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get subscription;

  /// No description provided for @freePlan.
  ///
  /// In en, this message translates to:
  /// **'Free Plan'**
  String get freePlan;

  /// No description provided for @premiumPlan.
  ///
  /// In en, this message translates to:
  /// **'Premium Plan'**
  String get premiumPlan;

  /// No description provided for @eggsale.
  ///
  /// In en, this message translates to:
  /// **'Egg Sale'**
  String get eggsale;

  /// No description provided for @personalUse.
  ///
  /// In en, this message translates to:
  /// **'Personal Use'**
  String get personalUse;

  /// No description provided for @hatching.
  ///
  /// In en, this message translates to:
  /// **'Hatching / Incubation'**
  String get hatching;

  /// No description provided for @wastage.
  ///
  /// In en, this message translates to:
  /// **'Wastage / Spoiled'**
  String get wastage;

  /// No description provided for @meatSale.
  ///
  /// In en, this message translates to:
  /// **'Meat Sale'**
  String get meatSale;

  /// No description provided for @addMeatSale.
  ///
  /// In en, this message translates to:
  /// **'Add Meat Sale'**
  String get addMeatSale;

  /// No description provided for @pricePerBird.
  ///
  /// In en, this message translates to:
  /// **'Price per Bird (LKR)'**
  String get pricePerBird;

  /// No description provided for @birdsRemaining.
  ///
  /// In en, this message translates to:
  /// **'Birds Remaining'**
  String get birdsRemaining;

  /// No description provided for @batchStatus.
  ///
  /// In en, this message translates to:
  /// **'Batch Status'**
  String get batchStatus;

  /// No description provided for @growing.
  ///
  /// In en, this message translates to:
  /// **'Growing'**
  String get growing;

  /// No description provided for @sold.
  ///
  /// In en, this message translates to:
  /// **'Sold'**
  String get sold;

  /// No description provided for @harvested.
  ///
  /// In en, this message translates to:
  /// **'Harvested'**
  String get harvested;

  /// No description provided for @eggCollection.
  ///
  /// In en, this message translates to:
  /// **'Egg Collection'**
  String get eggCollection;

  /// No description provided for @collectionDate.
  ///
  /// In en, this message translates to:
  /// **'Collection Date'**
  String get collectionDate;

  /// No description provided for @saveCollection.
  ///
  /// In en, this message translates to:
  /// **'Save Collection'**
  String get saveCollection;

  /// No description provided for @flock.
  ///
  /// In en, this message translates to:
  /// **'Flock'**
  String get flock;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'si'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'si':
      return AppLocalizationsSi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
