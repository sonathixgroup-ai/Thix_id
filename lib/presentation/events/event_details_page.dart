import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thix_id/models/event_item.dart';
import 'package:thix_id/nav.dart';
import 'package:thix_id/services/document_service.dart';
import 'package:thix_id/services/event_service.dart';

// ==================== COULEURS PREMIUM (GOLDEN + BLANC) ====================
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

// ==================== GRADIENT PREMIUM ====================
class PremiumGradients {
  static LinearGradient goldGradient() {
    return const LinearGradient(
      colors: [PremiumColors.goldLight, PremiumColors.gold],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient cinematicScrim() {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.transparent, Colors.black.withOpacity(0.55)],
    );
  }
}

// ==================== PAGE DÉTAILS ÉVÉNEMENT ====================
class EventDetailsPage extends StatefulWidget {
  final String eventId;
  final bool registered;
  const EventDetailsPage({super.key, required this.eventId, this.registered = false});

  @override
  State<EventDetailsPage> createState() => _EventDetailsPageState();
}

class _EventDetailsPageState extends State<EventDetailsPage> {
  final _svc = EventService();
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

  String _countdown(DateTime startsAt) {
    final d = startsAt.difference(DateTime.now());
    if (d.isNegative) return 'En cours';
    final days = d.inDays;
    final hours = d.inHours.remainder(24);
    final minutes = d.inMinutes.remainder(60);
    if (days > 0) return '${days}j ${hours}h';
    if (hours > 0) return '${hours}h ${minutes}m';
    return '${minutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumColors.backgroundLight,
      body: SafeArea(
        child: FutureBuilder<EventItem?>(
          future: _svc.fetchEvent(widget.eventId),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: PremiumColors.gold));
            }
            final event = snap.data;
            if (event == null) return const _NotFound();

            final countdown = _countdown(event.startsAt);
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _TopBar(event: event),
                        const SizedBox(height: 16),
                        if (widget.registered) ...[
                          _RegisteredBanner(onOpenTicket: () async {
                            final regs = await _svc.listMyRegistrations();
                            final r = regs.where((e) => e.eventId == event.id).toList();
                            if (!mounted) return;
                            if (r.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Billet non trouvé.')));
                              return;
                            }
                            context.push('/events/${event.id}/ticket/${r.first.id}');
                          }),
                          const SizedBox(height: 16),
                        ],
                        _HeroBanner(event: event),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _Pill(icon: Icons.timer_rounded, label: countdown, color: PremiumColors.gold),
                            _Pill(icon: Icons.event_available_rounded, label: event.dateLabel, color: PremiumColors.textSecondary),
                            _Pill(icon: Icons.location_on_rounded, label: event.location, color: PremiumColors.textSecondary),
                            _Pill(icon: Icons.payments_rounded, label: event.priceLabel, color: PremiumColors.textSecondary),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _PrimaryActions(event: event),
                        const SizedBox(height: 24),
                        _Section(title: 'À propos', icon: Icons.info_outline_rounded, child: Text(event.description, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PremiumColors.textSecondary, height: 1.6))),
                        const SizedBox(height: 24),
                        if (event.speakers.isNotEmpty) ...[
                          _Section(title: 'Intervenants', icon: Icons.record_voice_over_rounded, child: _SpeakersList(speakers: event.speakers)),
                          const SizedBox(height: 24),
                        ],
                        if (event.agenda.isNotEmpty) ...[
                          _Section(title: 'Programme', icon: Icons.view_agenda_rounded, child: _AgendaList(items: event.agenda)),
                          const SizedBox(height: 24),
                        ],
                        _Section(
                          title: 'Points forts',
                          icon: Icons.auto_awesome_rounded,
                          child: Column(
                            children: event.highlights.isEmpty
                                ? [Text('Aucun point fort pour le moment.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PremiumColors.textSecondary))]
                                : event.highlights
                                    .map((h) => Padding(
                                          padding: const EdgeInsets.only(bottom: 12),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const Padding(padding: EdgeInsets.only(top: 2), child: Icon(Icons.bolt_rounded, size: 18, color: PremiumColors.gold)),
                                              const SizedBox(width: 10),
                                              Expanded(child: Text(h, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PremiumColors.textSecondary, height: 1.5))),
                                            ],
                                          ),
                                        ))
                                    .toList(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (event.sponsors.isNotEmpty) ...[
                          _Section(title: 'Sponsors', icon: Icons.handshake_rounded, child: _SponsorsRow(sponsors: event.sponsors)),
                          const SizedBox(height: 24),
                        ],
                        _Section(
                          title: 'Livestream',
                          icon: Icons.live_tv_rounded,
                          child: (event.meetingLink ?? '').trim().isEmpty
                              ? Text('Pas de lien de livestream pour cet événement.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PremiumColors.textSecondary))
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text('Lien sécurisé disponible pour les participants vérifiés.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PremiumColors.textSecondary, height: 1.5)),
                                    const SizedBox(height: 16),
                                    FilledButton.icon(
                                      style: FilledButton.styleFrom(
                                        backgroundColor: PremiumColors.gold,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                      ),
                                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Livestream: lien disponible sur la page détail (MVP).'))),
                                      icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                                      label: const Text('Rejoindre le live', style: TextStyle(fontWeight: FontWeight.w800)),
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ==================== BARRE DE RETOUR ====================
class _TopBar extends StatelessWidget {
  final EventItem event;
  const _TopBar({required this.event});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.popOrGo(AppRoutes.events),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: PremiumColors.textPrimary),
        ),
        Expanded(child: Text('Événement', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: PremiumColors.textPrimary, fontWeight: FontWeight.w900))),
        IconButton(
          tooltip: 'Partager',
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Partage : bientôt (liens profonds).'))),
          icon: const Icon(Icons.ios_share_rounded, color: PremiumColors.textPrimary),
        ),
      ],
    );
  }
}

