import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thix_id/models/event_item.dart';
import 'package:thix_id/nav.dart';
import 'package:thix_id/services/event_service.dart';
import 'package:thix_id/theme.dart';

/// Couleurs premium officielles THIX ID / EVENTS
class PremiumColors {
  static const Color primaryDark = Color(0xFF071B8C);
  static const Color primaryElectric = Color(0xFF2E5BFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF6F8FC);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6C6C7A);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
}

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final _svc = EventService();
  final _search = TextEditingController();

  String _filter = 'Tous';
  bool _onlyOnline = false;
  bool _onlyPhysical = false;
  bool _onlyFree = false;
  bool _onlyPaid = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumColors.backgroundLight,
      body: SafeArea(
        child: Stack(
          children: [
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // 1. HEADER BANNER AVEC DÉGRADÉ PREMIUM
                SliverToBoxAdapter(
                  child: _PremiumHeader(
                    onOpenMyEvents: () => context.push('/events/me'),
                  ),
                ),

                // 2. RECHERCHE & FILTRES RAPIDES HIERARCHIQUES
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        _PremiumSearchBar(
                          controller: _search,
                          onOpenFilters: _openFilters,
                          onChanged: (_) => setState(() {}),
                        ),
                        const SizedBox(height: 20),
                        _PremiumFilterRow(
                          selected: _filter,
                          onChanged: (v) => setState(() => _filter = v),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3. CAROUSEL DES ÉVÉNEMENTS À LA UNE (GESTION DU PORTFOLIO AVEC DOTS)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                    child: _PremiumFeaturedSection(
                      service: _svc,
                      onOpen: (e) => context.push('/events/${e.id}'),
                      onRegister: (e) => context.push('/events/${e.id}/register'),
                      onJoinLive: (e) {
                        final link = (e.meetingLink ?? '').trim();
                        if (link.isEmpty) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Lien disponible sur la page détail.')),
                        );
                        context.push('/events/${e.id}');
                      },
                    ),
                  ),
                ),

                // 4. TITRE INTERMÉDIAIRE D'EXPLORATION DES FLUX
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        const Icon(Icons.explore_rounded, color: PremiumColors.gold),
                        const SizedBox(width: 8),
                        Text(
                          'Explorer',
                          style: context.textStyles.titleLarge?.copyWith(
                            color: PremiumColors.textPrimary,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 5. BANQUETTE DE DONNÉES FILTRÉES ET CHARGÉES DYNAMIQUEMENT SANS OVERFLOW
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 96), // Espace préservé pour le dock inférieur
                    child: FutureBuilder<List<EventItem>>(
                      future: _svc.listEvents(),
                      builder: (context, snap) {
                        if (snap.connectionState != ConnectionState.done) return const _PremiumLoadingGrid();
                        final all = snap.data ?? const <EventItem>[];
                        final filtered = _applyFilters(all);
                        if (filtered.isEmpty) return const _PremiumEmptyState();

                        return Column(
                          children: [
                            _PremiumEventsGrid(
                              title: 'À venir',
                              subtitle: 'Prochains événements premium',
                              events: filtered
                                  .where((e) => e.startsAt.isAfter(DateTime.now().subtract(const Duration(hours: 1))))
                                  .toList(growable: false),
                              onOpen: (e) => context.push('/events/${e.id}'),
                            ),
                            const SizedBox(height: 32),
                            _PremiumEventsGrid(
                              title: 'Tendances',
                              subtitle: 'Ce qui cartonne en ce moment',
                              events: filtered.take(6).toList(growable: false),
                              onOpen: (e) => context.push('/events/${e.id}'),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),

            // 6. PERSISTENT FLOATING BOTTOM NAV BAR (Z-INDEX SÉCURISÉ)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildCustomBottomNavBar(context),
            ),
          ],
        ),
      ),
    );
  }

  List<EventItem> _applyFilters(List<EventItem> input) {
    final q = _search.text.trim().toLowerCase();
    bool matchesQuery(EventItem e) =>
        q.isEmpty ||
        e.title.toLowerCase().contains(q) ||
        e.location.toLowerCase().contains(q) ||
        e.category.toLowerCase().contains(q);
    bool matchesCategory(EventItem e) =>
        _filter == 'Tous' || e.category.toLowerCase().contains(_filter.toLowerCase());
    bool matchesToggles(EventItem e) {
      if (_onlyOnline && e.eventType.toLowerCase() != 'online') return false;
      if (_onlyPhysical && e.eventType.toLowerCase() != 'physical') return false;
      if (_onlyFree && !e.isFree) return false;
      if (_onlyPaid && e.isFree) return false;
      return true;
    }

    final list = input
        .where((e) => matchesQuery(e) && matchesCategory(e) && matchesToggles(e) && e.status == 'published')
        .toList(growable: false);
    list.sort((a, b) => a.startsAt.compareTo(b.startsAt));
    return list;
  }

  Future<void> _openFilters() async {
    final res = await showModalBottomSheet<_FiltersResult>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _PremiumFiltersSheet(
        initial: _FiltersResult(
          onlyOnline: _onlyOnline,
          onlyPhysical: _onlyPhysical,
          onlyFree: _onlyFree,
          onlyPaid: _onlyPaid,
        ),
      ),
    );
    if (res == null) return;
    setState(() {
      _onlyOnline = res.onlyOnline;
      _onlyPhysical = res.onlyPhysical;
      _onlyFree = res.onlyFree;
      _onlyPaid = res.onlyPaid;
    });
  }

  Widget _buildCustomBottomNavBar(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, -4),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavBarItem(Icons.home_rounded, 'Accueil', true, () {}),
          _buildNavBarItem(Icons.search_rounded, 'Rechercher', false, () {}),
          Transform.translate(
            offset: const Offset(0, -12),
            child: GestureDetector(
              onTap: () => context.push('/events/me'),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: PremiumColors.primaryElectric,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x3D2E5BFF),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                    ),
                    child: Transform.rotate(
                      angle: -0.5,
                      child: const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 20),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Mes billets',
                    style: TextStyle(color: PremiumColors.primaryElectric, fontSize: 10, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
          ),
          _buildNavBarItem(Icons.favorite_border_rounded, 'Favoris', false, () {}),
          _buildNavBarItem(Icons.person_outline_rounded, 'Profil', false, () {}),
        ],
      ),
    );
  }

  Widget _buildNavBarItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isActive ? PremiumColors.primaryElectric : PremiumColors.textSecondary, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? PremiumColors.primaryElectric : PremiumColors.textSecondary,
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w900 : FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== HEADER COMPONENT ====================
class _PremiumHeader extends StatelessWidget {
  final VoidCallback onOpenMyEvents;
  const _PremiumHeader({required this.onOpenMyEvents});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [PremiumColors.primaryDark, PremiumColors.primaryElectric],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 6))],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.event_available_rounded, color: PremiumColors.gold, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THIX ID',
                  style: context.textStyles.labelSmall?.copyWith(
                    color: Colors.white70,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'EVENTS',
                  style: context.textStyles.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          ),
          _PremiumIconButton(icon: Icons.dashboard_customize_rounded, onPressed: onOpenMyEvents),
          const SizedBox(width: 8),
          _PremiumIconButton(
            icon: Icons.notifications_active_rounded,
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Aucune nouvelle notification active.')),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _PremiumIconButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// ==================== BARRE DE RECHERCHE COMPONENT ====================
class _PremiumSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onOpenFilters;
  final ValueChanged<String> onChanged;
  const _PremiumSearchBar({required this.controller, required this.onOpenFilters, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: PremiumColors.textSecondary, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(color: PremiumColors.textPrimary, fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Rechercher un événement...',
                hintStyle: TextStyle(color: PremiumColors.textSecondary, fontSize: 14),
                border: InputBorder.none,
              ),
            ),
          ),
          GestureDetector(
            onTap: onOpenFilters,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [PremiumColors.primaryElectric, PremiumColors.primaryDark]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.tune_rounded, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== ROW FILTRES PAR CATÉGORIES COMPONENT ====================
class _PremiumFilterRow extends StatelessWidget {
  final String selected;
  final ValueChanged<String> onChanged;
  const _PremiumFilterRow({required this.selected, required this.onChanged});

  static const _values = ['Tous', 'Tech', 'Business', 'Education', 'Government', 'Networking'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: _values.map((v) {
          final active = v == selected;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => onChanged(v),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: active ? PremiumColors.primaryElectric : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: active ? Colors.transparent : PremiumColors.textSecondary.withOpacity(0.2),
                  ),
                  boxShadow: active
                      ? [BoxShadow(color: PremiumColors.primaryElectric.withOpacity(0.25), blurRadius: 8, offset: const Offset(0, 2))]
                      : null,
                ),
                child: Text(
                  v,
                  style: context.textStyles.labelLarge?.copyWith(
                    color: active ? Colors.white : PremiumColors.textSecondary,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ==================== FEATURED / CAROUSEL SECTION ====================
class _PremiumFeaturedSection extends StatelessWidget {
  final EventService service;
  final ValueChanged<EventItem> onOpen, onRegister, onJoinLive;
  const _PremiumFeaturedSection({required this.service, required this.onOpen, required this.onRegister, required this.onJoinLive});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.whatshot_rounded, color: PremiumColors.gold, size: 20),
            const SizedBox(width: 8),
            Text(
              'À LA UNE',
              style: context.textStyles.titleMedium?.copyWith(color: PremiumColors.textPrimary, fontWeight: FontWeight.w900),
            ),
          ],
        ),
        const SizedBox(height: 14),
        FutureBuilder<List<EventItem>>(
          future: service.listFeaturedEvents(),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) return const _PremiumFeaturedLoading();
            final list = (snap.data ?? const <EventItem>[])
                .where((e) => e.status == 'published')
                .toList(growable: false);
            if (list.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: PremiumColors.textSecondary.withOpacity(0.1)),
                ),
                child: Text(
                  'Aucun événement phare disponible.',
                  style: context.textStyles.bodyMedium?.copyWith(color: PremiumColors.textSecondary),
                ),
              );
            }
            return _PremiumEventsCarousel(
              events: list,
              onOpen: onOpen,
              onRegister: onRegister,
              onJoinLive: onJoinLive,
            );
          },
        ),
      ],
    );
  }
}

