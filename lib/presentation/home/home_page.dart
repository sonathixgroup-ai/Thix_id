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

<<<<<<< Updated upstream
import 'package:thix_id/l10n/app_localizations.dart';
import 'package:thix_id/l10n/locale_controller.dart';

/// Premium color palette for THIX ID - Premium Startup 2026
class ThixPremiumColors {
  // Primary colors
  static const Color primaryDark = Color(0xFF071B8C);
  static const Color primaryElectric = Color(0xFF2E5BFF);
  
  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF6F8FC);
  static const Color grayDark = Color(0xFF1A1A2E);
  static const Color grayMedium = Color(0xFF6C6C7A);
  static const Color grayLight = Color(0xFF9AA0B5);
  
  // Accent colors
  static const Color mintLight = Color(0xFFCFF7E8);
  static const Color lavenderLight = Color(0xFFEEE7FF);
  static const Color peachLight = Color(0xFFFFE9D6);
  
  // Vibrant accents
  static const Color greenVibrant = Color(0xFF10B981);
  static const Color orangeVibrant = Color(0xFFF97316);
  static const Color purpleVibrant = Color(0xFFA78BFA);
  static const Color amberVibrant = Color(0xFFFCD34D);
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
=======
import '../../theme.dart';
import '../../nav.dart';

// ============================================================================
// PALETTE DE COULEURS PREMIUM
// ============================================================================

class PremiumColors {
  static const Color primaryDark = Color(0xFF071B8C);
  static const Color primaryElectric = Color(0xFF2E5BFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF6F8FC);
  static const Color mintLight = Color(0xFFCFF7E8);
  static const Color lavenderLight = Color(0xFFEEE7FF);
  static const Color peachLight = Color(0xFFFFE9D6);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6C6C7A);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
}

// ============================================================================
// EXTENSIONS UTILES
// ============================================================================

extension ThemeHelper on BuildContext {
  ThemeData get theme => Theme.of(this);
}

extension TextStyleHelper on BuildContext {
  TextTheme get textStyles => Theme.of(this).textTheme;
}

extension LocaleHelper on BuildContext {
  AppLocalizations get loc => AppLocalizations.of(this)!;
}

// ============================================================================
// PAGE HOME PRINCIPALE
// ============================================================================

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  // Contrôleurs et états
  final TextEditingController _searchController = TextEditingController();
  bool _searching = false;
  bool _isLoading = false;
  int _currentNavIndex = 0;
  
  // Services
  final NotificationService _notifications = NotificationService();
  final NotificationCountersService _counters = NotificationCountersService();
  final _uidLikeRegex = RegExp(r'^[A-Za-z0-9_\-]{20,}$');
  
  // Animation
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
>>>>>>> Stashed changes

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
<<<<<<< Updated upstream
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();
=======
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _animationController.forward();
>>>>>>> Stashed changes
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

