import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';

const _ink = Color(0xFF10283C);
const Color _green = PanganKitaColors.brandPrimaryStrong;
const _orderImageSize = 80.0;
const _bubbleWidthFraction = .78;
const _suggestionSpacing = 8.0;
const _suggestionRunSpacing = 4.0;

/// Display-only support conversation based on the supplied reference panel.
class SupportPage extends StatefulWidget {
  /// Creates the local conversation preview.
  const new({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final _message = TextEditingController();

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  void _unavailable() => DemoNotice.show(
    context,
    'Contoh tampilan. Pesan tidak dikirim ke customer service.',
  );

  void _useSuggestion(String suggestion) {
    _message.text = suggestion;
    _message.selection = TextSelection.collapsed(offset: suggestion.length);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    body: SafeArea(
      child: Column(
        children: [
          const _SupportHeader(),
          const _ExampleOrderCard(),
          const Expanded(child: _ExampleMessages()),
          _Suggestions(onSelected: _useSuggestion),
          _Composer(controller: _message, onUnavailable: _unavailable),
        ],
      ),
    ),
  );
}

class _SupportHeader extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
    child: Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton.filledTonal(
            tooltip: 'Kembali ke Profil Saya',
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: _ink,
              minimumSize: const Size.square(52),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
            ),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const CircleAvatar(
              radius: 36,
              backgroundColor: PanganKitaColors.savingsSurface,
              child: Icon(Icons.headset_mic, size: 38, color: _green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bantuan PanganKita',
                    style: Theme.of(context).textTheme.headlineMedium
                        ?.copyWith(color: _ink),
                  ),
                  Text(
                    'Customer Service • contoh',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Opsi bantuan belum tersedia',
              onPressed: () => DemoNotice.unavailable(context),
              icon: const Icon(Icons.more_vert),
            ),
          ],
        ),
      ],
    ),
  );
}

class _ExampleOrderCard extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Card(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    color: Colors.white,
    child: Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            child: SizedBox.square(
              dimension: _orderImageSize,
              child: Image.asset(
                'assets/prototype/support-coconut-buns.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MWR-028 • Mawar Bakery & Cake',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall
                      ?.copyWith(color: _ink),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  ),
                  decoration: const BoxDecoration(
                    color: PanganKitaColors.savingsSurface,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 18,
                        color: _green,
                      ),
                      SizedBox(width: 6),
                      Flexible(child: Text('Siap diambil • contoh')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _ExampleMessages extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
    children: const [
      Center(
        child: Chip(
          label: Text('Percakapan contoh'),
          backgroundColor: Color(0xFFECEBE9),
          side: BorderSide.none,
          shape: StadiumBorder(),
        ),
      ),
      SizedBox(height: 10),
      _MessageBubble(
        message: 'Halo! Ada yang bisa kami bantu terkait pesanan contoh?',
        time: '19.42 • contoh',
      ),
      SizedBox(height: 18),
      _MessageBubble(
        message: 'Saya sudah di toko, tetapi pesanan belum tersedia.',
        time: '19.43 • contoh',
        outgoing: true,
      ),
      SizedBox(height: 18),
      _MessageBubble(
        message: 'Baik, Kak. Bisa ceritakan kondisi di lokasi?',
        time: '19.43 • contoh',
      ),
    ],
  );
}

class _MessageBubble extends StatelessWidget {
  const new({required this.message, required this.time, this.outgoing = false});

  final String message;
  final String time;
  final bool outgoing;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: outgoing
        ? MainAxisAlignment.end
        : MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (!outgoing) ...[
        const CircleAvatar(
          radius: 21,
          backgroundColor: PanganKitaColors.savingsSurface,
          child: Icon(Icons.headset_mic, color: _ink),
        ),
        const SizedBox(width: 10),
      ],
      Flexible(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * _bubbleWidthFraction,
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: outgoing ? PanganKitaColors.savingsSurface : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(18)),
              border: Border.all(color: PanganKitaColors.borderNeutral),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(message, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    textAlign: outgoing ? TextAlign.right : TextAlign.left,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

class _Suggestions extends StatelessWidget {
  const new({required this.onSelected});

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 16, right: 16, bottom: 32),
    child: Wrap(
      alignment: WrapAlignment.center,
      spacing: _suggestionSpacing,
      runSpacing: _suggestionRunSpacing,
      children: [
        for (final label in ['Pesanan belum siap', 'Kendala pembayaran'])
          ActionChip(
            label: Text(label),
            backgroundColor: Colors.white,
            side: const BorderSide(color: PanganKitaColors.borderNeutral),
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            onPressed: () => onSelected(label),
          ),
      ],
    ),
  );
}

class _Composer extends StatelessWidget {
  const new({required this.controller, required this.onUnavailable});

  final TextEditingController controller;
  final VoidCallback onUnavailable;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    color: Colors.white,
    child: Row(
      children: [
        IconButton.outlined(
          tooltip: 'Lampiran belum tersedia',
          onPressed: onUnavailable,
          style: IconButton.styleFrom(
            minimumSize: const Size.square(48),
            shape: const CircleBorder(),
          ),
          icon: const Icon(Icons.add),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Tulis pesan...',
              isDense: true,
              contentPadding: const EdgeInsets.all(16),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(28)),
              ),
              suffixIcon: IconButton(
                tooltip: 'Emoji belum tersedia',
                onPressed: onUnavailable,
                icon: const Icon(Icons.sentiment_satisfied_alt_outlined),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton.filled(
          tooltip: 'Kirim pesan contoh',
          onPressed: onUnavailable,
          style: IconButton.styleFrom(
            minimumSize: const Size.square(58),
            shape: const CircleBorder(),
          ),
          icon: const Icon(Icons.send),
        ),
      ],
    ),
  );
}
