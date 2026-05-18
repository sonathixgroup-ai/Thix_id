import 'dart:async';
import 'package:flutter/material.dart';

class ThixMarketPage extends StatefulWidget {
  const ThixMarketPage({super.key});

  @override
  State<ThixMarketPage> createState() => _ThixMarketPageState();
}

class _ThixMarketPageState extends State<ThixMarketPage> {
  late PageController _featuredController;
  int _featuredIndex = 0;
  Timer? _carouselTimer;
  final Duration _carouselInterval = const Duration(seconds: 4);

  // Articles vedettes (carrousel)
  final List<Map<String, String>> _featuredProducts = const [
    {'name': 'Écouteurs Pro X', 'price': '32.900 CDF', 'oldPrice': '47.000 CDF', 'image': '🎧', 'discount': '-30%'},
    {'name': 'Montre THIX 5', 'price': '75.000 CDF', 'oldPrice': '100.000 CDF', 'image': '⌚', 'discount': '-25%'},
    {'name': 'Sneakers Air Max', 'price': '56.000 CDF', 'oldPrice': '70.000 CDF', 'image': '👟', 'discount': '-20%'},
    {'name': 'Parfum Gold', 'price': '28.000 CDF', 'oldPrice': '33.000 CDF', 'image': '🧴', 'discount': '-15%'},
  ];

  // 12 produits recommandés (grille 2x6)
  final List<Map<String, String>> _products = const [
    {'name': 'Casque Studio', 'price': '45.000 CDF', 'oldPrice': '60.000 CDF', 'image': '🎧', 'rating': '4.7', 'discount': '-25%'},
    {'name': 'Montre Sport', 'price': '62.000 CDF', 'oldPrice': '80.000 CDF', 'image': '⌚', 'rating': '4.8', 'discount': '-22%'},
    {'name': 'Baskets Urban', 'price': '48.000 CDF', 'oldPrice': '65.000 CDF', 'image': '👟', 'rating': '4.6', 'discount': '-26%'},
    {'name': 'Parfum Oud', 'price': '38.000 CDF', 'oldPrice': '50.000 CDF', 'image': '🧴', 'rating': '4.9', 'discount': '-24%'},
    {'name': 'Sac à Dos', 'price': '42.000 CDF', 'oldPrice': '55.000 CDF', 'image': '🎒', 'rating': '4.8', 'discount': '-24%'},
    {'name': 'Lampe LED', 'price': '22.000 CDF', 'oldPrice': '29.000 CDF', 'image': '💡', 'rating': '4.5', 'discount': '-24%'},
    {'name': 'Montre Connectée', 'price': '85.000 CDF', 'oldPrice': '110.000 CDF', 'image': '⌚', 'rating': '4.9', 'discount': '-23%'},
    {'name': 'Écouteurs TWS', 'price': '35.000 CDF', 'oldPrice': '49.000 CDF', 'image': '🎧', 'rating': '4.7', 'discount': '-29%'},
    {'name': 'Sneakers Classic', 'price': '52.000 CDF', 'oldPrice': '68.000 CDF', 'image': '👟', 'rating': '4.6', 'discount': '-24%'},
    {'name': 'Parfum Bleu', 'price': '32.000 CDF', 'oldPrice': '42.000 CDF', 'image': '🧴', 'rating': '4.8', 'discount': '-24%'},
    {'name': 'Sac à Main', 'price': '58.000 CDF', 'oldPrice': '75.000 CDF', 'image': '👜', 'rating': '4.9', 'discount': '-23%'},
    {'name': 'Montre Luxe', 'price': '95.000 CDF', 'oldPrice': '130.000 CDF', 'image': '⌚', 'rating': '4.9', 'discount': '-27%'},
  ];

