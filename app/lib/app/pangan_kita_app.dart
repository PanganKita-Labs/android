import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/discovery/location_selection_page.dart';
import 'package:pangankita/features/discovery/product_detail_page.dart';
import 'package:pangankita/features/discovery/search_page.dart';
import 'package:pangankita/features/merchants/directions_page.dart';
import 'package:pangankita/features/merchants/nearby_map_page.dart';
import 'package:pangankita/features/merchants/nearby_stores_page.dart';
import 'package:pangankita/features/merchants/store_detail_page.dart';
import 'package:pangankita/features/messaging/chat_page.dart';
import 'package:pangankita/features/messaging/merchant_chat_page.dart';
import 'package:pangankita/features/messaging/support_page.dart';
import 'package:pangankita/features/notifications/notifications_page.dart';
import 'package:pangankita/features/onboarding/auth_page.dart';
import 'package:pangankita/features/onboarding/otp_page.dart';
import 'package:pangankita/features/onboarding/password_success_page.dart';
import 'package:pangankita/features/onboarding/recovery_page.dart';
import 'package:pangankita/features/onboarding/splash_page.dart';
import 'package:pangankita/features/onboarding/welcome_page.dart';
import 'package:pangankita/features/orders/order_detail_page.dart';
import 'package:pangankita/features/orders/orders_page.dart';
import 'package:pangankita/features/orders/pickup_page.dart';
import 'package:pangankita/features/orders/review_page.dart';
import 'package:pangankita/features/profile/edit_profile_page.dart';
import 'package:pangankita/features/profile/favorites_page.dart';
import 'package:pangankita/features/profile/profile_page.dart';
import 'package:pangankita/features/profile/settings_document_page.dart';
import 'package:pangankita/features/profile/settings_page.dart';
import 'package:pangankita/features/profile/terms_page.dart';
import 'package:pangankita/features/shopping/cart_page.dart';
import 'package:pangankita/features/shopping/checkout_page.dart';
import 'package:pangankita/features/shopping/demo_cart.dart';
import 'package:pangankita/features/shopping/payment_failed_page.dart';
import 'package:pangankita/features/shopping/payment_status_page.dart';
import 'package:pangankita/features/shopping/payment_success_page.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/models/demo_food.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Root widget for routes, localization, and local demonstration state.
///
/// The cart and selected area last only for this widget's lifetime.
/// UI language selection is the only device preference saved here.
class PanganKitaApp extends StatefulWidget {
  /// Creates the local prototype without server authentication or payments.
  /// [initialLocale] is the starting language, not a forced override.
  const new({this.initialLocale = const Locale('id'), super.key});

  /// Initial locale, defaulting to Indonesian.
  ///
  /// This constructor value is not replaced by a stored preference here.
  final Locale initialLocale;

  @override
  State<PanganKitaApp> createState() => _PanganKitaAppState();
}

/// Owns the session cart, example area, and active UI locale.
///
/// Routes share one session cart. Language changes attempt a device-preference
/// write, but this state initializes from [PanganKitaApp.initialLocale] rather
/// than loading a previously stored preference.
class _PanganKitaAppState extends State<PanganKitaApp> {
  /// Shared by product, cart, checkout, and payment preview routes.
  /// Disposed with the root application widget.
  final _cart = DemoCart();

  /// Example location shared across screens, without device GPS access.
  /// This value is not persisted across application restarts.
  final _selectedArea = ValueNotifier<String>('Mandala by Pass, Medan');
  Locale _locale = const Locale('id');

  @override
  void initState() {
    super.initState();
    _locale = widget.initialLocale;
  }

  /// Applies [locale] immediately, then attempts device persistence.
  ///
  /// Simplified Chinese is stored as `zh_Hans`; other choices use their
  /// language code. A storage [Exception] is logged rather than propagated,
  /// and the newly selected locale stays active for this session.
  Future<void> _setLocale(Locale locale) async {
    if (_locale == locale) return;
    setState(() => _locale = locale);
    final value = locale.languageCode == 'zh' ? 'zh_Hans' : locale.languageCode;
    try {
      await SharedPreferencesAsync().setString('pangankita.ui.locale', value);
    } on Exception catch (error) {
      debugPrint('Unable to save language preference: $error');
    }
  }

  @override
  void dispose() {
    _cart.dispose();
    _selectedArea.dispose();
    super.dispose();
  }

  /// Registers welcome, authentication, and recovery preview routes.
  Map<String, WidgetBuilder> get _introRoutes => {
    AppRoutes.splash: (context) => const SplashPage(),
    AppRoutes.welcome: (context) => const WelcomePage(),
    AppRoutes.login: (context) => const AuthPage.login(),
    AppRoutes.register: (context) => const AuthPage.register(),
    AppRoutes.verify: (context) => const OtpPage(),
    AppRoutes.recover: (context) => const RecoveryPage(),
    AppRoutes.recoverOtp: (context) => const OtpPage(recovery: true),
    AppRoutes.password: (context) => const AuthPage.password(),
    AppRoutes.success: (context) => const PasswordSuccessPage(),
  };

