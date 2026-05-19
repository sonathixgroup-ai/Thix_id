import 'package:flutter/material.dart';

class IncubatorPage extends StatelessWidget {
  const IncubatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // Fond gris très clair ultra propre de la maquette
      body: SafeArea(
        child: Column(
          children: [
            // 1. Barre de navigation supérieure (Header complet)
            _buildTopNavBar(),
            
            /// 2. Zone principale défilante (responsive : une colonne sur mobile, deux sur desktop)
Expanded(
  child: SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Si l'écran est plus petit que 900px, on passe en colonne unique
          if (constraints.maxWidth < 900) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeroBanner(),
                const SizedBox(height: 24),
                _buildQuickActionsGrid(),
                const SizedBox(height: 32),
                _buildSectionHeader("Statut de mes projets"),
                const SizedBox(height: 16),
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
                const SizedBox(height: 16),
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
                const SizedBox(height: 32),
                _buildSectionHeader("Ressources pour vous"),
                const SizedBox(height: 16),
                _buildResourcesGrid(),
                const SizedBox(height: 32),
                _buildSectionHeader("Mentors disponibles"),
                const SizedBox(height: 16),
                _buildMentorsList(),
                const SizedBox(height: 32),
                _buildBottomIdeaBanner(),
                const SizedBox(height: 24),
                _buildUpcomingEventsWidget(),   // Événements en bas
                const SizedBox(height: 24),
                _buildOpportunitiesWidget(),    // Opportunités
                const SizedBox(height: 24),
                _buildCommunityWidget(),        // Communauté
                const SizedBox(height: 40),
              ],
            );
          } else {
            // Version desktop : deux colonnes
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Colonne gauche (contenu principal)
                Expanded(
                  flex: 7,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildWelcomeHeroBanner(),
                      const SizedBox(height: 24),
                      _buildQuickActionsGrid(),
                      const SizedBox(height: 32),
                      _buildSectionHeader("Statut de mes projets"),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 32),
                      _buildSectionHeader("Ressources pour vous"),
                      const SizedBox(height: 16),
                      _buildResourcesGrid(),
                      const SizedBox(height: 32),
                      _buildSectionHeader("Mentors disponibles"),
                      const SizedBox(height: 16),
                      _buildMentorsList(),
                      const SizedBox(height: 32),
                      _buildBottomIdeaBanner(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                // Colonne droite (événements, opportunités, communauté)
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUpcomingEventsWidget(),
                      const SizedBox(height: 24),
                      _buildOpportunitiesWidget(),
                      const SizedBox(height: 24),
                      _buildCommunityWidget(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    ),
  ),
),
                      
                      // --- COLONNE DROITE : EVENEMENTS & OPPORTUNITES (Flex 3) ---
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildUpcomingEventsWidget(),
                            const SizedBox(height: 24),
                            _buildOpportunitiesWidget(),
                            const SizedBox(height: 24),
                            _buildCommunityWidget(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavbar(),
    )
  }
}
  // --- BARRE SUPÉRIEURE (HEADER) ---

  Widget _buildTopNavBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 24),
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
                height: 42,
                width: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A5CFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text("𝒯", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text("THIX ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                      Text("INCUBATEUR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF0A5CFF))),
                    ],
                  ),
                  const Text("Innover aujourd'hui, impacter demain.", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                ],
              )
            ],
          ),
          Row(
            children: [
              const Icon(Icons.search, color: Color(0xFF64748B), size: 22),
              const SizedBox(width: 20),
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
              const SizedBox(width: 20),
              const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200'),
              )
            ],
          )
        ],
      ),
    );
  }

  // --- BANNER DE BIENVENUE AVEC L'ILLUSTRATION FUSÉE ORBITALE & INDICATEURS ---

  Widget _buildWelcomeHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Côté gauche : Textes explicatifs et Bouton principal
              Expanded(
                flex: 6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Bienvenue dans\nTHIX Incubateur 👋",
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF0F172A), height: 1.2),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "L'écosystème qui propulse vos idées en entreprises à fort impact.",
                      style: TextStyle(color: Color(0xFF475569), fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A5CFF),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text("Soumettre mon projet", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
              // Côté droit : L'illustration Fusée avec effets d'ondes de choc et mini-statistiques
              Expanded(
                flex: 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF0A5CFF).withOpacity(0.08), width: 1),
                          ),
                        ),
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFF0A5CFF).withOpacity(0.12), width: 1.5),
                          ),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFF0A5CFF).withOpacity(0.05),
                          ),
                        ),
                        Transform.rotate(
                          angle: -0.2, // Incline la fusée exactement comme sur la maquette
                          child: const Icon(
                            Icons.rocket_launch_rounded, 
                            size: 70, 
                            color: Color(0xFF0A5CFF)
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroMiniStat("Projets incubés", "128", Icons.business_center, Colors.blue.shade100, const Color(0xFF0A5CFF)),
                        const SizedBox(height: 12),
                        _buildHeroMiniStat("Startups créées", "56", Icons.trending_up, Colors.green.shade100, Colors.green),
                        const SizedBox(height: 12),
                        _buildHeroMiniStat("Emplois générés", "342", Icons.people, Colors.orange.shade100, Colors.orange),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
          
          // Indicateurs de carrousel (Dots) disposés sous le contenu
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3.5),
                width: index == 0 ? 18 : 6, // Le premier point est étiré (actif)
                height: 6,
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

  Widget _buildHeroMiniStat(String label, String value, IconData icon, Color bgIcon, Color iconColor) {
    return Container(
      width: 155,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bgIcon, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 15),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF64748B))),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            ],
          )
        ],
      ),
    );
  }

  // --- GRILLE DES ACTIONS RAPIDES ---

  Widget _buildQuickActionsGrid() {
    final actions = [
      {'icon': Icons.note_add_outlined, 'title': 'Soumettre\nun projet'},
      {'icon': Icons.folder_open_outlined, 'title': 'Mes\nprojets'},
      {'icon': Icons.account_balance_wallet_outlined, 'title': 'Financement'},
      {'icon': Icons.co_present_outlined, 'title': 'Mentorat'},
      {'icon': Icons.school_outlined, 'title': 'Formations'},
      {'icon': Icons.hub_outlined, 'title': 'Réseau'},
      {'icon': Icons.calendar_month_outlined, 'title': 'Événements'},
      {'icon': Icons.menu_book_outlined, 'title': 'Ressources'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((act) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.015), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: Icon(act['icon'] as IconData, color: const Color(0xFF0A5CFF), size: 24),
            ),
            const SizedBox(height: 8),
            Text(act['title'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
          ],
        );
      }).toList(),
    );
  }

  // --- COMPOSANT PROJETS EN INCUBATION ---

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
      padding: const EdgeInsets.all(18),
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
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: logoColor.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                    child: Icon(logo, color: logoColor, size: 24),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          SizedBox(
                            width: 160,
                            height: 6,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFE2E8F0), valueColor: AlwaysStoppedAnimation<Color>(const Color(0xFF0A5CFF))),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(progressText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(tag, style: TextStyle(color: tagColor, fontSize: 11, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.layers_outlined, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text("Phase actuelle : ", style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              Text(phase, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
              const SizedBox(width: 24),
              Icon(Icons.calendar_today_outlined, size: 14, color: Colors.grey.shade400),
              const SizedBox(width: 4),
              Text("Échéance : ", style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              Text(date, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
            ],
          )
        ],
      ),
    );
  }

  // --- GRILLE DES RESSOURCES DISPONIBLES ---

  Widget _buildResourcesGrid() {
  final resources = [
    {'icon': Icons.backpack_outlined, 'title': 'Guides & Outils', 'desc': '24 ressources'},
    {'icon': Icons.article_outlined, 'title': 'Templates', 'desc': '15 modèles'},
    {'icon': Icons.analytics_outlined, 'title': 'Études & Rapports', 'desc': '10 documents'},
    {'icon': Icons.play_circle_outline_rounded, 'title': 'Vidéos', 'desc': '32 vidéos'},
  ];

  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: resources.map((res) {
      return Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFF0A5CFF).withOpacity(0.05), shape: BoxShape.circle),
              child: Icon(res['icon'] as IconData, color: const Color(0xFF0A5CFF), size: 20),
            ),
            const SizedBox(height: 14),
            Text(res['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Color(0xFF0F172A))),
            const SizedBox(height: 2),
            Text(res['desc'] as String? ?? '', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          ],
        ),
      );
    }).toList(),
  );
}
  // --- CARROUSEL COMPACT DE MENTORS ---

  Widget _buildMentorsList() {
    final mentors = [
      {'name': 'Jean N\'guessan', 'role': 'Entrepreneur'},
      {'name': 'Fatou Diallo', 'role': 'Marketing'},
      {'name': 'Koffi Mensah', 'role': 'Tech Expert'},
      {'name': 'Aïcha Traoré', 'role': 'Finance'},
      {'name': 'Mickaël Yao', 'role': 'Growth Hacker'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: mentors.map((m) {
        return Container(
          width: 125,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200'),
              ),
              const SizedBox(height: 8),
              Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(m['role']!, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
            ],
          ),
        );
      }).toList(),
    );
  }

  // --- BANNER D'APPEL À L'ACTION (BAS DE PAGE) ---

  Widget _buildBottomIdeaBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF0A5CFF), Color(0xFF003BB3)]),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text("Vous avez une idée ?", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text("Nous avons l'écosystème pour la transformer en une grande entreprise.", style: TextStyle(color: Colors.white70, fontSize: 12)),
            ],
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            child: Row(
              children: const [
                Text("Soumettre mon projet", style: TextStyle(color: Color(0xFF0A5CFF), fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(width: 6),
                Icon(Icons.arrow_forward, size: 14, color: Color(0xFF0A5CFF)),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- COMPOSANTS DE LA COLONNE DROITE ---

  Widget _buildUpcomingEventsWidget() {
    final events = [
      {'day': '24', 'month': 'MAI', 'title': 'Atelier Pitch Deck', 'time': '09:00 - 12:00', 'type': 'En ligne'},
      {'day': '07', 'month': 'JUIN', 'title': 'Journée Innovation', 'time': '09:00 - 17:00', 'type': 'Abidjan, CI'},
      {'day': '21', 'month': 'JUIN', 'title': 'Masterclass Branding', 'time': '14:00 - 16:00', 'type': 'En ligne'},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSideHeader("Événements à venir"),
          const SizedBox(height: 16),
          Column(
            children: events.map((ev) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Text(ev['day']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0A5CFF))),
                              Text(ev['month']!, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(ev['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                            Text(ev['time']!, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                            Text(ev['type']!, style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.w500)),
                          ],
                        )
                      ],
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0A5CFF)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      ),
                      child: const Text("S'inscrire", style: TextStyle(fontSize: 10, color: Color(0xFF0A5CFF), fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildOpportunitiesWidget() {
    final opps = [
      {'title': 'Financement Seed', 'desc': 'Jusqu\'à 10M FCFA', 'tag': 'Ouvert', 'color': Colors.purple, 'icon': Icons.eco_outlined},
      {'title': 'Accélération 6 mois', 'desc': 'Mentorat intensif', 'tag': 'Ouvert', 'color': Colors.blue, 'icon': Icons.rocket_launch_outlined},
      {'title': 'Partenariat corporate', 'desc': 'Accès grands comptes', 'tag': 'Ouvert', 'color': Colors.orange, 'icon': Icons.handshake_outlined},
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSideHeader("Opportunités"),
          const SizedBox(height: 16),
          Column(
            children: opps.map((op) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(op['icon'] as IconData, color: op['color'] as Color, size: 20),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(op['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                            Text(op['desc'] as String, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                          ],
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFF0A5CFF).withOpacity(0.05), borderRadius: BorderRadius.circular(6)),
                      child: Text(op['tag'] as String, style: const TextStyle(color: Color(0xFF0A5CFF), fontSize: 9, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _buildCommunityWidget() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSideHeader("Communauté THIX"),
          const SizedBox(height: 8),
          const Text("Échangez, collaborez et progressez avec d'autres entrepreneurs.", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
          const SizedBox(height: 14),
          Row(
            children: [
              ...List.generate(4, (index) => const Align(
                widthFactor: 0.7,
                child: CircleAvatar(radius: 14, backgroundColor: Colors.white, child: CircleAvatar(radius: 12, backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=100'))),
              )),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                decoration: BoxDecoration(color: const Color(0xFF0A5CFF), borderRadius: BorderRadius.circular(10)),
                child: const Text("+124", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A5CFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
              child: const Text("Rejoindre la communauté", style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  // --- EN-TÊTES ET UTILITAIRES DE TITRE ---

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const Text("Voir tout", style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildSideHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const Text("Voir tout", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
      ],
    );
  }

  // --- COMPOSANT BARRE DE NAVIGATION INFÉRIEURE ---

  Widget _buildBottomNavbar() {
    return BottomAppBar(
      color: Colors.white,
      child: SizedBox(
        height: 56,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomItem(Icons.home, "Accueil", true),
            _buildBottomItem(Icons.folder_open, "Projets", false),
            const CircleAvatar(radius: 20, backgroundColor: Color(0xFF0A5CFF), child: Icon(Icons.add, color: Colors.white)),
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
        Icon(icon, color: selected ? const Color(0xFF0A5CFF) : Colors.grey, size: 20),
        Text(text, style: TextStyle(fontSize: 10, color: selected ? const Color(0xFF0A5CFF) : Colors.grey)),
      ],
    );
  }
}
