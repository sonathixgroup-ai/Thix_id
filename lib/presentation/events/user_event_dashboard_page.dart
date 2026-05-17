import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thix_id/models/event_item.dart';
import 'package:thix_id/models/event_registration.dart';
import 'package:thix_id/nav.dart';
import 'package:thix_id/services/event_service.dart';

// ==================== COULEURS PREMIUM ====================
class PremiumColors {
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF8F9FA);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color goldLight = Color(0xFFFFE066);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6C6C7A);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color stroke = Color(0xFFE2E8F0);
}

// ==================== PAGE TABLEAU DE BORD ÉVÉNEMENTS ====================
class UserEventDashboardPage extends StatefulWidget {
  const UserEventDashboardPage({super.key});

  @override
  State<UserEventDashboardPage> createState() => _UserEventDashboardPageState();
}

class _UserEventDashboardPageState extends State<UserEventDashboardPage> {
  final _svc = EventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumColors.backgroundLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barre de retour et titre
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.popOrGo(AppRoutes.events),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: PremiumColors.textPrimary),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Mes événements',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w900,
                            color: PremiumColors.textPrimary,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Onglets
              Expanded(
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: PremiumColors.stroke),
                        ),
                        child: TabBar(
                          indicator: BoxDecoration(
                            color: PremiumColors.gold,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          dividerColor: Colors.transparent,
                          labelColor: Colors.white,
                          unselectedLabelColor: PremiumColors.textSecondary,
                          labelStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                          tabs: const [
                            Tab(text: 'Inscrit'),
                            Tab(text: 'Sauvegardés'),
                            Tab(text: 'Historique'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _RegisteredTab(service: _svc),
                            _SavedTab(service: _svc),
                            _HistoryTab(service: _svc),
                          ],
                        ),
                      ),
                    ],
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

// ==================== ONGLET "INSCRIT" ====================
class _RegisteredTab extends StatelessWidget {
  final EventService service;
  const _RegisteredTab({required this.service});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventRegistration>>(
      future: service.listMyRegistrations(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(color: PremiumColors.gold));
        }
        final regs = snap.data ?? [];
        if (regs.isEmpty) return const _EmptyMessage(label: 'Aucune inscription pour le moment.');
        return ListView.separated(
          itemCount: regs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _RegistrationTile(reg: regs[i]),
        );
      },
    );
  }
}

// ==================== CARTE D’INSCRIPTION ====================
class _RegistrationTile extends StatelessWidget {
  final EventRegistration reg;
  const _RegistrationTile({required this.reg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
        border: Border.all(color: PremiumColors.stroke),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [PremiumColors.goldLight, PremiumColors.gold]),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.confirmation_number_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Billet • ${reg.status}',
                  style: const TextStyle(fontWeight: FontWeight.w900, color: PremiumColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Événement: ${reg.eventId}',
                  style: const TextStyle(fontSize: 12, color: PremiumColors.textSecondary),
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => context.push('/events/${reg.eventId}/ticket/${reg.id}'),
            icon: const Icon(Icons.qr_code_rounded, color: PremiumColors.gold),
            label: const Text('Pass'),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: PremiumColors.stroke),
              foregroundColor: PremiumColors.textPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== ONGLET "SAUVEGARDÉS" ====================
class _SavedTab extends StatefulWidget {
  final EventService service;
  const _SavedTab({required this.service});

  @override
  State<_SavedTab> createState() => _SavedTabState();
}

class _SavedTabState extends State<_SavedTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<({List<EventItem> events, Set<String> savedIds})>(
      future: _load(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(color: PremiumColors.gold));
        }
        final data = snap.data;
        if (data == null) return const _EmptyMessage(label: 'Aucun événement sauvegardé.');
        final savedEvents = data.events.where((e) => data.savedIds.contains(e.id)).toList();
        if (savedEvents.isEmpty) return const _EmptyMessage(label: 'Aucun événement sauvegardé.');
        return ListView.separated(
          itemCount: savedEvents.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final e = savedEvents[i];
            return _EventMiniTile(
              event: e,
              trailing: IconButton(
                onPressed: () async {
                  await widget.service.toggleSaveEvent(eventId: e.id, saved: false);
                  if (mounted) setState(() {});
                },
                icon: const Icon(Icons.bookmark_remove_rounded, color: PremiumColors.gold),
              ),
              onTap: () => context.push('/events/${e.id}'),
            );
          },
        );
      },
    );
  }

  Future<({List<EventItem> events, Set<String> savedIds})> _load() async {
    final results = await Future.wait([
      widget.service.listEvents(),
      widget.service.listSavedEventIds(),
    ]);
    return (events: results[0] as List<EventItem>, savedIds: results[1] as Set<String>);
  }
}

// ==================== CARTE MINIATURE ÉVÉNEMENT ====================
class _EventMiniTile extends StatelessWidget {
  final EventItem event;
  final Widget trailing;
  final VoidCallback onTap;
  const _EventMiniTile({required this.event, required this.trailing, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
          border: Border.all(color: PremiumColors.stroke),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 56,
                height: 56,
                child: event.imageAssetPath != null && event.imageAssetPath!.isNotEmpty
                    ? Image.asset(event.imageAssetPath!, fit: BoxFit.cover)
                    : Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [PremiumColors.goldLight, PremiumColors.gold]),
                        ),
                        child: const Icon(Icons.event_rounded, color: Colors.white),
                      ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w900, color: PremiumColors.textPrimary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${event.dateLabel} • ${event.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: PremiumColors.textSecondary),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}

// ==================== ONGLET "HISTORIQUE" ====================
class _HistoryTab extends StatelessWidget {
  final EventService service;
  const _HistoryTab({required this.service});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<EventRegistration>>(
      future: service.listMyRegistrations(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator(color: PremiumColors.gold));
        }
        final regs = (snap.data ?? []).where((r) => r.status != 'registered').toList();
        if (regs.isEmpty) return const _EmptyMessage(label: 'L’historique apparaîtra après validation des présences.');
        return ListView.separated(
          itemCount: regs.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) => _RegistrationTile(reg: regs[i]),
        );
      },
    );
  }
}

// ==================== COMPOSANT "VIDE" ====================
class _EmptyMessage extends StatelessWidget {
  final String label;
  const _EmptyMessage({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8)],
        border: Border.all(color: PremiumColors.stroke),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(fontSize: 14, color: PremiumColors.textSecondary),
        ),
      ),
    );
  }
}
