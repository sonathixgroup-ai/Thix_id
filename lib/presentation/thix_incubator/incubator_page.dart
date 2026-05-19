import 'package:flutter/material.dart';

class IncubatorPage extends StatelessWidget {
  const IncubatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Column(
          children: [
            // 1. Barre de navigation supérieure (Header Mobile)
            _buildTopNavBar(),
            
            // 2. Zone principale défilante unique pour Téléphone
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeHeroBanner(),
                      const SizedBox(height: 24),
                      _buildSectionHeader("Actions rapides"),
                      const SizedBox(height: 12),
                      _buildQuickActionsGrid(),
                      const SizedBox(height: 28),
                      _buildSectionHeader("Statut de mes projets"),
                      const SizedBox(height: 12),
                      _buildProjectStatusCard(
                        logo: Icons.eco_outlined,
                        logoColor: Colors.green,
                        title: "AgriTech Solutions",
                        progress: 0.75,
                        progressText: "75%",
                        tag: "En incubation",
                        tagColor: Colors.green,
                        phase: "Prototype",
                        date: "30 Juin 2025",
                      ),
                      const SizedBox(height: 12),
                      _buildProjectStatusCard(
                        logo: Icons.school_outlined,
                        logoColor: Colors.purple,
                        title: "EduConnect",
                        progress: 0.40,
                        progressText: "40%",
                        tag: "En évaluation",
                        tagColor: Colors.orange,
                        phase: "Idéation",
                        date: "15 Août 2025",
                      ),
                      const SizedBox(height: 28),
                      _buildSectionHeader("Ressources pour vous"),
                      const SizedBox(height: 12),
                      _buildResourcesGrid(),
                      const SizedBox(height: 28),
                      _buildSectionHeader("Mentors disponibles"),
                      const SizedBox(height: 12),
                      _buildMentorsList(),
                      const SizedBox(height: 28),
                      _buildUpcomingEventsWidget(),
                      const SizedBox(height: 24),
                      _buildOpportunitiesWidget(),
                      const SizedBox(height: 24),
                      _buildCommunityWidget(),
                      const SizedBox(height: 24),
                      _buildBottomIdeaBanner(),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavbar(),
    );
  }

  // --- BARRE SUPÉRIEURE (HEADER MOBILE) ---

