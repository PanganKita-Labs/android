import 'package:flutter/material.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/shared/demo_notice.dart';
import 'package:pangankita/shared/models/demo_food.dart';

const Color _ink = PanganKitaColors.inkDeep;
const Color _green = PanganKitaColors.brandPrimaryStrong;
const _photoSize = 72.0;
const _photoRadius = 12.0;
const _cardRadius = 16.0;
const _maxReviewLength = 500;
const _starCount = 5;
const _starSize = 38.0;
const _tagGap = 8.0;
const _tagRunGap = 6.0;
const _tagIconSize = 18.0;
const _tagColumns = 2;
const _tagRadius = 12.0;
const _tagMinHeight = 48.0;
const _merchantRadius = 24.0;

/// Local review-form preview without a submitted or saved review.
class ReviewPage extends StatefulWidget {
  /// Shows the selected completed-order example.
  const new({required this.food, required this.quantity, super.key});

  /// Example product to describe.
  final DemoFood food;

  /// Example quantity.
  final int quantity;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int _rating = 0;
  Set<String> _tags = {};
  bool _showName = true;

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: PanganKitaColors.surfaceWarm,
    appBar: AppBar(
      leading: const BackButton(),
      title: const Text('Beri Ulasan'),
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          _ReviewProduct(food: widget.food, quantity: widget.quantity),
          const SizedBox(height: 20),
          Text(
            'Bagaimana makananmu?',
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(color: _ink),
          ),
          const SizedBox(height: 8),
          _RatingPicker(
            rating: _rating,
            onSelected: (rating) => setState(() => _rating = rating),
          ),
          const SizedBox(height: 12),
          _TagPicker(
            selected: _tags,
            onToggled: (label) => setState(() {
              _tags = _tags.contains(label)
                  ? _tags.difference(<String>{label})
                  : <String>{..._tags, label};
            }),
          ),
          const SizedBox(height: 18),
          Text(
            'Ceritakan pengalamanmu',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const TextField(
            maxLines: 3,
            maxLength: _maxReviewLength,
            decoration: InputDecoration(
              hintText: 'Bagaimana rasa makanan dan pengalaman pengambilanmu?',
            ),
          ),
          const SizedBox(height: 6),
          const _PhotoPicker(),
          CheckboxListTile(
            value: _showName,
            onChanged: (value) => setState(() => _showName = value ?? false),
            title: const Text('Tampilkan nama saya'),
            subtitle: const Text(
              'Pilihan ini hanya contoh dan tidak disimpan.',
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 8),
          FilledButton.icon(
            style: FilledButton.styleFrom(
              minimumSize: const Size.fromHeight(54),
            ),
            onPressed: () => DemoNotice.unavailable(context),
            icon: const Icon(Icons.send_outlined),
            label: const Text('Kirim Ulasan'),
          ),
        ],
      ),
    ),
  );
}

class _PhotoPicker extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Tambah foto (opsional)',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () => DemoNotice.unavailable(context),
        icon: const Icon(Icons.add_a_photo_outlined),
        label: const Text('Tambah foto'),
      ),
    ],
  );
}

class _RatingPicker extends StatelessWidget {
  const new({required this.rating, required this.onSelected});

  final int rating;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        children: [
          for (var star = 1; star <= _starCount; star++)
            Expanded(
              child: IconButton(
                tooltip: 'Beri rating $star bintang',
                onPressed: () => onSelected(star),
                icon: Icon(
                  star <= rating ? Icons.star : Icons.star_border,
                  color: PanganKitaColors.brandAccent,
                  size: _starSize,
                ),
              ),
            ),
        ],
      ),
      if (rating > 0)
        Chip(
          label: Text('$rating dari $_starCount bintang · contoh'),
          backgroundColor: const Color(0xFFFFF0DF),
        ),
    ],
  );
}

class _TagPicker extends StatelessWidget {
  const new({required this.selected, required this.onToggled});

  final Set<String> selected;
  final ValueChanged<String> onToggled;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Wrap(
      spacing: _tagGap,
      runSpacing: _tagRunGap,
      children: [
        for (final (:label, :icon) in [
          (label: 'Rasa enak', icon: Icons.restaurant_outlined),
          (label: 'Porsi pas', icon: Icons.inventory_2_outlined),
          (label: 'Kemasan rapi', icon: Icons.widgets_outlined),
          (label: 'Toko ramah', icon: Icons.sentiment_satisfied_outlined),
        ])
          SizedBox(
            width: (constraints.maxWidth - _tagGap) / _tagColumns,
            child: Semantics(
              selected: selected.contains(label),
              child: OutlinedButton.icon(
                key: ValueKey('review-tag-$label'),
                onPressed: () => onToggled(label),
                icon: Icon(icon, size: _tagIconSize),
                label: Text(label),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(_tagMinHeight),
                  alignment: Alignment.centerLeft,
                  foregroundColor: _green,
                  backgroundColor: selected.contains(label)
                      ? PanganKitaColors.positiveSurface
                      : Colors.white,
                  side: BorderSide(
                    color: selected.contains(label)
                        ? _green
                        : PanganKitaColors.borderNeutral,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(_tagRadius)),
                  ),
                ),
              ),
            ),
          ),
      ],
    ),
  );
}

class _ReviewProduct extends StatelessWidget {
  const new({required this.food, required this.quantity});

  final DemoFood food;
  final int quantity;

  @override
  Widget build(BuildContext context) => Card(
    color: Colors.white,
    margin: EdgeInsets.zero,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(_cardRadius)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: _merchantRadius,
                backgroundImage: AssetImage(food.image),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.merchant,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(food.pickupAddress),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(_photoRadius),
                ),
                child: SizedBox.square(
                  dimension: _photoSize,
                  child: Image.asset(food.image, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      food.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text('$quantity × ${food.price}'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