<<<<<<< Updated upstream
  Future<void> _handleHomeSearchVerify() async {
=======
  // ==========================================================================
  // MÉTHODES DE RECHERCHE ET VÉRIFICATION
  // ==========================================================================

  Future<void> _handleSearch() async {
>>>>>>> Stashed changes
    final raw = _searchController.text.trim();

    if (raw.isEmpty) {
      await FullScreenMessage.showError(
        context,
        title: 'Identifiant requis',
<<<<<<< Updated upstream
        message: "Saisissez un THIX ID puis appuyez sur Vérifier.",
=======
        message: "Saisissez un THIX ID (ex: ${ThixIdService.exampleV2}) ou un UID.",
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        message: 'Format THIX ID incorrect.',
=======
        message: 'Format attendu: THIX-XXXXXX ou UID valide.',
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
          message: "Aucun profil trouvé.",
=======
          message: "Aucun profil trouvé pour: ${normalized.toUpperCase()}.",
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        message: "Impossible d'effectuer la vérification.",
      );
    } finally {
      if (mounted) {
        setState(() => _searching = false);
      }
=======
        message: 'Impossible de vérifier l\'identifiant: $e',
      );
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  // ==========================================================================
  // GESTION DES COMPTES
  // ==========================================================================

  Future<void> _handleRequestAccount() async {
    final auth = context.read<AuthController>();
    final choice = await showModalBottomSheet<_AccountRequestChoice>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const AccountRequestSheet(),
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

  // ==========================================================================
  // NAVIGATION
  // ==========================================================================

  void _onMessagesTap() {
    final auth = context.read<AuthController>();
    if (auth.isAuthenticated) {
      final me = auth.currentUser;
      if (me != null) {
        unawaited(_counters.markSectionSeen(uid: me.id, section: ThixSection.messages));
      }
      context.push(AppRoutes.chat);
    } else {
      context.push(AppRoutes.login);
>>>>>>> Stashed changes
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

<<<<<<< Updated upstream
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
=======
  void _onServicesTap() {
    // Scroll automatique vers la section services
    // Implémentation simplifiée
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Section services'), duration: Duration(seconds: 1)),
    );
>>>>>>> Stashed changes
  }

  void _onEmergencyTap() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: const Text('⚠️ Alerte d\'urgence'),
        content: const Text('Cette action enverra une notification à vos contacts d\'urgence. Confirmez-vous ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Alerte d\'urgence envoyée !'),
                  backgroundColor: Colors.redAccent,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
  }

  // ==========================================================================
  // BUILD
  // ==========================================================================

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final safeTop = MediaQuery.paddingOf(context).top;
    final badgeCountsStream = auth.currentUser == null
        ? Stream.value(SectionBadgeCounts.zero)
        : _counters.streamCounts(auth.currentUser!.id);
<<<<<<< Updated upstream

    return Scaffold(
      backgroundColor: ThixPremiumColors.backgroundLight,
      extendBody: true,
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            onNotification: (notification) {
              if (notification is ScrollUpdateNotification) {
                setState(() {
                  _scrollOffset = notification.metrics.pixels;
                });
              }
              return false;
            },
            slivers: [
              /// Premium Header Section
              SliverToBoxAdapter(
                child: _PremiumHeader(
                  safeTop: safeTop,
                  onProfileTap: _onProfileTap,
                ),
              ),

              /// Spacer
              const SliverToBoxAdapter(
                child: SizedBox(height: 58),
              ),

              /// Quick Action Cards (QR & NFC)
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
                          backgroundColor: ThixPremiumColors.lavenderLight,
                          iconColor: ThixPremiumColors.primaryElectric,
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
                          backgroundColor: ThixPremiumColors.mintLight,
                          iconColor: ThixPremiumColors.greenVibrant,
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

              /// Notification Preview Card
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
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: ThixPremiumColors.grayDark,
                          letterSpacing: -0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
                          'Tout voir',
                          style: TextStyle(
                            color: ThixPremiumColors.primaryElectric,
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

              /// Services Grid (2x4)
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
                          iconBackgroundColor: const Color(0xFFF0F4FF),
                          iconColor: ThixPremiumColors.primaryElectric,
                          onTap: () => _handleRequestAccount(context),
                        ),
                        _ServiceCard(
                          icon: Icons.account_circle,
                          title: 'Mon\nCompte',
                          iconBackgroundColor: const Color(0xFFF5ECFF),
                          iconColor: ThixPremiumColors.purpleVibrant,
                          onTap: _onProfileTap,
                        ),
                        _ServiceCard(
                          icon: Icons.school,
                          title: 'Formations',
                          iconBackgroundColor: const Color(0xFFE8FFF5),
                          iconColor: ThixPremiumColors.greenVibrant,
                          badgeCount: counts.formations,
                          onTap: () => context.push(AppRoutes.trainingHome),
                        ),
                        _ServiceCard(
                          icon: Icons.work,
                          title: 'Emplois',
                          iconBackgroundColor: const Color(0xFFFFF4E9),
                          iconColor: ThixPremiumColors.orangeVibrant,
                          badgeCount: counts.jobs,
                          onTap: () => context.push(AppRoutes.jobs),
                        ),
                        _ServiceCard(
                          icon: Icons.newspaper,
                          title: 'THIX\nINFO',
                          iconBackgroundColor: const Color(0xFFEFF3FF),
                          iconColor: ThixPremiumColors.primaryElectric,
                          badgeCount: counts.info,
                          onTap: () => AlertInfoSheet.show(context),
                        ),
                        _ServiceCard(
                          icon: Icons.lightbulb_rounded,
                          title: 'Opportunités',
                          iconBackgroundColor: const Color(0xFFFFF8E8),
                          iconColor: ThixPremiumColors.amberVibrant,
                          badgeCount: counts.opportunities,
                          onTap: () =>
                              context.push(AppRoutes.opportunities),
                        ),
                        _ServiceCard(
                          icon: Icons.event,
                          title: 'Événements',
                          iconBackgroundColor: const Color(0xFFF8ECFF),
                          iconColor: ThixPremiumColors.purpleVibrant,
                          badgeCount: counts.events,
                          onTap: () => context.push(AppRoutes.events),
                        ),
                        _ServiceCard(
                          icon: Icons.groups,
                          title: 'Réseau\nPro',
                          iconBackgroundColor: const Color(0xFFFFEEF5),
                          iconColor: Colors.pink,
                          onTap: () => context.push(AppRoutes.network),
                        ),
                      ]),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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

              /// Mission Banner
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverToBoxAdapter(
                  child: _MissionBanner(),
                ),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),

          /// Search Bar Overlay
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

          /// Loading Overlay
          if (_searching)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.2),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: ThixPremiumColors.primaryElectric,
                  ),
                ),
              ),
