import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/discovery_navigation.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _ink = Color(0xFF14313A);
const _orderSurface = Color(0xFFE7F0EB);
const _orderIconSurface = Color(0xFFD0E6D9);
const _promoIconSurface = Color(0xFFF9E7D1);
const _cardRadius = 20.0;
const _chipSpacing = 10.0;
const _iconRadius = 23.0;

typedef _Notice = ({
  int id,
  String title,
  String description,
  String time,
  bool order,
  bool today,
  bool unread,
});

const List<_Notice> _examples = [
  (
    id: 0,
    title: 'Pesanan siap diambil!',
    description:
        'Mawar Bakery & Cake sudah menyiapkan pesananmu. '
        'Ambil sebelum 20.30, ya.',
    time: '10.42 · Pesanan',
    order: true,
    today: true,
    unread: true,
  ),
  (
    id: 1,
    title: 'Pesanan siap diambil!',
    description: 'Soto Kesawan sedang menyiapkan makanan favoritmu.',
    time: '07.10 · Pesanan',
    order: true,
    today: true,
    unread: true,
  ),
  (
    id: 2,
    title: 'Favoritmu lagi diskon!',
    description: 'Hemat hingga 60% untuk roti dan camilan pilihan hari ini.',
    time: '09.00 · Promo',
    order: false,
    today: true,
    unread: false,
  ),
  (
    id: 3,
    title: 'Pesanan selesai',
    description:
        'Terima kasih sudah menyelamatkan makanan bersama '
        'Raihan Bakery & Cake.',
    time: '24 Okt · Pesanan',
    order: true,
    today: false,
    unread: false,
  ),
  (
    id: 4,
    title: 'Ada yang enak di dekatmu',
    description: 'Temukan makanan favorit dengan harga yang lebih hemat.',
    time: '24 Okt · Promo',
    order: false,
    today: false,
    unread: false,
  ),
];

/// Local visual preview of the supplied notifications design.
class NotificationsPage extends StatefulWidget {
  /// Creates the preview without push notifications or real orders.
  const new({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  String _filter = 'Semua';
  final Set<int> _read = {};

  @override
  Widget build(BuildContext context) {
    final visible = _examples.where(
      (notice) =>
          _filter == 'Semua' ||
          (_filter == 'Pesanan' ? notice.order : !notice.order),
    );
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(23, 24, 23, 32),
          children: [
            _NotificationsHeader(
              onMarkRead: () => setState(() {
                _read.addAll(_examples.map((notice) => notice.id));
              }),
            ),
            const SizedBox(height: 18),
            _NotificationFilters(
              selected: _filter,
              onSelected: (value) => setState(() => _filter = value),
            ),
            const SizedBox(height: 14),
            const Text(
              'Contoh tampilan · belum ada notifikasi nyata.',
              style: TextStyle(color: Colors.black54),
            ),
            for (final today in [true, false])
              _NotificationGroup(today: today, notices: visible, read: _read),
          ],
        ),
      ),
      bottomNavigationBar: const DiscoveryNavigation(selectedIndex: 3),
    );
  }
}

class _NotificationGroup extends StatelessWidget {
  const new({required this.today, required this.notices, required this.read});

  final bool today;
  final Iterable<_Notice> notices;
  final Set<int> read;

  @override
  Widget build(BuildContext context) {
    final grouped = notices.where((notice) => notice.today == today);
    if (grouped.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 20),
        Text(
          today ? 'Hari ini' : 'Kemarin',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: _ink),
        ),
        const SizedBox(height: 14),
        for (final notice in grouped) ...[
          _NotificationCard(
            notice: notice,
            unread: notice.unread && !read.contains(notice.id),
            onTap: () => DemoNotice.unavailable(context),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _NotificationsHeader extends StatelessWidget {
  const new({required this.onMarkRead});

  final VoidCallback onMarkRead;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              'Notifikasi',
              style: Theme.of(context).textTheme.displayLarge
                  ?.copyWith(color: _ink),
            ),
          ),
          TextButton.icon(
            onPressed: onMarkRead,
            icon: const Icon(Icons.done_all),
            label: const Text('Tandai dibaca'),
          ),
        ],
      ),
      const Text('Kabar terbaru untukmu.'),
    ],
  );
}

class _NotificationFilters extends StatelessWidget {
  const new({required this.selected, required this.onSelected});

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: _chipSpacing,
    children: [
      for (final label in ['Semua', 'Pesanan', 'Promo'])
        ChoiceChip(
          label: Text(label),
          selected: selected == label,
          showCheckmark: false,
          selectedColor: PanganKitaColors.brandPrimaryStrong,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            fontFamily: PanganKitaTheme.emphasisFontFamily,
            fontWeight: FontWeight.w600,
            color: selected == label ? Colors.white : _ink,
          ),
          side: BorderSide.none,
          onSelected: (_) => onSelected(label),
        ),
    ],
  );
}

class _NotificationIcon extends StatelessWidget {
  const new({required this.order});

  final bool order;

  @override
  Widget build(BuildContext context) => CircleAvatar(
    radius: _iconRadius,
    backgroundColor: order ? _orderIconSurface : _promoIconSurface,
    child: Icon(
      order ? Icons.restaurant : Icons.card_giftcard,
      color: order
          ? PanganKitaColors.brandPrimary
          : PanganKitaColors.brandAccent,
    ),
  );
}

class _NotificationCard extends StatelessWidget {
  const new({required this.notice, required this.unread, required this.onTap});

  final _Notice notice;
  final bool unread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: unread ? _orderSurface : Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(_cardRadius)),
      side: BorderSide(color: PanganKitaColors.borderNeutral),
    ),
    child: InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(_cardRadius)),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _NotificationIcon(order: notice.order),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notice.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(notice.description),
                  const SizedBox(height: 12),
                  Text(
                    notice.time,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            if (unread) ...[
              const SizedBox(width: 6),
              const Icon(
                Icons.circle,
                size: 9,
                color: PanganKitaColors.brandPrimary,
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