  Widget _buildTopNavBar() {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A5CFF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text("𝒯", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text("THIX ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                      Text("INCUBATEUR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0A5CFF))),
                    ],
                  ),
                  const Text("Innover aujourd'hui, impacter demain.", style: TextStyle(fontSize: 9, color: Color(0xFF64748B))),
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF64748B), size: 22),
              const SizedBox(width: 16),
              Stack(
                children: [
                  const Icon(Icons.notifications_none_rounded, color: Color(0xFF64748B), size: 24),
                  Positioned(
                    right: 2,
                    top: 2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: const Text("3", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200'),
              )
            ],
          )
        ],
      ),
    );
  }

  // --- BANNER DE BIENVENUE CONFIGURÉ POUR ÉCRAN MOBILE ---

  Widget _buildWelcomeHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Partie Gauche : Textes
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bienvenue dans\nTHIX Incubateur 👋",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.2),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "L'écosystème qui propulse vos idées.",
                      style: TextStyle(color: Color(0xFF475569), fontSize: 12, height: 1.3),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A5CFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text("Soumettre", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 14, color: Colors.white),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Partie Droite : Illustration Fusée Mobile
              Expanded(
                flex: 4,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0A5CFF).withOpacity(0.08), width: 1),
                        ),
                      ),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: const Color(0xFF0A5CFF).withOpacity(0.12), width: 1.5),
                        ),
                      ),
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0A5CFF).withOpacity(0.05),
                        ),
                      ),
                      Transform.rotate(
                        angle: -0.2,
                        child: const Icon(
                          Icons.rocket_launch_rounded, 
                          size: 45, 
                          color: Color(0xFF0A5CFF)
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFE2E8F0), height: 1),
          const SizedBox(height: 16),
          
          // Statistiques alignées horizontalement pour le mobile
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildHeroMiniStat("Projets", "128", Icons.business_center, const Color(0xFF0A5CFF)),
                const SizedBox(width: 8),
                _buildHeroMiniStat("Startups", "56", Icons.trending_up, Colors.green),
                const SizedBox(width: 8),
                _buildHeroMiniStat("Emplois", "342", Icons.people, Colors.orange),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          // Indicateurs de pages (Dots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2.5),
                width: index == 0 ? 14 : 5,
                height: 5,
                decoration: BoxDecoration(
                  color: index == 0 ? const Color(0xFF0A5CFF) : const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroMiniStat(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text("$label: ", style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
          Text(value, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        ],
      ),
    );
  }

  // --- ACTIONS RAPIDES (SCROLL HORIZONTAL OPTIMISÉ MOBILE) ---

  Widget _buildQuickActionsGrid() {
    final actions = [
      {'icon': Icons.note_add_outlined, 'title': 'Soumettre'},
      {'icon': Icons.folder_open_outlined, 'title': 'Projets'},
      {'icon': Icons.account_balance_wallet_outlined, 'title': 'Finances'},
      {'icon': Icons.co_present_outlined, 'title': 'Mentorat'},
      {'icon': Icons.school_outlined, 'title': 'Formations'},
      {'icon': Icons.hub_outlined, 'title': 'Réseau'},
      {'icon': Icons.calendar_month_outlined, 'title': 'Événements'},
      {'icon': Icons.menu_book_outlined, 'title': 'Ressources'},
    ];

    return SizedBox(
      height: 85,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: actions.length,
        itemBuilder: (context, index) {
          final act = actions[index];
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 4, offset: const Offset(0, 2))],
                  ),
                  child: Icon(act['icon'] as IconData, color: const Color(0xFF0A5CFF), size: 22),
                ),
                const SizedBox(height: 6),
                Text(act['title'] as String, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- CARTES DE STATUT PROJETS MOBILE ---

  Widget _buildProjectStatusCard({
    required IconData logo,
    required Color logoColor,
    required String title,
    required double progress,
    required String progressText,
    required String tag,
    required Color tagColor,
    required String phase,
    required String date,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: logoColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                      child: Icon(logo, color: logoColor, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(3),
                                    child: LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF0A5CFF))),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(progressText, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(tag, style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.layers_outlined, size: 12, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(phase, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today_outlined, size: 12, color: Colors.grey.shade400),
                  const SizedBox(width: 4),
                  Text(date, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  // --- GRILLE DE RESSOURCES SCROLLABLE MOBILE ---

  Widget _buildResourcesGrid() {
    final resources = [
      {'icon': Icons.backpack_outlined, 'title': 'Guides & Outils', 'desc': '24 ressources'},
      {'icon': Icons.article_outlined, 'title': 'Templates', 'desc': '15 modèles'},
      {'icon': Icons.analytics_outlined, 'title': 'Études & Rapports', 'desc': '10 docs'},
      {'icon': Icons.play_circle_outline_rounded, 'title': 'Vidéos', 'desc': '32 vidéos'},
    ];

    return SizedBox(
      height: 105,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: resources.length,
        itemBuilder: (context, index) {
          final res = resources[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(res['icon'] as IconData, color: const Color(0xFF0A5CFF), size: 18),
                const SizedBox(height: 10),
                Text(res['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                Text(res['desc'] as String, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- LISTE DES MENTORS OPTIMISÉE MOBILE ---

  Widget _buildMentorsList() {
    final mentors = [
      {'name': 'Jean N\'guessan', 'role': 'Entrepreneur'},
      {'name': 'Fatou Diallo', 'role': 'Marketing'},
      {'name': 'Koffi Mensah', 'role': 'Tech Expert'},
      {'name': 'Aïcha Traoré', 'role': 'Finance'},
    ];

    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: mentors.length,
        itemBuilder: (context, index) {
          final m = mentors[index];
          return Container(
            width: 110,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200'),
                ),
                const SizedBox(height: 6),
                Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10.5, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(m['role']!, style: const TextStyle(fontSize: 9, color: Color(0xFF64748B))),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- ÉVÉNEMENTS MOBILE ---

  Widget _buildUpcomingEventsWidget() {
    final events = [
      {'day': '24', 'month': 'MAI', 'title': 'Atelier Pitch Deck', 'time': '09:00', 'type': 'En ligne'},
      {'day': '07', 'month': 'JUIN', 'title': 'Innovation Day', 'time': '09:00', 'type': 'Abidjan'},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSideHeader("Événements à venir"),
          const SizedBox(height: 12),
          ...events.map((ev) => Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                      child: Column(
                        children: [
                          Text(ev['day']!, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0A5CFF))),
                          Text(ev['month']!, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ev['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0F172A))),
                        Text("${ev['time']!} - ${ev['type']!}", style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w500)),
                      ],
                    )
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A5CFF),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                  child: const Text("S'inscrire", style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          )).toList()
        ],
      ),
    );
  }

  // --- OPPORTUNITÉS MOBILE ---

  Widget _buildOpportunitiesWidget() {
    final opps = [
      {'title': 'Financement Seed', 'desc': 'Jusqu\'à 10M FCFA', 'icon': Icons.eco_outlined, 'color': Colors.purple},
      {'title': 'Accélération 6 mois', 'desc': 'Mentorat intensif', 'icon': Icons.rocket_launch_outlined, 'color': Colors.blue},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSideHeader("Opportunités"),
          const SizedBox(height: 12),
          ...opps.map((op) => Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(op['icon'] as IconData, color: op['color'] as Color, size: 18),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(op['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF0F172A))),
                        Text(op['desc'] as String, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                      ],
                    )
                  ],
                ),
                const Icon(Icons.arrow_forward_ios, size: 12, color: Color(0xFFCBD5E1)),
              ],
            ),
          )).toList()
        ],
      ),
    );
  }

  // --- COMMUNAUTÉ MOBILE ---

  Widget _buildCommunityWidget() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSideHeader("Communauté THIX"),
          const SizedBox(height: 6),
          const Text("Échangez avec d'autres entrepreneurs.", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ...List.generate(3, (index) => const Align(
                    widthFactor: 0.7,
                    child: CircleAvatar(radius: 11, backgroundColor: Colors.white, child: CircleAvatar(radius: 10, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=100'))),
                  )),
                  const SizedBox(width: 8),
                  const Text("+124 membres", style: TextStyle(color: Color(0xFF0A5CFF), fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A5CFF), elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                child: const Text("Rejoindre", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ],
      ),
    );
  }

  // --- BANNER DE FIN (IDÉE) ---

  Widget _buildBottomIdeaBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Color(0xFF0A5CFF), Color(0xFF003BB3)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Vous avez une idée ?", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("Nous avons l'écosystème pour la propulser.", style: TextStyle(color: Colors.white70, fontSize: 11)),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: const Text("Lancer mon projet 🚀", style: TextStyle(color: Color(0xFF0A5CFF), fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  // --- EN-TÊTES ET NAV BAR MOBILE ---

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const Text("Voir tout", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildSideHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const Text("Voir tout", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildBottomNavbar() {
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomItem(Icons.home, "Accueil", true),
            _buildBottomItem(Icons.folder_open, "Projets", false),
            const CircleAvatar(radius: 18, backgroundColor: Color(0xFF0A5CFF), child: Icon(Icons.add, color: Colors.white, size: 18)),
            _buildBottomItem(Icons.chat_bubble_outline, "Messages", false),
            _buildBottomItem(Icons.person_outline, "Profil", false),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomItem(IconData icon, String text, bool selected) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: selected ? const Color(0xFF0A5CFF) : Colors.grey, size: 18),
        Text(text, style: TextStyle(fontSize: 9, color: selected ? const Color(0xFF0A5CFF) : Colors.grey)),
      ],
    );
  }
}