=======
    final safeTop = MediaQuery.paddingOf(context).top;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isSmall = screenWidth < 380;

    return Scaffold(
      backgroundColor: PremiumColors.backgroundLight,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: Stack(
          children: [
            // =================================================================
            // CONTENU PRINCIPAL SCROLLABLE
            // =================================================================
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // =============================================================
                // HEADER PREMIUM AVEC GRADIENT
                // =============================================================
                SliverToBoxAdapter(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [PremiumColors.primaryDark, PremiumColors.primaryElectric],
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(32),
                        bottomRight: Radius.circular(32),
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Éléments décoratifs
                        _buildDecorativeCircles(),
                        _buildFingerprintDecoration(),
                        _buildAbstractShapes(),
                        
                        Padding(
                          padding: EdgeInsets.only(top: safeTop + 12, left: 20, right: 20, bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Ligne logo + avatar
                              _buildHeaderRow(isSmall),
                              const SizedBox(height: 28),
                              
                              // Zone Hero
                              _buildHeroSection(isSmall),
                              const SizedBox(height: 20),
                              
                              // Barre de recherche flottante
                              _buildSearchBar(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                
                // =============================================================
                // CARTES ACTION: SCANNER QR & LIRE NFC (côte à côte)
                // =============================================================
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Expanded(
                          child: _PremiumActionCard(
                            icon: Icons.qr_code_scanner_rounded,
                            title: 'Scanner un QR',
                            subtitle: 'Scannez un code en toute sécurité',
                            bgColor: PremiumColors.mintLight,
                            iconColor: const Color(0xFF059669),
                            onTap: () => ThixIdentitySheets.showQrScanSheet(context),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _PremiumActionCard(
                            icon: Icons.nfc_rounded,
                            title: 'Lire via NFC',
                            subtitle: 'Approchez votre appareil',
                            bgColor: PremiumColors.lavenderLight,
                            iconColor: const Color(0xFF7C3AED),
                            onTap: () => ThixIdentitySheets.showNfcScanSheet(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
                
                // =============================================================
                // SECTION NOTIFICATIONS
                // =============================================================
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _PremiumNotificationsCard(
                      isAuthenticated: auth.isAuthenticated,
                      notifications: _notifications.streamForHome(uid: auth.currentUser?.id),
                      onSeeMore: () {
                        if (!auth.isAuthenticated) {
                          context.push(AppRoutes.login);
                        } else {
                          NotificationsSheet.show(context);
                        }
                      },
                      onMarkRead: (id) {
                        final me = auth.currentUser;
                        if (me != null) _notifications.markRead(uid: me.id, notificationId: id);
                      },
                      onOpen: (notif) async {
                        if (!auth.isAuthenticated) {
                          context.push(AppRoutes.login);
                          return;
                        }
                        final me = auth.currentUser;
                        if (me == null) return;
                        final type = (notif['type'] ?? '').toString().toLowerCase();
                        if (type.contains('message')) {
                          await _counters.markSectionSeen(uid: me.id, section: ThixSection.messages);
                          if (context.mounted) context.push(AppRoutes.chat);
                        }
                      },
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                
                // =============================================================
                // SECTION NOS SERVICES (GRILLE 2x4)
                // =============================================================
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildServicesHeader(),
                        const SizedBox(height: 16),
                        StreamBuilder<SectionBadgeCounts>(
                          stream: badgeStream,
                          builder: (context, snap) {
                            final counts = snap.data ?? SectionBadgeCounts.zero;
                            return _buildServicesGrid(counts);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                
                // =============================================================
                // SECTION MISSION
                // =============================================================
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverToBoxAdapter(
                    child: _buildMissionSection(),
                  ),
                ),
                
                const SliverToBoxAdapter(child: SizedBox(height: 100)),
              ],
            ),
            
            // =================================================================
            // BOUTONS FLOTTANTS (URGENCE + CHAT)
            // =================================================================
            Positioned(
              bottom: 85,
              left: 16,
              child: _buildEmergencyButton(),
            ),
            Positioned(
              bottom: 85,
              right: 16,
              child: _buildChatButton(),
            ),
            
            // =================================================================
            // INDICATEUR DE CHARGEMENT
            // =================================================================
            if (_searching)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
      
      // =====================================================================
      // BOTTOM NAVIGATION BAR (Accueil | Services | Messages | Profil)
      // =====================================================================
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // ==========================================================================
  // MÉTHODES DE CONSTRUCTION (UI)
  // ==========================================================================

  Widget _buildDecorativeCircles() {
    return Stack(
      children: [
        Positioned(
          top: 30,
          right: -20,
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
            ),
          ),
        ),
        Positioned(
          bottom: -30,
          left: -30,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.03),
            ),
          ),
        ),
        Positioned(
          top: 100,
          left: 30,
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
          ),
        ),
        Positioned(
          bottom: 50,
          right: 60,
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
          ),
        ),
      ],
    );
  }

  Widget _buildFingerprintDecoration() {
    return Positioned(
      right: -10,
      bottom: 10,
      child: Icon(
        Icons.fingerprint,
        size: 120,
        color: Colors.white.withOpacity(0.06),
      ),
    );
  }

  Widget _buildAbstractShapes() {
    return Positioned(
      top: 80,
      right: -50,
      child: Transform.rotate(
        angle: -0.3,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderRow(bool isSmall) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'THIX ID',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Identité Sécurisée. Avenir de Confiance.',
              style: TextStyle(
                fontSize: isSmall ? 9 : 10,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _onProfileTap,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.15),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: const Icon(Icons.person_outline, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildHeroSection(bool isSmall) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bienvenue !',
          style: TextStyle(
            fontSize: isSmall ? 28 : 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Que voulez-vous faire aujourd’hui ?',
          style: TextStyle(
            fontSize: isSmall ? 13 : 15,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: PremiumColors.textSecondary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => _searching ? null : _handleSearch(),
              decoration: const InputDecoration(
                hintText: 'Rechercher un THIX ID...',
                hintStyle: TextStyle(fontSize: 13),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: _searching ? null : _handleSearch,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [PremiumColors.primaryElectric, PremiumColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text(
                'Vérifier',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Nos services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: PremiumColors.textPrimary,
          ),
        ),
        TextButton(
          onPressed: _onServicesTap,
          style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30)),
          child: const Text(
            'Tout voir >',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildServicesGrid(SectionBadgeCounts counts) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
      childAspectRatio: 0.95,
      children: [
        _ServiceCard(
          title: 'Demander un Compte',
          icon: Icons.person_add_alt_1,
          gradient: const [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          iconColor: Colors.white,
          onTap: _handleRequestAccount,
        ),
        _ServiceCard(
          title: 'Mon Compte',
          icon: Icons.account_circle,
          gradient: const [Color(0xFF10B981), Color(0xFF059669)],
          iconColor: Colors.white,
          onTap: _onProfileTap,
        ),
        _ServiceCard(
          title: 'Formations',
          icon: Icons.school_rounded,
          badge: counts.formations,
          onTap: () => context.push(AppRoutes.trainingHome),
        ),
        _ServiceCard(
          title: 'Emplois',
          icon: Icons.work_rounded,
          badge: counts.jobs,
          onTap: () => context.push(AppRoutes.jobs),
        ),
        _ServiceCard(
          title: 'THIX INFO',
          icon: Icons.newspaper_rounded,
          badge: counts.info,
          onTap: () => AlertInfoSheet.show(context),
        ),
        _ServiceCard(
          title: 'Opportunités',
          icon: Icons.lightbulb_rounded,
          badge: counts.opportunities,
          onTap: () => context.push(AppRoutes.opportunities),
        ),
        _ServiceCard(
          title: 'Événements',
          icon: Icons.event_rounded,
          badge: counts.events,
          onTap: () => context.push(AppRoutes.events),
        ),
        _ServiceCard(
          title: 'Réseau Pro',
          icon: Icons.groups_rounded,
          onTap: () => context.push(AppRoutes.network),
        ),
      ],
    );
  }

  Widget _buildMissionSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [PremiumColors.primaryDark, PremiumColors.primaryElectric],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'NOTRE MISSION',
                  style: TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.2,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Construisons ensemble l’avenir de la jeunesse.',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Accédez à des opportunités, des ressources et un réseau engagé.',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.12),
>>>>>>> Stashed changes
            ),
            child: const Icon(
              Icons.diversity_3_rounded,
              size: 32,
              color: Colors.white,
            ),
          ),
        ],
      ),
<<<<<<< Updated upstream

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

/// Premium Header with gradient, decorative elements
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
        /// Gradient Background
        Container(
          height: 280,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                ThixPremiumColors.primaryDark,
                ThixPremiumColors.primaryElectric,
              ],
              stops: [0.0, 1.0],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(48),
              bottomRight: Radius.circular(48),
            ),
          ),
        ),

        /// Decorative Circles
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

        /// Fingerprint Background Effect
        Positioned(
          right: -30,
          bottom: -20,
          child: Icon(
            Icons.fingerprint_rounded,
            size: 200,
            color: Colors.white.withOpacity(0.06),
          ),
        ),

        /// Decorative Dots
        Positioned(
          right: 90,
          top: 80,
          child: Column(
            children: List.generate(
              10,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                  ),
                ),
              ),
            ),
          ),
        ),

        /// Content
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
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.7),
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.fingerprint_rounded,
                          color: Colors.white,
                          size: 38,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'THIX ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Identité Sécurisée.\nAvenir de Confiance.',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.88),
                              fontSize: 12,
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
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ThixPremiumColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        color: ThixPremiumColors.primaryDark,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              /// Hero Text
              const Text(
                'Bienvenue !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.2,
                  height: 1.1,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Que voulez-vous faire aujourd'hui ?',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.92),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Modern Search Bar with floating effect
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
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: ThixPremiumColors.white,
        borderRadius: BorderRadius.circular(38),
        boxShadow: [
          BoxShadow(
            color: ThixPremiumColors.primaryElectric.withOpacity(0.15),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(
            Icons.search_rounded,
            color: Color(0xFF9AA0B5),
            size: 28,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextField(
              controller: widget.controller,
              enabled: !widget.isSearching,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Rechercher un THIX ID…',
                hintStyle: TextStyle(
                  color: Color(0xFFA8ADB8),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              style: const TextStyle(
                color: ThixPremiumColors.grayDark,
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
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
                gradient: const LinearGradient(
                  colors: [
                    ThixPremiumColors.primaryElectric,
                    ThixPremiumColors.primaryDark,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: ThixPremiumColors.primaryElectric.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Text(
                    'Vérifier',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
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

/// Quick Action Card (QR & NFC)
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _controller.forward();
  }

  void _onTapUp(_) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

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
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  widget.icon,
                  color: widget.iconColor,
                  size: 32,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: ThixPremiumColors.grayDark,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                widget.subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: ThixPremiumColors.grayMedium,
                  height: 1.3,
                ),
=======
    );
  }

  Widget _buildEmergencyButton() {
    return GestureDetector(
      onTap: _onEmergencyTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.redAccent, Color(0xFFDC2626)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.redAccent.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  Widget _buildChatButton() {
    final auth = context.read<AuthController>();
    return StreamBuilder<int>(
      stream: auth.currentUser != null
          ? _notifications.streamUnreadCount(auth.currentUser!.id)
          : Stream.value(0),
      builder: (context, snapshot) {
        final unreadCount = snapshot.data ?? 0;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: _onMessagesTap,
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [PremiumColors.primaryElectric, PremiumColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 28),
              ),
            ),
            if (unreadCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                  child: Text(
                    unreadCount > 99 ? '99+' : '$unreadCount',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _BottomNavItem(
                icon: Icons.home_outlined,
                label: 'Accueil',
                isSelected: _currentNavIndex == 0,
                onTap: () {
                  setState(() => _currentNavIndex = 0);
                  // Déjà sur la page d'accueil
                },
              ),
              _BottomNavItem(
                icon: Icons.grid_view_rounded,
                label: 'Services',
                isSelected: _currentNavIndex == 1,
                onTap: () {
                  setState(() => _currentNavIndex = 1);
                  _onServicesTap();
                },
              ),
              _BottomNavItem(
                icon: Icons.message_outlined,
                label: 'Messages',
                isSelected: _currentNavIndex == 2,
                onTap: () {
                  setState(() => _currentNavIndex = 2);
                  _onMessagesTap();
                },
              ),
              _BottomNavItem(
                icon: Icons.person_outline,
                label: 'Profil',
                isSelected: _currentNavIndex == 3,
                onTap: () {
                  setState(() => _currentNavIndex = 3);
                  _onProfileTap();
                },
>>>>>>> Stashed changes
              ),
            ],
          ),
        ),
      ),
    );
  }
}

<<<<<<< Updated upstream
/// Notification Preview Card
class _NotificationPreviewCard extends StatelessWidget {
  final VoidCallback onTap;

  const _NotificationPreviewCard({required this.onTap});
=======
// ============================================================================
// WIDGET: CARTE ACTION PREMIUM (QR / NFC)
// ============================================================================

class _PremiumActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _PremiumActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });
>>>>>>> Stashed changes

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
<<<<<<< Updated upstream
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [
                    ThixPremiumColors.primaryElectric,
                    ThixPremiumColors.primaryDark,
                  ],
                ),
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ThixPremiumColors.grayDark,
=======
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, size: 22, color: iconColor),
                ),
                Icon(Icons.arrow_forward_rounded, size: 16, color: PremiumColors.textSecondary),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: PremiumColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                color: PremiumColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// WIDGET: CARTE SERVICE (GRILLE 2x4)
