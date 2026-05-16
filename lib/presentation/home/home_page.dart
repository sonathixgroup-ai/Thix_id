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
  double _scrollOffset = 0;

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
      body: Stack(
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification notification) {
              if (notification is ScrollUpdateNotification) {
                setState(() {
                  _scrollOffset = notification.metrics.pixels;
                });
              }
              return false;
            },
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                /// Premium Header Section (Deep Luxury Blue Background)
                SliverToBoxAdapter(
                  child: _PremiumHeader(
                    safeTop: safeTop,
                    onProfileTap: _onProfileTap,
                  ),
                ),

                /// Spacer adjusted for floating look
                const SliverToBoxAdapter(
                  child: SizedBox(height: 54),
                ),

                /// Quick Action Cards (QR & NFC) - Upgraded with premium design
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: _QuickActionCard(
                            title: 'Scanner un QR',
                            subtitle: 'Scannez un code\nen toute sécurité',
                            icon: Icons.qr_code_scanner_rounded,
                            backgroundColor: Colors.white,
                            iconColor: ThixPremiumColors.goldPrimary,
                            onTap: () {
                              ThixIdentitySheets.showQrScanSheet(context);
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _QuickActionCard(
                            title: 'Lire via NFC',
                            subtitle: 'Approchez votre\nappareil',
                            icon: Icons.fingerprint_rounded,
                            backgroundColor: Colors.white,
                            iconColor: ThixPremiumColors.primaryDark,
                            onTap: () {
                              ThixIdentitySheets.showNfcScanSheet(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 24)),

                /// Notification Preview Card - Clean Institutional Polish
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _NotificationPreviewCard(
                      onTap: () {
                        if (!auth.isAuthenticated) {
                          context.push(AppRoutes.login);
                          return;
                        }
                        NotificationsSheet.show(context);
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                /// Services Section Header
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nos services',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: ThixPremiumColors.primaryDark,
                            letterSpacing: -0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Tout voir',
                            style: TextStyle(
                              color: ThixPremiumColors.goldDark,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 20)),

                /// Services Grid (2x4) - Golden accents on crisp high-end layouts
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: StreamBuilder<SectionBadgeCounts>(
                      stream: badgeCountsStream,
                      builder: (context, snap) {
                        final counts = snap.data ?? SectionBadgeCounts.zero;

                        return GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.9,
                          children: [
                            _ServiceCard(
                              icon: Icons.person_add_alt_1,
                              title: 'Demander un\nCompte',
                              iconBackgroundColor: ThixPremiumColors.primaryDark.withOpacity(0.06),
                              iconColor: ThixPremiumColors.primaryDark,
                              onTap: () => _handleRequestAccount(context),
                            ),
                            _ServiceCard(
                              icon: Icons.account_circle,
                              title: 'Mon\nCompte',
                              iconBackgroundColor: ThixPremiumColors.primaryDark.withOpacity(0.06),
                              iconColor: ThixPremiumColors.goldDark,
                              onTap: _onProfileTap,
                            ),
                            _ServiceCard(
                              icon: Icons.school,
                              title: 'Formations',
                              iconBackgroundColor: ThixPremiumColors.primaryDark.withOpacity(0.06),
                              iconColor: ThixPremiumColors.primaryDark,
                              badgeCount: counts.formations,
                              onTap: () => context.push(AppRoutes.trainingHome),
                            ),
                            _ServiceCard(
                              icon: Icons.work,
                              title: 'Emplois',
                              iconBackgroundColor: ThixPremiumColors.primaryDark.withOpacity(0.06),
                              iconColor: ThixPremiumColors.primaryDark,
                              badgeCount: counts.jobs,
                              onTap: () => context.push(AppRoutes.jobs),
                            ),
                            _ServiceCard(
                              icon: Icons.newspaper,
                              title: 'THIX\nINFO',
                              iconBackgroundColor: ThixPremiumColors.primaryDark.withOpacity(0.06),
                              iconColor: ThixPremiumColors.goldDark,
                              badgeCount: counts.info,
                              onTap: () => AlertInfoSheet.show(context),
                            ),
                            _ServiceCard(
                              icon: Icons.lightbulb_rounded,
                              title: 'Opportunités',
                              iconBackgroundColor: ThixPremiumColors.primaryDark.withOpacity(0.06),
                              iconColor: ThixPremiumColors.primaryDark,
                              badgeCount: counts.events, // Protection fallback
                              onTap: () => context.push(AppRoutes.opportunities),
                            ),
                            _ServiceCard(
                              icon: Icons.event,
                              title: 'Événements',
                              iconBackgroundColor: ThixPremiumColors.primaryDark.withOpacity(0.06),
                              iconColor: ThixPremiumColors.primaryDark,
                              badgeCount: counts.events,
                              onTap: () => context.push(AppRoutes.events),
                            ),
                            _ServiceCard(
                              icon: Icons.groups,
                              title: 'Réseau\nPro',
                              iconBackgroundColor: ThixPremiumColors.primaryDark.withOpacity(0.06),
                              iconColor: ThixPremiumColors.goldDark,
                              onTap: () => context.push(AppRoutes.network),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),

                /// Mission Banner - Stunning Deep Blue & Real Gold Gradient
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _MissionBanner(),
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 120)),
              ],
            ),
          ),

          /// Search Bar Overlay - Premium Gold Accent Lines (Clamped on Scroll)
          Positioned(
            top: (safeTop + 215 - _scrollOffset).clamp(safeTop + 12, safeTop + 215),
            left: 20,
            right: 20,
            child: Opacity(
              opacity: (1.0 - (_scrollOffset / 120)).clamp(0.0, 1.0),
              child: _SearchBarOverlay(
                controller: _searchController,
                isSearching: _searching,
                onVerify: _handleHomeSearchVerify,
              ),
            ),
          ),

          /// Loading Overlay
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
        ],
      ),

      /// Floating Bottom Navigation - Glassmorphism UI
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
        child: _FloatingBottomNav(
          onScanTap: () {
            ThixIdentitySheets.showQrScanSheet(context);
          },
        ),
      ),
    );
  }
}

