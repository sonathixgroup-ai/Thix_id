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

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Future<void> _requestAccount() async {
    final auth = context.read<AuthController>();
    final choice = await showModalBottomSheet<_AccountRequestChoice>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => const AccountRequestSheet(),
    );
    switch (choice) {
      case _AccountRequestChoice.personal:
        if (auth.isAuthenticated) await auth.signOut();
        if (context.mounted) context.push(AppRoutes.personalReg);
        break;
      case _AccountRequestChoice.enterprise:
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
          // Interface scannable et fixe
          SafeArea(
            bottom: false,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),
                  const SizedBox(height: 35), // Espace pour la barre attachée
                  _buildScanActions(),
                  const SizedBox(height: 14),
                  _buildNotificationBanner(),
                  const SizedBox(height: 18),
                  _buildServicesSection(badgeStream),
                  const SizedBox(height: 14),
                  _buildMissionBanner(),
                  const SizedBox(height: 100), // Empêche la bottom nav de cacher le contenu
                ],
              ),
            ),
          ),
          // Navigation basse fixe
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavigationBar(),
          ),
          // Indicateur de chargement plein écran
          if (_searching)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.25),
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

  // 1. HEADER INTEGRÉ AVEC BARRE DE RECHERCHE ATTACHÉE
  Widget _buildHeader(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF002DCC), Color(0xFF001C80)],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
          ),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
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
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.fingerprint, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'THIX ID',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                          ),
                          Text(
                            'Identité Sécurisée. Avenir de Confiance.',
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10),
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: _goProfile,
                    child: const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: Icon(Icons.person, color: Color(0xFF001C80), size: 22),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Bienvenue !',
                style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                'Que voulez-vous faire aujourd\'hui ?',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
              ),
            ],
          ),
        ),
        // Barre de recherche attachée et ajustée
        Positioned(
          bottom: -22,
          left: 20,
          right: 20,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              children: [
                const SizedBox(width: 12),
                const Icon(Icons.search, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    enabled: !_searching,
                    style: const TextStyle(fontSize: 14),
                    decoration: const InputDecoration(
                      hintText: 'Rechercher un THIX ID...',
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _searching ? null : _verify,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A52FF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Text('Vérifier', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, color: Colors.white, size: 12),
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

  // 2. BOUTONS COMPACTS SCAN & NFC (BANDES RÉDUITES)
  Widget _buildScanActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: _buildCompactScanCard(
              'Scanner un QR',
              'Scannez en sécurité',
              Icons.qr_code_scanner,
              const Color(0xFFEBF0FF),
              const Color(0xFF1A52FF),
              onTap: () => ThixIdentitySheets.showQrScanSheet(context),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildCompactScanCard(
              'Lire via NFC',
              'Approchez l\'appareil',
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

  Widget _buildCompactScanCard(String title, String subtitle, IconData icon, Color iconBg, Color accentColor, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: accentColor, size: 18),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                  Text(subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. BANNIÈRE DE NOTIFICATIONS
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
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFF1A52FF),
                    radius: 16,
                    child: Icon(Icons.notifications, color: Colors.white, size: 16),
                  ),
                  Positioned(
                    right: 1,
                    top: 1,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                    Text('Restez informé de vos activités.', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFF001C80), size: 16),
            ],
          ),
        ),
      ),
    );
  }

  // 4. GRILLE OPTIMISÉE SANS OVERFLOW (BORDURES DE 20PX)
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
              const Text('Nos services', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF001C80))),
              GestureDetector(
                onTap: () {},
                child: const Row(
                  children: [
                    Text('Tout voir', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Icon(Icons.chevron_right, size: 14, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          StreamBuilder<SectionBadgeCounts>(
            stream: badgeStream,
            builder: (context, snap) {
              final counts = snap.data ?? SectionBadgeCounts.zero;
              final badgeList = [0, 0, counts.formations, counts.jobs, counts.info, counts.opportunities, counts.events, 0];
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: services.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final s = services[index];
                  final badge = badgeList[index];
                  return GestureDetector(
                    onTap: s['tap'] as VoidCallback,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20), // Amélioré à 20px
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 1))],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                backgroundColor: s['color'],
                                radius: 18,
                                child: Icon(s['icon'], color: s['iconColor'], size: 16),
                              ),
                              if (badge > 0)
                                Positioned(
                                  right: -4,
                                  top: -4,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                                    constraints: const BoxConstraints(minWidth: 12, minHeight: 12),
                                    child: Text(
                                      badge > 99 ? '99+' : '$badge',
                                      style: const TextStyle(color: Colors.white, fontSize: 7, fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            s['title'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87, height: 1.1),
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

  // 5. BANNIÈRE MISSION COMPACTE
  Widget _buildMissionBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF002DCC), Color(0xFF001A7A)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NOTRE MISSION', style: TextStyle(color: Colors.white70, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                  const SizedBox(height: 4),
                  const Text('Construisons l\'avenir de la jeunesse.', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('Accédez à des opportunités et un réseau engagé.', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 10)),
                ],
              ),
            ),
            const Expanded(
              flex: 3,
              child: Icon(Icons.people_alt, size: 50, color: Colors.white24),
            ),
          ],
        ),
      ),
    );
  }

  // 6. BOTTOM NAVIGATION BAR AVEC THIX MONEY AU CENTRE
  Widget _buildBottomNavigationBar() {
    return Container(
      height: 74,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Accueil', true),
          _buildNavItem(Icons.grid_view, 'Services', false),
          // BOUTON CENTRAL SUBTILEMENT ADAPTÉ POUR THIX MONEY
          Transform.translate(
            offset: const Offset(0, -12),
            child: GestureDetector(
              onTap: () {
                // Insérer ici la route ou l'action financière THIX MONEY
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF002DCC), Color(0xFF1A52FF)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Color(0x331A52FF), blurRadius: 8, offset: Offset(0, 4))],
                    ),
                    child: const Icon(Icons.account_balance_wallet, color: Colors.white, size: 22), // Icône Money style
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'THIX MONEY',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF002DCC)),
                  ),
                ],
              ),
            ),
          ),
          _buildNavItem(Icons.chat_bubble_outline, 'Messages', false, onTap: () {
            final auth = context.read<AuthController>();
            if (auth.isAuthenticated) {
              context.push(AppRoutes.chat);
            } else {
              context.push(AppRoutes.login);
            }
          }),
          _buildNavItem(Icons.person_outline, 'Profil', false, onTap: _goProfile),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? const Color(0xFF1A52FF) : Colors.grey, size: 22),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFF1A52FF) : Colors.grey, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
          if (isActive) ...[
            const SizedBox(height: 2),
            Container(width: 4, height: 4, decoration: const BoxDecoration(color: Color(0xFF1A52FF), shape: BoxShape.circle)),
          ],
        ],
      ),
    );
  }
}

// ===== CLASSES ET MODALS CONSERVÉS =====
enum _AccountRequestChoice { personal, enterprise }

class AccountRequestSheet extends StatelessWidget {
  const AccountRequestSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            const Text('Créer un compte', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
            const SizedBox(height: 20),
            _OptionButton(
              icon: Icons.person,
              title: 'Compte Personnel',
              subtitle: 'Pour un profil individuel',
              onTap: () => Navigator.pop(context, _AccountRequestChoice.personal),
            ),
            const SizedBox(height: 12),
            _OptionButton(
              icon: Icons.business,
              title: 'Compte Entreprise',
              subtitle: 'Pour une organisation',
              onTap: () => Navigator.pop(context, _AccountRequestChoice.enterprise),
            ),
            const SizedBox(height: 16),
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF1A52FF).withOpacity(0.15)),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: const Color(0xFF1A52FF).withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: const Color(0xFF1A52FF), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                  Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF1A52FF)),
          ],
        ),
      ),
    );
  }
}