// ==================== BANNIÈRE INSCRIT ====================
class _RegisteredBanner extends StatelessWidget {
  final VoidCallback onOpenTicket;
  const _RegisteredBanner({required this.onOpenTicket});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: PremiumColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: PremiumColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: PremiumColors.success),
          const SizedBox(width: 10),
          Expanded(child: Text('Inscription confirmée. Votre pass événementiel est prêt.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w800, color: PremiumColors.textPrimary))),
          const SizedBox(width: 10),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: PremiumColors.success.withOpacity(0.6)),
              foregroundColor: PremiumColors.textPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            ),
            onPressed: onOpenTicket,
            child: const Text('Voir le pass'),
          ),
        ],
      ),
    );
  }
}

// ==================== BANNIÈRE HÉRO ====================
class _HeroBanner extends StatelessWidget {
  final EventItem event;
  const _HeroBanner({required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: PremiumColors.stroke),
        boxShadow: [BoxShadow(color: PremiumColors.gold.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 12))],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _EventCoverImage(event: event),
          Container(decoration: BoxDecoration(gradient: PremiumGradients.cinematicScrim())),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.36),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: PremiumColors.success.withOpacity(0.55)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_rounded, size: 14, color: PremiumColors.success),
                      const SizedBox(width: 6),
                      Text('Événement certifié THIX', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(event.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900, height: 1.12)),
                const SizedBox(height: 6),
                Text(event.category, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: PremiumColors.gold, fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ==================== IMAGE DE COUVERTURE ====================
class _EventCoverImage extends StatefulWidget {
  final EventItem event;
  const _EventCoverImage({required this.event});

  @override
  State<_EventCoverImage> createState() => _EventCoverImageState();
}

class _EventCoverImageState extends State<_EventCoverImage> {
  final _docs = DocumentService();
  String? _url;

  @override
  void initState() {
    super.initState();
    unawaited(_resolve());
  }

  @override
  void didUpdateWidget(covariant _EventCoverImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.event.coverImagePath != widget.event.coverImagePath || oldWidget.event.coverImageBucket != widget.event.coverImageBucket) {
      unawaited(_resolve());
    }
  }

  Future<void> _resolve() async {
    final path = (widget.event.coverImagePath ?? '').trim();
    final bucket = (widget.event.coverImageBucket ?? '').trim();
    if (path.isEmpty || bucket.isEmpty) {
      if (mounted) setState(() => _url = null);
      return;
    }
    try {
      final url = await _docs.createDownloadUrl(storagePath: path, bucketName: bucket);
      if (!mounted) return;
      setState(() => _url = url);
    } catch (e) {
      debugPrint('_EventCoverImage resolve failed err=$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_url != null) {
      return Image.network(_url!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => _fallback());
    }
    return _fallback();
  }

  Widget _fallback() {
    final a = widget.event.imageAssetPath;
    if (a != null && a.trim().isNotEmpty) return Image.asset(a, fit: BoxFit.cover);
    return Container(decoration: BoxDecoration(gradient: PremiumGradients.goldGradient()));
  }
}

// ==================== ACTIONS PRIMAIRES (S'INSCRIRE / SAUVEGARDER) ====================
class _PrimaryActions extends StatefulWidget {
  final EventItem event;
  const _PrimaryActions({required this.event});

  @override
  State<_PrimaryActions> createState() => _PrimaryActionsState();
}

class _PrimaryActionsState extends State<_PrimaryActions> {
  final _svc = EventService();
  bool _saving = false;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadSaved());
  }

  Future<void> _loadSaved() async {
    try {
      final ids = await _svc.listSavedEventIds();
      if (!mounted) return;
      setState(() => _saved = ids.contains(widget.event.id));
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: () => context.push('/events/${widget.event.id}/register'),
          style: FilledButton.styleFrom(
            backgroundColor: PremiumColors.gold,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          child: const Text('S\'inscrire maintenant', style: TextStyle(fontWeight: FontWeight.w800)),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _saving
                    ? null
                    : () async {
                        setState(() => _saving = true);
                        try {
                          final next = !_saved;
                          await _svc.toggleSaveEvent(eventId: widget.event.id, saved: next);
                          if (!mounted) return;
                          setState(() => _saved = next);
                        } catch (e) {
                          debugPrint('EventDetails save failed err=$e');
                        } finally {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
                icon: Icon(_saved ? Icons.bookmark_added_rounded : Icons.bookmark_add_rounded, color: PremiumColors.gold),
                label: Text(_saved ? 'Sauvegardé' : 'Sauvegarder'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: PremiumColors.stroke),
                  foregroundColor: PremiumColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ajout au calendrier : bientôt.'))),
                icon: const Icon(Icons.event_repeat_rounded, color: PremiumColors.gold),
                label: const Text('Ajouter au calendrier'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: PremiumColors.stroke),
                  foregroundColor: PremiumColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ==================== SECTION GÉNÉRIQUE ====================
class _Section extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _Section({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 12, offset: const Offset(0, 4))],
        border: Border.all(color: PremiumColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(icon, color: PremiumColors.gold),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: PremiumColors.textPrimary))),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ==================== BADGE (PILL) ====================
class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Pill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: PremiumColors.stroke),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: PremiumColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ==================== LISTE INTERVENANTS ====================
class _SpeakersList extends StatelessWidget {
  final List<Map<String, dynamic>> speakers;
  const _SpeakersList({required this.speakers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: speakers.map((s) {
        final name = (s['name'] ?? '—').toString();
        final title = (s['title'] ?? '').toString();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: PremiumGradients.goldGradient(),
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.person_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900, color: PremiumColors.textPrimary)),
                    if (title.trim().isNotEmpty) Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PremiumColors.textSecondary, height: 1.4)),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ==================== AGENDA ====================
class _AgendaList extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _AgendaList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((a) {
        final t = (a['time'] ?? '').toString();
        final title = (a['title'] ?? a['label'] ?? '').toString();
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 68,
                child: Text(t.isEmpty ? '—' : t, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: PremiumColors.gold, fontWeight: FontWeight.w800)),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(title.isEmpty ? '—' : title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PremiumColors.textSecondary, height: 1.5))),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ==================== SPONSORS ====================
class _SponsorsRow extends StatelessWidget {
  final List<Map<String, dynamic>> sponsors;
  const _SponsorsRow({required this.sponsors});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: sponsors.map((s) {
        final name = (s['name'] ?? '—').toString();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: PremiumColors.stroke),
          ),
          child: Text(name, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: PremiumColors.textPrimary, fontWeight: FontWeight.w600)),
        );
      }).toList(),
    );
  }
}

// ==================== PAGE NON TROUVÉE ====================
class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(onPressed: () => context.popOrGo(AppRoutes.events), icon: const Icon(Icons.arrow_back_ios_new_rounded, color: PremiumColors.textPrimary)),
              Expanded(child: Text('Événement', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: PremiumColors.textPrimary, fontWeight: FontWeight.w900))),
            ],
          ),
          const Spacer(),
          Text('Événement introuvable.', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: PremiumColors.textPrimary)),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go(AppRoutes.events),
            style: FilledButton.styleFrom(
              backgroundColor: PremiumColors.gold,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Retour', style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