/// Premium Header with rich Deep Blue to Black-Blue Gradient and Subtle Gold Borders
class _PremiumHeader extends StatelessWidget {
  final double safeTop;
  final VoidCallback onProfileTap;

  const _PremiumHeader({
    required this.safeTop,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// Gradient Background (Deep Institutional Luxury)
        Container(
          height: 270,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThixPremiumColors.primaryDark,
                ThixPremiumColors.primaryElectric,
              ],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),

        /// High-end geometric background rings instead of colorful circles
        Positioned(
          right: -40,
          top: -20,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: ThixPremiumColors.goldPrimary.withOpacity(0.05),
                width: 1.5,
              ),
            ),
          ),
        ),

        /// Cryptographic/Biometric Backdrop Effect
        Positioned(
          right: -20,
          bottom: -10,
          child: Icon(
            Icons.fingerprint_rounded,
            size: 180,
            color: ThixPremiumColors.goldPrimary.withOpacity(0.04),
          ),
        ),

        /// Content Structure
        Padding(
          padding: EdgeInsets.fromLTRB(24, safeTop + 16, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Top: Logo + Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Logo Section
                  Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: const LinearGradient(
                            colors: [ThixPremiumColors.goldDark, ThixPremiumColors.goldLight],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(1.5),
                          child: Card(
                            margin: EdgeInsets.zero,
                            color: ThixPremiumColors.primaryDark,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(15)),
                            ),
                            child: Icon(
                              Icons.fingerprint_rounded,
                              color: ThixPremiumColors.goldPrimary,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'THIX ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -0.2,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Identité Sécurisée.\nAvenir de Confiance.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 11,
                              height: 1.3,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  /// Profile Avatar
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: ThixPremiumColors.goldPrimary.withOpacity(0.6),
                          width: 1.5,
                        ),
                        color: ThixPremiumColors.primaryDark,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person_outline_rounded,
                        color: ThixPremiumColors.goldPrimary,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              /// Hero Text
              const Text(
                'Bienvenue !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Que voulez-vous faire aujourd\'hui ?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Modern Search Bar with gold gradient button accent
class _SearchBarOverlay extends StatefulWidget {
  final TextEditingController controller;
  final bool isSearching;
  final VoidCallback onVerify;

  const _SearchBarOverlay({
    required this.controller,
    required this.isSearching,
    required this.onVerify,
  });

  @override
  State<_SearchBarOverlay> createState() => _SearchBarOverlayState();
}

class _SearchBarOverlayState extends State<_SearchBarOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: ThixPremiumColors.white,
        borderRadius: BorderRadius.circular(35),
        border: Border.all(
          color: ThixPremiumColors.grayLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThixPremiumColors.primaryDark.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(
            Icons.search_rounded,
            color: ThixPremiumColors.grayMedium,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: widget.controller,
              enabled: !widget.isSearching,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Rechercher un THIX ID…',
                hintStyle: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              style: const TextStyle(
                color: ThixPremiumColors.primaryDark,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: widget.isSearching ? null : widget.onVerify,
            child: Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                gradient: const LinearGradient(
                  colors: [
                    ThixPremiumColors.goldDark,
                    ThixPremiumColors.goldPrimary,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThixPremiumColors.goldDark.withOpacity(0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Text(
                    'Vérifier',
                    style: TextStyle(
                      color: ThixPremiumColors.primaryDark,
                      fontWeight: FontWeight.w800,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(width: 6),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: ThixPremiumColors.primaryDark,
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick Action Card (QR & NFC) - Clean, Minimalist institutional boxes
class _QuickActionCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) {
    _controller.reverse();
    widget.onTap();
  }
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: ThixPremiumColors.grayLight,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ThixPremiumColors.primaryDark.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: ThixPremiumColors.primaryDark,
                  letterSpacing: -0.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ThixPremiumColors.grayMedium,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Notification Preview Card
class _NotificationPreviewCard extends StatelessWidget {
  final VoidCallback onTap;

  const _NotificationPreviewCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: ThixPremiumColors.grayLight,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThixPremiumColors.primaryDark.withOpacity(0.06),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: ThixPremiumColors.primaryDark,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: ThixPremiumColors.primaryDark,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Vous avez de nouvelles mises à jour',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ThixPremiumColors.grayMedium,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: ThixPremiumColors.goldDark,
            ),
          ],
        ),
      ),
    );
  }
}

/// Service Card (2x4 Grid) - Beautiful solid minimalist panels
class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color iconBackgroundColor;
  final Color iconColor;
  final int? badgeCount;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.badgeCount,
    required this.onTap,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.forward();
  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    widget.onTap();
  }
  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: ThixPremiumColors.grayLight,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.iconBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 22,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: ThixPremiumColors.primaryDark,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
              if (widget.badgeCount != null && widget.badgeCount! > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [ThixPremiumColors.goldDark, ThixPremiumColors.goldPrimary],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${widget.badgeCount}',
                      style: const TextStyle(
                        color: ThixPremiumColors.primaryDark,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Mission Banner - Majestic Institutional Blue and Real Gold Highlights
class _MissionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThixPremiumColors.primaryDark,
            ThixPremiumColors.accentBlue,
          ],
        ),
        border: Border.all(
          color: ThixPremiumColors.goldPrimary.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: ThixPremiumColors.primaryDark.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -30,
            right: -30,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ThixPremiumColors.goldPrimary.withOpacity(0.03),
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: ThixPremiumColors.goldPrimary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'NOTRE MISSION',
                        style: TextStyle(
                          color: ThixPremiumColors.goldLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Construisons ensemble\nl\'avenir de la jeunesse.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Accédez à des opportunités,\ndes ressources et un réseau engagé.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.shield_outlined,
                size: 80,
                color: ThixPremiumColors.goldPrimary.withOpacity(0.2),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Floating Bottom Navigation - Frosted Glassmorphism Polish
class _FloatingBottomNav extends StatelessWidget {
  final VoidCallback onScanTap;

  const _FloatingBottomNav({required this.onScanTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: ThixPremiumColors.white.withOpacity(0.88),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(
              color: Colors.white.withOpacity(0.6),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: ThixPremiumColors.primaryDark.withOpacity(0.06),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home_filled,
                label: 'Accueil',
                active: true,
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'Services',
                onTap: () {},
              ),
              GestureDetector(
                onTap: onScanTap,
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        ThixPremiumColors.primaryDark,
                        ThixPremiumColors.accentBlue,
                      ],
                    ),
                    border: Border.all(
                      color: ThixPremiumColors.goldPrimary.withOpacity(0.5),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ThixPremiumColors.primaryDark.withOpacity(0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: ThixPremiumColors.goldPrimary,
                    size: 26,
                  ),
                ),
              ),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Messages',
                onTap: () {},
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profil',
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom Navigation Item
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active
                ? ThixPremiumColors.primaryDark
                : ThixPremiumColors.grayMedium,
            size: 22,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: active ? FontWeight.w800 : FontWeight.w500,
              color: active
                  ? ThixPremiumColors.primaryDark
                  : ThixPremiumColors.grayMedium,
            ),
          ),
        ],
      ),
    );
  }
}

