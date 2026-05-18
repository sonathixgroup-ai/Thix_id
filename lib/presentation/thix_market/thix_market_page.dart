import 'package:flutter/material.dart';

class ThixMarketPage extends StatelessWidget {
  const ThixMarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xFF071739),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text('🛍️', style: TextStyle(fontSize: 28)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: 'THIX ',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF071739),
                                  ),
                                ),
                                TextSpan(
                                  text: 'MARKET',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFEAB308),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Text(
                            'Achetez. Vendez. Évoluez.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _IconButton(
                        icon: Icons.notifications_none_rounded,
                        onTap: () {},
                      ),
                      const SizedBox(width: 8),
                      _IconButton(
                        icon: Icons.person_outline_rounded,
                        onTap: () {},
                        isDark: true,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ========== BANNIÈRE HÉRO ==========
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF04142D), Color(0xFF071739), Color(0xFF0A2D5E)],
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      bottom: -20,
                      child: Text('🛒', style: TextStyle(fontSize: 130, color: Colors.white.withOpacity(0.08))),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bonjour Michel 👋',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFDE047),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Votre marketplace\npremium & sécurisée',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Des milliers de produits, des vendeurs vérifiés,\nune expérience unique.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFD1D5DB),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEAB308),
                            foregroundColor: const Color(0xFF071739),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Explorer le marché', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, size: 16),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ========== BARRE DE RECHERCHE ==========
              Container(
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const Icon(Icons.search_rounded, size: 20, color: Color(0xFF9CA3AF)),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Rechercher un produit, une marque...',
                          hintStyle: TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(4),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF071739),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Center(
                        child: Text('Rechercher', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ========== CATÉGORIES (grille 3x2) ==========
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: const [
                  _CategoryCard(icon: '📱', label: 'Électronique'),
                  _CategoryCard(icon: '👕', label: 'Fashion'),
                  _CategoryCard(icon: '🏠', label: 'Maison'),
                  _CategoryCard(icon: '💄', label: 'Beauté'),
                  _CategoryCard(icon: '⚽', label: 'Sports'),
                  _CategoryCard(icon: '➕', label: 'Plus'),
                ],
              ),
              const SizedBox(height: 20),

              // ========== CARTES PROMO (2 côte à côte) ==========
              Row(
                children: [
                  Expanded(
                    child: _PromoCard(
                      title: 'OFFRES EXCLUSIVES',
                      subtitle: 'Jusqu’à -50%',
                      buttonText: 'Découvrir',
                      gradient: const [Color(0xFF071739), Color(0xFF0B3B7A)],
                      textColor: Colors.white,
                      buttonBg: const Color(0xFFEAB308),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _PromoCard(
                      title: 'DEVENEZ VENDEUR',
                      subtitle: 'Vendez avec THIX',
                      buttonText: 'Commencer',
                      gradient: const [Color(0xFFFEF3C7), Color(0xFFFDE68A)],
                      textColor: Color(0xFF071739),
                      buttonBg: const Color(0xFF071739),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ========== SECTION OFFRES FLASH ==========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.flash_on_rounded, color: Color(0xFFEAB308), size: 20),
                      SizedBox(width: 4),
                      Text('⚡ Offres Flash', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF071739))),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Voir tout', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, fontSize: 12)),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ========== GRILLE PRODUITS (2x2) ==========
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: 0.7,
                children: const [
                  _ProductCard(
                    name: 'Écouteurs Premium Pro',
                    price: '32.900 FCFA',
                    oldPrice: '47.000 FCFA',
                    image: '🎧',
                    rating: 4.8,
                    discount: '-30%',
                  ),
                  _ProductCard(
                    name: 'Montre Connectée THIX',
                    price: '75.000 FCFA',
                    oldPrice: '100.000 FCFA',
                    image: '⌚',
                    rating: 4.9,
                    discount: '-25%',
                  ),
                  _ProductCard(
                    name: 'Sneakers Air Max',
                    price: '56.000 FCFA',
                    oldPrice: '70.000 FCFA',
                    image: '👟',
                    rating: 4.7,
                    discount: '-20%',
                  ),
                  _ProductCard(
                    name: 'Parfum Élégance',
                    price: '28.000 FCFA',
                    oldPrice: '33.000 FCFA',
                    image: '🧴',
                    rating: 4.6,
                    discount: '-15%',
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ========== VENDEURS VEDETTES ==========
              const Text(
                'Vendeurs vedettes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF071739)),
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.2,
                children: const [
                  _SellerCard(name: 'TechStore Pro', verified: true, rating: 4.9),
                  _SellerCard(name: 'Fashion House', verified: true, rating: 4.8),
                  _SellerCard(name: 'Maison Chic', verified: true, rating: 4.9),
                  _SellerCard(name: 'Beauty Expert', verified: true, rating: 4.8),
                ],
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_filled, label: 'Accueil', active: true, onTap: () {}),
              _NavItem(icon: Icons.category_rounded, label: 'Catégories', onTap: () {}),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFEAB308),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEAB308).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.shopping_bag_rounded, color: Color(0xFF071739), size: 28),
              ),
              _NavItem(icon: Icons.inventory_rounded, label: 'Commandes', onTap: () {}),
              _NavItem(icon: Icons.person_rounded, label: 'Profil', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== COMPOSANTS ==========
class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isDark;
  const _IconButton({required this.icon, required this.onTap, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF071739) : Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, color: isDark ? Colors.white : const Color(0xFF1F2937), size: 20),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String icon;
  final String label;
  const _CategoryCard({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(icon, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF374151))),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final String title, subtitle, buttonText;
  final List<Color> gradient;
  final Color textColor, buttonBg;
  const _PromoCard({
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.gradient,
    required this.textColor,
    required this.buttonBg,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor.withOpacity(0.8))),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor)),
          const SizedBox(height: 12),
          SizedBox(
            height: 32,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: buttonBg,
                foregroundColor: gradient[0] == const Color(0xFF071739) ? Colors.white : const Color(0xFF071739),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: Text(buttonText, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String name, price, oldPrice, image, discount;
  final double rating;
  const _ProductCard({
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.image,
    required this.rating,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: Text(image, style: const TextStyle(fontSize: 48))),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAB308),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(discount, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF071739))),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {},
                  child: const Icon(Icons.favorite_border_rounded, size: 18, color: Color(0xFF9CA3AF)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)), maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 14, color: Color(0xFFEAB308)),
              const SizedBox(width: 2),
              Text(rating.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF071739))),
                  Text(oldPrice, style: const TextStyle(fontSize: 10, decoration: TextDecoration.lineThrough, color: Color(0xFF9CA3AF))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF071739),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Ajouter au panier', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SellerCard extends StatelessWidget {
  final String name;
  final bool verified;
  final double rating;
  const _SellerCard({required this.name, required this.verified, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundColor: Color(0xFFE5E7EB),
            radius: 20,
            child: Icon(Icons.store_rounded, color: Color(0xFF6B7280), size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
                    if (verified) ...[
                      const SizedBox(width: 4),
                      const Icon(Icons.verified_rounded, size: 14, color: Color(0xFF3B82F6)),
                    ],
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, size: 12, color: Color(0xFFEAB308)),
                    const SizedBox(width: 2),
                    Text(rating.toString(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    const Text(' (avt)', style: TextStyle(fontSize: 10, color: Color(0xFF9CA3AF))),
                  ],
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF9CA3AF)),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 22, color: active ? const Color(0xFFEAB308) : const Color(0xFF9CA3AF)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: active ? const Color(0xFFEAB308) : const Color(0xFF9CA3AF))),
        ],
      ),
    );
  }
}
