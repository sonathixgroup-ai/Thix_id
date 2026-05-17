/// =======================================================
/// THIX CHAT - PREMIUM INSTITUTIONAL UI 2026
/// Ultra Premium Messaging Interface
/// =======================================================

import 'dart:ui';
import 'package:flutter/material.dart';

class ThixChatPage extends StatelessWidget {
  const ThixChatPage({super.key});

  static const Color bg = Color(0xFFF4F5F9);
  static const Color navy = Color(0xFF07122A);
  static const Color navy2 = Color(0xFF001B5E);
  static const Color gold = Color(0xFFD4AF37);
  static const Color goldDark = Color(0xFFB8860B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,

      /// =========================
      /// BODY
      /// =========================
      body: SafeArea(
        child: Column(
          children: [

            /// =================================================
            /// HEADER
            /// =================================================
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
                    navy,
                    navy2,
                  ],
                ),
              ),
              child: Column(
                children: [

                  /// TOP BAR
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [

                      /// LOGO
                      Row(
                        children: [

                          Container(
                            width: 58,
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(18),
                              border: Border.all(
                                color: gold,
                                width: 1.2,
                              ),
                            ),
                            child: const Icon(
                              Icons.fingerprint_rounded,
                              color: gold,
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: const [

                              Row(
                                children: [
                                  Text(
                                    "THIX ",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight:
                                          FontWeight.w800,
                                    ),
                                  ),
                                  Text(
                                    "CHAT",
                                    style: TextStyle(
                                      color: gold,
                                      fontSize: 28,
                                      fontWeight:
                                          FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2),

                              Text(
                                "Messagerie sécurisée premium.",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      /// ACTIONS
                      Row(
                        children: [
                          _topIcon(Icons.search_rounded),
                          const SizedBox(width: 10),
                          _topIcon(Icons.more_vert_rounded),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 26),

                  /// TABS
                  Row(
                    children: [
                      _tab("Discussions", true),
                      const SizedBox(width: 36),
                      _tab("Groupes", false),
                      const SizedBox(width: 36),
                      _tab("Appels", false),
                    ],
                  ),
                ],
              ),
            ),

            /// =================================================
            /// SEARCH BAR
            /// =================================================
            Transform.translate(
              offset: const Offset(0, -26),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: 70,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withOpacity(0.08),
                        blurRadius: 20,
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

                      const Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                "Rechercher une discussion...",
                            hintStyle: TextStyle(
                              color: Color(0xFF9CA3AF),
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),

                      Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              goldDark,
                              gold,
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.edit_rounded,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            /// =================================================
            /// CHAT LIST
            /// =================================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  0,
                  20,
                  20,
                ),
                children: [

                  /// ACTIVE CONTACTS
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(26),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: [

                        _storyItem(
                          icon: Icons.add,
                          label: "Ajouter",
                          border: true,
                        ),

                        _storyItem(
                          image:
                              "https://i.pravatar.cc/150?img=47",
                          label: "Aïcha",
                          online: true,
                        ),

                        _storyItem(
                          image:
                              "https://i.pravatar.cc/150?img=33",
                          label: "Marc",
                          online: true,
                        ),

                        _storyItem(
                          image:
                              "https://i.pravatar.cc/150?img=48",
                          label: "Fatou",
                          online: true,
                        ),

                        _storyItem(
                          icon: Icons.groups_rounded,
                          label: "Équipe",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  /// CHAT TILES
                  _chatTile(
                    name: "Aïcha Koné",
                    message:
                        "Bonjour ! As-tu vu le nouveau document ?",
                    time: "11:24",
                    unread: 2,
                    image:
                        "https://i.pravatar.cc/150?img=47",
                  ),

                  _chatTile(
                    name: "Marc Diallo",
                    message:
                        "Parfait, merci beaucoup 🙌",
                    time: "10:58",
                    unread: 1,
                    image:
                        "https://i.pravatar.cc/150?img=33",
                  ),

                  _chatTile(
                    name: "Équipe Projet THIX",
                    message:
                        "Réunion prévue demain à 10h.",
                    time: "09:30",
                    unread: 5,
                    group: true,
                  ),

                  _chatTile(
                    name: "Support THIX",
                    message:
                        "Votre demande a été validée.",
                    time: "Hier",
                    unread: 1,
                    support: true,
                  ),

                  _chatTile(
                    name: "Fatou S.",
                    message:
                        "D’accord, à plus tard !",
                    time: "Lun.",
                    image:
                        "https://i.pravatar.cc/150?img=48",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      /// =================================================
      /// BOTTOM NAVIGATION
      /// =================================================
      bottomNavigationBar: Padding(
        padding:
            const EdgeInsets.fromLTRB(18, 0, 18, 18),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 20,
              sigmaY: 20,
            ),
            child: Container(
              height: 84,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius:
                    BorderRadius.circular(34),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                children: [

                  _navItem(
                    Icons.home_filled,
                    "Accueil",
                  ),

                  _navItem(
                    Icons.grid_view_rounded,
                    "Services",
                  ),

                  /// CENTER BUTTON
                  Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          navy,
                          navy2,
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner_rounded,
                      color: gold,
                      size: 30,
                    ),
                  ),

                  _navItem(
                    Icons.chat_bubble_rounded,
                    "Messages",
                    active: true,
                  ),

                  _navItem(
                    Icons.person_outline,
                    "Profil",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// =======================================================
  /// TOP ICON
  /// =======================================================
  static Widget _topIcon(IconData icon) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: Icon(
        icon,
        color: gold,
      ),
    );
  }

  /// =======================================================
  /// TAB
  /// =======================================================
  static Widget _tab(
    String title,
    bool active,
  ) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            color:
                active ? gold : Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 10),

        if (active)
          Container(
            width: 80,
            height: 3,
            decoration: BoxDecoration(
              color: gold,
              borderRadius:
                  BorderRadius.circular(2),
            ),
          ),
      ],
    );
  }

  /// =======================================================
  /// STORY ITEM
  /// =======================================================
  static Widget _storyItem({
    String? image,
    IconData? icon,
    required String label,
    bool online = false,
    bool border = false,
  }) {
    return Column(
      children: [

        Stack(
          children: [

            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color:
                      border ? gold : Colors.transparent,
                  width: 1.5,
                ),
                image: image != null
                    ? DecorationImage(
                        image:
                            NetworkImage(image),
                        fit: BoxFit.cover,
                      )
                    : null,
                color:
                    const Color(0xFFF3F4F6),
              ),
              child: image == null
                  ? Icon(
                      icon,
                      color: gold,
                    )
                  : null,
            ),

            if (online)
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                ),
              ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  /// =======================================================
  /// CHAT TILE
  /// =======================================================
  static Widget _chatTile({
    required String name,
    required String message,
    required String time,
    int unread = 0,
    String? image,
    bool group = false,
    bool support = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(24),
      ),
      child: Row(
        children: [

          /// AVATAR
          Stack(
            children: [

              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: image != null
                      ? DecorationImage(
                          image:
                              NetworkImage(image),
                          fit: BoxFit.cover,
                        )
                      : null,
                  color:
                      const Color(0xFFF3F4F6),
                ),
                child: image == null
                    ? Icon(
                        group
                            ? Icons.groups_rounded
                            : Icons.verified_user_rounded,
                        color: gold,
                      )
                    : null,
              ),

              if (image != null)
                Positioned(
                  right: 1,
                  bottom: 1,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(width: 14),

          /// CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [

                Row(
                  children: [

                    Expanded(
                      child: Text(
                        name,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight:
                              FontWeight.w800,
                        ),
                      ),
                    ),

                    Text(
                      time,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          /// UNREAD
          if (unread > 0)
            Container(
              margin:
                  const EdgeInsets.only(left: 10),
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: gold,
              ),
              child: Center(
                child: Text(
                  unread.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// =======================================================
  /// NAV ITEM
  /// =======================================================
  static Widget _navItem(
    IconData icon,
    String label, {
    bool active = false,
  }) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [

        Icon(
          icon,
          color:
              active ? gold : Colors.grey,
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color:
                active ? gold : Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