// ============================================================================

class _ServiceCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final int badge;
  final List<Color> gradient;
  final Color? iconColor;
  final VoidCallback onTap;

  const _ServiceCard({
    required this.title,
    required this.icon,
    this.badge = 0,
    this.gradient = const [Colors.white, Colors.white],
    this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradient),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, size: 26, color: iconColor ?? PremiumColors.primaryElectric),
                ),
                if (badge > 0)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                      child: Text(
                        badge > 99 ? '99+' : '$badge',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
>>>>>>> Stashed changes
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Vous avez de nouvelles mises à jour',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: ThixPremiumColors.grayMedium,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: ThixPremiumColors.primaryElectric,
            ),
<<<<<<< Updated upstream
=======
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: PremiumColors.textPrimary,
              ),
            ),
>>>>>>> Stashed changes
          ],
        ),
      ),
    );
  }
}

<<<<<<< Updated upstream
/// Service Card (2x4 Grid)
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(_) {
    _controller.forward();
  }

  void _onTapUp(_) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
  }

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
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
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
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: ThixPremiumColors.grayDark,
                      height: 1.2,
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
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: ThixPremiumColors.primaryElectric,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${widget.badgeCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
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

/// Mission Banner
class _MissionBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            ThixPremiumColors.primaryDark,
            ThixPremiumColors.primaryElectric,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: ThixPremiumColors.primaryElectric.withOpacity(0.2),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          /// Decorative Element
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          /// Content
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'NOTRE MISSION',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Construisons ensemble\nl'avenir de la jeunesse.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Accédez à des opportunités,\ndes ressources et un réseau engagé.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                Icons.groups_rounded,
                size: 100,
                color: Colors.white.withOpacity(0.9),
              ),
            ],
          ),
