import 'dart:async';
import 'dart:ui';

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

/// Design System - Conformité Fiche Technique (Enhanced)
class ThixDesignSystem {
  // Primary Colors - Gradient Bleu Institutional
  static const Color primaryInstitutional = Color(0xFF002DCC);
  static const Color primaryInstitutionalDark = Color(0xFF001C80);
  static const Color primaryAccent = Color(0xFF1A52FF);
  
  // Background & Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color graySecondary = Color(0xFF667085);
  static const Color darkText = Color(0xFF1A1A1A);
  
  // Accent Colors for Services
  static const Color accentBlueLight = Color(0xFFEFF3FF);
  static const Color accentGreenLight = Color(0xFFE8FFF5);
  static const Color accentOrangeLight = Color(0xFFFFF4E9);
  static const Color accentVioletLight = Color(0xFFF5ECFF);
  static const Color accentYellowLight = Color(0xFFFFF8E8);
  static const Color accentPinkLight = Color(0xFFFFEEF5);
  
  static const Color accentGreen = Color(0xFF10B981);
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentViolet = Color(0xFFA78BFA);
  static const Color accentYellow = Color(0xFFFCD34D);
  static const Color accentPink = Color(0xFFFF1493);
}

enum _AccountRequestChoice { personal, enterprise }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _searching = false;
  late AnimationController _animationController;
  int _carouselIndex = 0;

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
    final isThix = normalized.startsWith('THIX-') && ThixIdService.isValid(normalized);
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
        if (auth.isAuthenticated) await auth.signOut();
        if (context.mounted) context.push(AppRoutes.personalReg);
        return;
      case _AccountRequestChoice.enterprise:
        if (auth.isAuthenticated) await auth.signOut();
        if (context.mounted) context.push(AppRoutes.enterpriseReg);
        return;
      case null:
        return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final badgeCountsStream = auth.currentUser == null
        ? Stream.value(SectionBadgeCounts.zero)
        : _counters.streamCounts(auth.currentUser!.id);

    return Scaffold(
      backgroundColor: ThixDesignSystem.backgroundLight,
      extendBody: false,
      body: Stack(
        children: [
          // Main Content - Fixed Height Layout (No Scroll)
          SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  100, // Reserve space for bottom nav
              child: Column(
                children: [
                  // ===== HEADER + SEARCH BAR (Integrated) =====
                  _PremiumHeaderWithSearchBar(
                    onProfileTap: _onProfileTap,
                    searchController: _searchController,
                    isSearching: _searching,
                    onVerify: _handleHomeSearchVerify,
                  ),

                  // ===== QUICK ACTION BANDS (Compact) =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _CompactActionBand(
                            icon: Icons.qr_code_scanner_rounded,
                            label: 'Scan QR',
                            backgroundColor: ThixDesignSystem.accentBlueLight,
                            iconColor: ThixDesignSystem.primaryAccent,
                            onTap: () => ThixIdentitySheets.showQrScanSheet(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _CompactActionBand(
                            icon: Icons.fingerprint_rounded,
                            label: 'Lire NFC',
                            backgroundColor: ThixDesignSystem.accentGreenLight,
                            iconColor: ThixDesignSystem.accentGreen,
                            onTap: () => ThixIdentitySheets.showNfcScanSheet(context),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===== CAROUSEL (Bannières) =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: _PromoBannerCarousel(
                      onIndexChanged: (index) =>
                          setState(() => _carouselIndex = index),
                    ),
                  ),

                  // ===== NOTIFICATION PREVIEW (Compact) =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
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

                  // ===== SERVICES SECTION HEADER =====
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Nos services',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: ThixDesignSystem.darkText,
                            letterSpacing: -0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'Tout voir >',
                            style: TextStyle(
                              color: ThixDesignSystem.primaryAccent,
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ===== SERVICES GRID (8 Cards - No Overflow) =====
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: StreamBuilder<SectionBadgeCounts>(
                        stream: badgeCountsStream,
                        builder: (context, snap) {
                          final counts = snap.data ?? SectionBadgeCounts.zero;
                          return GridView.count(
                            crossAxisCount: 4,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.85,
                            physics: const NeverScrollableScrollPhysics(),
                            children: [
                              _ServiceCardModernized(
                                icon: Icons.person_add_alt_1_rounded,
                                title: 'Demander',
                                subtitle: 'Compte',
                                iconBackgroundColor: ThixDesignSystem.accentBlueLight,
                                iconColor: ThixDesignSystem.primaryAccent,
                                onTap: () => _handleRequestAccount(context),
                              ),
                              _ServiceCardModernized(
                                icon: Icons.account_circle_rounded,
                                title: 'Mon',
                                subtitle: 'Compte',
                                iconBackgroundColor: ThixDesignSystem.accentVioletLight,
                                iconColor: ThixDesignSystem.accentViolet,
                                onTap: _onProfileTap,
                              ),
                              _ServiceCardModernized(
                                icon: Icons.school_rounded,
                                title: 'Form',
                                subtitle: 'ations',
                                iconBackgroundColor: ThixDesignSystem.accentGreenLight,
                                iconColor: ThixDesignSystem.accentGreen,
                                badgeCount: counts.formations,
                                onTap: () => context.push(AppRoutes.trainingHome),
                              ),
                              _ServiceCardModernized(
                                icon: Icons.work_rounded,
                                title: 'Em',
                                subtitle: 'plois',
                                iconBackgroundColor: ThixDesignSystem.accentOrangeLight,
                                iconColor: ThixDesignSystem.accentOrange,
                                badgeCount: counts.jobs,
                                onTap: () => context.push(AppRoutes.jobs),
                              ),
                              _ServiceCardModernized(
                                icon: Icons.newspaper_rounded,
                                title: 'THIX',
                                subtitle: 'INFO',
                                iconBackgroundColor: ThixDesignSystem.accentBlueLight,
                                iconColor: ThixDesignSystem.primaryInstitutional,
                                badgeCount: counts.info,
                                onTap: () => AlertInfoSheet.show(context),
                              ),
                              _ServiceCardModernized(
                                icon: Icons.lightbulb_rounded,
                                title: 'Oppor',
                                subtitle: 'tunités',
                                iconBackgroundColor: ThixDesignSystem.accentYellowLight,
                                iconColor: ThixDesignSystem.accentYellow,
                                badgeCount: counts.opportunities,
                                onTap: () => context.push(AppRoutes.opportunities),
                              ),
                              _ServiceCardModernized(
                                icon: Icons.event_rounded,
                                title: 'Événe',
                                subtitle: 'ments',
                                iconBackgroundColor: ThixDesignSystem.accentVioletLight,
                                iconColor: ThixDesignSystem.accentViolet,
                                badgeCount: counts.events,
                                onTap: () => context.push(AppRoutes.events),
                              ),
                              _ServiceCardModernized(
                                icon: Icons.groups_rounded,
                                title: 'Réseau',
                                subtitle: 'Pro',
                                iconBackgroundColor: ThixDesignSystem.accentPinkLight,
                                iconColor: ThixDesignSystem.accentPink,
                                onTap: () => context.push(AppRoutes.network),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ===== LOADING OVERLAY =====
          if (_searching)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ThixDesignSystem.primaryAccent,
                  ),
                ),
              ),
            ),
        ],
      ),

      // ===== BOTTOM NAVIGATION (Fixed, Modernized) =====
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: _ModernizedBottomNav(
          onScanTap: () {
            ThixIdentitySheets.showQrScanSheet(context);
          },
        ),
      ),
    );
  }
}

// ========== NEW WIDGETS ==========

/// Integrated Header with Search Bar (No Floating)
class _PremiumHeaderWithSearchBar extends StatelessWidget {
  final VoidCallback onProfileTap;
  final TextEditingController searchController;
  final bool isSearching;
  final VoidCallback onVerify;

  const _PremiumHeaderWithSearchBar({
    required this.onProfileTap,
    required this.searchController,
    required this.isSearching,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    final safeTop = MediaQuery.paddingOf(context).top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Diagonal gradient background
        ClipPath(
          clipper: _DiagonalClipper(),
          child: Container(
            height: 340,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  ThixDesignSystem.primaryInstitutional,
                  ThixDesignSystem.primaryInstitutionalDark,
                ],
                stops: [0.0, 1.0],
              ),
            ),
          ),
        ),

        // Decorative circles
        Positioned(
          right: -80,
          top: 20,
          child: Container(
            width: 240,
            height: 240,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
        ),
        Positioned(
          left: -60,
          bottom: -40,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
        ),

        // Header Content
        Padding(
          padding: EdgeInsets.fromLTRB(24, safeTop + 12, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Top Bar: Logo + Profile
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.7),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.fingerprint_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'THIX ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Identité Sécurisée.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ThixDesignSystem.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: ThixDesignSystem.primaryInstitutional,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // Welcome Text (Compact)
              const Text(
                'Bienvenue !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Que voulez-vous faire ?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.90),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),

              // Integrated Search Bar (Inside Header)
              _IntegratedSearchBar(
                controller: searchController,
                isSearching: isSearching,
                onVerify: onVerify,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Integrated Search Bar (No Floating)
class _IntegratedSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;
  final VoidCallback onVerify;

  const _IntegratedSearchBar({
    required this.controller,
    required this.isSearching,
    required this.onVerify,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ThixDesignSystem.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: ThixDesignSystem.primaryAccent.withOpacity(0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          const Icon(
            Icons.search_rounded,
            color: ThixDesignSystem.graySecondary,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isSearching,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Rechercher un THIX ID…',
                hintStyle: TextStyle(
                  color: Color(0xFFB0B8C1),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: const TextStyle(
                color: ThixDesignSystem.darkText,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: isSearching ? null : onVerify,
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  colors: [
                    ThixDesignSystem.primaryAccent,
                    ThixDesignSystem.primaryInstitutional,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThixDesignSystem.primaryAccent.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Vérifier',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 14,
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

/// Compact Action Band (Replaces Large Cards)
class _CompactActionBand extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor, iconColor;
  final VoidCallback onTap;

  const _CompactActionBand({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<_CompactActionBand> createState() => _CompactActionBandState();
}

class _CompactActionBandState extends State<_CompactActionBand>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.96)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                widget.icon,
                color: widget.iconColor,
                size: 22,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.label,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: ThixDesignSystem.darkText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Promo Banner Carousel
class _PromoBannerCarousel extends StatefulWidget {
  final ValueChanged<int> onIndexChanged;

  const _PromoBannerCarousel({required this.onIndexChanged});

  @override
  State<_PromoBannerCarousel> createState() => _PromoBannerCarouselState();
}

class _PromoBannerCarouselState extends State<_PromoBannerCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  final List<_BannerData> banners = [
    _BannerData(
      title: 'Accédez à vos documents\nsécurisés',
      subtitle: 'Partez en confiance',
      gradient: [Color(0xFF1A52FF), Color(0xFF002DCC)],
      icon: Icons.security_rounded,
    ),
    _BannerData(
      title: 'Certification digitale\ninstantanée',
      subtitle: 'Obtenue en quelques clics',
      gradient: [Color(0xFF10B981), Color(0xFF059669)],
      icon: Icons.verified_user_rounded,
    ),
    _BannerData(
      title: 'Identité vérifiée\npartout',
      subtitle: 'Reconnue internationalement',
      gradient: [Color(0xFFF97316), Color(0xFFEA580C)],
      icon: Icons.public_rounded,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
              widget.onIndexChanged(index);
            },
            itemCount: banners.length,
            itemBuilder: (context, index) => _PromoBannerCard(
              data: banners[index],
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Dot Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            banners.length,
            (index) => Container(
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index
                    ? ThixDesignSystem.primaryAccent
                    : ThixDesignSystem.graySecondary.withOpacity(0.3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final List<Color> gradient;
  final IconData icon;

  _BannerData({
    required this.title,
    required this.subtitle,
    required this.gradient,
    required this.icon,
  });
}

class _PromoBannerCard extends StatelessWidget {
  final _BannerData data;

  const _PromoBannerCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: data.gradient,
        ),
        boxShadow: [
          BoxShadow(
            color: data.gradient[0].withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative Icon
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              data.icon,
              size: 120,
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    height: 1.3,
                  ),
                ),
                Text(
                  data.subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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

/// Notification Preview Card (Optimized)
class _NotificationPreviewCard extends StatelessWidget {
  final VoidCallback onTap;

  const _NotificationPreviewCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: ThixDesignSystem.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    ThixDesignSystem.primaryAccent,
                    ThixDesignSystem.primaryInstitutional,
                  ],
                ),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: ThixDesignSystem.darkText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Restez informé de vos activités',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: ThixDesignSystem.graySecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: ThixDesignSystem.primaryAccent,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

/// Modernized Service Card
class _ServiceCardModernized extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color iconBackgroundColor, iconColor;
  final int? badgeCount;
  final VoidCallback onTap;

  const _ServiceCardModernized({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.iconBackgroundColor,
    required this.iconColor,
    this.badgeCount,
    required this.onTap,
  });

  @override
  State<_ServiceCardModernized> createState() => _ServiceCardModernizedState();
}

class _ServiceCardModernizedState extends State<_ServiceCardModernized>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 120),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.90)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: ThixDesignSystem.white,
            borderRadius: BorderRadius.circular(24), // Increased radius
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.iconBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 18,
                    ),
                  ),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: ThixDesignSystem.darkText,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: ThixDesignSystem.graySecondary,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              if (widget.badgeCount != null && widget.badgeCount! > 0)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF3B30),
                    ),
                    child: Text(
                      widget.badgeCount! > 9 ? '9+' : widget.badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      ),
    );
  }
}

/// Modernized Bottom Navigation
class _ModernizedBottomNav extends StatelessWidget {
  final VoidCallback onScanTap;

  const _ModernizedBottomNav({required this.onScanTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: ThixDesignSystem.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Main Navigation Items
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavItem(
                icon: Icons.home_rounded,
                label: 'Accueil',
                isActive: true,
              ),
              _NavItem(
                icon: Icons.grid_3x3_rounded,
                label: 'Services',
              ),
              const SizedBox(width: 60), // Space for center button
              _NavItem(
                icon: Icons.mail_outline_rounded,
                label: 'Messages',
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                label: 'Profil',
              ),
            ],
          ),

          // Central Floating Button (THIX MONEY)
          Positioned(
            top: -28,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: onScanTap,
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        ThixDesignSystem.primaryAccent,
                        ThixDesignSystem.primaryInstitutional,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: ThixDesignSystem.primaryAccent.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Money Icon (stylized)
                      Icon(
                        Icons.wallet_rounded,
                        color: Colors.white,
                        size: 32,
                      ),
                      // Decorative T badge
                      Positioned(
                        right: 6,
                        bottom: 6,
                        child: Container(
                          width: 18,
                          height: 18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              'T',
                              style: TextStyle(
                                color: ThixDesignSystem.primaryInstitutional,
                                fontWeight: FontWeight.w800,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Label under center button
          Positioned(
            bottom: 8,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                'THIX MONEY',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: ThixDesignSystem.primaryAccent,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive
              ? ThixDesignSystem.primaryAccent
              : ThixDesignSystem.graySecondary,
          size: 24,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
            color: isActive
                ? ThixDesignSystem.primaryAccent
                : ThixDesignSystem.graySecondary,
          ),
        ),
      ],
    );
  }
}

// ========== HELPER CLIPPERS & UTILITIES ==========

class _DiagonalClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height * 0.80);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.92,
      size.width,
      size.height * 0.70,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
