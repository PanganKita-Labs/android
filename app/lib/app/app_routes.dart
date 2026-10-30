/// Routes for the local HTML reference conversion.
abstract final class AppRoutes {
  /// Initial brand screen.
  static const splash = '/';

  /// Introduction.
  static const welcome = '/welcome';

  /// Demo sign in.
  static const login = '/login';

  /// Demo account form.
  static const register = '/register';

  /// Demo registration verification.
  static const verify = '/verify';

  /// Demo recovery verification.
  static const recover = '/recover';

  /// Demo password replacement.
  static const password = '/password';

  /// Demo recovery confirmation.
  static const success = '/success';

  /// Details for one local example; not a public deep link.
  static String product(String id) => '/products/$id';

  /// Session-only shopping preview.
  static const cart = '/cart';

  /// Read-only pickup checkout simulation.
  static const checkout = '/checkout';

  /// Local order-screen preview; no order is created by checkout.
  static const orders = '/orders';

  /// Display-only chat list; no messages are exchanged.
  static const chat = '/chat';

  /// Display-only notification examples; no push service is connected.
  static const notifications = '/notifications';

  /// Status of the local checkout preview; no payment is created.
  static const paymentStatus = '/checkout/status';

  /// Local food examples.
  static const home = '/home';

  /// Display-only profile example; no account data is loaded.
  static const profile = '/profile';

  /// Local edit-form preview; changes are not saved to an account.
  static const editProfile = '/profile/edit';

  /// Local account-settings preview without saved preferences.
  static const settings = '/profile/settings';

  /// Search across local listing examples.
  static const search = '/search';

  /// Selects an illustrative area without device location access.
  static const location = '/location';

  /// Display-only nearby merchant examples; no live location is used.
  static const nearbyStores = '/stores/nearby';

  /// Illustrative map of local merchant examples.
  static const nearbyMap = '/stores/map';

  /// Detail for one illustrative merchant; no live store data.
  static String store(String id) => '/stores/$id';
}