=======
// ============================================================================
// WIDGET: CARTE NOTIFICATIONS PREMIUM
// ============================================================================

class _PremiumNotificationsCard extends StatelessWidget {
  final bool isAuthenticated;
  final Stream<List<Map<String, dynamic>>>? notifications;
  final VoidCallback onSeeMore;
  final void Function(String) onMarkRead;
  final void Function(Map<String, dynamic>) onOpen;

  const _PremiumNotificationsCard({
    required this.isAuthenticated,
    required this.notifications,
    required this.onSeeMore,
    required this.onMarkRead,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_rounded,
                  color: Color(0xFF3B82F6),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Notifications',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: PremiumColors.textPrimary,
                  ),
                ),
              ),
              TextButton(
                onPressed: onSeeMore,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  'Voir tout >',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!isAuthenticated)
            const Text(
              'Connectez-vous pour voir vos notifications.',
              style: TextStyle(fontSize: 13, color: PremiumColors.textSecondary),
            )
          else
            StreamBuilder<List<Map<String, dynamic>>>(
              stream: notifications,
              builder: (context, snap) {
                final rows = snap.data ?? [];
                if (rows.isEmpty) {
                  return const Text(
                    'Aucune notification récente.',
                    style: TextStyle(fontSize: 13, color: PremiumColors.textSecondary),
                  );
                }
                final first = rows.first;
                final title = (first['title'] ?? '') as String;
                final body = (first['body'] ?? '') as String;
                final read = (first['read'] ?? false) as bool;
                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: read ? FontWeight.w500 : FontWeight.w700,
                              color: PremiumColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            body,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: PremiumColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!read)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: PremiumColors.primaryElectric,
                          shape: BoxShape.circle,
                        ),
                      ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        final id = (first['id'] ?? '').toString();
                        if (!read) onMarkRead(id);
                        onOpen(first);
                      },
                      child: const Icon(
                        Icons.chevron_right,
                        size: 18,
                        color: PremiumColors.textSecondary,
                      ),
                    ),
                  ],
                );
              },
            ),
