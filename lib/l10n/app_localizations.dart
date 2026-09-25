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

  /// No description provided for @exportAndShare.
  ///
  /// In en, this message translates to:
  /// **'Export & Share'**
  String get exportAndShare;

  /// No description provided for @chooseFile.
  ///
  /// In en, this message translates to:
  /// **'Choose File'**
  String get chooseFile;

  /// No description provided for @importRestore.
  ///
  /// In en, this message translates to:
  /// **'Import / Restore'**
  String get importRestore;

  /// No description provided for @backupUpToDate.
  ///
  /// In en, this message translates to:
  /// **'Backup Up to Date'**
  String get backupUpToDate;

  /// No description provided for @noBackupYet.
  ///
  /// In en, this message translates to:
  /// **'No Backup Yet'**
  String get noBackupYet;

  /// No description provided for @exportFarmData.
  ///
  /// In en, this message translates to:
  /// **'Export Farm Data'**
  String get exportFarmData;

  /// No description provided for @importFromFile.
  ///
  /// In en, this message translates to:
  /// **'Import from File'**
  String get importFromFile;

  /// No description provided for @clearAllData.
  ///
  /// In en, this message translates to:
  /// **'Clear All Data'**
  String get clearAllData;

  /// No description provided for @clearAllDataConfirm.
  ///
  /// In en, this message translates to:
  /// **'Permanently delete ALL farm data? Export a backup first!'**
  String get clearAllDataConfirm;

  /// No description provided for @dangerZone.
  ///
  /// In en, this message translates to:
  /// **'Danger Zone'**
  String get dangerZone;

  /// No description provided for @whatsIncluded.
  ///
  /// In en, this message translates to:
  /// **'What\'s Included in Backup'**
  String get whatsIncluded;

  /// No description provided for @cloudBackup.
  ///
  /// In en, this message translates to:
  /// **'Cloud Backup'**
  String get cloudBackup;

  /// No description provided for @autoBackup.
  ///
  /// In en, this message translates to:
  /// **'Auto Backup'**
  String get autoBackup;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @autoSyncSettings.
  ///
  /// In en, this message translates to:
  /// **'Auto-Sync Settings'**
  String get autoSyncSettings;

  /// No description provided for @upgradeTitle.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Premium'**
  String get upgradeTitle;

  /// No description provided for @unlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock Premium'**
  String get unlockPremium;

  /// No description provided for @whatYouGet.
  ///
  /// In en, this message translates to:
  /// **'What you\'ll get'**
  String get whatYouGet;

  /// No description provided for @choosePlan.
  ///
  /// In en, this message translates to:
  /// **'Choose your plan'**
  String get choosePlan;

  /// No description provided for @monthlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyPlan;

  /// No description provided for @yearlyPlan.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearlyPlan;

  /// No description provided for @lifetimePlan.
  ///
  /// In en, this message translates to:
  /// **'Lifetime'**
  String get lifetimePlan;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get perMonth;

  /// No description provided for @perYear.
  ///
  /// In en, this message translates to:
  /// **'/year'**
  String get perYear;

  /// No description provided for @oneTime.
  ///
  /// In en, this message translates to:
  /// **'one-time'**
  String get oneTime;

  /// No description provided for @popular.
  ///
  /// In en, this message translates to:
  /// **'POPULAR'**
  String get popular;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @alreadyPremium.
  ///
  /// In en, this message translates to:
  /// **'You\'re on Premium!'**
  String get alreadyPremium;

  /// No description provided for @thankYouPremium.
  ///
  /// In en, this message translates to:
  /// **'Thank you for supporting Easy Poultry Manager. All premium features are unlocked.'**
  String get thankYouPremium;

  /// No description provided for @pdfReports.
  ///
  /// In en, this message translates to:
  /// **'PDF Reports'**
  String get pdfReports;

  /// No description provided for @pdfReportsDesc.
  ///
  /// In en, this message translates to:
  /// **'Generate and share detailed farm reports'**
  String get pdfReportsDesc;

  /// No description provided for @cloudBackupFeature.
  ///
  /// In en, this message translates to:
  /// **'Google Drive Backup'**
  String get cloudBackupFeature;

  /// No description provided for @cloudBackupDesc.
  ///
  /// In en, this message translates to:
  /// **'Auto-backup to Google Drive, restore from any device'**
  String get cloudBackupDesc;

  /// No description provided for @multiUser.
  ///
  /// In en, this message translates to:
  /// **'Up to 5 Workers'**
  String get multiUser;

  /// No description provided for @multiUserDesc.
  ///
  /// In en, this message translates to:
  /// **'Invite your farm staff to manage records'**
  String get multiUserDesc;

  /// No description provided for @unlimitedFlocks.
  ///
  /// In en, this message translates to:
  /// **'Unlimited Flocks & Batches'**
  String get unlimitedFlocks;

  /// No description provided for @unlimitedFlocksDesc.
  ///
  /// In en, this message translates to:
  /// **'No cap on the number of active flocks or batches'**
  String get unlimitedFlocksDesc;

  /// No description provided for @fullHistory.
  ///
  /// In en, this message translates to:
  /// **'Full History'**
  String get fullHistory;

  /// No description provided for @fullHistoryDesc.
  ///
  /// In en, this message translates to:
  /// **'Access all records without time limits'**
  String get fullHistoryDesc;

  /// No description provided for @advancedCharts.
  ///
  /// In en, this message translates to:
  /// **'Advanced Charts & P&L'**
  String get advancedCharts;

  /// No description provided for @advancedChartsDesc.
  ///
  /// In en, this message translates to:
  /// **'Detailed profit/loss analysis and trend charts'**
  String get advancedChartsDesc;

  /// No description provided for @reportsHub.
  ///
  /// In en, this message translates to:
  /// **'Reports Hub'**
  String get reportsHub;

  /// No description provided for @flockSummaryReport.
  ///
  /// In en, this message translates to:
  /// **'Flock / Batch Summary'**
  String get flockSummaryReport;

  /// No description provided for @eggProductionReport.
  ///
  /// In en, this message translates to:
  /// **'Egg Production Report'**
  String get eggProductionReport;

  /// No description provided for @meatSalesReport.
  ///
  /// In en, this message translates to:
  /// **'Meat Sales Report'**
  String get meatSalesReport;

  /// No description provided for @feedingReport.
  ///
  /// In en, this message translates to:
  /// **'Feeding Report'**
  String get feedingReport;

  /// No description provided for @healthReport.
  ///
  /// In en, this message translates to:
  /// **'Health & Vaccination Report'**
  String get healthReport;

  /// No description provided for @financeReport.
  ///
  /// In en, this message translates to:
  /// **'Finance / P&L Report'**
  String get financeReport;

  /// No description provided for @fullFarmReport.
  ///
  /// In en, this message translates to:
  /// **'Full Farm Overview'**
  String get fullFarmReport;

  /// No description provided for @selectDateRange.
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @lastMonth.
  ///
  /// In en, this message translates to:
  /// **'Last Month'**
  String get lastMonth;

  /// No description provided for @last3Months.
  ///
  /// In en, this message translates to:
  /// **'Last 3 Months'**
  String get last3Months;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @previewReport.
  ///
  /// In en, this message translates to:
  /// **'Preview Report'**
  String get previewReport;

  /// No description provided for @shareReport.
  ///
  /// In en, this message translates to:
  /// **'Share Report'**
  String get shareReport;

  /// No description provided for @teamAndWorkers.
  ///
  /// In en, this message translates to:
  /// **'Team & Workers'**
  String get teamAndWorkers;

  /// No description provided for @inviteCode.
  ///
  /// In en, this message translates to:
  /// **'Invite Code'**
  String get inviteCode;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy Code'**
  String get copyCode;

  /// No description provided for @shareInvite.
  ///
  /// In en, this message translates to:
  /// **'Share Invite'**
  String get shareInvite;

  /// No description provided for @pendingInvite.
  ///
  /// In en, this message translates to:
  /// **'Pending Invites'**
  String get pendingInvite;

  /// No description provided for @noWorkers.
  ///
  /// In en, this message translates to:
  /// **'No Workers Yet'**
  String get noWorkers;

  /// No description provided for @inviteFirstWorker.
  ///
  /// In en, this message translates to:
  /// **'Invite your first worker'**
  String get inviteFirstWorker;

  /// No description provided for @workerPermissions.
  ///
  /// In en, this message translates to:
  /// **'Worker Permissions'**
  String get workerPermissions;

  /// No description provided for @canView.
  ///
  /// In en, this message translates to:
  /// **'Can view'**
  String get canView;

  /// No description provided for @canAdd.
  ///
  /// In en, this message translates to:
  /// **'Can add records'**
  String get canAdd;

  /// No description provided for @cannotDelete.
  ///
  /// In en, this message translates to:
  /// **'Cannot delete'**
  String get cannotDelete;

  /// No description provided for @cannotViewFinance.
  ///
  /// In en, this message translates to:
  /// **'Cannot view financials'**
  String get cannotViewFinance;

  /// No description provided for @removeWorker.
  ///
  /// In en, this message translates to:
  /// **'Remove Worker'**
  String get removeWorker;

  /// No description provided for @confirmRemoveWorker.
  ///
  /// In en, this message translates to:
  /// **'Remove this worker from the farm?'**
  String get confirmRemoveWorker;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @vaccinationReminders.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Reminders'**
  String get vaccinationReminders;

  /// No description provided for @lowStockAlerts.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Alerts'**
  String get lowStockAlerts;

  /// No description provided for @medicineExpiryAlerts.
  ///
  /// In en, this message translates to:
  /// **'Medicine Expiry Alerts'**
  String get medicineExpiryAlerts;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutApp;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get appVersion;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the App'**
  String get rateApp;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @confirmSignOut.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get confirmSignOut;

  /// No description provided for @manageWorkers.
  ///
  /// In en, this message translates to:
  /// **'Manage Workers'**
  String get manageWorkers;

  /// No description provided for @backupAndRestore.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get backupAndRestore;

  /// No description provided for @editFarmName.
  ///
  /// In en, this message translates to:
  /// **'Edit Farm Name'**
  String get editFarmName;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get editName;

  /// No description provided for @changeFarmType.
  ///
  /// In en, this message translates to:
  /// **'Change Farm Type'**
  String get changeFarmType;

  /// No description provided for @selectLanguageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguageTitle;

  /// No description provided for @premiumDevToggle.
  ///
  /// In en, this message translates to:
  /// **'Premium Mode (Dev Toggle)'**
  String get premiumDevToggle;

  /// No description provided for @plan.
  ///
  /// In en, this message translates to:
  /// **'Plan'**
  String get plan;

  /// No description provided for @premiumActive.
  ///
  /// In en, this message translates to:
  /// **'👑 Premium — Active'**
  String get premiumActive;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due Soon'**
  String get dueSoon;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @markComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get markComplete;

  /// No description provided for @vaccinationSchedule.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Schedule'**
  String get vaccinationSchedule;

  /// No description provided for @medicineStock.
  ///
  /// In en, this message translates to:
  /// **'Medicine & Vaccine Stock'**
  String get medicineStock;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @expiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Expiring Soon'**
  String get expiringSoon;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @threshold.
  ///
  /// In en, this message translates to:
  /// **'Alert Threshold'**
  String get threshold;

  /// No description provided for @restock.
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get restock;

  /// No description provided for @addStock.
  ///
  /// In en, this message translates to:
  /// **'Add Stock'**
  String get addStock;

  /// No description provided for @addItem.
  ///
  /// In en, this message translates to:
  /// **'Add Item'**
  String get addItem;

  /// No description provided for @unit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unit;

  /// No description provided for @itemType.
  ///
  /// In en, this message translates to:
  /// **'Item Type'**
  String get itemType;

  /// No description provided for @medicine.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicine;

  /// No description provided for @vaccine.
  ///
  /// In en, this message translates to:
  /// **'Vaccine'**
  String get vaccine;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @netLoss.
  ///
  /// In en, this message translates to:
  /// **'Net Loss'**
  String get netLoss;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @breakdownByCategory.
  ///
  /// In en, this message translates to:
  /// **'Breakdown by Category'**
  String get breakdownByCategory;

  /// No description provided for @incomeVsExpense.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expense'**
  String get incomeVsExpense;

  /// No description provided for @profitMargin.
  ///
  /// In en, this message translates to:
  /// **'Profit Margin'**
  String get profitMargin;

  /// No description provided for @layerChickPurchase.
  ///
  /// In en, this message translates to:
  /// **'Layer Chick Purchase'**
  String get layerChickPurchase;

  /// No description provided for @docPurchase.
  ///
  /// In en, this message translates to:
  /// **'DOC Purchase'**
  String get docPurchase;

  /// No description provided for @labour.
  ///
  /// In en, this message translates to:
  /// **'Labour'**
  String get labour;

  /// No description provided for @utilities.
  ///
  /// In en, this message translates to:
  /// **'Electricity / Water'**
  String get utilities;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get processing;

  /// No description provided for @spentHenSale.
  ///
  /// In en, this message translates to:
  /// **'Spent Hen Sale'**
  String get spentHenSale;

  /// No description provided for @liveBirdSale.
  ///
  /// In en, this message translates to:
  /// **'Live Bird Sale'**
  String get liveBirdSale;

  /// No description provided for @feedCost.
  ///
  /// In en, this message translates to:
  /// **'Feed Cost'**
  String get feedCost;

  /// No description provided for @medicineCost.
  ///
  /// In en, this message translates to:
  /// **'Medicine Cost'**
  String get medicineCost;

  /// No description provided for @vaccineCost.
  ///
  /// In en, this message translates to:
  /// **'Vaccine Cost'**
  String get vaccineCost;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncome;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @linkedFlock.
  ///
  /// In en, this message translates to:
  /// **'Linked Flock'**
  String get linkedFlock;

  /// No description provided for @linkedBatch.
  ///
  /// In en, this message translates to:
  /// **'Linked Batch'**
  String get linkedBatch;

  /// No description provided for @todaysFeed.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Feed'**
  String get todaysFeed;

  /// No description provided for @weeklyUsage.
  ///
  /// In en, this message translates to:
  /// **'Weekly Usage'**
  String get weeklyUsage;

  /// No description provided for @monthlyCost.
  ///
  /// In en, this message translates to:
  /// **'Monthly Cost'**
  String get monthlyCost;

  /// No description provided for @stockValue.
  ///
  /// In en, this message translates to:
  /// **'Stock Value'**
  String get stockValue;

  /// No description provided for @addFeedType.
  ///
  /// In en, this message translates to:
  /// **'Add Feed Type'**
  String get addFeedType;

  /// No description provided for @feedTypeName.
  ///
  /// In en, this message translates to:
  /// **'Feed Type Name'**
  String get feedTypeName;

  /// No description provided for @brand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get brand;

  /// No description provided for @openingStock.
  ///
  /// In en, this message translates to:
  /// **'Opening Stock (kg)'**
  String get openingStock;

  /// No description provided for @lowStockThreshold.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Threshold (kg)'**
  String get lowStockThreshold;

  /// No description provided for @pricePerKgLabel.
  ///
  /// In en, this message translates to:
  /// **'Price per kg (LKR)'**
  String get pricePerKgLabel;

  /// No description provided for @allFlocks.
  ///
  /// In en, this message translates to:
  /// **'All Flocks'**
  String get allFlocks;

  /// No description provided for @feedSummary.
  ///
  /// In en, this message translates to:
  /// **'Feed Summary'**
  String get feedSummary;

  /// No description provided for @mortalityRate.
  ///
  /// In en, this message translates to:
  /// **'Mortality Rate'**
  String get mortalityRate;

  /// No description provided for @ageInDays.
  ///
  /// In en, this message translates to:
  /// **'Age (days)'**
  String get ageInDays;

  /// No description provided for @addMortality.
  ///
  /// In en, this message translates to:
  /// **'Add Mortality'**
  String get addMortality;

  /// No description provided for @flockPurpose.
  ///
  /// In en, this message translates to:
  /// **'Flock Purpose'**
  String get flockPurpose;

  /// No description provided for @layerHens.
  ///
  /// In en, this message translates to:
  /// **'Layer Hens'**
  String get layerHens;

  /// No description provided for @broilerChickens.
  ///
  /// In en, this message translates to:
  /// **'Broiler Chickens'**
  String get broilerChickens;

  /// No description provided for @closeFlock.
  ///
  /// In en, this message translates to:
  /// **'Close Flock'**
  String get closeFlock;

  /// No description provided for @flockDetail.
  ///
  /// In en, this message translates to:
  /// **'Flock Details'**
  String get flockDetail;

  /// No description provided for @batchDetail.
  ///
  /// In en, this message translates to:
  /// **'Batch Details'**
  String get batchDetail;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @closeBatch.
  ///
  /// In en, this message translates to:
  /// **'Close Batch'**
  String get closeBatch;

  /// No description provided for @logMortality.
  ///
  /// In en, this message translates to:
  /// **'Log Mortality'**
  String get logMortality;

  /// No description provided for @addBirdEvent.
  ///
  /// In en, this message translates to:
  /// **'Log Bird Event'**
  String get addBirdEvent;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @culling.
  ///
  /// In en, this message translates to:
  /// **'Culling'**
  String get culling;

  /// No description provided for @saleEvent.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get saleEvent;

  /// No description provided for @goodEggs.
  ///
  /// In en, this message translates to:
  /// **'Good Eggs'**
  String get goodEggs;

  /// No description provided for @totalTrays.
  ///
  /// In en, this message translates to:
  /// **'Total Trays'**
  String get totalTrays;

  /// No description provided for @eggsByTray.
  ///
  /// In en, this message translates to:
  /// **'Sell by Tray'**
  String get eggsByTray;

  /// No description provided for @eggsByUnit.
  ///
  /// In en, this message translates to:
  /// **'Sell by Egg'**
  String get eggsByUnit;

  /// No description provided for @saleType.
  ///
  /// In en, this message translates to:
  /// **'Sale Type'**
  String get saleType;

  /// No description provided for @buyerContact.
  ///
  /// In en, this message translates to:
  /// **'Buyer Contact'**
  String get buyerContact;

  /// No description provided for @alertCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Alert Center'**
  String get alertCenterTitle;

  /// No description provided for @lowFeedStock.
  ///
  /// In en, this message translates to:
  /// **'Feed Stock Low'**
  String get lowFeedStock;

  /// No description provided for @lowMedicineStock.
  ///
  /// In en, this message translates to:
  /// **'Medicine / Vaccine Low'**
  String get lowMedicineStock;

  /// No description provided for @medicineExpiringSoon.
  ///
  /// In en, this message translates to:
  /// **'Medicine Expiring Soon'**
  String get medicineExpiringSoon;

  /// No description provided for @medicineExpired.
  ///
  /// In en, this message translates to:
  /// **'Medicine Expired'**
  String get medicineExpired;

  /// No description provided for @vaccinationOverdue.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Overdue'**
  String get vaccinationOverdue;

  /// No description provided for @vaccinationDueSoon.
  ///
  /// In en, this message translates to:
  /// **'Vaccination Due Soon'**
  String get vaccinationDueSoon;

  /// No description provided for @dismissAlert.
  ///
  /// In en, this message translates to:
  /// **'Dismiss Alert'**
  String get dismissAlert;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark All Read'**
  String get markAllRead;

  /// No description provided for @restock_action.
  ///
  /// In en, this message translates to:
  /// **'Restock'**
  String get restock_action;

  /// No description provided for @stockOverview.
  ///
  /// In en, this message translates to:
  /// **'Stock Overview'**
  String get stockOverview;

  /// No description provided for @feedTab.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feedTab;

  /// No description provided for @medicineTab.
  ///
  /// In en, this message translates to:
  /// **'Medicine'**
  String get medicineTab;

  /// No description provided for @eggsTab.
  ///
  /// In en, this message translates to:
  /// **'Eggs'**
  String get eggsTab;

  /// No description provided for @stockSummary.
  ///
  /// In en, this message translates to:
  /// **'Stock Summary'**
  String get stockSummary;

  /// No description provided for @estimatedValue.
  ///
  /// In en, this message translates to:
  /// **'Estimated Value'**
  String get estimatedValue;

  /// No description provided for @totalStockValue.
  ///
  /// In en, this message translates to:
  /// **'Total Stock Value'**
  String get totalStockValue;

  /// No description provided for @lowStockItems.
  ///
  /// In en, this message translates to:
  /// **'Low Stock Items'**
  String get lowStockItems;

  /// No description provided for @critesItems.
  ///
  /// In en, this message translates to:
  /// **'Critical Items'**
  String get critesItems;

  /// No description provided for @allStockGood.
  ///
  /// In en, this message translates to:
  /// **'All Stock OK'**
  String get allStockGood;

  /// No description provided for @trays.
  ///
  /// In en, this message translates to:
  /// **'Trays'**
  String get trays;

  /// No description provided for @crates.
  ///
  /// In en, this message translates to:
  /// **'Crates'**
  String get crates;

  /// No description provided for @recentCollections.
  ///
  /// In en, this message translates to:
  /// **'Recent Collections'**
  String get recentCollections;

  /// No description provided for @collectionThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get collectionThisWeek;

  /// No description provided for @todayCollection.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayCollection;

  /// No description provided for @estValue.
  ///
  /// In en, this message translates to:
  /// **'Est. Value'**
  String get estValue;
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
