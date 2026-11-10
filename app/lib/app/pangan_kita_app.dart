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

  /// Startup locale; defaults to Indonesian in isolated widget tests.
  final Locale initialLocale;

  @override
  State<PanganKitaApp> createState() => _PanganKitaAppState();
}

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

  /// Updates visible language immediately, then attempts persistence.
  /// If storage fails, the current session keeps its selected locale.
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
    AppRoutes.settings: (context) => SettingsPage(
      onLocaleChanged: (locale) => _setLocale(locale).ignore(),
    ),
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
      initialQuery:
          ModalRoute.of(context)?.settings.arguments as String? ?? '',
    ),
  };

  Map<String, WidgetBuilder> get _merchantRoutes => {
    AppRoutes.nearbyStores: (context) => const NearbyStoresPage(),
    AppRoutes.nearbyMap: (context) => const NearbyMapPage(),
  };

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
              body: Center(
                child: I18nText('Contoh chat toko tidak tersedia.'),
              ),
            );
    },
    AppRoutes.notifications: (context) => const NotificationsPage(),
  };

  Map<String, WidgetBuilder> get _shoppingRoutes => {
    AppRoutes.cart: (context) => CartPage(cart: _cart),
    AppRoutes.checkout: (context) => CheckoutPage(cart: _cart),
    AppRoutes.paymentStatus: (context) => PaymentStatusPage(cart: _cart),
    AppRoutes.paymentSuccessPreview: (context) =>
        PaymentSuccessPage(cart: _cart),
    AppRoutes.paymentFailedPreview: (context) =>
        PaymentFailedPage(cart: _cart),
  };

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