  // Compte à rebours (2h45min)
  int _countdownSeconds = 2 * 3600 + 45 * 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _featuredController = PageController(viewportFraction: 0.92);
    _carouselTimer = Timer.periodic(_carouselInterval, (_) {
      if (_featuredController.hasClients) {
        final next = (_featuredIndex + 1) % _featuredProducts.length;
        _featuredController.animateToPage(next, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
        setState(() => _featuredIndex = next);
      }
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        setState(() => _countdownSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _featuredController.dispose();
    _carouselTimer?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  String _formatCountdown(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ========== EN-TÊTE ==========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFF071739),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
                        ),
                        child: const Center(child: Text('🛍️', style: TextStyle(fontSize: 24))),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'THIX ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF071739))),
                                TextSpan(text: 'MARKET', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFFEAB308))),
                              ],
                            ),
                          ),
                          const Text('Achetez. Vendez. Évoluez.', style: TextStyle(fontSize: 9, color: Color(0xFF6B7280))),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _IconButton(icon: Icons.notifications_none_rounded, onTap: () {}, size: 36),
                      const SizedBox(width: 4),
                      _IconButton(icon: Icons.person_outline_rounded, onTap: () {}, isDark: true, size: 36),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ========== BANNIÈRE HÉRO ==========
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF04142D), Color(0xFF071739), Color(0xFF0A2D5E)]),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 6))],
                ),
                child: Stack(
                  children: [
                    Positioned(right: -10, bottom: -10, child: Text('🛒', style: TextStyle(fontSize: 90, color: Colors.white.withOpacity(0.08)))),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Bonjour Michel 👋', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFFDE047))),
                        const SizedBox(height: 4),
                        const Text('Votre marketplace\npremium & sécurisée', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1)),
                        const SizedBox(height: 6),
                        const Text('Des milliers de produits, vendeurs vérifiés.', style: TextStyle(fontSize: 10, color: Color(0xFFD1D5DB))),
                        const SizedBox(height: 14),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEAB308),
                            foregroundColor: const Color(0xFF071739),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Explorer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_rounded, size: 14),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ========== BARRE DE RECHERCHE ==========
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    const Icon(Icons.search_rounded, size: 18, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 6),
                    const Expanded(child: TextField(decoration: InputDecoration(hintText: 'Rechercher...', hintStyle: TextStyle(fontSize: 12), border: InputBorder.none))),
                    Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(color: const Color(0xFF071739), borderRadius: BorderRadius.circular(20)),
                      child: const Center(child: Text('Ok', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // ========== CATÉGORIES (3x2) ==========
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.9,
                children: const [
                  _CategoryCard(icon: '📱', label: 'Électronique'),
                  _CategoryCard(icon: '👕', label: 'Fashion'),
                  _CategoryCard(icon: '🏠', label: 'Maison'),
                  _CategoryCard(icon: '💄', label: 'Beauté'),
                  _CategoryCard(icon: '⚽', label: 'Sports'),
                  _CategoryCard(icon: '➕', label: 'Plus'),
                ],
              ),
              const SizedBox(height: 16),

              // ========== OFFRES FLASH AVEC COUNTDOWN ==========
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF071739), Color(0xFF0B3B7A)]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('⚡ OFFRES FLASH', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEAB308))),
                        const SizedBox(height: 4),
                        Text('Se termine dans', style: TextStyle(fontSize: 9, color: Colors.white70)),
                        Text(_formatCountdown(_countdownSeconds), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(color: const Color(0xFFEAB308), borderRadius: BorderRadius.circular(16)),
                      child: const Text('Jusqu’à -50%', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF071739))),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ========== CARROUSEL ARTICLES VEDETTES ==========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.star_rounded, color: Color(0xFFEAB308), size: 16),
                      SizedBox(width: 4),
                      Text('À la une', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF071739))),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text('Voir tout', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SizedBox(
                height: 150,
                child: PageView.builder(
                  controller: _featuredController,
                  itemCount: _featuredProducts.length,
                  onPageChanged: (i) => setState(() => _featuredIndex = i),
                  itemBuilder: (context, i) {
                    final p = _featuredProducts[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: _CompactFeaturedCard(
                        name: p['name']!,
                        price: p['price']!,
                        oldPrice: p['oldPrice']!,
                        image: p['image']!,
                        discount: p['discount']!,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ========== GRILLE PRODUITS (2x6 = 12 articles) ==========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.flash_on_rounded, color: Color(0xFFEAB308), size: 16),
                      SizedBox(width: 4),
                      Text('Recommandés', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF071739))),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text('Voir tout', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF2563EB))),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.65,
                children: _products.map((p) => _MiniProductCard(
                  name: p['name']!,
                  price: p['price']!,
                  oldPrice: p['oldPrice']!,
                  image: p['image']!,
                  rating: p['rating']!,
                  discount: p['discount']!,
                )).toList(),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, -2))]),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_filled, label: 'Accueil', active: true, onTap: () {}),
              _NavItem(icon: Icons.category_rounded, label: 'Catégories', onTap: () {}),
              Container(width: 48, height: 48, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEAB308), boxShadow: [BoxShadow(color: Color(0xFFEAB308), blurRadius: 8)]), child: const Icon(Icons.shopping_bag_rounded, color: Color(0xFF071739), size: 24)),
              _NavItem(icon: Icons.inventory_rounded, label: 'Commandes', onTap: () {}),
              _NavItem(icon: Icons.person_rounded, label: 'Profil', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== COMPOSANTS COMPACTS ==========
class _IconButton extends StatelessWidget {
  final IconData icon; final VoidCallback onTap; final bool isDark; final double size;
  const _IconButton({required this.icon, required this.onTap, this.isDark = false, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size, height: size,
        decoration: BoxDecoration(color: isDark ? const Color(0xFF071739) : Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]),
        child: Icon(icon, color: isDark ? Colors.white : const Color(0xFF1F2937), size: 18),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String icon, label;
  const _CategoryCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6)]),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
      ]),
    );
  }
}

