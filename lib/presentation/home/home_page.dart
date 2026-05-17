import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:thix_id/auth/auth_controller.dart';
import 'package:thix_id/models/app_user.dart';
import 'package:thix_id/nav.dart';

import 'package:thix_id/presentation/common/full_screen_message.dart';
import 'package:thix_id/presentation/common/alert_info_sheet.dart';
import 'package:thix_id/presentation/common/notifications_sheet.dart';
import 'package:thix_id/presentation/common/thix_identity_sheets.dart';

import 'package:thix_id/services/firestore_user_service.dart';
import 'package:thix_id/services/notification_service.dart';
import 'package:thix_id/services/notification_counters_service.dart';
import 'package:thix_id/services/thix_id_service.dart';

import 'package:thix_id/l10n/app_localizations.dart';
import 'package:thix_id/l10n/locale_controller.dart';

/// Palette Ultra-Premium Institutionnelle - THIX ID 2026
class ThixPremiumColors {
  // Deep Institutional Blues
  static const Color primaryDark = Color(0xFF0A1128);       // Bleu Nuit Profond
  static const Color primaryElectric = Color(0xFF1C2541);   // Bleu Saphir Sombre
  static const Color accentBlue = Color(0xFF001F54);        // Bleu Byzantin

  // Premium Metallic Golds
  static const Color goldPrimary = Color(0xFFD4AF37);       // Or Classique
  static const Color goldLight = Color(0xFFF3E5AB);         // Éclat d'Or Douce
  static const Color goldDark = Color(0xFFAA7C11);          // Or Sombre Réaliste
  
  // Neutrals & Surfaces (Glassmorphic Base)
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF4F6F9);   // Fond Institutionnel épuré
  static const Color grayDark = Color(0xFF111827);          // Texte Principal
  static const Color grayMedium = Color(0xFF4B5563);        // Texte Secondaire
  static const Color grayLight = Color(0xFFE5E7EB);         // Bordures subtiles
}

enum _AccountRequestChoice { personal, enterprise }

class HomePagePremium extends StatefulWidget {
  const HomePagePremium({super.key});

  @override
  State<HomePagePremium> createState() => _HomePagePremiumState();
}

