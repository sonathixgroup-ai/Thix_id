import 'package:flutter/material.dart';

class NetworkPage extends StatelessWidget {
  const NetworkPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Couleurs officielles THIX
    const primaryBlue = Color(0xFF0D6EFD);
    const textDark = Color(0xFF1E293B);
    const bgLight = Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.blur_on, color: primaryBlue, size: 22),
            ),
            const SizedBox(width: 8),
            const Text(
              'THIX RÉSEAU PRO',
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(
              label: Text('3', style: TextStyle(color: Colors.white, fontSize: 10)),
              child: Icon(Icons.notifications_none, color: textDark),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: const Badge(
              label: Text('5', style: TextStyle(color: Colors.white, fontSize: 10)),
              child: Icon(Icons.chat_bubble_outline, color: textDark),
            ),
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. BLOC PROFIL FIXE (Anciennement à droite, maintenant adapté au mobile)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.blueGrey,
                          child: Icon(Icons.person, color: Colors.white, size: 28),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Hi, Koffi Amani",
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textDark),
                                  ),
                                  SizedBox(width: 4),
                                  Text("👋", style: TextStyle(fontSize: 14)),
                                ],
                              ),
                              const Text(
                                "Entrepreneur | Innovateur",
                                style: TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  Icon(Icons.location_on, size: 12, color: Colors.grey[600]),
                                  const SizedBox(width: 2),
                                  Text(
                                    "Abidjan, Côte d'Ivoire",
                                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 36),
                        side: const BorderSide(color: primaryBlue),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {},
                      child: const Text("Voir mon profil", style: TextStyle(color: primaryBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    const Divider(height: 1),
                    const SizedBox(height: 12),
                    // Statistiques Réseau
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem("128", "Connexions"),
                        _buildStatItem("24", "Demandes"),
                        _buildStatItem("18", "Visites"),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 2. BARRE DE RECHERCHE
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withOpacity(0.15)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Rechercher des personnes, entreprises...",
                    hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 3. BOUTONS D'ACTIONS RAPIDES (Taille mobile optimisée)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.3,
                children: [
                  _buildQuickAction(Icons.person_add_alt_1, "Trouver des\npersonnes", primaryBlue),
                  _buildQuickAction(Icons.business, "Entreprises", Colors.emerald),
                  _buildQuickAction(Icons.work_outline, "Offres d'emploi", Colors.orange),
                ],
              ),
              const SizedBox(height: 20),

              // 4. SECTION : SUGGESTIONS POUR VOUS (Défilement horizontal fluide)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Suggestions pour vous", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textDark)),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                    child: const Text("Voir tout", style: TextStyle(fontSize: 12, color: primaryBlue, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 155, // Hauteur contrôlée pour éviter le "Right/Bottom Overflowed"
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSuggestionCard("Ismaël Koné", "CEO, AgroVision", "12 en commun"),
                    _buildSuggestionCard("Fatou N'Guessan", "Consultante RH", "7 en commun"),
                    _buildSuggestionCard("Herve Yao", "Investisseur", "5 en commun"),
                    _buildSuggestionCard("Adama Bakayoko", "Développeur Fullstack", "9 en commun"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 5. SECTION : FIL D'ACTUALITÉ
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Fil d'actualité", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textDark)),
                  Row(
                    children: [
                      Text("Trier par : ", style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                      Text("Récents", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textDark)),
                      Icon(Icons.arrow_drop_down, size: 16, color: Colors.grey[600]),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildFeedPost(
                author: "Aïcha Diallo",
                role: "CEO, TechNova",
                time: "2h",
                text: "Heureuse d'annoncer le lancement de notre nouvelle plateforme d'intelligence artificielle dédiée aux PME. Hâte d'avoir vos retours !",
              ),
            ],
          ),
        ),
      ),
      // BARRE DE NAVIGATION INFÉRIEURE MOBILE
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // "Réseau" activé
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 11,
        unselectedFontSize: 11,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), activeIcon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), activeIcon: Icon(Icons.people), label: 'Réseau'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 36, color: primaryBlue), label: 'Créer'),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), activeIcon: Icon(Icons.mail), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), activeIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // Widget utilitaire pour les statistiques du profil
  Widget _buildStatItem(String count, String label) {
    return Column(
      children: [
        Text(count, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  // Widget utilitaire pour les boutons d'actions en grille
  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 6),
          Text(
            label, 
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), height: 1.2), 
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Widget utilitaire pour les cartes de suggestions horizontales
  Widget _buildSuggestionCard(String name, String title, String mutual) {
    return Container(
      width: 135,
      margin: const EdgeInsets.only(right: 10, bottom: 4),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 18, 
            backgroundColor: Color(0xFFE2E8F0), 
            child: Icon(Icons.person, color: Colors.blueGrey, size: 20)
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(title, style: const TextStyle(fontSize: 9, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 2),
          Text(mutual, style: const TextStyle(fontSize: 8, color: Colors.grey), maxLines: 1),
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            height: 24,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D6EFD),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                elevation: 0,
              ),
              onPressed: () {},
              child: const Text("Se connecter", style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  // Widget utilitaire pour le rendu d'un post dans le fil
  Widget _buildFeedPost({required String author, required String role, required String time, required String text}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 16, backgroundColor: Color(0xFFCBD5E1), child: Icon(Icons.person, size: 16, color: Colors.white)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                    Text("$role • $time", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
              Icon(Icons.more_vert, size: 16, color: Colors.grey[600]),
            ],
          ),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(fontSize: 12, height: 1.3, color: Color(0xFF334155))),
          const SizedBox(height: 10),
          // Bannière TechNova AI simulée proprement sans assets externes requis
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("TechNova AI", style: TextStyle(color: Color(0xFF38BDF8), fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 4),
                Text(
                  "L'intelligence au service\nde votre croissance.", 
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 11, fontWeight: FontWeight.w500, height: 1.2),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPostActionButton(Icons.thumb_up_out_line_rounded, "J'aime"),
              _buildPostActionButton(Icons.chat_bubble_outline, "Commenter"),
              _buildPostActionButton(Icons.share_outlined, "Partager"),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPostActionButton(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500)),
      ],
    );
  }
}
