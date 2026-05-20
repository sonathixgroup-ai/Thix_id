import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({super.key});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  String selectedCategory = 'Tous les événements';
  int _currentIndex = 2; // Positionné sur "Mes billets" comme sur ton design
  final Set<String> favoriteEvents = {};

  // Données fidèles à tes maquettes
  final List<Map<String, dynamic>> featuredEvents = [
    {
      'id': '1',
      'type': 'CONCERT',
      'title': 'TAYC EN CONCERT',
      'date': '25 Mai 2024 • 20h00',
      'location': 'Palais des Congrès',
      'price': '15.000 FC',
      'color': const Color(0xFF6320EE),
      'image': 'https://images.unsplash.com/photo-1514525253161-7a46d19cd819?w=500&q=80',
    },
    {
      'id': '2',
      'type': 'CONFÉRENCE',
      'title': 'AFRICA BUSINESS SUMMIT',
      'date': '12 Juin 2024 • 09h00',
      'location': 'Hôtel 2 Février',
      'price': '35.000 FC',
      'color': const Color(0xFFE67E22),
      'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=500&q=80',
    },
    {
      'id': '3',
      'type': 'MATCH',
      'title': 'AS DOUANES VS JARAAF',
      'date': '18 Mai 2024 • 16h00',
      'location': 'Stade Léopold Sédar',
      'price': '5.000 FC',
      'color': const Color(0xFF2ECC71),
      'image': 'https://images.unsplash.com/photo-1508098682722-e99c43a406b2?w=500&q=80',
    },
    {
      'id': '4',
      'type': 'FESTIVAL',
      'title': 'AFRO VIBES FESTIVAL',
      'date': '30 Juin 2024 • 18h00',
      'location': "Place de l'Indépendance",
      'price': '20.000 FC',
      'color': const Color(0xFFE91E63),
      'image': 'https://images.unsplash.com/photo-1533174072545-7a4b6ad7a6c3?w=500&q=80',
    },
  ];

  final List<Map<String, String>> upcomingEvents = [
    {
      'title': 'Spectacle : Le Rire du Continent',
      'tag': 'SPECTACLE',
      'date': '22 Mai 2024 • 20h00',
      'location': 'Institut Français',
      'price': '10.000 FC',
      'image': 'https://images.unsplash.com/photo-1585699324551-f6c309eed262?w=150&q=80'
    },
    {
      'title': "Salon International de l'Auto 2024",
      'tag': 'EXPOSITION',
      'date': '05 Août 2024 • 10h00',
      'location': 'Parc des Expositions',
      'price': '7.500 FC',
      'image': 'https://images.unsplash.com/photo-1542282088-fe8426682b8f?w=150&q=80'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildHeroBanner(),
              const SizedBox(height: 24),
              _buildMainCategoriesGrid(),
              const SizedBox(height: 24),
              _buildSectionHeader('Catégories populaires'),
              const SizedBox(height: 12),
              _buildPopularHorizontalList(),
              const SizedBox(height: 24),
              _buildSectionHeader('Événements recommandés'),
              const SizedBox(height: 12),
              _buildRecommendedHorizontalList(),
              const SizedBox(height: 24),
              _buildNotificationBanner(),
              const SizedBox(height: 24),
              _buildSectionHeader('Prochains événements'),
              _buildUpcomingVerticalList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  // --- STRUCTURE : APP BAR ---
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFFF8F9FC),
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF1E293B), size: 26),
          onPressed: () {},
        ),
      ),
      titleSpacing: 0,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6320EE).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.calendar_month_rounded, color: Color(0xFF6320EE), size: 22),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: const TextSpan(
                    text: 'THIX ',
                    style: TextStyle(fontWeight: FontWeight.black, fontSize: 18, color: Color(0xFF1E293B), fontFamily: 'Poppins'),
                    children: [
                      TextSpan(text: 'ÉVÉNEMENT', style: TextStyle(color: Color(0xFF6320EE), fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const Text("Découvrez, réservez, vivez l'exceptionnel.", style: TextStyle(fontSize: 10, color: Color(0xFF64748B), height: 1.2)),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1E293B), size: 26),
              onPressed: () {},
            ),
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Color(0xFF6320EE), shape: BoxShape.circle),
                child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(right: 16.0, left: 6.0),
          child: CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&q=80'),
          ),
        ),
      ],
    );
  }

  // --- BLOC 1 : HERO BANNER ---
  Widget _buildHeroBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: double.infinity,
        height: 185,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
            image: NetworkImage('https://images.unsplash.com/photo-1470225620780-dba8ba36b745?w=800&q=80'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [Colors.black.withOpacity(0.85), Colors.transparent],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF6320EE), borderRadius: BorderRadius.circular(6)),
                child: const Text('★ À LA UNE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
              ),
              const SizedBox(height: 10),
              const Text('Vivez des moments\ninoubliables.', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold, height: 1.2)),
              const SizedBox(height: 4),
              Text('Concerts, festivals, conférences, spectacles et plus encore.', style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11)),
              const Spacer(),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6320EE),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text('Découvrir les événements', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    SizedBox(width: 6),
                    Icon(Icons.chevron_right_rounded, color: Colors.white, size: 16),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // --- BLOC 2 : GRILLE DES CATÉGORIES PRINCIPALES (Fidèle aux boutons blancs) ---
  Widget _buildMainCategoriesGrid() {
    final categories = [
      {'icon': Icons.calendar_today_rounded, 'label': 'Tous les\névénements'},
      {'icon': Icons.music_note_rounded, 'label': 'Concerts'},
      {'icon': Icons.theater_comedy_rounded, 'label': 'Spectacles'},
      {'icon': Icons.mic_external_on_rounded, 'label': 'Conférences'},
      {'icon': Icons.emoji_events_rounded, 'label': 'Sport'},
      {'icon': Icons.more_horiz_rounded, 'label': 'Plus'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.05,
        ),
        itemBuilder: (context, index) {
          String catLabel = categories[index]['label'] as String;
          bool isSelected = (catLabel.contains('Tous') && selectedCategory == 'Tous les événements') || (selectedCategory == catLabel);

          return GestureDetector(
            onTap: () => setState(() => selectedCategory = catLabel.replaceAll('\n', ' ')),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isSelected ? const Color(0xFF6320EE) : Colors.transparent, width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    categories[index]['icon'] as IconData,
                    color: isSelected ? const Color(0xFF6320EE) : const Color(0xFF6320EE), // Violet icône identique partout
                    size: 24,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    catLabel,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                      color: isSelected ? const Color(0xFF6320EE) : const Color(0xFF334155),
                      height: 1.2,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // --- BLOC 3 : CATÉGORIES POPULAIRES (Horizontal & Coloré) ---
  Widget _buildPopularHorizontalList() {
    final popularSub = [
      {'icon': Icons.library_music_rounded, 'label': 'Musique & Concerts', 'color': const Color(0xFF9C27B0)},
      {'icon': Icons.business_center_rounded, 'label': 'Conférences & Séminaires', 'color': const Color(0xFF2196F3)},
      {'icon': Icons.color_lens_rounded, 'label': 'Culture & Art', 'color': const Color(0xFFFF9800)},
      {'icon': Icons.sports_basketball_rounded, 'label': 'Sport & Loisirs', 'color': const Color(0xFF4CAF50)},
      {'icon': Icons.nightlife_rounded, 'label': 'Festivals & Soirées', 'color': const Color(0xFFE91E63)},
    ];

    return SizedBox(
      height: 42,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 16),
        itemCount: popularSub.length,
        itemBuilder: (context, index) {
          final sub = popularSub[index];
          final color = sub['color'] as Color;

          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: color.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withOpacity(0.12), width: 1),
            ),
            child: Row(
              children: [
                Icon(sub['icon'] as IconData, color: color, size: 16),
                const SizedBox(width: 8),
                Text(sub['label'] as String, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- BLOC 4 : ÉVÉNEMENTS RECOMMANDÉS (Cartes Horizontales) ---
  Widget _buildRecommendedHorizontalList() {
    return SizedBox(
      height: 295,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(left: 16),
        itemCount: featuredEvents.length,
        itemBuilder: (context, index) {
          final event = featuredEvents[index];
          bool isFav = favoriteEvents.contains(event['id']);

          return Container(
            width: 215,
            margin: const EdgeInsets.only(right: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(event['image'], height: 125, width: double.infinity, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: event['color'], borderRadius: BorderRadius.circular(6)),
                        child: Text(event['type'], style: const TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.2),
                        radius: 15,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(isFav ? Icons.favorite : Icons.favorite_border_rounded, color: isFav ? Colors.red : Colors.white, size: 18),
                          onPressed: () {
                            setState(() {
                              if (isFav) favoriteEvents.remove(event['id']);
                              else favoriteEvents.add(event['id']);
                            });
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 10),
                      _buildRowInfo(Icons.calendar_today_outlined, event['date']),
                      const SizedBox(height: 6),
                      _buildRowInfo(Icons.location_on_outlined, event['location']),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.between,
                        children: [
                          Text(event['price'], style: TextStyle(color: event['color'], fontWeight: FontWeight.black, fontSize: 14)),
                          SizedBox(
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: event['color'],
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                elevation: 0,
                              ),
                              child: const Text('Réserver', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // --- BLOC 5 : BANNIÈRE DE NOTIFICATION (Dégradé Violet) ---
  Widget _buildNotificationBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8E2DE2), Color(0xFF6320EE)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.confirmation_number_outlined, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ne manquez aucun événement !', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 3),
                  Text('Activez les notifications pour être informé des nouveaux événements près de chez vous.', style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF6320EE),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                elevation: 0,
              ),
              icon: const Icon(Icons.notifications_active_outlined, size: 14),
              label: const Text('Activer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
            )
          ],
        ),
      ),
    );
  }

  // --- BLOC 6 : PROCHAINS ÉVÉNEMENTS (Liste Verticale Basse) ---
  Widget _buildUpcomingVerticalList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: upcomingEvents.length,
      itemBuilder: (context, index) {
        final item = upcomingEvents[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 10, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(item['image']!, width: 72, height: 72, fit: BoxFit.cover),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Color(0xFF1E293B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: const Color(0xFF6320EE).withOpacity(0.08), borderRadius: BorderRadius.circular(4)),
                      child: Text(item['tag']!, style: const TextStyle(color: Color(0xFF6320EE), fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 6),
                    Text('${item['date']}   |   ${item['location']}', style: const TextStyle(fontSize: 9.5, color: Color(0xFF64748B))),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(item['price']!, style: const TextStyle(fontWeight: FontWeight.black, color: Color(0xFF6320EE), fontSize: 12.5)),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6320EE),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        elevation: 0,
                      ),
                      child: const Text('Réserver', style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }

  // --- COMPOSANTS OUTILS (Headers, Rangées, Navigation) ---
  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.between,
        children: [
          Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
          GestureDetector(
            onTap: () {},
            child: Row(
              children: const [
                Text('Voir tout', style: TextStyle(color: Color(0xFF6320EE), fontSize: 12, fontWeight: FontWeight.bold)),
                Icon(Icons.chevron_right_rounded, size: 16, color: Color(0xFF6320EE)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRowInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 13, color: const Color(0xFF94A3B8)),
        const SizedBox(width: 5),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis)),
      ],
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 15, offset: const Offset(0, -2))],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF6320EE),
        unselectedItemColor: const Color(0xFF94A3B8),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedTextStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home_rounded), label: 'Accueil'),
          const BottomNavigationBarItem(icon: Icon(Icons.search_rounded), label: 'Rechercher'),
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Color(0xFF6320EE), shape: BoxShape.circle),
              child: const Icon(Icons.confirmation_number_rounded, color: Colors.white, size: 22),
            ),
            label: 'Mes billets',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.favorite_border_rounded), activeIcon: Icon(Icons.favorite_rounded), label: 'Favoris'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), activeIcon: Icon(Icons.person_rounded), label: 'Profil'),
        ],
      ),
    );
  }
}
