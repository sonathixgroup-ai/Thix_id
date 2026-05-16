import 'dart:async';

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

class THIXIDHomePage extends StatefulWidget {
  const THIXIDHomePage({super.key});

  @override
  State<THIXIDHomePage> createState() => _THIXIDHomePageState();
}

class _THIXIDHomePageState extends State<THIXIDHomePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _searching = false;
  final _notifications = NotificationService();
  final _counters = NotificationCountersService();
  final _uidRegex = RegExp(r'^[A-Za-z0-9_-]{20,}$');

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Recherche et vérification THIX ID
  Future<void> _verify() async {
    final raw = _searchController.text.trim();
    if (raw.isEmpty) {
      await FullScreenMessage.showError(
        context,
        title: 'Identifiant requis',
        message: 'Saisissez un THIX ID ou un UID.',
      );
      return;
    }
    final normalized = ThixIdService.normalize(raw);
    final isThix = normalized.startsWith('THIX-') && ThixIdService.isValid(normalized);
    final isUid = _uidRegex.hasMatch(raw);
    if (!isThix && !isUid) {
      await FullScreenMessage.showError(
        context,
        title: 'Format invalide',
        message: 'THIX ID ou UID incorrect.',
      );
      return;
    }

    setState(() => _searching = true);
    try {
      final service = FirestoreUserService();
      final user = isThix
          ? await service.fetchUserByThixId(normalized)
          : await service.fetchUserByUid(raw);
      if (!mounted) return;
      if (user == null) {
        await FullScreenMessage.showError(
          context,
          title: 'Profil introuvable',
          message: 'Aucun utilisateur trouvé.',
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
    } catch (_) {
      if (!mounted) return;
      await FullScreenMessage.showError(
        context,
        title: 'Erreur',
        message: 'Vérification impossible.',
      );
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  // Navigation Profil
  void _goProfile() {
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

  // Demande de compte
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
    final badgeStream = auth.currentUser == null
        ? Stream.value(SectionBadgeCounts.zero)
        : _counters.streamCounts(auth.currentUser!.id);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildScanActions(),
                const SizedBox(height: 16),
                _buildNotificationBanner(),
                const SizedBox(height: 24),
                _buildServicesSection(badgeStream),
                const SizedBox(height: 16),
                _buildMissionBanner(),
                const SizedBox(height: 100),
              ],
            ),
          ),
          // Barre de navigation basse fixe
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavigationBar(),
          ),
          if (_searching)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF1A52FF),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // 1. HEADER DIAGONAL AVEC RECHERCHE ATTACHÉE
  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 260,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF002DCC), Color(0xFF001C80)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.fingerprint,
                            color: Colors.white, size: 28),
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
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            'Identité Sécurisée. Avenir de Confiance.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _goProfile,
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 22,
                      child: Icon(Icons.person,
                          color: Color(0xFF001C80), size: 26),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const Text(
                'Bienvenue !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Que voulez-vous faire aujourd\'hui ?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        // Barre de recherche flottante
        Positioned(
          bottom: -24,
          left: 20,
          right: 20,
          child: Container(
            height: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: Colors.grey, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    enabled: !_searching,
                    decoration: const InputDecoration(
                      hintText: 'Rechercher un THIX ID...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _searching ? null : _verify,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A52FF),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      children: [
                        Text(
                          'Vérifier',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward,
                            color: Colors.white, size: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // 2. CARTES QR / NFC
  Widget _buildScanActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildScanCard(
              'Scanner un QR',
              'Scannez un code\nen toute sécurité',
              Icons.qr_code_scanner,
              const Color(0xFFEBF0FF),
              const Color(0xFF1A52FF),
              onTap: () => ThixIdentitySheets.showQrScanSheet(context),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildScanCard(
              'Lire via NFC',
              'Approchez votre\nappareil',
              Icons.nfc,
              const Color(0xFFEEFBF4),
              const Color(0xFF27AE60),
              onTap: () => ThixIdentitySheets.showNfcScanSheet(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanCard(String title, String subtitle, IconData icon,
      Color iconBg, Color accentColor, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
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
                color: iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 24),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.bottomRight,
              child: CircleAvatar(
                radius: 12,
                backgroundColor: accentColor,
                child: const Icon(Icons.arrow_forward,
                    color: Colors.white, size: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. NOTIFICATIONS BANNER
  Widget _buildNotificationBanner() {
    final auth = context.read<AuthController>();
    return GestureDetector(
      onTap: () {
        if (!auth.isAuthenticated) {
          context.push(AppRoutes.login);
        } else {
          NotificationsSheet.show(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF1A52FF),
                    radius: 20,
                    child: Icon(Icons.notifications, color: Colors.white, size: 20),
                  ),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Restez informé de vos activités et mises à jour.',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: const [
                  Text(
                    'Voir tout',
                    style: TextStyle(
                      color: Color(0xFF001C80),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.chevron_right,
                      color: Color(0xFF001C80), size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 4. GRILLE NOS SERVICES (4x2)
  Widget _buildServicesSection(Stream<SectionBadgeCounts> badgeStream) {
    final List<Map<String, dynamic>> services = [
      {'title': 'Demander un\nCompte', 'icon': Icons.person_add, 'color': const Color(0xFFEBF0FF), 'iconColor': const Color(0xFF1A52FF), 'tap': _requestAccount},
      {'title': 'Mon\nCompte', 'icon': Icons.person, 'color': const Color(0xFFF3E8FF), 'iconColor': const Color(0xFF9333EA), 'tap': _goProfile},
      {'title': 'Formations', 'icon': Icons.school, 'color': const Color(0xFFEEFBF4), 'iconColor': const Color(0xFF27AE60), 'tap': () => context.push(AppRoutes.trainingHome)},
      {'title': 'Emplois', 'icon': Icons.work, 'color': const Color(0xFFFFF2E6), 'iconColor': const Color(0xFFF97316), 'tap': () => context.push(AppRoutes.jobs)},
      {'title': 'THIX\nINFO', 'icon': Icons.assignment, 'color': const Color(0xFFE6F7FF), 'iconColor': const Color(0xFF0369A1), 'tap': () => AlertInfoSheet.show(context)},
      {'title': 'Opportunités', 'icon': Icons.lightbulb, 'color': const Color(0xFFFEFCE8), 'iconColor': const Color(0xFFCA8A04), 'tap': () => context.push(AppRoutes.opportunities)},
      {'title': 'Événements', 'icon': Icons.calendar_month, 'color': const Color(0xFFFCE7F3), 'iconColor': const Color(0xFFDB2777), 'tap': () => context.push(AppRoutes.events)},
      {'title': 'Réseau\nPro', 'icon': Icons.group, 'color': const Color(0xFFFFEAEA), 'iconColor': const Color(0xFFEF4444), 'tap': () => context.push(AppRoutes.network)},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Nos services',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF001C80),
                ),
              ),
              Row(
                children: const [
                  Text('Tout voir', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          StreamBuilder<SectionBadgeCounts>(
            stream: badgeStream,
            builder: (context, snap) {
              final counts = snap.data ?? SectionBadgeCounts.zero;
              // Associer les badges dynamiques aux services concernés
              final badgeList = [
                0, // Demander
                0, // Mon compte
                counts.formations, // Formations
                counts.jobs, // Emplois
                counts.info, // THIX INFO
                counts.opportunities, // Opportunités
                counts.events, // Événements
                0, // Réseau Pro
              ];
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.82,
                ),
                itemBuilder: (context, index) {
                  final s = services[index];
                  final badge = badgeList[index];
                  return GestureDetector(
                    onTap: s['tap'] as VoidCallback,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.01),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                backgroundColor: s['color'],
                                radius: 20,
                                child: Icon(s['icon'],
                                    color: s['iconColor'], size: 18),
                              ),
                              if (badge > 0)
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 14,
                                      minHeight: 14,
                                    ),
                                    child: Text(
                                      badge > 99 ? '99+' : '$badge',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            s['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              height: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // 5. BANNIÈRE MISSION
  Widget _buildMissionBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF002DCC), Color(0xFF001A7A)],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NOTRE MISSION',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Construisons ensemble l\'avenir de la jeunesse.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Accédez à des opportunités, des ressources et un réseau engagé.',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                height: 90,
                alignment: Alignment.centerRight,
                child: const Icon(Icons.people_alt,
                    size: 70, color: Colors.white24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 6. BOTTOM NAVIGATION BAR AVEC BOUTON SCAN CENTRAL
  Widget _buildBottomNavigationBar() {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Accueil', true),
          _buildNavItem(Icons.grid_view, 'Services', false),
          Transform.translate(
            offset: const Offset(0, -10),
            child: GestureDetector(
              onTap: () => ThixIdentitySheets.showQrScanSheet(context),
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: Color(0xFF1A52FF),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x4D1A52FF),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.qr_code_scanner,
                    color: Colors.white, size: 26),
              ),
            ),
          ),
          _buildNavItem(Icons.chat_bubble_outline, 'Messages', false,
              onTap: () {
            final auth = context.read<AuthController>();
            if (auth.isAuthenticated) {
              context.push(AppRoutes.chat);
            } else {
              context.push(AppRoutes.login);
            }
          }),
          _buildNavItem(Icons.person_outline, 'Profil', false,
              onTap: _goProfile),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF1A52FF) : Colors.grey,
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: isActive ? const Color(0xFF1A52FF) : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 2),
            Container(
              width: 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Color(0xFF1A52FF),
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ===== COMPOSANT POUR LA FEUILLE DE DEMANDE DE COMPTE =====
enum _AccountChoice { personal, enterprise }

class _AccountSheet extends StatelessWidget {
  const _AccountSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            const Text(
              'Créer un compte',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            _OptionButton(
              icon: Icons.person,
              title: 'Compte Personnel',
              subtitle: 'Pour un profil individuel',
              onTap: () => Navigator.pop(context, _AccountChoice.personal),
            ),
            const SizedBox(height: 16),
            _OptionButton(
              icon: Icons.business,
              title: 'Compte Entreprise',
              subtitle: 'Pour une organisation',
              onTap: () => Navigator.pop(context, _AccountChoice.enterprise),
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
            color: const Color(0xFF1A52FF).withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF1A52FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF1A52FF)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 16, color: Color(0xFF1A52FF)),
          ],
        ),
      ),
    );
  }
}
