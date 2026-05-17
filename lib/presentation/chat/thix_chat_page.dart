Voici l'intégralité du code fusionné et corrigé, prêt à être collé directement dans votre fichier thix_chat_page.dart.
La logique applicative complète (gestion des appels Agora, synchronisation de la présence en ligne, écoute en temps réel via Supabase/Services, contrôleurs d'onglets, authentification, etc.) a été conservée et intégrée de manière invisible au sein de la nouvelle interface graphique Premium.
```dart
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:thix_id/auth/auth_controller.dart';
import 'package:thix_id/models/app_user.dart';
import 'package:thix_id/services/call_service.dart';
import 'package:thix_id/services/chat_service.dart';
import 'package:thix_id/services/presence_service.dart';
import 'package:thix_id/services/status_service.dart';
import 'package:thix_id/services/thix_id_service.dart';
import 'package:thix_id/theme.dart';
import 'package:thix_id/nav.dart';

import 'package:thix_id/presentation/chat/thix_agora_call_sheet.dart';

/// THIX CHAT — Premium rebuild with Institutional Interface
class ThixChatPage extends StatefulWidget {
  const ThixChatPage({super.key});

  @override
  State<ThixChatPage> createState() => _ThixChatPageState();
}

class _ThixChatPageState extends State<ThixChatPage> with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  final _chat = ChatService();
  final _status = StatusService();
  final _calls = CallService();
  final _presence = PresenceService();

  StreamSubscription<List<ThixCall>>? _incomingCallsSub;
  String? _incomingForUid;
  bool _incomingSheetOpen = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    unawaited(_presence.setOnline(true));
    _presence.startHeartbeat();
  }

  @override
  void dispose() {
    unawaited(_incomingCallsSub?.cancel());
    _presence.stopHeartbeat();
    unawaited(_presence.setOnline(false));
    _tabs.dispose();
    super.dispose();
  }

  void _ensureIncomingCallListener(AppUser me) {
    if (_incomingForUid == me.id) return;
    _incomingForUid = me.id;
    unawaited(_incomingCallsSub?.cancel());
    _incomingCallsSub = _calls.streamIncomingOngoingCalls(receiverId: me.id).listen((calls) {
      if (!mounted) return;
      if (calls.isEmpty) return;
      if (_incomingSheetOpen) return;
      final c = calls.first;
      _incomingSheetOpen = true;
      unawaited(_showIncomingCallSheet(me: me, call: c));
    });
  }

  Future<void> _showIncomingCallSheet({required AppUser me, required ThixCall call}) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => _IncomingCallSheet(
        kind: call.kind,
        callerId: call.callerId,
        onDecline: () async {
          try {
            await _calls.setCallStatus(callId: call.id, status: 'declined');
          } catch (e) {
            debugPrint('IncomingCall: decline failed err=$e');
          }
          if (context.mounted) context.pop();
        },
        onAccept: () async {
          if (!context.mounted) return;
          context.pop();
          await showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            useSafeArea: true,
            builder: (_) => ThixAgoraCallSheet(
              callId: call.id,
              otherUserId: call.callerId,
              kind: call.kind,
              isCaller: false,
              calls: _calls,
            ),
          );
        },
      ),
    );
    _incomingSheetOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('ThixChatPage: build route=/chat');
    final me = context.watch<AuthController>().currentUser;

    if (me == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF4F5F9),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Veuillez vous connecter pour accéder à THIX CHAT.',
              style: const TextStyle(color: Color(0xFF07122A), fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    _ensureIncomingCallListener(me);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F9),
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER PREMIUM INSTITUTIONNEL
            Container(
              padding: const EdgeInsets.fromLTRB(22, 18, 22, 34),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(34),
                  bottomRight: Radius.circular(34),
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF07122A),
                    Color(0xFF001B5E),
                  ],
                ),
              ),
              child: Column(
                children: [
                  /// TOP BAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: const Color(0xFFD4AF37),
                                width: 1.2,
                              ),
                            ),
                            child: const Icon(
                              Icons.fingerprint_rounded,
                              color: Color(0xFFD4AF37),
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Row(
                                children: [
                                  Text(
                                    "THIX ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    "CHAT",
                                    style: TextStyle(
                                      color: Color(0xFFD4AF37),
                                      fontSize: 28,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 2),
                              Text(
                                "Échangez en toute confiance.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: () => _openSearch(context, me),
                            child: _topIcon(Icons.search_rounded),
                          ),
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () => context.push(AppRoutes.settings),
                            child: _topIcon(Icons.more_vert_rounded),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 26),

                  /// TABS LIÉES DIRECTEMENT AU TABCONTROLLER LOGIQUE
                  TabBar(
                    controller: _tabs,
                    dividerHeight: 0,
                    indicatorColor: const Color(0xFFD4AF37),
                    indicatorSize: TabBarIndicatorSize.label,
                    labelColor: const Color(0xFFD4AF37),
                    unselectedLabelColor: Colors.white,
                    labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                    unselectedLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    tabs: const [
                      Tab(text: "Discussions"),
                      Tab(text: "Statut"),
                      Tab(text: "Contacts"),
                    ],
                  ),
                ],
              ),
            ),

            /// ZONE RECHERCHE & ACTION FLOTTANTE
            Transform.translate(
              offset: const Offset(0, -26),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 68,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(34),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: Colors.grey,
                        size: 28,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: TextField(
                          onTap: () => _openSearch(context, me),
                          readOnly: true,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Rechercher un contact ou message...",
                            hintStyle: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _openStartByThixId(context, me),
                        child: Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                Color(0xFFB8860B),
                                Color(0xFFD4AF37),
                              ],
                            ),
                          ),
                          child: const Icon(
                            Icons.edit_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// CONTENU DYNAMIQUE BRANCHÉ SUR VOS SERVICES APPLICATIFS (ZÉRO ÉCRAN BLANC)
            Expanded(
              child: TabBarView(
                controller: _tabs,
                children: [
                  // Onglet Discussions réel branché sur ChatService
                  ThixChatsTab(
                    me: me,
                    chat: _chat,
                    onOpenThread: (chatId, otherUid, otherName) => _openThreadSheet(
                      context,
                      me: me,
                      chatId: chatId,
                      otherUid: otherUid,
                      otherName: otherName,
                    ),
                    onStartByThixId: () => _openStartByThixId(context, me),
                  ),
                  // Onglet Statut réel branché sur StatusService
                  ThixStatusTab(me: me, status: _status),
                  // Onglet Contacts réel branché sur ChatService
                  ThixContactsTab(
                    me: me,
                    chat: _chat,
                    onOpenThread: (chatId, otherUid, otherName) => _openThreadSheet(
                      context,
                      me: me,
                      chatId: chatId,
                      otherUid: otherUid,
                      otherName: otherName,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// BOTTOM NAV PREMIUM SEMI-TRANSPARENT
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              height: 84,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(34),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _navItem(Icons.home_filled, "Accueil", onTap: () => context.go('/')),
                  _navItem(Icons.grid_view_rounded, "Services", onTap: () => context.push(AppRoutes.vault)),

                  /// BOUTON CENTRAL : REJOINDRE OU CRÉER GROUPE / APPEL CONTROLLÉ
                  GestureDetector(
                    onTap: () => _openGroups(context, me),
                    child: Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF07122A),
                            Color(0xFF001B5E),
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.qr_code_scanner_rounded,
                        color: Color(0xFFD4AF37),
                        size: 30,
                      ),
                    ),
                  ),

                  _navItem(Icons.chat_bubble_rounded, "Messages", active: true),
                  _navItem(Icons.person_outline, "Profil", onTap: () => context.push(AppRoutes.settings)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// COMPONENTS DE STYLE REMPLACÉS SANS PERTE DE LOGIQUE
  static Widget _topIcon(IconData icon) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: const Color(0xFFD4AF37)),
    );
  }

  Widget _navItem(IconData icon, String label, {bool active = false, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? const Color(0xFFD4AF37) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: active ? const Color(0xFFD4AF37) : Colors.grey,
              fontWeight: FontWeight.w600,
          ),
          ),
        ],
      ),
    );
  }

  /// METHODES PRIVÉES RECONNECTÉES AUX PANNEAUX APPLICATIFS REELS
  Future<void> _openGroups(BuildContext context, AppUser me) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => ThixGroupComposerSheet(me: me, chat: _chat),
    );
  }

  Future<void> _openCalls(BuildContext context, AppUser me) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => ThixCallLauncherSheet(me: me, chat: _chat, calls: _calls),
    );
  }

  Future<void> _openThreadSheet(BuildContext context, {
    required AppUser me,
    required String? chatId,
    required String otherUid,
    required String otherName,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => ThixChatThreadSheet(
        me: me,
        chatId: chatId,
        otherUid: otherUid,
        otherName: otherName,
        chat: _chat,
        calls: _calls,
      ),
    );
  }

  Future<void> _openStartByThixId(BuildContext context, AppUser me) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => ThixStartChatByThixIdSheet(
        me: me,
        chat: _chat,
        onOpenThread: (chatId, otherUid, otherName) {
          context.pop();
          unawaited(_openThreadSheet(context, me: me, chatId: chatId, otherUid: otherUid, otherName: otherName));
        },
      ),
    );
  }

  Future<void> _openSearch(BuildContext context, AppUser me) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      builder: (_) => ThixChatSearchSheet(
        me: me,
        chat: _chat,
        onOpenThread: (chatId, otherUid, otherName) {
          context.pop();
          unawaited(_openThreadSheet(context, me: me, chatId: chatId, otherUid: otherUid, otherName: otherName));
        },
      ),
    );
  }
}

/// ============================================================================
/// PANNEAU INTERNE TEMPORAIRE EN CAS D'APPEL ENTRANT (COMPACT LOGIQUE REUSE)
/// ============================================================================
class _IncomingCallSheet extends StatelessWidget {
  final String kind;
  final String callerId;
  final VoidCallback onDecline;
  final VoidCallback onAccept;

  const _IncomingCallSheet({
    required this.kind,
    required this.callerId,
    required this.onDecline,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            kind == 'video' ? 'Appel vidéo entrant...' : 'Appel vocal entrant...',
            style: context.textStyles.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('ID de l\'appelant: $callerId', style: context.textStyles.bodyMedium),
          const SizedBox(height: AppSpacing.xl),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton.icon(
                onPressed: onDecline,
                style: FilledButton.styleFrom(backgroundColor: Colors.red),
                icon: const Icon(Icons.call_end_rounded),
                label: const Text('Décliner'),
              ),
              FilledButton.icon(
                onPressed: onAccept,
                style: FilledButton.styleFrom(backgroundColor: Colors.green),
                icon: const Icon(Icons.call_rounded),
                label: const Text('Accepter'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

```
