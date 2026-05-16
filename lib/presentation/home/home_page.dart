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

/// Design System - Conformité Fiche Technique
class ThixDesignSystem {
  static const Color primaryInstitutional = Color(0xFF002DCC);
  static const Color primaryInstitutionalDark = Color(0xFF001C80);
  static const Color primaryAccent = Color(0xFF1A52FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color graySecondary = Color(0xFF667085);
  static const Color darkText = Color(0xFF1A1A1A);
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

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
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
    final safeTop = MediaQuery.paddingOf(context).top;
    final badgeCountsStream = auth.currentUser == null
        ? Stream.value(SectionBadgeCounts.zero)
        : _counters.streamCounts(auth.currentUser!.id);

    return Scaffold(
      backgroundColor: ThixDesignSystem.backgroundLight,
      extendBody: true,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _PremiumHeader(
                  safeTop: safeTop,
                  onProfileTap: _onProfileTap,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 58)),
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
                          backgroundColor: ThixDesignSystem.accentBlueLight,
                          iconColor: ThixDesignSystem.primaryInstitutional,
                          onTap: () => ThixIdentitySheets.showQrScanSheet(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _QuickActionCard(
                          title: 'Lire via NFC',
                          subtitle: 'Approchez votre\nappareil',
                          icon: Icons.nfc_rounded,
                          backgroundColor: ThixDesignSystem.accentGreenLight,
                          iconColor: ThixDesignSystem.accentGreen,
                          onTap: () => ThixIdentitySheets.showNfcScanSheet(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
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
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nos services',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: ThixDesignSystem.darkText,
                          letterSpacing: -0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Tout voir',
                          style: TextStyle(
                            color: ThixDesignSystem.primaryInstitutional,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: StreamBuilder<SectionBadgeCounts>(
                  stream: badgeCountsStream,
                  builder: (context, snap) {
                    final counts = snap.data ?? SectionBadgeCounts.zero;
                    return SliverGrid(
                      delegate: SliverChildListDelegate([
                        _ServiceCard(
                          icon: Icons.person_add_alt_1,
                          title: 'Demander un\nCompte',
                          iconBackgroundColor: ThixDesignSystem.accentBlueLight,
                          iconColor: ThixDesignSystem.primaryInstitutional,
                          onTap: () => _handleRequestAccount(context),
                        ),
                        _ServiceCard(
                          icon: Icons.account_circle,
                          title: 'Mon\nCompte',
                          iconBackgroundColor: ThixDesignSystem.accentVioletLight,
                          iconColor: ThixDesignSystem.accentViolet,
                          onTap: _onProfileTap,
                        ),
                        _ServiceCard(
                          icon: Icons.school,
                          title: 'Formations',
                          iconBackgroundColor: ThixDesignSystem.accentGreenLight,
                          iconColor: ThixDesignSystem.accentGreen,
                          badgeCount: counts.formations,
                          onTap: () => context.push(AppRoutes.trainingHome),
                        ),
                        _ServiceCard(
                          icon: Icons.work,
                          title: 'Emplois',
                          iconBackgroundColor: ThixDesignSystem.accentOrangeLight,
                          iconColor: ThixDesignSystem.accentOrange,
                          badgeCount: counts.jobs,
                          onTap: () => context.push(AppRoutes.jobs),
                        ),
                        _ServiceCard(
                          icon: Icons.newspaper,
                          title: 'THIX\nINFO',
                          iconBackgroundColor: ThixDesignSystem.accentBlueLight,
                          iconColor: ThixDesignSystem.primaryInstitutional,
                          badgeCount: counts.info,
                          onTap: () => AlertInfoSheet.show(context),
                        ),
                        _ServiceCard(
                          icon: Icons.lightbulb_rounded,
                          title: 'Opportunités',
                          iconBackgroundColor: ThixDesignSystem.accentYellowLight,
                          iconColor: ThixDesignSystem.accentYellow,
                          badgeCount: counts.opportunities,
                          onTap: () => context.push(AppRoutes.opportunities),
                        ),
                        _ServiceCard(
                          icon: Icons.event,
                          title: 'Événements',
                          iconBackgroundColor: ThixDesignSystem.accentVioletLight,
                          iconColor: ThixDesignSystem.accentViolet,
                          badgeCount: counts.events,
                          onTap: () => context.push(AppRoutes.events),
                        ),
                        _ServiceCard(
                          icon: Icons.groups,
                          title: 'Réseau\nPro',
                          iconBackgroundColor: ThixDesignSystem.accentPinkLight,
                          iconColor: ThixDesignSystem.accentPink,
                          onTap: () => context.push(AppRoutes.network),
                        ),
                      ]),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.85,
                      ),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: _MissionBanner(),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
          Positioned(
            top: safeTop + 125,
            left: 20,
            right: 20,
            child: _SearchBarOverlay(
              controller: _searchController,
              isSearching: _searching,
              onVerify: _handleHomeSearchVerify,
            ),
          ),
          if (_searching)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ThixDesignSystem.primaryInstitutional,
                  ),
                ),
              ),
            ),
        ],
      ),
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

// ========== COMPOSANTS UI ==========

class _PremiumHeader extends StatelessWidget {
  final double safeTop;
  final VoidCallback onProfileTap;
  const _PremiumHeader({required this.safeTop, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 280,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [ThixDesignSystem.primaryInstitutionalDark, ThixDesignSystem.primaryInstitutional],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(48),
              bottomRight: Radius.circular(48),
            ),
          ),
        ),
        Positioned(
          right: -80,
          top: 20,
          child: Container(
            width: 240, height: 240,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.07)),
          ),
        ),
        Positioned(
          left: -60,
          bottom: -40,
          child: Container(
            width: 200, height: 200,
            decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)),
          ),
        ),
        Positioned(
          right: -30,
          bottom: -20,
          child: Icon(Icons.fingerprint, size: 200, color: Colors.white.withOpacity(0.06)),
        ),
        Positioned(
          right: 90,
          top: 80,
          child: Column(
            children: List.generate(10, (index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Container(width: 5, height: 5, decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24)),
            )),
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24, safeTop + 16, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 64, height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.7), width: 2),
                        ),
                        child: const Icon(Icons.fingerprint, color: Colors.white, size: 38),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('THIX ID', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800, letterSpacing: -0.5)),
                          const SizedBox(height: 4),
                          Text('Identité Sécurisée.\nAvenir de Confiance.', style: TextStyle(color: Colors.white.withOpacity(0.88), fontSize: 12, height: 1.3, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onProfileTap,
                    child: Container(
                      width: 60, height: 60,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: ThixDesignSystem.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16, offset: const Offset(0, 8))]),
                      child: const Icon(Icons.person, color: ThixDesignSystem.primaryInstitutionalDark, size: 32),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text('Bienvenue !', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w800, letterSpacing: -1.2, height: 1.1)),
              const SizedBox(height: 10),
              Text('Que voulez-vous faire aujourd\'hui ?', style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 18, fontWeight: FontWeight.w500, height: 1.4)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBarOverlay extends StatefulWidget {
  final TextEditingController controller;
  final bool isSearching;
  final VoidCallback onVerify;
  const _SearchBarOverlay({required this.controller, required this.isSearching, required this.onVerify});

  @override
  State<_SearchBarOverlay> createState() => _SearchBarOverlayState();
}

