import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('id'),
    Locale('en'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale('zh'),
  ];

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navOrders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get navOrders;

  /// No description provided for @navChat.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get navChat;

  /// No description provided for @navNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get navNotifications;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @backToProfile.
  ///
  /// In en, this message translates to:
  /// **'Back to my profile'**
  String get backToProfile;

  /// No description provided for @notificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notificationsTitle;

  /// No description provided for @notificationsDemo.
  ///
  /// In en, this message translates to:
  /// **'Notification settings are for demonstration only and are not saved.'**
  String get notificationsDemo;

  /// No description provided for @accountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTitle;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePassword;

  /// No description provided for @languageLabel.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageLabel;

  /// No description provided for @aboutPanganKita.
  ///
  /// In en, this message translates to:
  /// **'About PanganKita'**
  String get aboutPanganKita;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get terms;

  /// No description provided for @privacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy;

  /// No description provided for @helpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get helpCenter;

  /// No description provided for @settingsFooter.
  ///
  /// In en, this message translates to:
  /// **'PanganKita • Demo settings'**
  String get settingsFooter;

  /// No description provided for @ordersUpdate.
  ///
  /// In en, this message translates to:
  /// **'Order updates'**
  String get ordersUpdate;

  /// No description provided for @ordersUpdateDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive updates about your order status.'**
  String get ordersUpdateDescription;

  /// No description provided for @merchantMessages.
  ///
  /// In en, this message translates to:
  /// **'Messages from stores'**
  String get merchantMessages;

  /// No description provided for @merchantMessagesDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive messages from your selected stores.'**
  String get merchantMessagesDescription;

  /// No description provided for @promotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions & offers'**
  String get promotions;

  /// No description provided for @promotionsDescription.
  ///
  /// In en, this message translates to:
  /// **'Get updates about promotions, discounts and special offers.'**
  String get promotionsDescription;

  /// No description provided for @languageIndonesian.
  ///
  /// In en, this message translates to:
  /// **'Bahasa Indonesia'**
  String get languageIndonesian;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageChinese.
  ///
  /// In en, this message translates to:
  /// **'Simplified Chinese'**
  String get languageChinese;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Example order unavailable.'**
  String get uiExampleOrderUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Example merchant chat unavailable.'**
  String get uiExampleMerchantChatUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Example pickup unavailable.'**
  String get uiExamplePickupUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Example review unavailable.'**
  String get uiExampleReviewUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Mandala by Pass, Medan · sample location'**
  String get uiMandalaByPassMedanSampleLocation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'{arg0} sample food items found'**
  String uiValueSampleFoodItemsFound(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get uiFilter;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Distance unavailable'**
  String get uiDistanceUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pick up at {arg0} (demo)'**
  String uiPickUpAtValueDemo(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Can\'t find your food?'**
  String get uiCanTFindYourFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Try another keyword from the available sample foods.'**
  String get uiTryAnotherKeywordFromTheAvailableSampleFoods;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Edit Search'**
  String get uiEditSearch;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Reset Filters'**
  String get uiResetFilters;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'You May Also Like'**
  String get uiYouMayAlsoLike;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Search Filters'**
  String get uiSearchFilters;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get uiReset;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get uiCategory;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Price range (Rp)'**
  String get uiPriceRangeRp;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get uiDistance;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Distance filtering is unavailable in the demo data.'**
  String get uiDistanceFilteringIsUnavailableInTheDemoData;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get uiSortBy;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Open stores only'**
  String get uiOpenStoresOnly;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Store opening status is unavailable in the demo data.'**
  String get uiStoreOpeningStatusIsUnavailableInTheDemoData;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Show Results'**
  String get uiShowResults;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Example sorting'**
  String get uiExampleSorting;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Lowest price'**
  String get uiLowestPrice;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'FLASH SALE'**
  String get uiFLASHSALE;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Your Favorite Croissants,\nUp to 60% Off'**
  String get uiYourFavoriteCroissantsUpTo60Off;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order Now!'**
  String get uiOrderNow;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Offline demo · All offers, locations, ratings, and stock are sample data.'**
  String get uiOfflineDemoAllOffersLocationsRatingsAndStockAreSampleData;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sorted by nearest pickup distance'**
  String get uiSortedByNearestPickupDistance;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get uiViewAll;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No foods match your search.'**
  String get uiNoFoodsMatchYourSearch;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Want to browse by store?'**
  String get uiWantToBrowseByStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Explore nearby merchants'**
  String get uiExploreNearbyMerchants;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Choose Location'**
  String get uiChooseLocation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get uiUseCurrentLocation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Location access is unavailable'**
  String get uiLocationAccessIsUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Selected location'**
  String get uiSelectedLocation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Recent searches'**
  String get uiRecentSearches;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample area not found.'**
  String get uiSampleAreaNotFound;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'This area is for display only; distance-based results are not available.'**
  String get uiThisAreaIsForDisplayOnlyDistanceBasedResultsAreNotAvailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Use This Location'**
  String get uiUseThisLocation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Illustrative map — not a live location'**
  String get uiIllustrativeMapNotALiveLocation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo pickup: {arg0} · {arg1}'**
  String uiDemoPickupValueValue(String arg0, String arg1);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample product'**
  String get uiSampleProduct;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Choose Add-ons'**
  String get uiChooseAddOns;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Make it even tastier! (demo)'**
  String get uiMakeItEvenTastierDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Customer Reviews'**
  String get uiCustomerReviews;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo Customer'**
  String get uiDemoCustomer;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample review'**
  String get uiSampleReview;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'This is a sample customer review. There are no real reviews for this demo product.'**
  String
  get uiThisIsASampleCustomerReviewThereAreNoRealReviewsForThisDemoProduct;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart (Demo)'**
  String get uiAddToCartDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Offline demo · Favorites last only while this page is open. Products, locations, add-ons, and reviews are examples. Selecting 1–10 items does not change inventory or place an order.'**
  String
  get uiOfflineDemoFavoritesLastOnlyWhileThisPageIsOpenProductsLocationsAd;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get uiTermsConditions;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Information about using the PanganKita demo'**
  String get uiInformationAboutUsingThePanganKitaDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get uiPrivacyPolicy;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy unavailable'**
  String get uiPrivacyPolicyUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'The official document is not yet available in this demo.'**
  String get uiTheOfficialDocumentIsNotYetAvailableInThisDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Back to Settings'**
  String get uiBackToSettings;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get uiEditProfile;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Change Photo'**
  String get uiChangePhoto;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Security'**
  String get uiSecurity;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get uiChangePassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get uiSaveChanges;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get uiFullName;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get uiEmail;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get uiPhoneNumber;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'A phone number helps merchants contact you.'**
  String get uiAPhoneNumberHelpsMerchantsContactYou;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get uiMyProfile;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Thank you for helping save food.'**
  String get uiThankYouForHelpingSaveFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'My Favorites'**
  String get uiMyFavorites;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Save what you love and find it anytime.'**
  String get uiSaveWhatYouLoveAndFindItAnytime;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo favorites. Prices and availability are not connected.'**
  String get uiDemoFavoritesPricesAndAvailabilityAreNotConnected;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample favorite store'**
  String get uiSampleFavoriteStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo view · No completed orders yet.'**
  String get uiDemoViewNoCompletedOrdersYet;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No matching sample orders.'**
  String get uiNoMatchingSampleOrders;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample payment total'**
  String get uiSamplePaymentTotal;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo'**
  String get uiDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pickup time: Unavailable'**
  String get uiPickupTimeUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get uiViewDetails;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Write Review'**
  String get uiWriteReview;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get uiOrders;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Your favorite food, ready to enjoy.'**
  String get uiYourFavoriteFoodReadyToEnjoy;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample active orders'**
  String get uiSampleActiveOrders;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo view · There are no real orders.'**
  String get uiDemoViewThereAreNoRealOrders;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pickup code'**
  String get uiPickupCode;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get uiUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Message Store'**
  String get uiMessageStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get uiOrderDetails;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order Help'**
  String get uiOrderHelp;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get uiHowCanWeHelp;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Contact Customer Support'**
  String get uiContactCustomerSupport;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order ID unavailable'**
  String get uiOrderIDUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pickup'**
  String get uiPickup;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order picked up!'**
  String get uiOrderPickedUp;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample completed pickup view.\nNo real pickup has been confirmed.'**
  String get uiSampleCompletedPickupViewNoRealPickupHasBeenConfirmed;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Thank you for choosing surplus food.'**
  String get uiThankYouForChoosingSurplusFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get uiBackToHome;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo view · No canceled orders yet.'**
  String get uiDemoViewNoCanceledOrdersYet;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Canceled orders will appear here.'**
  String get uiCanceledOrdersWillAppearHere;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No payment yet'**
  String get uiNoPaymentYet;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Cancellation reason: Unavailable'**
  String get uiCancellationReasonUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Browse Other Food'**
  String get uiBrowseOtherFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No order or code has been created.'**
  String get uiNoOrderOrCodeHasBeenCreated;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pickup Information'**
  String get uiPickupInformation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Payment Details'**
  String get uiPaymentDetails;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample order details'**
  String get uiSampleOrderDetails;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order status unavailable.'**
  String get uiOrderStatusUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'How was your food?'**
  String get uiHowWasYourFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience'**
  String get uiTellUsAboutYourExperience;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Display my name'**
  String get uiDisplayMyName;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'This option is a demo and is not saved.'**
  String get uiThisOptionIsADemoAndIsNotSaved;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Submit Review'**
  String get uiSubmitReview;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Add photo (optional)'**
  String get uiAddPhotoOptional;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Add Photo'**
  String get uiAddPhoto;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'PanganKita Help'**
  String get uiPanganKitaHelp;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Customer Support • demo'**
  String get uiCustomerSupportDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Ready for pickup • demo'**
  String get uiReadyForPickupDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample conversation'**
  String get uiSampleConversation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get uiChat;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Stay connected with your favorite stores.'**
  String get uiStayConnectedWithYourFavoriteStores;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo view · No real conversations yet.'**
  String get uiDemoViewNoRealConversationsYet;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No matching examples.'**
  String get uiNoMatchingExamples;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Unread'**
  String get uiUnread;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get uiAll;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No sample messages for this store.'**
  String get uiNoSampleMessagesForThisStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample conversation. Messages are not sent or saved.'**
  String get uiSampleConversationMessagesAreNotSentOrSaved;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Stores Near You'**
  String get uiStoresNearYou;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Illustrative map • sample store locations'**
  String get uiIllustrativeMapSampleStoreLocations;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'View List'**
  String get uiViewList;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Directions'**
  String get uiDirections;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'View Store'**
  String get uiViewStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo view · No live location or store data is used.'**
  String get uiDemoViewNoLiveLocationOrStoreDataIsUsed;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No matching sample stores.'**
  String get uiNoMatchingSampleStores;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Featured Stores'**
  String get uiFeaturedStores;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'4 sample stores to preview'**
  String get ui4SampleStoresToPreview;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'View Map'**
  String get uiViewMap;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'My location (demo)'**
  String get uiMyLocationDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Illustrative route'**
  String get uiIllustrativeRoute;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'{arg0} • distance and time unavailable'**
  String uiValueDistanceAndTimeUnavailable(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo pickup deadline: {arg0}'**
  String uiDemoPickupDeadlineValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Open in Maps'**
  String get uiOpenInMaps;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample store name copied.'**
  String get uiSampleStoreNameCopied;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Store Details'**
  String get uiStoreDetails;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'View map ›'**
  String get uiViewMap2;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pack of 5'**
  String get uiPackOf5;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Garlic butter and cheese toast · demo'**
  String get uiGarlicButterAndCheeseToastDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Store Reviews'**
  String get uiStoreReviews;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample ratings, not verified.'**
  String get uiSampleRatingsNotVerified;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No store reviews in the offline demo.'**
  String get uiNoStoreReviewsInTheOfflineDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'About Store'**
  String get uiAboutStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Category: {arg0}'**
  String uiCategoryValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo pickup location: {arg0}'**
  String uiDemoPickupLocationValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'This store information comes from offline demo data.'**
  String get uiThisStoreInformationComesFromOfflineDemoData;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'{arg0} items · {arg1}'**
  String uiValueItemsValue(String arg0, String arg1);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'View Cart'**
  String get uiViewCart;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get uiPayment;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Payment unavailable'**
  String get uiPaymentUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'This is a demo screen. No QR code, bill, transaction, or order is created.'**
  String get uiThisIsADemoScreenNoQRCodeBillTransactionOrOrderIsCreated;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get uiClose;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty. No payment status available.'**
  String get uiCartIsEmptyNoPaymentStatusAvailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'There is no bill to pay.'**
  String get uiThereIsNoBillToPay;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Payment deadline'**
  String get uiPaymentDeadline;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Total payment'**
  String get uiTotalPayment;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get uiPaymentMethod;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Save QR'**
  String get uiSaveQR;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Preview Status'**
  String get uiPreviewStatus;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get uiOrderID;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'QR unavailable'**
  String get uiQRUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'View example successful payment'**
  String get uiViewExampleSuccessfulPayment;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Back to Checkout'**
  String get uiBackToCheckout;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'View example unsuccessful payment'**
  String get uiViewExampleUnsuccessfulPayment;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get uiCheckout;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Offline demo. Stores, schedules, profiles, prices, and QRIS are examples. No payment or order is created.'**
  String
  get uiOfflineDemoStoresSchedulesProfilesPricesAndQRISAreExamplesNoPaymen;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty. Add products before checkout.'**
  String get uiYourCartIsEmptyAddProductsBeforeCheckout;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pick up your order at the store'**
  String get uiPickUpYourOrderAtTheStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No delivery fee, save more!'**
  String get uiNoDeliveryFeeSaveMore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pickup until {arg0}'**
  String uiPickupUntilValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Location Details'**
  String get uiLocationDetails;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order recipient'**
  String get uiOrderRecipient;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get uiChange;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get uiPaymentSummary;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pickup Terms (Demo)'**
  String get uiPickupTermsDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'This page is a simulation. Stores, locations, and schedules are examples. No payment, order, or reservation is created. Actual service terms are not yet available.'**
  String
  get uiThisPageIsASimulationStoresLocationsAndSchedulesAreExamplesNoPayme;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get uiIAgreeToThe;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'pickup terms.'**
  String get uiPickupTerms;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get uiPayNow;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get uiCart;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get uiClearAll;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Offline demo. Prices, add-ons, locations, and schedules are examples. The cart clears when the app closes. No inventory is reserved and no payment is created.'**
  String
  get uiOfflineDemoPricesAddOnsLocationsAndSchedulesAreExamplesTheCartClea;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get uiYourCartIsEmpty;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Select food from Home to see it here.'**
  String get uiSelectFoodFromHomeToSeeItHere;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Continue Shopping'**
  String get uiContinueShopping;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample store location'**
  String get uiSampleStoreLocation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Add More Food'**
  String get uiAddMoreFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pickup at Store'**
  String get uiPickupAtStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pickup deadline: {arg0}'**
  String uiPickupDeadlineValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Notes for Store'**
  String get uiNotesForStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order Summary'**
  String get uiOrderSummary;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Make sure you can arrive on time. The actual schedule is unavailable in the demo.'**
  String
  get uiMakeSureYouCanArriveOnTimeTheActualScheduleIsUnavailableInTheDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Continue to Checkout'**
  String get uiContinueToCheckout;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty. No demo payment available.'**
  String get uiCartIsEmptyNoDemoPaymentAvailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Example unsuccessful payment'**
  String get uiExampleUnsuccessfulPayment;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No payment has been processed or confirmed. This is just a sample screen.'**
  String get uiNoPaymentHasBeenProcessedOrConfirmedThisIsJustASampleScreen;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get uiStatus;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'What You Can Do'**
  String get uiWhatYouCanDo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Try Paying Again'**
  String get uiTryPayingAgain;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Change Payment Method'**
  String get uiChangePaymentMethod;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Need help?'**
  String get uiNeedHelp;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order Details'**
  String get uiOrderDetails2;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample Order Details'**
  String get uiSampleOrderDetails2;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Example successful payment'**
  String get uiExampleSuccessfulPayment;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Preview of the post-payment screen.\nNo transaction or order has been created.'**
  String get uiPreviewOfThePostPaymentScreenNoTransactionOrOrderHasBeenCreated;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample merchant'**
  String get uiSampleMerchant;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'This schedule is not an order confirmation.'**
  String get uiThisScheduleIsNotAnOrderConfirmation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'View sample orders'**
  String get uiViewSampleOrders;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Choose Payment Method'**
  String get uiChoosePaymentMethod;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Only QRIS is shown as an example. No payment or QR code is generated.'**
  String get uiOnlyQRISIsShownAsAnExampleNoPaymentOrQRCodeIsGenerated;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample payment method'**
  String get uiSamplePaymentMethod;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Use QRIS (Demo)'**
  String get uiUseQRISDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Password Updated!'**
  String get uiPasswordUpdated;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Please sign in again using your\nnew password.'**
  String get uiPleaseSignInAgainUsingYourNewPassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get uiBackToLogin;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Local simulation. No passwords or accounts are saved.'**
  String get uiLocalSimulationNoPasswordsOrAccountsAreSaved;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Quality Food,\nFriendlier Prices.'**
  String get uiQualityFoodFriendlierPrices;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Discover quality surplus food from trusted nearby businesses before pickup time ends.'**
  String
  get uiDiscoverQualitySurplusFoodFromTrustedNearbyBusinessesBeforePickupT;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get uiSignUp;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get uiAlreadyHaveAnAccount;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get uiLogIn;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Remembered your password?'**
  String get uiRememberedYourPassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: no email or code is sent.'**
  String get uiDemoModeNoEmailOrCodeIsSent;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Send OTP Code'**
  String get uiSendOTPCode;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get uiForgotPassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry, we\'ll help recover your account.'**
  String get uiDonTWorryWeLlHelpRecoverYourAccount;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get uiVerify;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo mode: use code 5102.\nNo email or SMS is sent.'**
  String get uiDemoModeUseCode5102NoEmailOrSMSIsSent;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code?'**
  String get uiDidnTReceiveTheCode;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Resend'**
  String get uiResend;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Verify OTP Code'**
  String get uiVerifyOTPCode;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sign up and enjoy delicious food\nat lower prices.'**
  String get uiSignUpAndEnjoyDeliciousFoodAtLowerPrices;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo view · No real notifications yet.'**
  String get uiDemoViewNoRealNotificationsYet;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get uiNotifications;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get uiMarkAsRead;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Your latest updates.'**
  String get uiYourLatestUpdates;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'This feature is unavailable in the offline demo.'**
  String get uiThisFeatureIsUnavailableInTheOfflineDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Open demo profile'**
  String get uiOpenDemoProfile;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Choose location'**
  String get uiChooseLocation2;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get uiBack;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Search for food...'**
  String get uiSearchForFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get uiClearSearch;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Search filters'**
  String get uiSearchFilters2;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get uiMinimum;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Maximum'**
  String get uiMaximum;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample badge; merchant not verified'**
  String get uiSampleBadgeMerchantNotVerified;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'QRIS Promotion'**
  String get uiQRISPromotion;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Flash Sale'**
  String get uiFlashSale;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo pickup {arg0}, {arg1}'**
  String uiDemoPickupValueValue2(String arg0, String arg1);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Near Your Location'**
  String get uiNearYourLocation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Find delicious food near you...'**
  String get uiFindDeliciousFoodNearYou;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Filter food'**
  String get uiFilterFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Search sample areas'**
  String get uiSearchSampleAreas;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Copy product information'**
  String get uiCopyProductInformation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample product photo from {arg0}'**
  String uiSampleProductPhotoFromValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Decrease demo quantity'**
  String get uiDecreaseDemoQuantity;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo quantity {arg0}'**
  String uiDemoQuantityValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Increase demo quantity'**
  String get uiIncreaseDemoQuantity;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get uiAccount;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Products and Orders'**
  String get uiProductsAndOrders;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Payment and Pickup'**
  String get uiPaymentAndPickup;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Back to My Profile'**
  String get uiBackToMyProfile;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Changing photos is unavailable'**
  String get uiChangingPhotosIsUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample email'**
  String get uiSampleEmail;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Add phone number'**
  String get uiAddPhoneNumber;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get uiOpenSettings;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get uiFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Stores'**
  String get uiStores;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No sample favorite stores.'**
  String get uiNoSampleFavoriteStores;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No sample favorite foods.'**
  String get uiNoSampleFavoriteFoods;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Remove {arg0} from demo favorites'**
  String uiRemoveValueFromDemoFavorites(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Search orders'**
  String get uiSearchOrders;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Search sample product or store name'**
  String get uiSearchSampleProductOrStoreName;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Close Order Help'**
  String get uiCloseOrderHelp;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'How do I pick up my order?'**
  String get uiHowDoIPickUpMyOrder;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order not ready'**
  String get uiOrderNotReady;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Store closed or hard to find'**
  String get uiStoreClosedOrHardToFind;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Incorrect order'**
  String get uiIncorrectOrder;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Payment issue'**
  String get uiPaymentIssue;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Pickup time'**
  String get uiPickupTime;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo total'**
  String get uiDemoTotal;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Open Order Help'**
  String get uiOpenOrderHelp;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Store location'**
  String get uiStoreLocation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo pickup deadline'**
  String get uiDemoPickupDeadline;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo subtotal'**
  String get uiDemoSubtotal;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'How was the food and pickup experience?'**
  String get uiHowWasTheFoodAndPickupExperience;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Give {arg0} stars'**
  String uiGiveValueStars(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Tasty food'**
  String get uiTastyFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Good portion'**
  String get uiGoodPortion;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Neat packaging'**
  String get uiNeatPackaging;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Friendly store'**
  String get uiFriendlyStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Help options unavailable'**
  String get uiHelpOptionsUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Hello! How can we help with your sample order?'**
  String get uiHelloHowCanWeHelpWithYourSampleOrder;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'I\'m at the store, but my order isn\'t ready.'**
  String get uiIMAtTheStoreButMyOrderIsnTReady;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Of course. Could you describe what\'s happening at the store?'**
  String get uiOfCourseCouldYouDescribeWhatSHappeningAtTheStore;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Attachments unavailable'**
  String get uiAttachmentsUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Write a message...'**
  String get uiWriteAMessage;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Emoji unavailable'**
  String get uiEmojiUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Send sample message'**
  String get uiSendSampleMessage;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Your order is ready for pickup!'**
  String get uiYourOrderIsReadyForPickup;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'We\'re preparing your order now.'**
  String get uiWeRePreparingYourOrderNow;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Thank you for shopping with us!'**
  String get uiThankYouForShoppingWithUs;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Okay, thank you!'**
  String get uiOkayThankYou;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Search stores or messages...'**
  String get uiSearchStoresOrMessages;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Write a sample message...'**
  String get uiWriteASampleMessage;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Add sample message'**
  String get uiAddSampleMessage;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Back to store list'**
  String get uiBackToStoreList;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Map filters unavailable'**
  String get uiMapFiltersUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Device location unavailable'**
  String get uiDeviceLocationUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Search store name or category...'**
  String get uiSearchStoreNameOrCategory;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Store filters unavailable'**
  String get uiStoreFiltersUnavailable;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'{arg0} sample reviews'**
  String uiValueSampleReviews(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'distance unavailable'**
  String get uiDistanceUnavailable2;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'sample products'**
  String get uiSampleProducts;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Walking'**
  String get uiWalking;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Motorcycle'**
  String get uiMotorcycle;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Car'**
  String get uiCar;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Back to store map'**
  String get uiBackToStoreMap;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Copy store name'**
  String get uiCopyStoreName;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Add sample product to cart'**
  String get uiAddSampleProductToCart;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'About the payment preview'**
  String get uiAboutThePaymentPreview;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'QRIS logo, sample payment method'**
  String get uiQRISLogoSamplePaymentMethod;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Subtotal ({arg0} items)'**
  String uiSubtotalValueItems(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Service fee'**
  String get uiServiceFee;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'I agree to the demo pickup terms'**
  String get uiIAgreeToTheDemoPickupTerms;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Example: separate packaging, less sweet, etc.'**
  String get uiExampleSeparatePackagingLessSweetEtc;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Service fee (demo)'**
  String get uiServiceFeeDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Check internet connection'**
  String get uiCheckInternetConnection;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Make sure your connection is stable before retrying.'**
  String get uiMakeSureYourConnectionIsStableBeforeRetrying;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Check transaction history'**
  String get uiCheckTransactionHistory;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Check your payment app before trying again.'**
  String get uiCheckYourPaymentAppBeforeTryingAgain;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Decrease {arg0}'**
  String uiDecreaseValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Quantity of {arg0}: {arg1}'**
  String uiQuantityOfValueValue(String arg0, String arg1);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Increase {arg0}'**
  String uiIncreaseValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Remove {arg0}'**
  String uiRemoveValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Payment status'**
  String get uiPaymentStatus;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Payment time'**
  String get uiPaymentTime;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order ID'**
  String get uiOrderID2;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'QRIS logo'**
  String get uiQRISLogo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Continue to welcome'**
  String get uiContinueToWelcome;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'PanganKita logo'**
  String get uiPanganKitaLogo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Digit {arg0}'**
  String uiDigitValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Continue with {arg0}'**
  String uiContinueWithValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order ready for pickup!'**
  String get uiOrderReadyForPickup;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Soto Kesawan is preparing your favorite food.'**
  String get uiSotoKesawanIsPreparingYourFavoriteFood;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Your favorites are on sale!'**
  String get uiYourFavoritesAreOnSale;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Save up to 60% on selected bread and snacks today.'**
  String get uiSaveUpTo60OnSelectedBreadAndSnacksToday;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order completed'**
  String get uiOrderCompleted;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Something tasty near you'**
  String get uiSomethingTastyNearYou;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Find your favorite food at better prices.'**
  String get uiFindYourFavoriteFoodAtBetterPrices;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Rice Dishes'**
  String get uiRiceDishes;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Bread & Pastries'**
  String get uiBreadPastries;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Cakes & Desserts'**
  String get uiCakesDesserts;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Save {arg0}%'**
  String uiSaveValue(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample stock'**
  String get uiSampleStock;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'{arg0} boxes left'**
  String uiValueBoxesLeft(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'{arg0} portions left'**
  String uiValuePortionsLeft(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'{arg0} boxes left'**
  String uiValueBoxesLeft2(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'{arg0} pieces left'**
  String uiValuePiecesLeft(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'{arg0} minutes left'**
  String uiValueMinutesLeft(String arg0);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get uiActive;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get uiCompleted;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Canceled'**
  String get uiCanceled;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Open Now'**
  String get uiOpenNow;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Biggest Discount'**
  String get uiBiggestDiscount;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Nearest'**
  String get uiNearest;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get uiRating;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'All stores'**
  String get uiAllStores;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get uiDiscount;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get uiPromotions;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get uiToday;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get uiYesterday;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Good Morning, '**
  String get uiGoodMorning;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Save '**
  String get uiSave;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'vincent@example.com • demo'**
  String get uiVincentExampleComDemo;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'(Pack of 5)'**
  String get uiPackOf52;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get uiWelcomeBack;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get uiCreateAccount;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Create New Password'**
  String get uiCreateNewPassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Find your favorite foods\nat better prices.'**
  String get uiFindYourFavoriteFoodsAtBetterPrices;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Choose a password that\'s easy to remember\nbut hard to guess.'**
  String get uiChooseAPasswordThatSEasyToRememberButHardToGuess;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get uiPassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Create password'**
  String get uiCreatePassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get uiNewPassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get uiSignIn;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Save Password'**
  String get uiSavePassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get uiDonTHaveAnAccount;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match.'**
  String get uiPasswordsDoNotMatch;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo mode. No authentication or server account.'**
  String get uiDemoModeNoAuthenticationOrServerAccount;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get uiConfirmNewPassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get uiConfirmPassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get uiThisFieldIsRequired;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get uiEnterAValidEmailAddress;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Use at least 8 characters, including letters and numbers.'**
  String get uiUseAtLeast8CharactersIncludingLettersAndNumbers;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Incorrect demo code. Use 5102.'**
  String get uiIncorrectDemoCodeUse5102;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'The demo code remains 5102. No SMS or email is sent.'**
  String get uiTheDemoCodeRemains5102NoSMSOrEmailIsSent;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Show password'**
  String get uiShowPassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Hide password'**
  String get uiHidePassword;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name.'**
  String get uiEnterYourFullName;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get uiEnterAValidEmailAddress2;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo changes cannot be saved to an account.'**
  String get uiDemoChangesCannotBeSavedToAnAccount;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Sample product added to local cart.'**
  String get uiSampleProductAddedToLocalCart;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo cart quantity limit reached.'**
  String get uiDemoCartQuantityLimitReached;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo product information copied.'**
  String get uiDemoProductInformationCopied;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo limit: 10 items per configuration. Change the quantity in your cart.'**
  String get uiDemoLimit10ItemsPerConfigurationChangeTheQuantityInYourCart;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Search food or stores'**
  String get uiSearchFoodOrStores;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Remove temporary favorite'**
  String get uiRemoveTemporaryFavorite;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Temporarily favorite'**
  String get uiTemporarilyFavorite;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'No inventory is reserved or payment created.'**
  String get uiNoInventoryIsReservedOrPaymentCreated;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order updates'**
  String get uiOrderUpdates;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Thank you for helping reduce food waste with Soto Kesawan.'**
  String get uiThankYouForHelpingReduceFoodWasteWithSotoKesawan;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Mawar Bakery & Cake has prepared your order. Please collect it before 20:30.'**
  String get uiMawarBakeryCakeHasPreparedYourOrderPleaseCollectItBefore2030;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Welcome to PanganKita'**
  String get uiWelcomeToPanganKita;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo pickup deadline: {arg0} · {arg1}'**
  String uiDemoPickupDeadlineValueValue(String arg0, String arg1);

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Demo data'**
  String get uiDemoData;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get uiSettings;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'About PanganKita'**
  String get uiAboutPanganKita;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Messages from stores'**
  String get uiMessagesFromStores;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Promotions & offers'**
  String get uiPromotionsOffers;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Order History'**
  String get uiOrderHistory;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'My Location'**
  String get uiMyLocation;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get uiHelpCenter;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get uiLogOut;

  /// Localizes a previously hard-coded UI message.
  ///
  /// In en, this message translates to:
  /// **'Try another search term.'**
  String get uiTryAnotherSearchTerm;
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
      <String>['en', 'id', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
