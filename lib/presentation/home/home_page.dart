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

/// Design System
class ThixDesignSystem {
  static const Color primaryDark = Color(0xFF071B8C);
  static const Color primaryLight = Color(0xFF2E5BFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF6F8FC);
  static const Color textDark = Color(0xFF1A1A2E);
  static const Color textGrey = Color(0xFF6C6C7A);
  static const Color mint = Color(0xFFCFF7E8);
  static const Color lavender = Color(0xFFEEE7FF);
  static const Color green = Color(0xFF10B981);
  static const Color orange = Color(0xFFF97316);
  static const Color purple = Color(0xFFA78BFA);
  static const Color amber = Color(0xFFFCD34D);
  static const Color pink = Color(0xFFFF1493);
}

enum _AccountChoice { personal, enterprise }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _searching = false;
  late AnimationController _animController;

  final _notifications = NotificationService();
  final _counters = NotificationCountersService();
  final _uidRegex = RegExp(r'^[A-Za-z0-9_-]{20,}$');

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600))..forward();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    final raw = _searchController.text.trim();
    if (raw.isEmpty) {
      await FullScreenMessage.showError(context, title: 'Identifiant requis', message: 'Entrez un THIX ID.');
      return;
    }
    final norm = ThixIdService.normalize(raw);
    final isThix = norm.startsWith('THIX-') && ThixIdService.isValid(norm);
    final isUid = _uidRegex.hasMatch(raw);
    if (!isThix && !isUid) {
      await FullScreenMessage.showError(context, title: 'Format invalide', message: 'THIX ID incorrect.');
      return;
    }

    setState(() => _searching = true);
    try {
      final service = FirestoreUserService();
      final user = isThix ? await service.fetchUserByThixId(norm) : await service.fetchUserByUid(raw);
      if (!mounted) return;
      if (user == null) {
        await FullScreenMessage.showError(context, title: 'Introuvable', message: 'Aucun profil.');
        return;
      }
      final thix = user.thixId.trim().toUpperCase();
      if (thix.isNotEmpty && ThixIdService.isValid(thix)) {
        context.push('${AppRoutes.publicProfile}?thixId=$thix');
      } else {
        await ThixIdentitySheets.showVerifySheet(context, initialUidOrThixId: user.id);
      }
    } catch (_) {
      if (!mounted) return;
      await FullScreenMessage.showError(context, title: 'Erreur', message: 'Vérification impossible.');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _goProfile() {
    final auth = context.read<AuthController>();
    if (auth.isAuthenticated) {
      final t = auth.currentUser?.accountType;
      context.go(t == AccountType.enterprise ? AppRoutes.enterpriseDashboard : AppRoutes.userDashboard);
    } else {
      context.push(AppRoutes.login);
    }
  }

  Future<void> _requestAccount() async {
    final auth = context.read<AuthController>();
    final choice = await showModalBottomSheet<_AccountChoice>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const _AccountSheet(),
    );
    switch (choice) {
      case _AccountChoice.personal:
        if (auth.isAuthenticated) await auth.signOut();
        if (context.mounted) context.push(AppRoutes.personalReg);
        break;
      case _AccountChoice.enterprise:
        if (auth.isAuthenticated) await auth.signOut();
        if (context.mounted) context.push(AppRoutes.enterpriseReg);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final safeTop = MediaQuery.paddingOf(context).top;
    final badgeStream = auth.currentUser == null
        ? Stream.value(SectionBadgeCounts.zero)
        : _counters.streamCounts(auth.currentUser!.id);

    return Scaffold(
      backgroundColor: ThixDesignSystem.background,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _Header(safeTop: safeTop, onProfile: _goProfile)),
              const SliverToBoxAdapter(child: SizedBox(height: 58)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: Row(
                    children: [
                      Expanded(child: _ActionCard(
                        title: 'Scanner un QR',
                        subtitle: 'Scannez un code\nen toute sécurité',
                        icon: Icons.qr_code_scanner,
                        bgColor: ThixDesignSystem.lavender,
                        iconColor: ThixDesignSystem.primaryLight,
                        onTap: () => ThixIdentitySheets.showQrScanSheet(context),
                      )),
                      const SizedBox(width: 16),
                      Expanded(child: _ActionCard(
                        title: 'Lire via NFC',
                        subtitle: 'Approchez votre\nappareil',
                        icon: Icons.nfc,
                        bgColor: ThixDesignSystem.mint,
                        iconColor: ThixDesignSystem.green,
                        onTap: () => ThixIdentitySheets.showNfcScanSheet(context),
                      )),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: _NotifCard(
                    onTap: () {
                      if (!auth.isAuthenticated) context.push(AppRoutes.login);
                      else NotificationsSheet.show(context);
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
                      const Text('Nos services', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: ThixDesignSystem.textDark)),
                      const Text('Tout voir', style: TextStyle(color: ThixDesignSystem.primaryLight, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 20)),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: StreamBuilder<SectionBadgeCounts>(
                  stream: badgeStream,
                  builder: (context, snap) {
                    final c = snap.data ?? SectionBadgeCounts.zero;
                    return SliverGrid(
                      delegate: SliverChildListDelegate([
                        _ServiceCard(icon: Icons.person_add, title: 'Demander un\nCompte', bgColor: const Color(0xFFEFF3FF), iconColor: ThixDesignSystem.primaryLight, onTap: _requestAccount),
                        _ServiceCard(icon: Icons.account_circle, title: 'Mon\nCompte', bgColor: const Color(0xFFF5ECFF), iconColor: ThixDesignSystem.purple, onTap: _goProfile),
                        _ServiceCard(icon: Icons.school, title: 'Formations', bgColor: const Color(0xFFE8FFF5), iconColor: ThixDesignSystem.green, badge: c.formations, onTap: () => context.push(AppRoutes.trainingHome)),
                        _ServiceCard(icon: Icons.work, title: 'Emplois', bgColor: const Color(0xFFFFF4E9), iconColor: ThixDesignSystem.orange, badge: c.jobs, onTap: () => context.push(AppRoutes.jobs)),
                        _ServiceCard(icon: Icons.newspaper, title: 'THIX\nINFO', bgColor: const Color(0xFFEFF3FF), iconColor: ThixDesignSystem.primaryLight, badge: c.info, onTap: () => AlertInfoSheet.show(context)),
                        _ServiceCard(icon: Icons.lightbulb, title: 'Opportunités', bgColor: const Color(0xFFFFF8E8), iconColor: ThixDesignSystem.amber, badge: c.opportunities, onTap: () => context.push(AppRoutes.opportunities)),
                        _ServiceCard(icon: Icons.event, title: 'Événements', bgColor: const Color(0xFFF8ECFF), iconColor: ThixDesignSystem.purple, badge: c.events, onTap: () => context.push(AppRoutes.events)),
                        _ServiceCard(icon: Icons.groups, title: 'Réseau\nPro', bgColor: const Color(0xFFFFEEF5), iconColor: ThixDesignSystem.pink, onTap: () => context.push(AppRoutes.network)),
                      ]),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 0.85),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
              SliverPadding(padding: const EdgeInsets.symmetric(horizontal: 20), sliver: SliverToBoxAdapter(child: _MissionBanner())),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
          Positioned(
            top: safeTop + 125,
            left: 20,
            right: 20,
            child: _SearchBar(controller: _searchController, isSearching: _searching, onVerify: _verify),
          ),
          if (_searching)
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.2), child: const Center(child: CircularProgressIndicator(color: ThixDesignSystem.primaryLight))),
            ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: _BottomNav(onScan: () => ThixIdentitySheets.showQrScanSheet(context)),
      ),
    );
  }
}

// ========== WIDGETS ==========

class _Header extends StatelessWidget {
  final double safeTop;
  final VoidCallback onProfile;
  const _Header({required this.safeTop, required this.onProfile});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 280,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [ThixDesignSystem.primaryDark, ThixDesignSystem.primaryLight]),
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(48), bottomRight: Radius.circular(48)),
          ),
        ),
        Positioned(right: -80, top: 20, child: Container(width: 240, height: 240, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.07)))),
        Positioned(left: -60, bottom: -40, child: Container(width: 200, height: 200, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.05)))),
        Positioned(right: -30, bottom: -20, child: Icon(Icons.fingerprint, size: 200, color: Colors.white.withOpacity(0.06))),
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
                      Container(width: 64, height: 64, decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white.withOpacity(0.7), width: 2)), child: const Icon(Icons.fingerprint, color: Colors.white, size: 38)),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('THIX ID', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 4),
                          Text('Identité Sécurisée.\nAvenir de Confiance.', style: TextStyle(color: Colors.white.withOpacity(0.88), fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: onProfile,
                    child: Container(width: 60, height: 60, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 16)]), child: const Icon(Icons.person, color: ThixDesignSystem.primaryDark, size: 32)),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              const Text('Bienvenue !', style: TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w800, height: 1.1)),
              const SizedBox(height: 10),
              Text('Que voulez-vous faire aujourd\'hui ?', style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 18)),
            ],
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;
  final VoidCallback onVerify;
  const _SearchBar({required this.controller, required this.isSearching, required this.onVerify});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(38),
        boxShadow: [BoxShadow(color: ThixDesignSystem.primaryLight.withOpacity(0.15), blurRadius: 32)],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFF9AA0B5), size: 28),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: !isSearching,
              decoration: const InputDecoration(border: InputBorder.none, hintText: 'Rechercher un THIX ID…', hintStyle: TextStyle(fontSize: 15)),
              style: const TextStyle(fontSize: 15),
            ),
          ),
          GestureDetector(
            onTap: isSearching ? null : onVerify,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                gradient: const LinearGradient(colors: [ThixDesignSystem.primaryLight, ThixDesignSystem.primaryDark]),
                boxShadow: [BoxShadow(color: ThixDesignSystem.primaryLight.withOpacity(0.3), blurRadius: 16)],
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

class _ActionCard extends StatefulWidget {
  final String title, subtitle;
  final IconData icon;
  final Color bgColor, iconColor;
  final VoidCallback onTap;
  const _ActionCard({required this.title, required this.subtitle, required this.icon, required this.bgColor, required this.iconColor, required this.onTap});

  @override
  State<_ActionCard> createState() => _ActionCardState();
}

class _ActionCardState extends State<_ActionCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scale = Tween(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _down(_) => _ctrl.forward();
  void _up(_) { _ctrl.reverse(); widget.onTap(); }
  void _cancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _down, onTapUp: _up, onTapCancel: _cancel,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: widget.bgColor, borderRadius: BorderRadius.circular(28), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 16)]),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), borderRadius: BorderRadius.circular(16)), child: Icon(widget.icon, color: widget.iconColor, size: 32)),
              const SizedBox(height: 14),
              Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ThixDesignSystem.textDark)),
              const SizedBox(height: 6),
              Text(widget.subtitle, style: const TextStyle(fontSize: 13, color: ThixDesignSystem.textGrey)),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final VoidCallback onTap;
  const _NotifCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16)]),
        child: Row(
          children: [
            Container(width: 52, height: 52, decoration: const BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [ThixDesignSystem.primaryLight, ThixDesignSystem.primaryDark])), child: const Icon(Icons.notifications_none, color: Colors.white, size: 26)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Text('Notifications', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ThixDesignSystem.textDark)),
              SizedBox(height: 4),
              Text('Vous avez de nouvelles mises à jour', style: TextStyle(fontSize: 13, color: ThixDesignSystem.textGrey)),
            ])),
            const Icon(Icons.arrow_forward_ios, size: 16, color: ThixDesignSystem.primaryLight),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color bgColor, iconColor;
  final int? badge;
  final VoidCallback onTap;
  const _ServiceCard({required this.icon, required this.title, required this.bgColor, required this.iconColor, this.badge, required this.onTap});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scale = Tween(begin: 1.0, end: 0.94).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _down(_) => _ctrl.forward();
  void _up(_) { _ctrl.reverse(); widget.onTap(); }
  void _cancel() => _ctrl.reverse();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _down, onTapUp: _up, onTapCancel: _cancel,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12)]),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(width: 44, height: 44, decoration: BoxDecoration(color: widget.bgColor, borderRadius: BorderRadius.circular(14)), child: Icon(widget.icon, color: widget.iconColor, size: 24)),
                  const Spacer(),
                  Text(widget.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: ThixDesignSystem.textDark)),
                ],
              ),
              if (widget.badge != null && widget.badge! > 0)
                Positioned(
                  top: 0, right: 0,
                  child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: ThixDesignSystem.primaryLight, borderRadius: BorderRadius.circular(12)), child: Text('${widget.badge}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700))),
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
        gradient: const LinearGradient(colors: [ThixDesignSystem.primaryDark, ThixDesignSystem.primaryLight]),
        boxShadow: [BoxShadow(color: ThixDesignSystem.primaryLight.withOpacity(0.2), blurRadius: 32)],
      ),
      child: Stack(
        children: [
          Positioned(top: -20, right: -20, child: Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.08)))),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('NOTRE MISSION', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12, fontWeight: FontWeight.w800, letterSpacing: 1.3)),
                    const SizedBox(height: 12),
                    const Text('Construisons ensemble\nl\'avenir de la jeunesse.', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w800, height: 1.15)),
                    const SizedBox(height: 12),
                    Text('Accédez à des opportunités,\ndes ressources et un réseau engagé.', style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 14)),
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

