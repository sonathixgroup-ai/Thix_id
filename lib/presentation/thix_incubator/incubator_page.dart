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
            Image.asset('assets/logo_thix.png', height: 32, errorBuilder: (_, __, ___) => const Icon(Icons.blur_on, color: primaryBlue, size: 32)),
            const SizedBox(width: 8),
            const Text(
              'THIX RÉSEAU PRO',
              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Badge(label: Text('3'), child: Icon(Icons.notifications_none, color: textDark)),
            onPressed: () {},
          ),
          IconButton(
            icon: const Badge(label: Text('5'), child: Icon(Icons.chat_bubble_outline, color: textDark)),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.0),
            child: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/profile.jpg'),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Barre de Recherche Rapide
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6)],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Rechercher des personnes, entreprises...",
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // 2. Grille d'actions rapides (Taille ultra-réduite pour mobile)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1.4,
                children: [
                  _buildQuickAction(Icons.person_add_alt_1, "Trouver", primaryBlue),
                  _buildQuickAction(Icons.business, "Entreprises", Colors.emerald),
                  _buildQuickAction(Icons.work_outline, "Emplois", Colors.orange),
                ],
              ),
              const SizedBox(height: 20),

              // 3. Section : Suggestions Pour Vous (Format liste horizontale compacte)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Suggestions pour vous", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textDark)),
                  TextButton(onPressed: () {}, child: const Text("Voir tout", style: TextStyle(fontSize: 13, color: primaryBlue))),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 145, // Hauteur fixe stricte pour empêcher le débordement vertical
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildCompactSuggestionCard("Ismaël Koné", "CEO, AgroVision", "12 en commun"),
                    _buildCompactSuggestionCard("Fatou N'Guessan", "Consultante RH", "7 en commun"),
                    _buildCompactSuggestionCard("Herve Yao", "Investisseur", "5 en commun"),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // 4. Section : Fil d'actualité
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Fil d'actualité", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textDark)),
                  DropdownButton<String>(
                    value: 'Récents',
                    underline: const SizedBox(),
                    style: const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
                    items: <String>['Récents', 'Populaires'].map((String value) {
                      return DropdownMenuItem<String>(value: value, child: Text(value));
                    }).toList(),
                    onChanged: (_) {},
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildFeedPost(
                author: "Aïcha Diallo",
                role: "CEO, TechNova",
                time: "2h",
                text: "Heureuse de d'annoncer le lancement de notre nouvelle plateforme d'intelligence artificielle dédiée aux PME. Hâte d'avoir vos retours !",
              ),
            ],
          ),
        ),
      ),
      // Bottom Navigation Bar Mobile standard
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: primaryBlue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Réseau'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle, size: 36, color: primaryBlue), label: 'Créer'),
          BottomNavigationBarItem(icon: Icon(Icons.mail_outline), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }

  // Composant widget pour les boutons du haut
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
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)), textAlign: Center),
        ],
      ),
    );
  }

  // Composant widget pour les cartes de suggestions (Taille optimisée)
  Widget _buildCompactSuggestionCard(String name, String title, String mutual) {
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
          const CircleAvatar(radius: 20, backgroundColor: Color(0xFFE2E8F0), child: Icon(Icons.person, color: Colors.grey, size: 20)),
          const SizedBox(height: 6),
          Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.grey), maxLines: 1, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 4),
          Text(mutual, style: const TextStyle(fontSize: 9, color: Colors.blueGrey), maxLines: 1),
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

  // Composant widget pour le post du fil d'actualité
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
                    Text(author, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text("$role • $time", style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
              IconButton(icon: const Icon(Icons.more_vert, size: 18, color: Colors.grey), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 8),
          Text(text, style: const TextStyle(fontSize: 12, height: 1.4, color: Color(0xFF334155))),
          const SizedBox(height: 12),
          // Remplacement de l'image lourde par un conteneur d'illustration UI premium simulé
          Container(
            height: 130,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("TechNova AI", style: TextStyle(color: Colors.blue[400], fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                const Text("L'intelligence au service\nde votre croissance.", style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton.icon(onPressed: () {}, icon: const Icon(Icons.thumb_up_out_line_rounded, size: 16, color: Colors.grey), label: const Text("J'aime", style: TextStyle(fontSize: 11, color: Colors.grey))),
              TextButton.icon(onPressed: () {}, icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.grey), label: const Text("Commenter", style: TextStyle(fontSize: 11, color: Colors.grey))),
              TextButton.icon(onPressed: () {}, icon: const Icon(Icons.share_outlined, size: 16, color: Colors.grey), label: const Text("Partager", style: TextStyle(fontSize: 11, color: Colors.grey))),
            ],
          )
        ],
      ),
    );
  }
}
