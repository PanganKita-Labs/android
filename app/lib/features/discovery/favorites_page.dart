import 'package:flutter/material.dart';
import 'package:pangankita/app/app_routes.dart';
import 'package:pangankita/app/pangan_kita_theme.dart';
import 'package:pangankita/features/discovery/demo_food.dart';

const _ink = Color(0xFF10283C);
const Color _green = PanganKitaColors.brandPrimaryStrong;
const Color _orange = PanganKitaColors.brandAccent;
const _foodIds = ['buns', 'garlic-bread', 'roti'];
const _cornerRadius = 12.0;
const _cardRadius = 16.0;
const _tabIconSize = 19.0;
const _foodImageWidth = 112.0;
const _foodImageHeight = 128.0;
const _merchantAvatarRadius = 11.0;
const _storeImageRadius = 10.0;
const _storeImageSize = 64.0;

/// Display-only favorites based on the supplied account design.
class FavoritesPage extends StatefulWidget {
  /// Creates local example favorites without account storage.
  const new({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final Set<String> _visibleFoodIds = _foodIds.toSet();
  bool _showStores = false;
  bool _showExampleStore = true;

  @override
  Widget build(BuildContext context) {
    final foods = [
      DemoFood.examples.first,
      DemoFood.garlicBread,
      DemoFood.examples[2],
    ].where((food) => _visibleFoodIds.contains(food.id));
    return Scaffold(
      backgroundColor: PanganKitaColors.surfaceWarm,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton.filledTonal(
                tooltip: 'Kembali ke Profil Saya',
                style: IconButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(_cornerRadius),
                    ),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: _ink),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Favorit Saya',
              style: Theme.of(context).textTheme.headlineLarge
                  ?.copyWith(color: _ink),
            ),
            const SizedBox(height: 4),
            Text(
              'Simpan yang kamu suka, temukan lagi kapan saja.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _TabButton(
                    label: 'Makanan',
                    icon: Icons.restaurant,
                    selected: !_showStores,
                    onPressed: () => setState(() => _showStores = false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _TabButton(
                    label: 'Toko',
                    icon: Icons.storefront_outlined,
                    selected: _showStores,
                    onPressed: () => setState(() => _showStores = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_showStores)
              if (_showExampleStore)
                _StoreCard(
                  onRemove: () => setState(() => _showExampleStore = false),
                )
              else
                const _EmptyFavorites(label: 'Tidak ada toko favorit contoh.')
            else if (foods.isEmpty)
              const _EmptyFavorites(label: 'Tidak ada makanan favorit contoh.')
            else
              for (final food in foods) ...[
                _FoodCard(
                  food: food,
                  onRemove: () =>
                      setState(() => _visibleFoodIds.remove(food.id)),
                ),
                const SizedBox(height: 12),
              ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: const BoxDecoration(
                color: PanganKitaColors.savingsSurface,
                borderRadius: BorderRadius.all(Radius.circular(14)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: _green),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Favorit contoh. Harga dan ketersediaan belum terhubung.',
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
}

class _TabButton extends StatelessWidget {
  const new({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    onPressed: onPressed,
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(48),
      backgroundColor: selected ? _green : Colors.white,
      foregroundColor: selected ? Colors.white : _ink,
      side: BorderSide(color: selected ? _green : const Color(0xFFE1E4E7)),
    ),
    icon: Icon(icon, size: _tabIconSize),
    label: Text(label),
  );
}

class _FoodCard extends StatelessWidget {
  const new({required this.food, required this.onRemove});

  final DemoFood food;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: Colors.white,
    child: InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(_cardRadius)),
      onTap: () =>
          Navigator.pushNamed(context, AppRoutes.product(food.id)).ignore(),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(
                Radius.circular(_cornerRadius),
              ),
              child: Image.asset(
                food.image,
                width: _foodImageWidth,
                height: _foodImageHeight,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          food.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(color: _ink),
                        ),
                      ),
                      IconButton.filledTonal(
                        tooltip: 'Hapus ${food.title} dari favorit contoh',
                        onPressed: onRemove,
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFFE1E4E7)),
                        ),
                        icon: const Icon(Icons.favorite, color: _orange),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: _merchantAvatarRadius,
                        backgroundImage: food.merchant.startsWith('Mawar')
                            ? const AssetImage(
                                'assets/prototype/mawar-mark.webp',
                              )
                            : null,
                        child: food.merchant.startsWith('Mawar')
                            ? null
                            : const Text('R'),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          food.merchant,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: _orange),
                      const SizedBox(width: 3),
                      Text(
                        '${food.rating.split(' ').first} · contoh',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    food.price,
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(color: _green),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _StoreCard extends StatelessWidget {
  const new({required this.onRemove});

  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) => Card(
    margin: EdgeInsets.zero,
    color: Colors.white,
    child: ListTile(
      contentPadding: const EdgeInsets.all(10),
      leading: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(_storeImageRadius),
        ),
        child: SizedBox.square(
          dimension: _storeImageSize,
          child: Image.asset(
            'assets/prototype/store-croissants.webp',
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(
        'Mawar Bakery & Cake',
        style: Theme.of(context).textTheme.titleSmall,
      ),
      subtitle: const Text('Toko favorit contoh'),
      trailing: IconButton(
        tooltip: 'Hapus Mawar Bakery & Cake dari favorit contoh',
        onPressed: onRemove,
        icon: const Icon(Icons.favorite, color: _orange),
      ),
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.store(DemoFood.examples.first.id),
      ).ignore(),
    ),
  );
}

class _EmptyFavorites extends StatelessWidget {
  const new({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 56),
    child: Center(
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    ),
  );
}