  /// Builds profile, search, and settings routes using app-owned state.
  Map<String, WidgetBuilder> get _accountRoutes => {
    AppRoutes.home: (context) => ValueListenableBuilder<String>(
      valueListenable: _selectedArea,
      builder: (context, area, child) => HomePage(
        initialLocation: area,
        onLocationChanged: (selected) => _selectedArea.value = selected,
      ),
    ),
    AppRoutes.profile: (context) => ProfilePage(
      readLocation: () => _selectedArea.value,
      onLocationChanged: (area) => _selectedArea.value = area,
    ),
    AppRoutes.editProfile: (context) => const EditProfilePage(),
    AppRoutes.settings: (context) =>
        SettingsPage(onLocaleChanged: (locale) => _setLocale(locale).ignore()),
    AppRoutes.terms: (context) => const TermsPage(),
    AppRoutes.privacy: (context) => const SettingsDocumentPage.privacy(),
    AppRoutes.favorites: (context) => const FavoritesPage(),
    AppRoutes.support: (context) => const SupportPage(),
    AppRoutes.location: (context) => LocationSelectionPage(
      initialArea:
          ModalRoute.of(context)?.settings.arguments as String? ??
          _selectedArea.value,
    ),
    AppRoutes.search: (context) => SearchPage(
      initialQuery: ModalRoute.of(context)?.settings.arguments as String? ?? '',
    ),
  };

  /// Registers the nearby-stores list and illustrative map routes.
  Map<String, WidgetBuilder> get _merchantRoutes => {
    AppRoutes.nearbyStores: (context) => const NearbyStoresPage(),
    AppRoutes.nearbyMap: (context) => const NearbyMapPage(),
  };

  /// Resolves example order routes from their supplied arguments.
  ///
  /// The detail route accepts a [DemoFood] argument. Other argument types
  /// display an unavailable-example message rather than an order detail.
  Map<String, WidgetBuilder> get _ordersRoutes => {
    AppRoutes.orders: (context) {
      final tab = ModalRoute.of(context)?.settings.arguments;
      return OrdersPage(initialTab: tab is OrdersTab ? tab.index : 0);
    },
    AppRoutes.orderDetail: (context) {
      final food = ModalRoute.of(context)?.settings.arguments;
      return food is DemoFood
          ? OrderDetailPage(food: food)
          : const Scaffold(
              body: Center(child: I18nText('Contoh pesanan tidak tersedia.')),
            );
    },
  };

  /// Builds local messaging and notification previews with argument checks.
  Map<String, WidgetBuilder> get _messagesRoutes => {
    AppRoutes.chat: (context) => const ChatPage(),
    AppRoutes.merchantChat: (context) {
      final example = ModalRoute.of(context)?.settings.arguments;
      return example is ({DemoFood food, String? message})
          ? MerchantChatPage(
              food: example.food,
              previewMessage: example.message,
            )
          : const Scaffold(
              body: Center(child: I18nText('Contoh chat toko tidak tersedia.')),
            );
    },
    AppRoutes.notifications: (context) => const NotificationsPage(),
  };

  /// Provides the shared demo cart to checkout and payment preview screens.
  Map<String, WidgetBuilder> get _shoppingRoutes => {
    AppRoutes.cart: (context) => CartPage(cart: _cart),
    AppRoutes.checkout: (context) => CheckoutPage(cart: _cart),
    AppRoutes.paymentStatus: (context) => PaymentStatusPage(cart: _cart),
    AppRoutes.paymentSuccessPreview: (context) =>
        PaymentSuccessPage(cart: _cart),
    AppRoutes.paymentFailedPreview: (context) => PaymentFailedPage(cart: _cart),
  };

  /// Builds pickup and review previews from validated fixture arguments.
  Map<String, WidgetBuilder> get _followupRoutes => {
    AppRoutes.pickup: (context) {
      final example = ModalRoute.of(context)?.settings.arguments;
      return example is ({DemoFood food, int quantity})
          ? PickupPage(food: example.food, quantity: example.quantity)
          : const Scaffold(
              body: Center(
                child: I18nText('Contoh pengambilan tidak tersedia.'),
              ),
            );
    },
    AppRoutes.review: (context) {
      final example = ModalRoute.of(context)?.settings.arguments;
      return example is ({DemoFood food, int quantity})
          ? ReviewPage(food: example.food, quantity: example.quantity)
          : const Scaffold(
              body: Center(child: I18nText('Contoh ulasan tidak tersedia.')),
            );
    },
  };

  /// Registers product, directions, and merchant paths for known fixture IDs.
  Map<String, WidgetBuilder> get _dynamicRoutes => {
    for (final food in DemoFood.examples)
      AppRoutes.product(food.id): (context) =>
          ProductDetailPage(food: food, cart: _cart),
    AppRoutes.product(DemoFood.garlicBread.id): (context) =>
        ProductDetailPage(food: DemoFood.garlicBread, cart: _cart),
    for (final food in DemoFood.examples)
      AppRoutes.directions(food.id): (context) => DirectionsPage(food: food),
    for (final food in DemoFood.examples)
      AppRoutes.store(food.id): (context) =>
          StoreDetailPage(food: food, cart: _cart),
  };

  /// Combines all local route groups into the app's named-route map.
  Map<String, WidgetBuilder> get _routes => {
    ..._introRoutes,
    ..._accountRoutes,
    ..._merchantRoutes,
    ..._ordersRoutes,
    ..._messagesRoutes,
    ..._shoppingRoutes,
    ..._followupRoutes,
    ..._dynamicRoutes,
  };

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'PanganKita',
    locale: _locale,
    supportedLocales: AppLocalizations.supportedLocales,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    debugShowCheckedModeBanner: false,
    initialRoute: AppRoutes.splash,
    theme: PanganKitaTheme.light,
    routes: _routes,
  );
}