class _SearchBarOverlayState extends State<_SearchBarOverlay> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ThixDesignSystem.white,
        borderRadius: BorderRadius.circular(38),
        boxShadow: [BoxShadow(color: ThixDesignSystem.primaryInstitutional.withOpacity(0.15), blurRadius: 32, offset: const Offset(0, 12))],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.search, color: Color(0xFF9AA0B5), size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: widget.controller,
              enabled: !widget.isSearching,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Rechercher un THIX ID…',
                hintStyle: TextStyle(color: Color(0xFFA8ADB8), fontSize: 15, fontWeight: FontWeight.w500),
              ),
              style: const TextStyle(color: ThixDesignSystem.darkText, fontSize: 15, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: widget.isSearching ? null : widget.onVerify,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const LinearGradient(colors: [ThixDesignSystem.primaryInstitutional, ThixDesignSystem.primaryInstitutionalDark]),
                boxShadow: [BoxShadow(color: ThixDesignSystem.primaryInstitutional.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
              ),
              child: const Row(
                children: [
                  Text('Vérifier', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionCard extends StatefulWidget {
  final String title, subtitle;
  final IconData icon;
  final Color backgroundColor, iconColor;
  final VoidCallback onTap;
  const _QuickActionCard({required this.title, required this.subtitle, required this.icon, required this.backgroundColor, required this.iconColor, required this.onTap});

  @override
  State<_QuickActionCard> createState() => _QuickActionCardState();
}

class _QuickActionCardState extends State<_QuickActionCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) { _controller.reverse(); widget.onTap(); }
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
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(16)),
                child: Icon(widget.icon, color: widget.iconColor, size: 32),
              ),
              const SizedBox(height: 14),
              Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ThixDesignSystem.darkText, height: 1.2)),
              const SizedBox(height: 6),
              Text(widget.subtitle, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: ThixDesignSystem.graySecondary, height: 1.3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationPreviewCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NotificationPreviewCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: ThixDesignSystem.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 6))],
        ),
        child: Row(
          children: [
            Container(
              width: 52, height: 52,
              decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [ThixDesignSystem.primaryInstitutional, ThixDesignSystem.primaryInstitutionalDark])),
              child: const Icon(Icons.notifications_none, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ThixDesignSystem.darkText)),
                  const SizedBox(height: 4),
                  Text('Vous avez de nouvelles mises à jour', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: ThixDesignSystem.graySecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: ThixDesignSystem.primaryInstitutional),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color iconBackgroundColor, iconColor;
  final int? badgeCount;
  final VoidCallback onTap;
  const _ServiceCard({required this.icon, required this.title, required this.iconBackgroundColor, required this.iconColor, this.badgeCount, required this.onTap});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) => _controller.forward();
  void _onTapUp(_) { _controller.reverse(); widget.onTap(); }
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
            color: ThixDesignSystem.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44, height: 44,
                    decoration: BoxDecoration(color: widget.iconBackgroundColor, borderRadius: BorderRadius.circular(14)),
                    child: Icon(widget.icon, color: widget.iconColor, size: 24),
                  ),
                  const Spacer(),
                  Text(widget.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ThixDesignSystem.darkText, height: 1.2)),
                ],
              ),
              if (widget.badgeCount != null && widget.badgeCount! > 0)
                Positioned(
                  top: 0, right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: ThixDesignSystem.primaryInstitutional, borderRadius: BorderRadius.circular(12)),
                    child: Text('${widget.badgeCount}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MissionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(colors: [ThixDesignSystem.primaryInstitutionalDark, ThixDesignSystem.primaryInstitutional]),
        boxShadow: [BoxShadow(color: ThixDesignSystem.primaryInstitutional.withOpacity(0.2), blurRadius: 32, offset: const Offset(0, 12))],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20, right: -20,
            child: Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08))),
          ),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('NOTRE MISSION', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.3)),
                    const SizedBox(height: 12),
                    const Text('Construisons ensemble\nl\'avenir de la jeunesse.', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.15, letterSpacing: -0.5)),
                    const SizedBox(height: 12),
                    Text('Accédez à des opportunités,\ndes ressources et un réseau engagé.', style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 14, fontWeight: FontWeight.w500, height: 1.5)),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.diversity_3, size: 100, color: Colors.white.withOpacity(0.9)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FloatingBottomNav extends StatelessWidget {
  final VoidCallback onScanTap;
  const _FloatingBottomNav({required this.onScanTap});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: ThixDesignSystem.white.withOpacity(0.93),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.5), width: 1),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 32, offset: const Offset(0, 12))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_filled, label: 'Accueil', active: true, onTap: () {}),
              _NavItem(icon: Icons.grid_view, label: 'Services', onTap: () {}),
              GestureDetector(
                onTap: onScanTap,
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [ThixDesignSystem.primaryInstitutional, ThixDesignSystem.primaryInstitutionalDark]),
                    boxShadow: [BoxShadow(color: ThixDesignSystem.primaryInstitutional.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
                  ),
                  child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                ),
              ),
              _NavItem(icon: Icons.chat_bubble_outline, label: 'Messages', onTap: () {}),
              _NavItem(icon: Icons.person_outline, label: 'Profil', onTap: () {}),
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
          Icon(icon, color: active ? ThixDesignSystem.primaryInstitutional : ThixDesignSystem.graySecondary, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? ThixDesignSystem.primaryInstitutional : ThixDesignSystem.graySecondary)),
        ],
      ),
    );
  }
}

// ========== CLASSE MANQUANTE AccountRequestSheet ==========
class AccountRequestSheet extends StatelessWidget {
  const AccountRequestSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: ThixDesignSystem.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text('Créer un compte', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: ThixDesignSystem.darkText)),
            const SizedBox(height: 24),
            _OptionButton(
              icon: Icons.person,
              title: 'Compte Personnel',
              subtitle: 'Pour un profil individuel',
              onTap: () => Navigator.pop(context, _AccountRequestChoice.personal),
            ),
            const SizedBox(height: 16),
            _OptionButton(
              icon: Icons.business,
              title: 'Compte Entreprise',
              subtitle: 'Pour une organisation',
              onTap: () => Navigator.pop(context, _AccountRequestChoice.enterprise),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _OptionButton({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: ThixDesignSystem.primaryInstitutional.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: ThixDesignSystem.primaryInstitutional.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: ThixDesignSystem.primaryInstitutional),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ThixDesignSystem.darkText)),
                  Text(subtitle, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: ThixDesignSystem.graySecondary)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: ThixDesignSystem.primaryInstitutional),
          ],
        ),
      ),
    );
  }
}