>>>>>>> Stashed changes
        ],
      ),
    );
  }
}

<<<<<<< Updated upstream
/// Floating Bottom Navigation
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
            color: ThixPremiumColors.white.withOpacity(0.93),
            borderRadius: BorderRadius.circular(40),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 32,
                offset: const Offset(0, 12),
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
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        ThixPremiumColors.primaryElectric,
                        ThixPremiumColors.primaryDark,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                            ThixPremiumColors.primaryElectric.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: Colors.white,
                    size: 28,
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
=======
// ============================================================================
// WIDGET: BOTTOM NAVIGATION ITEM
// ============================================================================

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isSelected = false,
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
            color: active
                ? ThixPremiumColors.primaryElectric
                : ThixPremiumColors.grayMedium,
            size: 24,
=======
            size: 24,
            color: isSelected ? PremiumColors.primaryElectric : PremiumColors.textSecondary,
>>>>>>> Stashed changes
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
<<<<<<< Updated upstream
              fontWeight: FontWeight.w600,
              color: active
                  ? ThixPremiumColors.primaryElectric
                  : ThixPremiumColors.grayMedium,
=======
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: isSelected ? PremiumColors.primaryElectric : PremiumColors.textSecondary,
>>>>>>> Stashed changes
            ),
          ),
        ],
      ),
    );
  }
}

