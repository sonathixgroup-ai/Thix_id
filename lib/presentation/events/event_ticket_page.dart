import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:thix_id/models/event_item.dart';
import 'package:thix_id/models/event_registration.dart';
import 'package:thix_id/nav.dart';
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

// ==================== PAGE DU BILLET ====================
class EventTicketPage extends StatefulWidget {
  final String eventId;
  final String registrationId;

  const EventTicketPage({super.key, required this.eventId, required this.registrationId});

  @override
  State<EventTicketPage> createState() => _EventTicketPageState();
}

class _EventTicketPageState extends State<EventTicketPage> {
  final _eventService = EventService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumColors.backgroundLight,
      body: SafeArea(
        child: FutureBuilder<_TicketBundle?>(
          future: _load(),
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: PremiumColors.gold));
            }
            final bundle = snap.data;
            if (bundle == null) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _TicketTopBar(),
                    const Spacer(),
                    Text('Billet introuvable.', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, color: PremiumColors.textPrimary)),
                    const SizedBox(height: 24),
                    FilledButton(
                      onPressed: () => context.popOrGo('/events/${widget.eventId}'),
                      style: FilledButton.styleFrom(backgroundColor: PremiumColors.gold, foregroundColor: Colors.white),
                      child: const Text('Retour à l’événement'),
                    ),
                    const Spacer(),
                  ],
                ),
              );
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _TicketTopBar(eventId: widget.eventId),
                  const SizedBox(height: 16),
                  Text('Pass événementiel THIX', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: PremiumColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text('Présentez ce code (QR) à l’entrée.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PremiumColors.textSecondary, height: 1.5)),
                  const SizedBox(height: 24),
                  _TicketCard(event: bundle.event, reg: bundle.reg),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () => context.go('/events/${widget.eventId}'),
                          icon: const Icon(Icons.event_rounded),
                          label: const Text('Détails'),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: PremiumColors.stroke),
                            foregroundColor: PremiumColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Billet prêt. Montrez le code à l’entrée.')),
                            );
                          },
                          icon: const Icon(Icons.verified_rounded),
                          label: const Text('Prêt à scanner'),
                          style: FilledButton.styleFrom(
                            backgroundColor: PremiumColors.gold,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<_TicketBundle?> _load() async {
    try {
      final event = await _eventService.fetchEvent(widget.eventId);
      final reg = await _eventService.fetchRegistrationById(widget.registrationId);
      if (event == null || reg == null) return null;
      if (reg.eventId != event.id) return null;
      return _TicketBundle(event: event, reg: reg);
    } catch (e) {
      debugPrint('EventTicketPage._load failed err=$e');
      return null;
    }
  }
}

// ==================== BARRE DE RETOUR ====================
class _TicketTopBar extends StatelessWidget {
  final String? eventId;
  const _TicketTopBar({this.eventId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.popOrGo(eventId == null ? AppRoutes.events : '/events/$eventId'),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: PremiumColors.textPrimary),
        ),
        Expanded(
          child: Text('Billet THIX', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: PremiumColors.textPrimary, fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }
}

// ==================== CARTE DU BILLET ====================
class _TicketCard extends StatelessWidget {
  final EventItem event;
  final EventRegistration reg;
  const _TicketCard({required this.event, required this.reg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PremiumColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
        border: Border.all(color: PremiumColors.stroke),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.shield_rounded, color: PremiumColors.gold),
              const SizedBox(width: 12),
              Expanded(
                child: Text(event.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900, color: PremiumColors.textPrimary)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text('${event.dateLabel} • ${event.location}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PremiumColors.textSecondary, height: 1.5)),
          const SizedBox(height: 24),
          // QR Code
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: PremiumColors.stroke),
            ),
            child: Column(
              children: [
                Center(
                  child: BarcodeWidget(
                    barcode: Barcode.qrCode(),
                    data: reg.ticketCode,
                    drawText: false,
                    width: 220,
                    height: 220,
                    color: Colors.black,
                    errorBuilder: (context, error) => Text('Erreur QR: $error', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: PremiumColors.error)),
                  ),
                ),
                const SizedBox(height: 16),
                SelectableText(
                  reg.ticketCode,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.5, color: PremiumColors.textPrimary),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _TicketMetaRow(label: 'THIX ID', value: reg.attendeeThixId),
          const SizedBox(height: 8),
          _TicketMetaRow(label: 'Billets', value: reg.tickets.toString()),
          if (reg.note != null && reg.note!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            _TicketMetaRow(label: 'Note', value: reg.note!),
          ],
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: PremiumColors.success.withOpacity(0.1),
                  border: Border.all(color: PremiumColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 16, color: PremiumColors.success),
                    const SizedBox(width: 6),
                    Text('Valide', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: PremiumColors.textPrimary, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const Spacer(),
              Text('ID: ${reg.id}', style: Theme.of(context).textTheme.labelSmall?.copyWith(color: PremiumColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

// ==================== LIGNE D’INFORMATION DU BILLET ====================
class _TicketMetaRow extends StatelessWidget {
  final String label;
  final String value;
  const _TicketMetaRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: PremiumColors.textSecondary, fontWeight: FontWeight.w700)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SelectableText(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PremiumColors.textPrimary, height: 1.4)),
        ),
      ],
    );
  }
}

// ==================== MODÈLE INTERNE ====================
class _TicketBundle {
  final EventItem event;
  final EventRegistration reg;
  const _TicketBundle({required this.event, required this.reg});
}
