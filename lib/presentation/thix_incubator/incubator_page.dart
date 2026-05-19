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
            // 1. Barre de navigation supérieure
            _buildTopNavBar(),
            
            // 2. Zone principale défilante réorganisée verticalement pour Mobile
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeHeroBanner(),
                    const SizedBox(height: 20),
                    
                    _buildSectionHeader("Actions rapides"),
                    const SizedBox(height: 12),
                    _buildQuickActionsGrid(),
                    const SizedBox(height: 24),
                    
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
                      date: "30 Juin 2026",
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
                      date: "15 Août 2026",
                    ),
                    const SizedBox(height: 24),
                    
                    _buildSectionHeader("Ressources pour vous"),
                    const SizedBox(height: 12),
                    _buildResourcesGrid(),
                    const SizedBox(height: 24),
                    
                    _buildSectionHeader("Mentors disponibles"),
                    const SizedBox(height: 12),
                    _buildMentorsList(),
                    const SizedBox(height: 24),
                    
                    // --- ANCIENNE COLONNE DROITE : PLACÉE PROPREMENT EN BAS ---
                    _buildUpcomingEventsWidget(),
                    const SizedBox(height: 24),
                    
                    _buildOpportunitiesWidget(),
                    const SizedBox(height: 24),
                    
                    _buildCommunityWidget(),
                    const SizedBox(height: 24),
                    
                    _buildBottomIdeaBanner(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavbar(),
    );
  }

  // --- BARRE SUPÉRIEURE (HEADER) ---
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
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: const Text("3", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 16),
              const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white, size: 18),
              )
            ],
          )
        ],
      ),
    );
  }

  // --- BANNER DE BIENVENUE MOBILE ---
  Widget _buildWelcomeHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bienvenue dans THIX Incubateur 👋",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          const Text(
            "L'écosystème qui propulse vos idées en entreprises à fort impact.",
            style: TextStyle(color: Color(0xFF475569), fontSize: 12, height: 1.4),
          ),
          const SizedBox(height: 16),
          
          // Statistiques alignées horizontalement et défilantes si nécessaire
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildHeroMiniStat("Projets incubés", "128", Icons.business_center, Colors.blue.shade50, const Color(0xFF0A5CFF)),
                const SizedBox(width: 8),
                _buildHeroMiniStat("Startups créées", "56", Icons.trending_up, Colors.green.shade50, Colors.green),
                const SizedBox(width: 8),
                _buildHeroMiniStat("Emplois générés", "342", Icons.people, Colors.orange.shade50, Colors.orange),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A5CFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text("Soumettre mon projet", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHeroMiniStat(String label, String value, IconData icon, Color bgIcon, Color iconColor) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: bgIcon, borderRadius: BorderRadius.circular(6)),
            child: Icon(icon, color: iconColor, size: 14),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 8, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              ],
            ),
          )
        ],
      ),
    );
  }

  // --- ACTIONS RAPIDES EN LISTE HORIZONTALE COMPACTE ---
  Widget _buildQuickActionsGrid() {
    final actions = [
      {'icon': Icons.note_add_outlined, 'title': 'Soumettre'},
      {'icon': Icons.folder_open_outlined, 'title': 'Projets'},
      {'icon': Icons.account_balance_wallet_outlined, 'title': 'Finance'},
      {'icon': Icons.co_present_outlined, 'title': 'Mentorat'},
      {'icon': Icons.school_outlined, 'title': 'Formations'},
    ];

    return SizedBox(
      height: 75,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: actions.map((act) {
          return Container(
            margin: const EdgeInsets.only(right: 12),
            width: 70,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.1)),
                  ),
                  child: Icon(act['icon'] as IconData, color: const Color(0xFF0A5CFF), size: 20),
                ),
                const SizedBox(height: 6),
                Text(act['title'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- STATUT DES PROJETS ---
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
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: logoColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(logo, color: logoColor, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          SizedBox(
                            width: 100,
                            height: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(value: progress, backgroundColor: const Color(0xFFE2E8F0), valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF0A5CFF))),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(progressText, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                        ],
                      )
                    ],
                  )
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: tagColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(tag, style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 10),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Phase : $phase", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
              Text("Échéance : $date", style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
            ],
          )
        ],
      ),
    );
  }

  // --- RESSOURCES COMPACTES HORIZONTALES ---
  Widget _buildResourcesGrid() {
    final resources = [
      {'icon': Icons.backpack_outlined, 'title': 'Guides & Outils'},
      {'icon': Icons.article_outlined, 'title': 'Templates'},
      {'icon': Icons.analytics_outlined, 'title': 'Études'},
    ];

    return Row(
      children: resources.map((res) {
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              children: [
                Icon(res['icon'] as IconData, color: const Color(0xFF0A5CFF), size: 18),
                const SizedBox(height: 6),
                Text(res['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // --- LISTE DE MENTORS HORIZONTALE ---
  Widget _buildMentorsList() {
    final mentors = [
      {'name': 'Jean N\'guessan', 'role': 'Entrepreneur'},
      {'name': 'Fatou Diallo', 'role': 'Marketing'},
      {'name': 'Koffi Mensah', 'role': 'Tech Expert'},
    ];

    return SizedBox(
      height: 95,
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: mentors.map((m) {
          return Container(
            width: 110,
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, 
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFF1F5F9)),
            ),
            child: Column(
              children: [
                const CircleAvatar(radius: 16, backgroundColor: Colors.blueGrey, child: Icon(Icons.person, color: Colors.white, size: 16)),
                const SizedBox(height: 6),
                Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(m['role']!, style: const TextStyle(fontSize: 8, color: Color(0xFF64748B))),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // --- ÉVÉNEMENTS À VENIR ---
  Widget _buildUpcomingEventsWidget() {
    final events = [
      {'day': '24', 'month': 'MAI', 'title': 'Atelier Pitch Deck'},
      {'day': '07', 'month': 'JUIN', 'title': 'Journée Innovation'},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSideHeader("Événements à venir"),
          const SizedBox(height: 12),
          Column(
            children: events.map((ev) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8)),
                          child: Column(
                            children: [
                              Text(ev['day']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0A5CFF))),
                              Text(ev['month']!, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(ev['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                    TextButton(onPressed: () {}, child: const Text("S'inscrire", style: TextStyle(fontSize: 10, color: Color(0xFF0A5CFF))))
                  ],
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  // --- OPPORTUNITÉS ---
  Widget _buildOpportunitiesWidget() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSideHeader("Opportunités"),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.eco_outlined, color: Colors.purple, size: 18),
                  SizedBox(width: 8),
                  Text("Financement Seed (10M)", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ],
              ),
              const Icon(Icons.arrow_forward_ios, size: 10, color: Colors.grey),
            ],
          )
        ],
      ),
    );
  }

  // --- COMMUNAUTÉ ---
  Widget _buildCommunityWidget() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSideHeader("Communauté THIX"),
          const SizedBox(height: 6),
          const Text("Échangez, collaborez et progressez ensemble.", style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 32,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A5CFF), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), elevation: 0),
              child: const Text("Rejoindre", style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  // --- CALL TO ACTION INFÉRIEUR ---
  Widget _buildBottomIdeaBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Color(0xFF0A5CFF), Color(0xFF003BB3)]),
      ),
      child: Column(
        children: [
          const Text("Vous avez une idée ?", style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text("Transformez-la en une grande entreprise.", style: TextStyle(color: Colors.white70, fontSize: 11), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            child: const Text("Démarrer", style: TextStyle(color: Color(0xFF0A5CFF), fontSize: 11, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
        const Text("Voir tout", style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
      ],
    );
  }

  Widget _buildSideHeader(String title) {
    return Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)));
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
            const CircleAvatar(radius: 18, backgroundColor: Color(0xFF0A5CFF), child: Icon(Icons.add, color: Colors.white, size: 20)),
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
