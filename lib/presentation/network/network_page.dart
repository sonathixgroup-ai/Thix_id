import 'package:flutter/material.dart';

class ThixReseauProPage extends StatelessWidget {
  const ThixReseauProPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6), // Fond gris clair uniforme du design
      body: SafeArea(
        child: Column(
          children: [
            // 1. Barre de navigation supérieure complète (Style Bureau / Tablette)
            _buildTopNavBar(),
            
            // 2. Zone principale avec division asymétrique
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // COLONNE DE GAUCHE : FLUX PRINCIPAL (Flex 7)
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeroBanner(),
                            const SizedBox(height: 20),
                            _buildQuickActionsGrid(),
                            const SizedBox(height: 24),
                            _buildSuggestionsSection(),
                            const SizedBox(height: 24),
                            
                            // Zone de création de Post (Oubliée précédemment)
                            _buildCreatePostCard(),
                            const SizedBox(height: 20),
                            
                            _buildFeedSectionHeader(),
                            const SizedBox(height: 12),
                            _buildNewsFeedCard(),
                            const SizedBox(height: 16),
                            _buildJobShareCard(),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      
                      // COLONNE DE DROITE : WIDGETS ET PROFIL (Flex 3)
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildProfileMiniCard(),
                            const SizedBox(height: 20),
                            _buildRecentConnectionsWidget(),
                            const SizedBox(height: 20),
                            _buildUpcomingEventsWidget(),
                            const SizedBox(height: 20),
                            _buildPopularGroupsWidget(),
                            const SizedBox(height: 20),
                            _buildRecommendedJobsWidget(),
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
    );
  }

  // --- BARRE SUPÉRIEURE AVEC ONGLETS CENTRAUX ---

  Widget _buildTopNavBar() {
    return Container(
      height: 65,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Logo & Titre
          Row(
            children: [
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(
                  child: Text("R", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text("THIX ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.black)),
                      Text("RÉSEAU PRO", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF2563EB))),
                    ],
                  ),
                  const Text("Connecter. Collaborer. Réussir.", style: TextStyle(fontSize: 9, color: Colors.grey)),
                ],
              )
            ],
          ),
          
          // Navigation Centrale (Fidèle aux plateformes pro)
          Row(
            children: [
              _buildTopNavTab(Icons.home_rounded, "Accueil", true),
              _buildTopNavTab(Icons.people_alt_outlined, "Réseau", false),
              _buildTopNavTab(Icons.business_center_outlined, "Emplois", false),
              _buildTopNavTab(Icons.chat_bubble_outline_rounded, "Messages", false),
              _buildTopNavTab(Icons.notifications_none_rounded, "Notifications", false),
            ],
          ),

          // Recherche & Profil à droite
          Row(
            children: [
              Container(
                width: 240,
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.search, color: Colors.grey, size: 18),
                    SizedBox(width: 8),
                    Text("Rechercher...", style: TextStyle(color: Colors.grey, fontSize: 11.5)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              const CircleAvatar(
                radius: 18,
                backgroundColor: Color(0xFF2563EB),
                child: Icon(Icons.person, color: Colors.white, size: 18),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTopNavTab(IconData icon, String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isSelected ? const Color(0xFF2563EB) : Colors.transparent, width: 2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF4B5563), size: 20),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 9.5, color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF4B5563), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  // --- ZONE DE CRÉATION DE POST ---

  Widget _buildCreatePostCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 18, backgroundColor: Color(0xFFE5E7EB), child: Icon(Icons.person, color: Colors.grey)),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Text("Commencer un post, partager une idée...", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF3F4F6)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPostTypeBtn(Icons.image_outlined, "Photo", Colors.blue),
              _buildPostTypeBtn(Icons.smart_display_outlined, "Vidéo", Colors.green),
              _buildPostTypeBtn(Icons.calendar_month_outlined, "Événement", Colors.orange),
              _buildPostTypeBtn(Icons.article_outlined, "Rédiger un article", Colors.red.shade400),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPostTypeBtn(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 11.5, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // --- FLUX & CONTENU ---

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [Color(0xFF030712), Color(0xFF1D4ED8)]),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, height: 1.2),
                    children: [
                      TextSpan(text: "Développez votre réseau,\nélevez vos "),
                      TextSpan(text: "opportunités.", style: TextStyle(color: Color(0xFF60A5FA))),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text("Rejoignez des experts, partagez vos projets et créez des partenariats uniques.", style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2563EB),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  icon: const Icon(Icons.person_add_alt_1, size: 16, color: Colors.white),
                  label: const Text("Élargir mon réseau", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                )
              ],
            ),
          ),
          const Expanded(flex: 4, child: Icon(Icons.blur_circular, size: 90, color: Colors.white10))
        ],
      ),
    );
  }

  Widget _buildQuickActionsGrid() {
    final actions = [
      {'icon': Icons.person_search_outlined, 'title': 'Trouver des\nmembres', 'color': const Color(0xFFEFF6FF), 'iconColor': const Color(0xFF2563EB)},
      {'icon': Icons.business_outlined, 'title': 'Entreprises', 'color': const Color(0xFFECFDF5), 'iconColor': const Color(0xFF10B981)},
      {'icon': Icons.business_center_outlined, 'title': 'Offres d\'emploi', 'color': const Color(0xFFFFF7ED), 'iconColor': const Color(0xFFF97316)},
      {'icon': Icons.event_note_outlined, 'title': 'Événements', 'color': const Color(0xFFFDF2F8), 'iconColor': const Color(0xFFEC4899)},
      {'icon': Icons.groups_outlined, 'title': 'Groupes', 'color': const Color(0xFFF5F3FF), 'iconColor': const Color(0xFF8B5CF6)},
      {'icon': Icons.analytics_outlined, 'title': 'Statistiques', 'color': const Color(0xFFF0FDFA), 'iconColor': const Color(0xFF14B8A6)},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: actions.map((act) {
        return Container(
          width: 100,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: act['color'] as Color, shape: BoxShape.circle),
                child: Icon(act['icon'] as IconData, color: act['iconColor'] as Color, size: 20),
              ),
              const SizedBox(height: 8),
              Text(act['title'] as String, textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSuggestionsSection() {
    final members = [
      {'name': 'Ismaël Koné', 'title': 'CEO, AgroVision', 'mutual': '12'},
      {'name': 'Fatou N\'Guessan', 'title': 'Consultante RH', 'mutual': '7'},
      {'name': 'Herve Yao', 'title': 'Investisseur Tech', 'mutual': '5'},
      {'name': 'Adama Bakayoko', 'title': 'Dev Fullstack', 'mutual': '9'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text("Suggestions pour vous", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
            Text("Voir tout", style: TextStyle(fontSize: 11.5, color: Colors.grey)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: members.map((m) {
            return Container(
              width: 155,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Column(
                children: [
                  const CircleAvatar(radius: 24, backgroundColor: Color(0xFFF3F4F6), child: Icon(Icons.person, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Text(m['name']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5)),
                  Text(m['title']!, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text("${m['mutual']} relations mutuelles", style: const TextStyle(fontSize: 8.5, color: Colors.grey)),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 28,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                      child: const Text("Se connecter", style: TextStyle(fontSize: 10.5, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  )
                ],
              ),
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildFeedSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Fil d'actualité", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1F2937))),
        Row(
          children: const [
            Text("Trier par : ", style: TextStyle(fontSize: 11.5, color: Colors.grey)),
            Text("Récent", style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
            Icon(Icons.arrow_drop_down, size: 16),
          ],
        )
      ],
    );
  }

  Widget _buildNewsFeedCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 18, backgroundColor: Color(0xFFF3F4F6)),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Text("Aïcha Diallo ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Icon(Icons.verified, color: Color(0xFF2563EB), size: 13), // Badge de vérification
                    ],
                  ),
                  const Text("CEO, TechNova • 2 heures", style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              )
            ],
          ),
          const SizedBox(height: 12),
          const Text("Ravi de vous annoncer l'ouverture de nos nouveaux bureaux. Une étape importante pour l'équipe !", style: TextStyle(fontSize: 12, color: Color(0xFF374151))),
          const SizedBox(height: 12),
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color(0xFF1E293B)),
            child: const Center(child: Icon(Icons.business, color: Colors.white30, size: 40)),
          ),
          const SizedBox(height: 12),
          _buildPostStatsAndActions("245", "48"),
        ],
      ),
    );
  }

  Widget _buildJobShareCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE5E7EB))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              CircleAvatar(radius: 18, backgroundColor: Color(0xFFE5E7EB)),
              const SizedBox(width: 10),
              Text("Jean-Baptiste Koffi a partagé un emploi • 4h", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 11.5)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF9FAFB), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE5E7EB))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Product Designer UI/UX", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    Text("THIX Group - Kinshasa (Hybride)", style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2563EB), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6))),
                  child: const Text("Postuler", style: TextStyle(fontSize: 11, color: Colors.white)),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildPostStatsAndActions("89", "14"),
        ],
      ),
    );
  }

  Widget _buildPostStatsAndActions(String likes, String comments) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$likes Mentions j'aime", style: const TextStyle(fontSize: 10.5, color: Colors.grey)),
            Text("$comments commentaires", style: const TextStyle(fontSize: 10.5, color: Colors.grey)),
          ],
        ),
        const Divider(height: 16, color: Color(0xFFF3F4F6)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildActionLabel(Icons.thumb_up_out_line_rounded, "J'aime"),
            _buildActionLabel(Icons.chat_bubble_outline, "Commenter"),
            _buildActionLabel(Icons.share_outlined, "Partager"),
          ],
        )
      ],
    );
  }

  Widget _buildActionLabel(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF4B5563)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(color: Color(0xFF4B5563), fontSize: 11, fontWeight: FontWeight.w500)),
      ],
    );
  }

  // --- PANNEAU DROIT (WIDGETS COMPACTS) ---

  Widget _buildProfileMiniCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          const CircleAvatar(radius: 28, backgroundColor: Color(0xFF2563EB)),
          const SizedBox(height: 8),
          const Text("Michel Sony", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          const Text("Développeur & Entrepreneur", style: TextStyle(fontSize: 11, color: Colors.grey)),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(children: const [Text("342", style: TextStyle(fontWeight: FontWeight.bold)), Text("Relations", style: TextStyle(fontSize: 9.5, color: Colors.grey))]),
              Column(children: const [Text("28", style: TextStyle(fontWeight: FontWeight.bold)), Text("Vues", style: TextStyle(fontSize: 9.5, color: Colors.grey))]),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildRecentConnectionsWidget() => _buildCompactList("Relations récentes", ["Sarah Mitonga", "Alexandre Kabeya"]);
  Widget _buildUpcomingEventsWidget() => _buildCompactList("Événements", ["Conférence THIX ID", "Pitch de Deel 2026"]);
  Widget _buildPopularGroupsWidget() => _buildCompactList("Groupes suggérés", ["Flutter Afrique", "Startup Hub RDC"]);
  Widget _buildRecommendedJobsWidget() => _buildCompactList("Offres recommandées", ["Mobile Dev (Flutter)", "Cybersecurity Lead"]);

  Widget _buildCompactList(String title, List<String> items) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Column(
            children: items.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.lens, size: 6, color: Color(0xFF2563EB)),
                  const SizedBox(width: 8),
                  Text(item, style: const TextStyle(fontSize: 11.5, color: Color(0xFF374151))),
                ],
              ),
            )).toList(),
          )
        ],
      ),
    );
  }

  // --- BARRE DE NAVIGATION INFÉRIEURE ---

  Widget _buildBottomNavbar() {
    return BottomAppBar(
      color: Colors.white,
      child: SizedBox(
        height: 52,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildBottomItem(Icons.home, "Accueil", true),
            _buildBottomItem(Icons.people_outline, "Réseau", false),
            _buildBottomItem(Icons.add_box_outlined, "Post", false),
            _buildBottomItem(Icons.cases_outlined, "Emplois", false),
            _buildBottomItem(Icons.chat_bubble_outline, "Messages", false),
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
        Icon(icon, color: selected ? const Color(0xFF2563EB) : Colors.grey, size: 20),
        Text(text, style: TextStyle(fontSize: 9, color: selected ? const Color(0xFF2563EB) : Colors.grey)),
      ],
    );
  }
}
