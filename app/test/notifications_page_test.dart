import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/home_page.dart';
import 'package:pangankita/features/discovery/notifications_page.dart';
import 'package:pangankita/features/discovery/orders_page.dart';

import 'font_test_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadBrandFonts);

  testWidgets('Home bell opens Notifications', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const HomePage(),
        routes: {
          AppRoutes.notifications: (context) => const NotificationsPage(),
        },
      ),
    );
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is IconButton && widget.tooltip == 'Notifikasi',
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(NotificationsPage), findsOneWidget);
  });

  testWidgets('Notifications opens from Home and filters local examples', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const HomePage(),
        routes: {
          AppRoutes.home: (context) => const HomePage(),
          AppRoutes.notifications: (context) => const NotificationsPage(),
        },
      ),
    );
    await tester.tap(find.text('Notifikasi'));
    await tester.pumpAndSettle();
    expect(find.textContaining('belum ada notifikasi nyata'), findsOneWidget);
    expect(find.text('Pesanan siap diambil!'), findsNWidgets(2));
    await tester.tap(find.text('Promo'));
    await tester.pumpAndSettle();
    expect(find.text('Pesanan siap diambil!'), findsNothing);
    expect(find.text('Favoritmu lagi diskon!'), findsOneWidget);
    await tester.tap(find.text('Semua'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.circle), findsNWidgets(2));
    await tester.tap(find.text('Tandai dibaca'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.circle), findsNothing);
  });

  testWidgets('notification cards open relevant preview pages', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const NotificationsPage(),
        routes: {AppRoutes.home: (context) => const HomePage()},
      ),
    );
    await tester.tap(find.text('Pesanan siap diambil!').first);
    await tester.pumpAndSettle();
    expect(find.byType(OrdersPage), findsOneWidget);
    expect(find.text('Contoh pesanan aktif'), findsOneWidget);
    Navigator.of(tester.element(find.byType(OrdersPage))).pop();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Promo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Favoritmu lagi diskon!'));
    await tester.pumpAndSettle();
    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('completed notification points to matching example order', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: PanganKitaTheme.light,
        home: const NotificationsPage(),
      ),
    );
    await tester.scrollUntilVisible(
      find.text('Pesanan selesai'),
      140,
      scrollable: find
          .descendant(
            of: find.byType(NotificationsPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pesanan selesai'));
    await tester.pumpAndSettle();
    expect(find.byType(OrdersPage), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Soto Kesawan'),
      140,
      scrollable: find
          .descendant(
            of: find.byType(OrdersPage),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Soto Kesawan'), findsOneWidget);
    expect(
      find.text('Contoh tampilan · belum ada pesanan selesai.'),
      findsOneWidget,
    );
  });

  for (final width in [320.0, 360.0, 390.0, 412.0]) {
    for (final scale in [1.0, 1.6]) {
      testWidgets('Notifications fit $width at text scale $scale', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 844);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        await tester.pumpWidget(
          MaterialApp(
            theme: PanganKitaTheme.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(scale)),
              child: child ?? const SizedBox.shrink(),
            ),
            home: const NotificationsPage(),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        await tester.scrollUntilVisible(
          find.text('Ada yang enak di dekatmu'),
          120,
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      });
    }
  }
}
