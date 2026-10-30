import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/cart_page.dart';
import 'package:pangankita/features/discovery/chat_page.dart';
import 'package:pangankita/features/discovery/checkout_page.dart';
import 'package:pangankita/features/discovery/demo_cart.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/discovery/location_selection_page.dart';
import 'package:pangankita/features/discovery/nearby_map_page.dart';
import 'package:pangankita/features/discovery/nearby_stores_page.dart';
import 'package:pangankita/features/discovery/notifications_page.dart';
import 'package:pangankita/features/discovery/orders_page.dart';
import 'package:pangankita/features/discovery/payment_status_page.dart';
import 'package:pangankita/features/discovery/product_detail_page.dart';
import 'package:pangankita/features/discovery/profile_page.dart';
import 'package:pangankita/features/discovery/search_page.dart';
import 'package:pangankita/features/discovery/store_detail_page.dart';
import 'package:pangankita/features/onboarding/auth_page.dart';
import 'package:pangankita/features/onboarding/otp_page.dart';
import 'package:pangankita/features/onboarding/password_success_page.dart';
import 'package:pangankita/features/onboarding/splash_page.dart';
import 'package:pangankita/features/onboarding/welcome_page.dart';

/// Application composition for the native Flutter reference conversion.
class PanganKitaApp extends StatefulWidget {
  /// Creates the local prototype without server authentication or payments.
  const new({super.key});

  @override
  State<PanganKitaApp> createState() => _PanganKitaAppState();
}

class _PanganKitaAppState extends State<PanganKitaApp> {
  final _cart = DemoCart();
  String _selectedArea = 'Mandala by Pass, Medan';

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'PanganKita',
    debugShowCheckedModeBanner: false,
    initialRoute: AppRoutes.splash,
    theme: PanganKitaTheme.light,
    routes: {
      AppRoutes.splash: (context) => const SplashPage(),
      AppRoutes.welcome: (context) => const WelcomePage(),
      AppRoutes.login: (context) => const AuthPage.login(),
      AppRoutes.register: (context) => const AuthPage.register(),
      AppRoutes.verify: (context) => const OtpPage(),
      AppRoutes.recover: (context) => const OtpPage(recovery: true),
      AppRoutes.password: (context) => const AuthPage.password(),
      AppRoutes.success: (context) => const PasswordSuccessPage(),
      AppRoutes.home: (context) => HomePage(
        initialLocation: _selectedArea,
        onLocationChanged: (area) => setState(() => _selectedArea = area),
      ),
      AppRoutes.profile: (context) => const ProfilePage(),
      AppRoutes.location: (context) => LocationSelectionPage(
        initialArea:
            ModalRoute.of(context)?.settings.arguments as String? ??
            _selectedArea,
      ),
      AppRoutes.search: (context) => SearchPage(
        initialQuery:
            ModalRoute.of(context)?.settings.arguments as String? ?? '',
      ),
      AppRoutes.nearbyStores: (context) => const NearbyStoresPage(),
      AppRoutes.nearbyMap: (context) => const NearbyMapPage(),
      AppRoutes.orders: (context) => const OrdersPage(),
      AppRoutes.chat: (context) => const ChatPage(),
      AppRoutes.notifications: (context) => const NotificationsPage(),
      AppRoutes.cart: (context) => CartPage(cart: _cart),
      AppRoutes.checkout: (context) => CheckoutPage(cart: _cart),
      AppRoutes.paymentStatus: (context) => PaymentStatusPage(cart: _cart),
      for (final food in DemoFood.examples)
        AppRoutes.product(food.id): (context) =>
            ProductDetailPage(food: food, cart: _cart),
      AppRoutes.product(DemoFood.garlicBread.id): (context) =>
          ProductDetailPage(food: DemoFood.garlicBread, cart: _cart),
      for (final food in DemoFood.examples)
        AppRoutes.store(food.id): (context) =>
            StoreDetailPage(food: food, cart: _cart),
    },
  );
}