class _PremiumEventsCarousel extends StatefulWidget {
  final List<EventItem> events;
  final ValueChanged<EventItem> onOpen, onRegister, onJoinLive;
  const _PremiumEventsCarousel({required this.events, required this.onOpen, required this.onRegister, required this.onJoinLive});

  @override
  State<_PremiumEventsCarousel> createState() => _PremiumEventsCarouselState();
}

class _PremiumEventsCarouselState extends State<_PremiumEventsCarousel> {
  late final PageController _controller;
  Timer? _timer;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(viewportFraction: 1.0);
    _timer = Timer.periodic(const Duration(seconds: 6), (_) {
      if (!mounted || widget.events.isEmpty) return;
      final next = (_index + 1) % widget.events.length;
      _controller.animateToPage(next, duration: const Duration(milliseconds: 600), curve: Curves.easeInOutCubic);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 315,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.events.length,
            onPageChanged: (i) => setState(() => _index = i),
            itemBuilder: (context, i) => _PremiumFeaturedCard(
              event: widget.events[i],
              onOpen: () => widget.onOpen(widget.events[i]),
              onRegister: () => widget.onRegister(widget.events[i]),
              onJoinLive: () => widget.onJoinLive(widget.events[i]),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.events.length, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 3),
            height: 5,
            width: i == _index ? 16 : 5,
            decoration: BoxDecoration(
              color: i == _index ? PremiumColors.primaryElectric : PremiumColors.textSecondary.withOpacity(0.3),
              borderRadius: BorderRadius.circular(3),
            ),
          )),
        ),
      ],
    );
  }
}

