import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/navigation/app_bottom_navigation.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/models/demo_food.dart';

const Color _ink = PanganKitaColors.inkCool;
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

/// Owns the local query and unread-only conversation filter.
///
/// Both controls filter fixed sample messages by merchant and preview text.
/// They neither read a mailbox nor change unread state on the server.
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
            I18nText(
              'Chat',
              style: Theme.of(context).textTheme.displayLarge
                  ?.copyWith(color: _ink),
            ),
            const I18nText('Terhubung dengan toko favoritmu.'),
            const SizedBox(height: 18),
            _ChatSearch(onChanged: (value) => setState(() => _query = value)),
            const SizedBox(height: 16),
            _ChatFilters(
              unreadOnly: _unreadOnly,
              onSelected: (value) => setState(() => _unreadOnly = value),
            ),
            const SizedBox(height: 12),
            const I18nText(
              'Contoh tampilan · belum ada percakapan nyata.',
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            _ConversationList(conversations: visible),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavigation(selectedIndex: 2),
    );
  }
}

/// Displays the fixture conversation entries matching the local query.
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
          child: Center(child: I18nText('Tidak ada contoh yang cocok.')),
        ),
    ],
  );
}

/// Collects text for filtering the on-device example conversations.
class _ChatSearch extends StatelessWidget {
  const new({required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => TextField(
    onChanged: onChanged,
    decoration: InputDecoration(
      hintText: translateDisplayText(context, 'Cari toko atau pesan...'),
      prefixIcon: const Icon(Icons.search, color: Colors.black45),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(_searchRadius)),
      ),
    ),
  );
}

/// Shows static example conversation categories.
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
                    const I18nText('Belum dibaca'),
                    const SizedBox(width: 8),
                    CircleAvatar(
                      radius: _unreadBadgeRadius,
                      backgroundColor: Colors.red,
                      child: I18nText(
                        '$_unreadConversationCount',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              : const I18nText('Semua'),
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

/// Displays the example timestamp and unread counter.
class _ConversationMeta extends StatelessWidget {
  const new({required this.time, required this.unreadCount});

  final String time;
  final int unreadCount;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: _trailingWidth,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        I18nText(time, style: Theme.of(context).textTheme.bodySmall),
        if (unreadCount > 0)
          CircleAvatar(
            radius: _unreadBadgeRadius,
            backgroundColor: PanganKitaColors.brandPrimaryStrong,
            child: I18nText(
              '$unreadCount',
              style: const TextStyle(color: Colors.white),
            ),
          ),
      ],
    ),
  );
}

/// Opens a fixture merchant conversation with preview information.
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
              child: I18nText(
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
        subtitle: I18nText(
          message,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: _ConversationMeta(time: time, unreadCount: unreadCount),
        onTap: () => Navigator.pushNamed<void>(
          context,
          AppRoutes.merchantChat,
          arguments: (food: food, message: message),
        ),
      ),
      const Divider(height: 1),
    ],
  );
}