<<<<<<< Updated upstream
/// Account Request Bottom Sheet
=======
// ============================================================================
// FEUILLES MODALES POUR DEMANDE DE COMPTE
// ============================================================================

enum _AccountRequestChoice { personal, enterprise }

>>>>>>> Stashed changes
class AccountRequestSheet extends StatelessWidget {
  const AccountRequestSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
<<<<<<< Updated upstream
        color: ThixPremiumColors.white,
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
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: ThixPremiumColors.grayDark,
              ),
            ),
            const SizedBox(height: 24),
            _OptionButton(
              icon: Icons.person,
              title: 'Compte Personnel',
              subtitle: 'Pour un profil individuel',
              onTap: () {
                Navigator.pop(context, _AccountRequestChoice.personal);
              },
            ),
            const SizedBox(height: 16),
            _OptionButton(
              icon: Icons.business,
              title: 'Compte Entreprise',
              subtitle: 'Pour une organisation',
              onTap: () {
                Navigator.pop(context, _AccountRequestChoice.enterprise);
              },
            ),
            const SizedBox(height: 24),
          ],
=======
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Demander un compte',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Choisissez le type de compte que vous souhaitez créer.',
                style: TextStyle(color: PremiumColors.textSecondary),
              ),
              const SizedBox(height: 24),
              _AccountChoiceTile(
                icon: Icons.person_outline,
                title: 'Compte Personnel',
                subtitle: 'Pour les citoyens, étudiants, particuliers',
                onTap: () => context.pop(_AccountRequestChoice.personal),
              ),
              const SizedBox(height: 12),
              _AccountChoiceTile(
                icon: Icons.business_outlined,
                title: 'Compte Entreprise',
                subtitle: 'Pour les institutions, sociétés, ONG',
                onTap: () => context.pop(_AccountRequestChoice.enterprise),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.pop(),
                child: const Text('Annuler'),
              ),
            ],
          ),
