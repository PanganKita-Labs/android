import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/i18n/i18n.dart';
import 'package:pangankita/shared/models/demo_food.dart';

const _photoSize = 48.0;
const _merchantRadius = 18.0;
const _bubbleWidthFraction = .82;

/// A local conversation example without message delivery or persistence.
class MerchantChatPage extends StatefulWidget {
  /// Shows the selected merchant and optional list-preview message.
  const new({required this.food, this.previewMessage, super.key});

  /// Example listing used only for the merchant and product context.
  final DemoFood food;

  /// Illustrative snippet shown in the chat list, if opened from that list.
  final String? previewMessage;

  @override
  State<MerchantChatPage> createState() => _MerchantChatPageState();
}

/// Owns the message draft and session-only preview conversation.
///
/// Submitting a draft adds local UI text; no network message is sent.
class _MerchantChatPageState extends State<MerchantChatPage> {
  final _controller = TextEditingController();
  final _localMessages = <String>[];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Adds the current draft to the in-memory conversation preview.
  void _addLocalMessage() {
    final message = _controller.text.trim();
    if (message.isEmpty) return;
    setState(() {
      _localMessages.add(message);
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    appBar: _MerchantHeader(food: widget.food),
    body: SafeArea(
      top: false,
      child: Column(
        children: [
          const _PreviewNotice(),
          _ProductContext(food: widget.food),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (widget.previewMessage case final message?)
                  _MessageBubble(message: message, local: false)
                else
                  const Center(
                    child: I18nText('Belum ada contoh pesan untuk toko ini.'),
                  ),
                for (final message in _localMessages) ...[
                  const SizedBox(height: 12),
                  _MessageBubble(message: message, local: true),
                ],
              ],
            ),
          ),
          _Composer(controller: _controller, onSend: _addLocalMessage),
        ],
      ),
    ),
  );
}

/// Shows the fixture merchant identity and navigation controls.
class _MerchantHeader extends StatelessWidget implements PreferredSizeWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
    leading: const BackButton(),
    titleSpacing: 0,
    title: Row(
      children: [
        CircleAvatar(
          radius: _merchantRadius,
          backgroundImage: AssetImage(food.image),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: I18nText(
            food.merchant,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    ),
  );
}

/// Explains that the displayed chat is a local demonstration.
class _PreviewNotice extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.fromLTRB(16, 8, 16, 4),
    child: I18nText(
      'Percakapan contoh. Pesan tidak dikirim atau disimpan.',
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.black54),
    ),
  );
}

/// Displays the selected food fixture above the conversation.
class _ProductContext extends StatelessWidget {
  const new({required this.food});

  final DemoFood food;

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: SizedBox.square(
              dimension: _photoSize,
              child: Image.asset(food.image, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const I18nText('Produk contoh'),
                I18nText(
                  food.title,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

/// Renders one local example message and its alignment.
class _MessageBubble extends StatelessWidget {
  const new({required this.message, required this.local});

  final String message;
  final bool local;

  @override
  Widget build(BuildContext context) => Align(
    alignment: local ? Alignment.centerRight : Alignment.centerLeft,
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.sizeOf(context).width * _bubbleWidthFraction,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: local ? const Color(0xFFE0F1E7) : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              I18nText(message),
              const SizedBox(height: 6),
              I18nText(
                local ? 'Pesan lokal, tidak terkirim' : 'Pesan contoh toko',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

/// Collects a draft message and invokes the local submit callback.
class _Composer extends StatelessWidget {
  const new({required this.controller, required this.onSend});

  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
              decoration: InputDecoration(
                hintText: translateDisplayText(
                  context,
                  'Tulis pesan contoh...',
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            tooltip: translateDisplayText(context, 'Tambahkan pesan contoh'),
            onPressed: onSend,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    ),
  );
}