class _BottomNav extends StatelessWidget {
  final VoidCallback onScan;
  const _BottomNav({required this.onScan});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          height: 88,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.93),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Colors.white.withOpacity(0.5)),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 32)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: Icons.home_filled, label: 'Accueil', active: true),
              _NavItem(icon: Icons.grid_view, label: 'Services'),
              GestureDetector(
                onTap: onScan,
                child: Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(colors: [ThixDesignSystem.primaryLight, ThixDesignSystem.primaryDark]),
                    boxShadow: [BoxShadow(color: ThixDesignSystem.primaryLight.withOpacity(0.3), blurRadius: 20)],
                  ),
                  child: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 28),
                ),
              ),
              _NavItem(icon: Icons.chat_bubble_outline, label: 'Messages'),
              _NavItem(icon: Icons.person_outline, label: 'Profil'),
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
  const _NavItem({required this.icon, required this.label, this.active = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: active ? ThixDesignSystem.primaryLight : ThixDesignSystem.textGrey, size: 24),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: active ? ThixDesignSystem.primaryLight : ThixDesignSystem.textGrey)),
      ],
    );
  }
}

// ========== ACCOUNT SHEET (classe manquante) ==========
class _AccountSheet extends StatelessWidget {
  const _AccountSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(32), topRight: Radius.circular(32))),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text('Créer un compte', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: ThixDesignSystem.textDark)),
            const SizedBox(height: 24),
            _Option(icon: Icons.person, title: 'Compte Personnel', subtitle: 'Pour un profil individuel', onTap: () => Navigator.pop(context, _AccountChoice.personal)),
            const SizedBox(height: 16),
            _Option(icon: Icons.business, title: 'Compte Entreprise', subtitle: 'Pour une organisation', onTap: () => Navigator.pop(context, _AccountChoice.enterprise)),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;
  const _Option({required this.icon, required this.title, required this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(border: Border.all(color: ThixDesignSystem.primaryLight.withOpacity(0.2)), borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(width: 48, height: 48, decoration: BoxDecoration(color: ThixDesignSystem.primaryLight.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: ThixDesignSystem.primaryLight)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: ThixDesignSystem.textDark)),
              Text(subtitle, style: const TextStyle(fontSize: 13, color: ThixDesignSystem.textGrey)),
            ])),
            const Icon(Icons.arrow_forward_ios, size: 16, color: ThixDesignSystem.primaryLight),
          ],
        ),
      ),
    );
  }
}