class _PremiumFeaturedCard extends StatefulWidget {
  final EventItem event;
  final VoidCallback onOpen, onRegister, onJoinLive;
  const _PremiumFeaturedCard({required this.event, required this.onOpen, required this.onRegister, required this.onJoinLive});

  @override
  State<_PremiumFeaturedCard> createState() => _PremiumFeaturedCardState();
}

class _PremiumFeaturedCardState extends State<_PremiumFeaturedCard> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    _tick = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.event;
    final remaining = e.startsAt.difference(DateTime.now());
    final countdown = remaining.isNegative ? 'En cours' : _formatCountdown(remaining);

    return GestureDetector(
      onTap: widget.onOpen,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: _EventImage(event: e, height: 140),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: PremiumColors.primaryElectric.withOpacity(0.08),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'THIX VERIFIED',
                          style: context.textStyles.labelSmall?.copyWith(
                            color: PremiumColors.primaryElectric,
                            fontWeight: FontWeight.w900,
                            fontSize: 9,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.timer_rounded, size: 12, color: Colors.orange),
                      const SizedBox(width: 4),
                      Text(
                        countdown,
                        style: const TextStyle(color: Colors.orange, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    e.title,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: PremiumColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 13, color: PremiumColors.textSecondary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          e.location,
                          style: const TextStyle(fontSize: 12, color: PremiumColors.textSecondary),
                          maxLines: 1,
                        ),
                      ),
                      Text(
                        e.priceLabel,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: PremiumColors.goldDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _PremiumCtaButton(label: 'Détails', icon: Icons.visibility_rounded, filled: false, onPressed: widget.onOpen)),
                      const SizedBox(width: 8),
                      Expanded(child: _PremiumCtaButton(label: 'S\'inscrire', icon: Icons.confirmation_number_rounded, filled: true, onPressed: widget.onRegister)),
                      const SizedBox(width: 8),
                      Expanded(child: _PremiumCtaButton(label: 'Live', icon: Icons.live_tv_rounded, filled: false, onPressed: (e.meetingLink ?? '').isEmpty ? null : widget.onJoinLive)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatCountdown(Duration d) {
    final days = d.inDays;
    final hours = d.inHours.remainder(24);
    final minutes = d.inMinutes.remainder(60);
    if (days > 0) return '${days}j ${hours}h';
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }
}

class _PremiumCtaButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback? onPressed;
  const _PremiumCtaButton({required this.label, required this.icon, required this.filled, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: onPressed == null ? 0.4 : 1.0,
      duration: const Duration(milliseconds: 150),
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            gradient: filled ? const LinearGradient(colors: [PremiumColors.primaryElectric, PremiumColors.primaryDark]) : null,
            color: filled ? null : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: filled ? null : Border.all(color: PremiumColors.textSecondary.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: filled ? Colors.white : PremiumColors.primaryElectric),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: filled ? Colors.white : PremiumColors.primaryElectric,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==================== SECTIONS DU SQUELETTE DE GRILLE ====================
class _PremiumEventsGrid extends StatelessWidget {
  final String title, subtitle;
  final List<EventItem> events;
  final ValueChanged<EventItem> onOpen;
  const _PremiumEventsGrid({required this.title, required this.subtitle, required this.events, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) return const SizedBox.shrink();
    final w = MediaQuery.sizeOf(context).width;
    final crossAxisCount = w >= 900 ? 3 : (w >= 580 ? 2 : 1);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: PremiumColors.textPrimary)),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: PremiumColors.textSecondary)),
              ],
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: PremiumColors.primaryElectric),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: crossAxisCount == 1 ? 2.9 : 0.85,
          ),
          itemCount: events.length,
          itemBuilder: (context, i) => _PremiumEventCard(event: events[i], onTap: () => onOpen(events[i])),
        ),
      ],
    );
  }
}