>>>>>>> Stashed changes
        ),
      ),
    );
  }
}

<<<<<<< Updated upstream
class _OptionButton extends StatelessWidget {
=======
class _AccountChoiceTile extends StatelessWidget {
>>>>>>> Stashed changes
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

<<<<<<< Updated upstream
  const _OptionButton({
=======
  const _AccountChoiceTile({
>>>>>>> Stashed changes
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
<<<<<<< Updated upstream
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: ThixPremiumColors.primaryElectric.withOpacity(0.2),
          ),
          borderRadius: BorderRadius.circular(16),
=======
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: PremiumColors.backgroundLight,
          borderRadius: BorderRadius.circular(20),
>>>>>>> Stashed changes
        ),
        child: Row(
          children: [
            Container(
<<<<<<< Updated upstream
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: ThixPremiumColors.primaryElectric.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: ThixPremiumColors.primaryElectric,
              ),
            ),
            const SizedBox(width: 16),
=======
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: PremiumColors.primaryElectric, size: 22),
            ),
            const SizedBox(width: 14),
>>>>>>> Stashed changes
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
<<<<<<< Updated upstream
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ThixPremiumColors.grayDark,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: ThixPremiumColors.grayMedium,
=======
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: PremiumColors.textSecondary,
>>>>>>> Stashed changes
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
<<<<<<< Updated upstream
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: ThixPremiumColors.primaryElectric,
=======
              Icons.arrow_forward_ios,
              size: 14,
              color: PremiumColors.textSecondary,
>>>>>>> Stashed changes
            ),
          ],
        ),
      ),
    );
  }
}
