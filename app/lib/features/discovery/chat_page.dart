import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';
import 'package:pangankita/features/discovery/discovery_navigation.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _ink = Color(0xFF14313A);
const _searchRadius = 24.0;
const _chipSpacing = 10.0;
const _avatarRadius = 27.0;
const _unreadBadgeRadius = 12.0;
const _trailingWidth = 48.0;

typedef _Conversation = ({
  int food,
  String message,
  String time,
  int unreadCount,
  bool designMark,
});

const List<_Conversation> _conversations = [
  (
    food: 0,
    message: 'Pesanan Kakak sudah siap diambil, ya',
    time: '10.42',
    unreadCount: 2,
    designMark: true,
  ),
  (
    food: 1,
    message: 'Baik, kak. Pesanan sedang kami siapkan.',
    time: '10.42',
    unreadCount: 1,
    designMark: false,
  ),
  (
    food: 2,
    message: 'Terima kasih sudah berbelanja, kak!',
    time: 'Kemarin',
    unreadCount: 0,
    designMark: true,
  ),
  (
    food: 3,
    message: 'Siap, kak. Terima kasih!',
    time: '22 Okt',
    unreadCount: 0,
    designMark: true,
  ),
];

int get _unreadConversationCount =>
    _conversations.where((item) => item.unreadCount > 0).length;

/// Searchable visual preview of the supplied chat list design.
class ChatPage extends StatefulWidget {
  /// Creates the preview without live conversations.
  const new({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String _query = '';
  bool _unreadOnly = false;

  @override
  Widget build(BuildContext context) {
    final visible = _conversations.where((conversation) {
      final merchant = DemoFood.examples[conversation.food].merchant;
      return (!_unreadOnly || conversation.unreadCount > 0) &&
          '$merchant ${conversation.message}'.toLowerCase().contains(
            _query.trim().toLowerCase(),
          );
    });
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(23, 24, 23, 32),
          children: [
            Text(
              'Chat',
              style: Theme.of(context).textTheme.displayLarge
                  ?.copyWith(color: _ink),
            ),
            const Text('Terhubung dengan toko favoritmu.'),
            const SizedBox(height: 18),
            _ChatSearch(onChanged: (value) => setState(() => _query = value)),
            const SizedBox(height: 16),
            _ChatFilters(
              unreadOnly: _unreadOnly,
              onSelected: (value) => setState(() => _unreadOnly = value),
            ),
            const SizedBox(height: 12),
            const Text(
              'Contoh tampilan · belum ada percakapan nyata.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            _ConversationList(conversations: visible),
          ],
        ),
      ),
      bottomNavigationBar: const DiscoveryNavigation(selectedIndex: 2),
    );
  }
}

class _ConversationList extends StatelessWidget {
  const new({required this.conversations});

  final Iterable<_Conversation> conversations;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      for (final conversation in conversations)
        _ConversationRow(
          food: DemoFood.examples[conversation.food],
          message: conversation.message,
          time: conversation.time,
          unreadCount: conversation.unreadCount,
          designMark: conversation.designMark,
        ),
      if (conversations.isEmpty)
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 36),
          child: Center(child: Text('Tidak ada contoh yang cocok.')),
        ),
    ],
  );
}

class _ChatSearch extends StatelessWidget {
  const new({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: const InputDecoration(
      hintText: 'Cari toko atau pesan...',
      prefixIcon: Icon(Icons.search, color: Colors.black45),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(_searchRadius)),
      ),
    ),
  );
}

class _ChatFilters extends StatelessWidget {
  const new({required this.unreadOnly, required this.onSelected});

  final bool unreadOnly;
  final ValueChanged<bool> onSelected;

  @override
  Widget build(BuildContext context) => Wrap(
    spacing: _chipSpacing,
    children: [
      for (final unread in [false, true])
        ChoiceChip(
          label: unread
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Belum dibaca'),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: _unreadBadgeRadius,
                      backgroundColor: Colors.red,
                      child: Text(
                        '$_unreadConversationCount',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              : const Text('Semua'),
          selected: unreadOnly == unread,
          showCheckmark: false,
          selectedColor: PanganKitaColors.brandPrimaryStrong,
          backgroundColor: Colors.white,
          labelStyle: TextStyle(
            fontFamily: PanganKitaTheme.emphasisFontFamily,
            fontWeight: FontWeight.w600,
            color: unreadOnly == unread ? Colors.white : _ink,
          ),
          side: BorderSide.none,
          onSelected: (_) => onSelected(unread),
        ),
    ],
  );
}

class _ConversationRow extends StatelessWidget {
  const new({
    required this.food,
    required this.message,
    required this.time,
    required this.unreadCount,
    required this.designMark,
  });

  final DemoFood food;
  final String message;
  final String time;
  final int unreadCount;
  final bool designMark;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 12),
        leading: CircleAvatar(
          radius: _avatarRadius,
          backgroundImage: AssetImage(food.image),
        ),
        title: Row(
          children: [
            Flexible(
              child: Text(
                food.merchant,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (designMark) ...[
              const SizedBox(width: 4),
              const ExcludeSemantics(
                child: Icon(
                  Icons.check_circle,
                  size: 15,
                  color: PanganKitaColors.brandPrimaryStrong,
                ),
              ),
            ],
          ],
        ),
        subtitle: Text(message, maxLines: 1, overflow: TextOverflow.ellipsis),
        trailing: SizedBox(
          width: _trailingWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(time, style: Theme.of(context).textTheme.bodySmall),
              if (unreadCount > 0)
                CircleAvatar(
                  radius: _unreadBadgeRadius,
                  backgroundColor: PanganKitaColors.brandPrimaryStrong,
                  child: Text(
                    '$unreadCount',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
            ],
          ),
        ),
        onTap: () => DemoNotice.unavailable(context),
      ),
      const Divider(height: 1),
    ],
  );
}
