/// Named navigation paths for the local Flutter demonstration.
///
/// Product and merchant paths are registered for known fixture IDs.
/// They are not external deep links or server endpoints.
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

  /// Recovery OTP preview.
  static const recoverOtp = '/recover/verify';

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

  /// Local order preview. Pass an [OrdersTab] to select a tab;
  /// missing or invalid route arguments default to active orders.
  static const orders = '/orders';

  /// Example order detail. Expects a DemoFood route argument;
  /// other arguments display an unavailable-example fallback.
  static const orderDetail = '/orders/detail';

  /// Display-only chat list; no messages are exchanged.
  static const chat = '/chat';

  /// Merchant chat preview; accepts a record with a DemoFood and
  /// an optional message. Other arguments show a fallback screen.
  static const merchantChat = '/chat/merchant';

  /// Display-only notification examples; no push service is connected.
  static const notifications = '/notifications';

  /// Status of the local checkout preview; no payment is created.
  static const paymentStatus = '/checkout/status';

  /// Illustrative success layout; no payment is confirmed.
  static const paymentSuccessPreview = '/checkout/success-preview';

  /// Illustrative unsuccessful-payment layout; no attempt is recorded.
  static const paymentFailedPreview = '/checkout/failed-preview';

  /// Pickup preview; expects a record with DemoFood and int quantity.
  /// No pickup is recorded, and invalid arguments show a fallback.
  static const pickup = '/orders/pickup';

  /// Review preview; expects a record with DemoFood and int quantity.
  /// No review is submitted, and invalid arguments show a fallback.
  static const review = '/orders/review';

  /// Local food examples.
  static const home = '/home';

  /// Display-only profile example; no account data is loaded.
  static const profile = '/profile';

  /// Local edit-form preview; changes are not saved to an account.
  static const editProfile = '/profile/edit';

  /// Local settings preview. Only the UI language preference persists.
  static const settings = '/profile/settings';

  /// Status of the unpublished terms document in this local prototype.
  static const terms = '/profile/settings/terms';

  /// Status of the unpublished privacy document in this local prototype.
  static const privacy = '/profile/settings/privacy';

  /// Local favorites example without persistence.
  static const favorites = '/profile/favorites';

  /// Display-only customer support conversation example.
  static const support = '/profile/support';

  /// Search across local listing examples.
  static const search = '/search';

  /// Selects an illustrative area without device location access.
  static const location = '/location';

  /// Display-only nearby merchant examples; no live location is used.
  static const nearbyStores = '/stores/nearby';

  /// Illustrative map of local merchant examples.
  static const nearbyMap = '/stores/map';

  /// Illustrative directions to one example merchant.
  static String directions(String id) => '/stores/$id/directions';

  /// Detail for one illustrative merchant; no live store data.
  static String store(String id) => '/stores/$id';
}

/// Typed argument for [AppRoutes.orders] to choose an orders tab.
///
/// An absent or unrecognized route argument opens the active tab.
enum OrdersTab {
  /// Show active-order examples.
  active,

  /// Show completed-order examples.
  completed,

  /// Show canceled-order examples.
  canceled,
}