class _HomePagePremiumState extends State<HomePagePremium>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _searching = false;
  late AnimationController _animationController;

  final _notifications = NotificationService();
  final _counters = NotificationCountersService();

  static final RegExp _uidLikeRegex = RegExp(r'^[A-Za-z0-9_-]{20,}$');

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleHomeSearchVerify() async {
    final raw = _searchController.text.trim();

    if (raw.isEmpty) {
      await FullScreenMessage.showError(
        context,
        title: 'Identifiant requis',
        message: "Saisissez un THIX ID puis appuyez sur Vérifier.",
      );
      return;
    }

    final normalized = ThixIdService.normalize(raw);
    final isThix = normalized.startsWith('THIX-') &&
        ThixIdService.isValid(normalized);
    final isUid = _uidLikeRegex.hasMatch(raw);

    if (!isThix && !isUid) {
      await FullScreenMessage.showError(
        context,
        title: 'Identifiant invalide',
        message: 'Format THIX ID incorrect.',
      );
      return;
    }

    setState(() => _searching = true);

    try {
      final userService = FirestoreUserService();
      AppUser? user;

      if (isThix) {
        user = await userService.fetchUserByThixId(normalized);
      } else {
        user = await userService.fetchUserByUid(raw);
      }

      if (!mounted) return;

      if (user == null) {
        await FullScreenMessage.showError(
          context,
          title: 'Profil introuvable',
          message: "Aucun profil trouvé.",
        );
        return;
      }

      final thix = user.thixId.trim().toUpperCase();

      if (thix.isNotEmpty && ThixIdService.isValid(thix)) {
        context.push('${AppRoutes.publicProfile}?thixId=$thix');
      } else {
        await ThixIdentitySheets.showVerifySheet(
          context,
          initialUidOrThixId: user.id,
        );
      }
    } catch (e) {
      if (!mounted) return;
      await FullScreenMessage.showError(
        context,
        title: 'Erreur',
        message: "Impossible d'effectuer la vérification.",
      );
    } finally {
      if (mounted) {
        setState(() => _searching = false);
      }
    }
  }

  void _onProfileTap() {
    final auth = context.read<AuthController>();
    if (auth.isAuthenticated) {
      final t = auth.currentUser?.accountType;
      context.go(
        t == AccountType.enterprise
            ? AppRoutes.enterpriseDashboard
            : AppRoutes.userDashboard,
      );
    } else {
      context.push(AppRoutes.login);
    }
  }

  Future<void> _handleRequestAccount(BuildContext context) async {
    final auth = context.read<AuthController>();
    final res = await showModalBottomSheet<_AccountRequestChoice>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const AccountRequestSheet(),
    );

    switch (res) {
      case _AccountRequestChoice.personal:
        if (auth.isAuthenticated) {
          await auth.signOut();
        }
        if (context.mounted) {
          context.push(AppRoutes.personalReg);
        }
        return;

      case _AccountRequestChoice.enterprise:
        if (auth.isAuthenticated) {
          await auth.signOut();
        }
        if (context.mounted) {
          context.push(AppRoutes.enterpriseReg);
        }
        return;

      case null:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final safeTop = MediaQuery.paddingOf(context).top;
    final badgeCountsStream = auth.currentUser == null
        ? Stream.value(SectionBadgeCounts.zero)
        : _counters.streamCounts(auth.currentUser!.id);

    return Scaffold(
      backgroundColor: ThixPremiumColors.backgroundLight,
      extendBody: true,
      body: Column(
        children: [
          /// 1. Header Premium Condensé et Ajusté
          _PremiumHeader(
            safeTop: safeTop,
            onProfileTap: _onProfileTap,
            searchController: _searchController,
            isSearching: _searching,
            onVerify: _handleHomeSearchVerify,
          ),

          /// Conteneur Principal Fixe - Aucune possibilité de scroll
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  /// 2. Boutons Horizontaux Fins de Couleur Or
                  Row(
                    children: [
                      Expanded(
                        child: _GoldCompactButton(
                          title: 'Scanner QR',
                          icon: Icons.qr_code_scanner_rounded,
                          onTap: () {
                            ThixIdentitySheets.showQrScanSheet(context);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _GoldCompactButton(
                          title: 'Lire via NFC',
                          icon: Icons.fingerprint_rounded,
                          onTap: () {
                            ThixIdentitySheets.showNfcScanSheet(context);
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// 3. Aperçu Notification - Affiné
                  _NotificationPreviewCard(
                    onTap: () {
                      if (!auth.isAuthenticated) {
                        context.push(AppRoutes.login);
                        return;
                      }
                      NotificationsSheet.show(context);
                    },
                  ),

                  const SizedBox(height: 12),

                  /// 4. Titre de la Section "Nos services"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nos services',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: ThixPremiumColors.primaryDark,
                          letterSpacing: -0.3,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Tout voir ›',
                          style: TextStyle(
                            color: ThixPremiumColors.goldDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// 5. Grille de Services en Deux Bandes Horizontales Fines
                  Expanded(
                    child: StreamBuilder<SectionBadgeCounts>(
                      stream: badgeCountsStream,
                      builder: (context, snap) {
                        final counts = snap.data ?? SectionBadgeCounts.zero;

                        return GridView.count(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(), // Bloque le scroll
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 3.4, // Écrase totalement la hauteur pour créer des bandes horizontales fines
                          children: [
                            _ServiceStripCard(
                              icon: Icons.person_add_alt_1,
                              title: 'Demander un Compte',
                              iconColor: ThixPremiumColors.primaryDark,
                              onTap: () => _handleRequestAccount(context),
                            ),
                            _ServiceStripCard(
                              icon: Icons.account_circle,
                              title: 'Mon Compte',
                              iconColor: ThixPremiumColors.goldDark,
                              onTap: _onProfileTap,
                            ),
                            _ServiceStripCard(
                              icon: Icons.school,
                              title: 'Formations',
                              iconColor: ThixPremiumColors.primaryDark,
                              badgeCount: counts.formations,
                              onTap: () => context.push(AppRoutes.trainingHome),
                            ),
                            _ServiceStripCard(
                              icon: Icons.work,
                              title: 'Emplois',
                              iconColor: ThixPremiumColors.primaryDark,
                              badgeCount: counts.jobs,
                              onTap: () => context.push(AppRoutes.jobs),
                            ),
                            _ServiceStripCard(
                              icon: Icons.newspaper,
                              title: 'THIX INFO',
                              iconColor: ThixPremiumColors.goldDark,
                              badgeCount: counts.info,
                              onTap: () => AlertInfoSheet.show(context),
                            ),
                            _ServiceStripCard(
                              icon: Icons.lightbulb_rounded,
                              title: 'Opportunités',
                              iconColor: ThixPremiumColors.primaryDark,
                              badgeCount: counts.events,
                              onTap: () => context.push(AppRoutes.opportunities),
                            ),
                            _ServiceStripCard(
                              icon: Icons.event,
                              title: 'Événements',
                              iconColor: ThixPremiumColors.primaryDark,
                              badgeCount: counts.events,
                              onTap: () => context.push(AppRoutes.events),
                            ),
                            _ServiceStripCard(
                              icon: Icons.groups,
                              title: 'Réseau Pro',
                              iconColor: ThixPremiumColors.goldDark,
                              onTap: () => context.push(AppRoutes.network),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  
                  // Zone tampon pour le Floating Bottom Nav
                  const SizedBox(height: 85),
                ],
              ),
            ),
          ),
        ],
      ),

      /// Loading Overlay global
      if (_searching)
        Positioned.fill(
          child: Container(
            color: ThixPremiumColors.primaryDark.withOpacity(0.4),
            child: const Center(
              child: CircularProgressIndicator(
                color: ThixPremiumColors.goldPrimary,
              ),
            ),
          ),
        ),

      /// Floating Bottom Navigation
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: _FloatingBottomNav(
          onScanTap: () {
            ThixIdentitySheets.showQrScanSheet(context);
          },
        ),
      ),
    );
  }
}

/// Header Premium Intégrant la barre de recherche en son sein
class _PremiumHeader extends StatelessWidget {
  final double safeTop;
  final VoidCallback onProfileTap;
  final TextEditingController searchController;
  final bool isSearching;
  final VoidCallback onVerify;

  const _PremiumHeader({
    required this.safeTop,
    required this.onProfileTap,
    required this.searchController,
    required this.isSearching,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, safeTop + 10, 16, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ThixPremiumColors.primaryDark, ThixPremiumColors.primaryElectric],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Profile
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: ThixPremiumColors.goldPrimary, width: 1),
                    ),
                    child: const Icon(Icons.fingerprint_rounded, color: ThixPremiumColors.goldPrimary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'THIX ID',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.black, fontSize: 15),
                      ),
                      Text(
                        'Identité Sécurisée. Avenir de Confiance.',
                        style: TextStyle(color: Colors.white70, fontSize: 9),
                      ),
                    ],
                  ),
                ],
              ),
              GestureDetector(
                onTap: onProfileTap,
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: ThixPremiumColors.goldPrimary.withOpacity(0.5), width: 1),
                  ),
                  child: const Icon(Icons.person_outline_rounded, color: ThixPremiumColors.goldPrimary, size: 18),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Bienvenue !',
            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: -0.5),
          ),
          const Text(
            'Que voulez-vous faire aujourd\'hui ?',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 12),
          
          // Barre de recherche optimisée pour ne jamais déborder
          Container(
            height: 42,
            decoration: BorderRadius.circular(21),
            color: Colors.white,
            padding: const EdgeInsets.only(left: 10, right: 3),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: ThixPremiumColors.grayMedium, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    enabled: !isSearching,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Rechercher un THIX ID…',
                      hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13),
                      isDense: true,
                    ),
                    style: const TextStyle(color: ThixPremiumColors.primaryDark, fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  onTap: isSearching ? null : onVerify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThixPremiumColors.goldPrimary,
                    foregroundColor: ThixPremiumColors.primaryDark,
                    elevation: 0,
                    height: 36,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                  ),
                  child: const Row(
                    children: [
                      Text('Vérifier', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Bouton d'action horizontal Or Aminci (QR / NFC)
class _GoldCompactButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _GoldCompactButton({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        height: 38, // Minceur maximale d'après la maquette
        decoration: BoxDecoration(
          color: ThixPremiumColors.goldPrimary,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: ThixPremiumColors.primaryDark, size: 16),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: ThixPremiumColors.primaryDark),
            ),
          ],
        ),
      ),
    );
  }
}