class _PremiumEventCard extends StatelessWidget {
  final EventItem event;
  final VoidCallback onTap;
  const _PremiumEventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isListLayout = MediaQuery.sizeOf(context).width < 580;

    if (isListLayout) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 75,
                  height: 75,
                  child: _EventImage(event: event, height: 75),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      event.category.toUpperCase(),
                      style: const TextStyle(color: PremiumColors.primaryElectric, fontSize: 9, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.title,
                      style: const TextStyle(color: PremiumColors.textPrimary, fontSize: 13, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${event.dateLabel}  |  ${event.location}',
                      style: const TextStyle(color: PremiumColors.textSecondary, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    event.priceLabel,
                    style: const TextStyle(color: PremiumColors.goldDark, fontSize: 11, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: PremiumColors.primaryElectric, borderRadius: BorderRadius.circular(6)),
                    child: const Text('Réserver', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  )
                ],
              )
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: _EventImage(event: event, height: 110),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        event.category,
                        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: PremiumColors.primaryElectric),
                      ),
                      const Spacer(),
                      Text(event.dateLabel, style: const TextStyle(fontSize: 10, color: PremiumColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    event.title,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: PremiumColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== IMAGE LOADER ====================
class _EventImage extends StatelessWidget {
  final EventItem event;
  final double height;
  const _EventImage({required this.event, required this.height});

  @override
  Widget build(BuildContext context) {
    if (event.imageAssetPath != null && event.imageAssetPath!.trim().isNotEmpty) {
      return Image.asset(event.imageAssetPath!, height: height, width: double.infinity, fit: BoxFit.cover);
    }
    return Container(
      height: height,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [PremiumColors.primaryDark, PremiumColors.primaryElectric]),
      ),
      child: const Icon(Icons.event_available_rounded, size: 36, color: Colors.white30),
    );
  }
}