class _CompactFeaturedCard extends StatelessWidget {
  final String name, price, oldPrice, image, discount;
  const _CompactFeaturedCard({required this.name, required this.price, required this.oldPrice, required this.image, required this.discount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
      child: Row(
        children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(image, style: const TextStyle(fontSize: 32)))),
          const SizedBox(width: 8),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 2),
              Row(children: [
                Text(price, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF071739))),
                const SizedBox(width: 6),
                Text(oldPrice, style: const TextStyle(fontSize: 9, decoration: TextDecoration.lineThrough, color: Color(0xFF9CA3AF))),
              ]),
              Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: const Color(0xFFEAB308), borderRadius: BorderRadius.circular(8)), child: Text(discount, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold))),
            ]),
          ),
        ],
      ),
    );
  }
}

class _MiniProductCard extends StatelessWidget {
  final String name, price, oldPrice, image, rating, discount;
  const _MiniProductCard({required this.name, required this.price, required this.oldPrice, required this.image, required this.rating, required this.discount});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => null,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)]),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(height: 80, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12)), child: Center(child: Text(image, style: const TextStyle(fontSize: 36)))),
                Positioned(top: 4, left: 4, child: Container(padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1), decoration: BoxDecoration(color: const Color(0xFFEAB308), borderRadius: BorderRadius.circular(8)), child: Text(discount, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)))),
                Positioned(top: 4, right: 4, child: const Icon(Icons.favorite_border_rounded, size: 14, color: Color(0xFF9CA3AF))),
              ],
            ),
            const SizedBox(height: 6),
            Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Row(children: [const Icon(Icons.star_rounded, size: 10, color: Color(0xFFEAB308)), const SizedBox(width: 2), Text(rating, style: const TextStyle(fontSize: 9))]),
            const SizedBox(height: 2),
            Text(price, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF071739))),
            Text(oldPrice, style: const TextStyle(fontSize: 8, decoration: TextDecoration.lineThrough, color: Color(0xFF9CA3AF))),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF071739), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 4), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Ajouter', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon; final String label; final bool active; final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 20, color: active ? const Color(0xFFEAB308) : const Color(0xFF9CA3AF)),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: active ? const Color(0xFFEAB308) : const Color(0xFF9CA3AF))),
      ]),
    );
  }
}