/// Notification Card - Fine et condensée
class _NotificationPreviewCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NotificationPreviewCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: ThixPremiumColors.grayLight, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThixPremiumColors.primaryDark.withOpacity(0.06),
              ),
              child: const Icon(Icons.notifications_none_rounded, color: ThixPremiumColors.primaryDark, size: 16),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: ThixPremiumColors.primaryDark),
                  ),
                  Text(
                    'Vous avez de nouvelles mises à jour',
                    style: TextStyle(fontSize: 10, color: ThixPremiumColors.grayMedium),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const Text('Voir tout', style: TextStyle(color: ThixPremiumColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 10)),
            const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: ThixPremiumColors.goldDark),
          ],
        ),
      ),
    );
  }
}

/// Bande de Service Horizontale Fine (Remplace l'ancienne grosse carte carrée)
class _ServiceStripCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final int? badgeCount;
  final VoidCallback onTap;

  const _ServiceStripCard({
    required this.icon,
    required this.title,
    required this.iconColor,
    this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ThixPremiumColors.grayLight, width: 0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: ThixPremiumColors.primaryDark.withOpacity(0.04),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, color: iconColor, size: 15),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: ThixPremiumColors.primaryDark),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (badgeCount != null && badgeCount! > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                decoration: BoxDecoration(
                  color: ThixPremiumColors.goldPrimary,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '$badgeCount',
                  style: const TextStyle(color: ThixPremiumColors.primaryDark, fontSize: 8, fontWeight: FontWeight.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Floating Bottom Navigation - Glassmorphic minimaliste
class _FloatingBottomNav extends StatelessWidget {
  final VoidCallback onScanTap;
  const _FloatingBottomNav({required this.onScanTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 68,
          decoration: BoxDecoration(
            color: ThixPremiumColors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_filled, label: 'Accueil', active: true, onTap: () {}),
              _NavItem(icon: Icons.grid_view_rounded, label: 'Services', onTap: () {}),
              GestureDetector(
                onTap: onScanTap,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [ThixPremiumColors.primaryDark, ThixPremiumColors.accentBlue]),
                  ),
                  child: const Icon(Icons.qr_code_scanner_rounded, color: ThixPremiumColors.goldPrimary, size: 20),
                ),
              ),
              _NavItem(icon: Icons.chat_bubble_outline_rounded, label: 'Messages', onTap: () {}),
              _NavItem(icon: Icons.person_outline_rounded, label: 'Profil', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({required this.icon, required this.label, this.active = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? ThixPremiumColors.primaryDark : ThixPremiumColors.grayMedium, size: 18),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(fontSize: 9, fontWeight: active ? FontWeight.bold : FontWeight.w500, color: active ? ThixPremiumColors.primaryDark : ThixPremiumColors.grayMedium),
          ),
        ],
      ),
    );
  }
}