/// Account Request Bottom Sheet - Polished Institutional Styling
class AccountRequestSheet extends StatelessWidget {
  const AccountRequestSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ThixPremiumColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ThixPremiumColors.grayLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Créer un compte',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: ThixPremiumColors.primaryDark,
              ),
            ),
            const SizedBox(height: 24),
            _OptionButton(
              icon: Icons.person_outline,
              title: 'Compte Personnel',
              subtitle: 'Pour un profil individuel',
              onTap: () {
                Navigator.pop(context, _AccountRequestChoice.personal);
              },
            ),
            const SizedBox(height: 16),
            _OptionButton(
              icon: Icons.business_outlined,
              title: 'Compte Entreprise',
              subtitle: 'Pour une organisation',
              onTap: () {
                Navigator.pop(context, _AccountRequestChoice.enterprise);
              },
            ),
            const SizedBox(height: 20),
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

  const _OptionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: ThixPremiumColors.grayLight,
          ),
          borderRadius: BorderRadius.circular(16),
          color: ThixPremiumColors.backgroundLight.withOpacity(0.5),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: ThixPremiumColors.primaryDark.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: ThixPremiumColors.primaryDark,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: ThixPremiumColors.primaryDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ThixPremiumColors.grayMedium,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: ThixPremiumColors.goldDark,
            ),
          ],
        ),
      ),
    );
  }
}
