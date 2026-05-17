import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thix_id/auth/auth_controller.dart';
import 'package:thix_id/nav.dart';
import 'package:thix_id/services/event_service.dart';
import 'package:thix_id/services/profile_service.dart';
import 'package:thix_id/services/thix_id_service.dart';

// ==================== COULEURS PREMIUM ====================
class PremiumColors {
  static const Color primaryDark = Color(0xFF071B8C);
  static const Color primaryElectric = Color(0xFF2E5BFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color backgroundLight = Color(0xFFF6F8FC);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldDark = Color(0xFFB8860B);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6C6C7A);
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
}

// ==================== PAGE D’INSCRIPTION ====================
class EventRegisterPage extends StatefulWidget {
  final String eventId;
  const EventRegisterPage({super.key, required this.eventId});

  @override
  State<EventRegisterPage> createState() => _EventRegisterPageState();
}

class _EventRegisterPageState extends State<EventRegisterPage> {
  final _eventService = EventService();
  final _profileService = ProfileService();
  final _thixCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  int _tickets = 1;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _thixCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final auth = context.read<AuthController>();
    final thixId = auth.currentUser?.thixId ?? '';
    if (_thixCtrl.text.trim().isEmpty && thixId.trim().isNotEmpty) {
      _thixCtrl.text = thixId;
    }
  }

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _error = null;
      _loading = true;
    });

    try {
      final canonical = ThixIdService.canonicalizeOrNull(_thixCtrl.text);
      if (canonical == null || !ThixIdService.isValid(canonical)) {
        setState(() => _error = 'THIX ID invalide. Exemple: ${ThixIdService.exampleV2}');
        return;
      }

      final profile = await _profileService.fetchPublicProfileByThixId(canonical);
      if (profile == null) {
        setState(() => _error = 'Aucun profil trouvé pour ce THIX ID.');
        return;
      }

      final reg = await _eventService.register(
        eventId: widget.eventId,
        attendeeThixId: canonical,
        tickets: _tickets,
        note: _noteCtrl.text,
      );
      if (!mounted) return;
      context.go('/events/${widget.eventId}/ticket/${reg.id}');
    } catch (e) {
      debugPrint('EventRegisterPage.submit failed err=$e');
      if (!mounted) return;
      setState(() => _error = 'Erreur lors de l’inscription. Réessaie.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PremiumColors.backgroundLight,
      body: SafeArea(
        child: FutureBuilder(
          future: _eventService.fetchEvent(widget.eventId),
          builder: (context, snap) {
            final event = snap.data;
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator(color: PremiumColors.primaryElectric));
            }
            if (event == null) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _TopBar(eventId: widget.eventId),
                    const Spacer(),
                    Text('Événement introuvable.', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => context.popOrGo(AppRoutes.events),
                        child: const Text('Retour'),
                      ),
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
                  _TopBar(eventId: widget.eventId),
                  const SizedBox(height: 16),
                  Text('Inscription', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: PremiumColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(event.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: PremiumColors.textSecondary, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 24),
                  // Carte principale
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified_user_rounded, color: PremiumColors.success),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text('THIX ID requis', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: PremiumColors.textPrimary)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _thixCtrl,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            labelText: 'THIX ID',
                            hintText: ThixIdService.exampleV2,
                            prefixIcon: const Icon(Icons.badge_rounded),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          onChanged: (_) {
                            if (_error != null) setState(() => _error = null);
                          },
                        ),
                        const SizedBox(height: 16),
                        // Sélecteur de billets
                        Row(
                          children: [
                            Expanded(
                              child: Text('Billets', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800, color: PremiumColors.textPrimary)),
                            ),
                            IconButton(
                              onPressed: _loading || _tickets <= 1 ? null : () => setState(() => _tickets -= 1),
                              icon: const Icon(Icons.remove_circle_outline_rounded),
                            ),
                            Container(
                              width: 56,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: PremiumColors.textSecondary.withOpacity(0.3)),
                              ),
                              child: Text('$_tickets', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                            ),
                            IconButton(
                              onPressed: _loading ? null : () => setState(() => _tickets += 1),
                              icon: const Icon(Icons.add_circle_outline_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _noteCtrl,
                          minLines: 2,
                          maxLines: 5,
                          decoration: InputDecoration(
                            labelText: 'Note (optionnel)',
                            hintText: 'Allergies, besoins spécifiques, entreprise…',
                            prefixIcon: const Icon(Icons.edit_note_rounded),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          Text(_error!, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: PremiumColors.error, fontWeight: FontWeight.w700)),
                        ],
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 52,
                          child: FilledButton(
                            onPressed: _loading ? null : _submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: PremiumColors.primaryElectric,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            child: _loading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Confirmer mon inscription', style: TextStyle(fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ==================== BARRE DE RETOUR ====================
class _TopBar extends StatelessWidget {
  final String eventId;
  const _TopBar({required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => context.popOrGo('/events/$eventId'),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: PremiumColors.textPrimary),
        ),
        Expanded(
          child: Text('THIX Register', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900, color: PremiumColors.textPrimary)),
        ),
      ],
    );
  }
}