/// Account Request Bottom Sheet
class AccountRequestSheet extends StatelessWidget {
  const AccountRequestSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ThixPremiumColors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 35, height: 4, decoration: BoxDecoration(color: ThixPremiumColors.grayLight, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            const Text('Créer un compte', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: ThixPremiumColors.primaryDark)),
            const SizedBox(height: 16),
            _OptionButton(
              icon: Icons.person_outline,
              title: 'Compte Personnel',
              subtitle: 'Pour un profil individuel',
              onTap: () => Navigator.pop(context, _AccountRequestChoice.personal),
            ),
            const SizedBox(height: 12),
            _OptionButton(
              icon: Icons.business_outlined,
              title: 'Compte Entreprise',
              subtitle: 'Pour une organisation',
              onTap: () => Navigator.pop(context, _AccountRequestChoice.enterprise),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionButton({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: ThixPremiumColors.grayLight),
          borderRadius: BorderRadius.circular(12),
          color: ThixPremiumColors.backgroundLight.withOpacity(0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: ThixPremiumColors.primaryDark.withOpacity(0.06), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: ThixPremiumColors.primaryDark, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: ThixPremiumColors.primaryDark)),
                  Text(subtitle, style: const TextStyle(fontSize: 11, color: ThixPremiumColors.grayMedium)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: ThixPremiumColors.goldDark),
          ],
        ),
      ),
    );
  }
}