// ==================== FEUILLE FILTRES MODAL SHEET ====================
class _PremiumFiltersSheet extends StatefulWidget {
  final _FiltersResult initial;
  const _PremiumFiltersSheet({required this.initial});

  @override
  State<_PremiumFiltersSheet> createState() => _PremiumFiltersSheetState();
}

class _PremiumFiltersSheetState extends State<_PremiumFiltersSheet> {
  late bool _onlyOnline, _onlyPhysical, _onlyFree, _onlyPaid;

  @override
  void initState() {
    super.initState();
    _onlyOnline = widget.initial.onlyOnline;
    _onlyPhysical = widget.initial.onlyPhysical;
    _onlyFree = widget.initial.onlyFree;
    _onlyPaid = widget.initial.onlyPaid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Text('Filtres de recherche', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: PremiumColors.textPrimary)),
                  const Spacer(),
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded, color: PremiumColors.textSecondary)),
                ],
              ),
              const SizedBox(height: 14),
              _PremiumSwitchRow(label: 'En ligne', value: _onlyOnline, onChanged: (v) => setState(() => _onlyOnline = v), icon: Icons.public_rounded),
              const SizedBox(height: 10),
              _PremiumSwitchRow(label: 'Physique', value: _onlyPhysical, onChanged: (v) => setState(() => _onlyPhysical = v), icon: Icons.location_city_rounded),
              const SizedBox(height: 10),
              _PremiumSwitchRow(label: 'Gratuit', value: _onlyFree, onChanged: (v) => setState(() => _onlyFree = v), icon: Icons.money_off_rounded),
              const SizedBox(height: 10),
              _PremiumSwitchRow(label: 'Payant', value: _onlyPaid, onChanged: (v) => setState(() => _onlyPaid = v), icon: Icons.payments_rounded),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => context.pop(_FiltersResult(onlyOnline: _onlyOnline, onlyPhysical: _onlyPhysical, onlyFree: _onlyFree, onlyPaid: _onlyPaid)),
                  style: FilledButton.styleFrom(
                    backgroundColor: PremiumColors.primaryElectric,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: const Text('Appliquer les filtres', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PremiumSwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final IconData icon;
  const _PremiumSwitchRow({required this.label, required this.value, required this.onChanged, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: PremiumColors.backgroundLight,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: PremiumColors.primaryElectric, size: 18),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, color: PremiumColors.textPrimary, fontSize: 13))),
          Switch(value: value, onChanged: onChanged, activeColor: PremiumColors.primaryElectric),
        ],
      ),
    );
  }
}

// ==================== LOADING & EMPTY STATES ====================
class _PremiumFeaturedLoading extends StatelessWidget {
  const _PremiumFeaturedLoading();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      alignment: Alignment.center,
      child: const CircularProgressIndicator(color: PremiumColors.primaryElectric, strokeWidth: 3),
    );
  }
}

class _PremiumLoadingGrid extends StatelessWidget {
  const _PremiumLoadingGrid();
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 40),
      child: Center(child: CircularProgressIndicator(color: PremiumColors.primaryElectric, strokeWidth: 3)),
    );
  }
}

class _PremiumEmptyState extends StatelessWidget {
  const _PremiumEmptyState();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: const [
          Icon(Icons.search_off_rounded, size: 36, color: PremiumColors.textSecondary),
          SizedBox(height: 8),
          Text('Aucun résultat trouvé', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: PremiumColors.textPrimary)),
        ],
      ),
    );
  }
}

class _FiltersResult {
  final bool onlyOnline, onlyPhysical, onlyFree, onlyPaid;
  const _FiltersResult({required this.onlyOnline, required this.onlyPhysical, required this.onlyFree, required this.onlyPaid});
}
