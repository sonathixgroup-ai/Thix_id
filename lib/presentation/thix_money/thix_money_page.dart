import 'package:flutter/material.dart';

class ThixMoneyPage extends StatefulWidget {
  const ThixMoneyPage({super.key});

  @override
  State<ThixMoneyPage> createState() => _ThixMoneyPageState();
}

class _ThixMoneyPageState extends State<ThixMoneyPage> {
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      /// ================= BOTTOM NAV =================
      bottomNavigationBar: Container(
        height: 78,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            navItem(Icons.home_filled, "Accueil", 0),
            navItem(Icons.swap_horiz, "Transactions", 1),
            centerButton(),
            navItem(Icons.credit_card, "Cartes", 3),
            navItem(Icons.person_outline, "Profil", 4),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),

          child: Column(
            children: [
              const SizedBox(height: 8),

              /// ================= HEADER =================
              Row(
                children: [
                  const Icon(
                    Icons.menu_rounded,
                    size: 30,
                    color: Color(0xff091B4A),
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
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: Color(0xff091B4A),
                            ),
                          ),
                          Text(
                            "MONEY",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 22,
                              color: Color(0xff2563FF),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Votre argent, votre liberté.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Stack(
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        size: 30,
                        color: Color(0xff091B4A),
                      ),
                      Positioned(
                        right: 2,
                        top: 2,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 14),

                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      image: const DecorationImage(
                        image: NetworkImage(
                          "https://i.pravatar.cc/300",
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              /// ================= CARD BALANCE =================
              Container(
                height: size.height * .21,
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xff020B52),
                      Color(0xff00197D),
                    ],
                  ),
                ),

                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Text(
                                "Solde disponible",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.remove_red_eye_outlined,
                                color: Colors.white70,
                                size: 18,
                              ),
                            ],
                          ),

                          const Spacer(),

                          const Text(
                            "1.250.000 FC",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 38,
                              fontWeight: FontWeight.w900,
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            "≈ 625,00 USD",
                            style: TextStyle(
                              color: Color(0xff8EA4FF),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const Spacer(),

                          Row(
                            children: [
                              actionButton(
                                Icons.history,
                                "Historique",
                              ),
                              const SizedBox(width: 12),
                              miniButton(Icons.more_horiz),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 14),

                    /// VISA CARD
                    Container(
                      width: 190,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(22),
                        image: const DecorationImage(
                          image: NetworkImage(
                            "https://images.unsplash.com/photo-1640161704729-cbe966a08476?q=80&w=1200&auto=format&fit=crop",
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// ================= MAIN ACTIONS =================
              Row(
                children: [
                  Expanded(
                    child: quickAction(
                      Colors.blue,
                      Icons.north_east_rounded,
                      "Envoyer",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: quickAction(
                      Colors.green,
                      Icons.add,
                      "Recharger",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: quickAction(
                      Colors.deepPurple,
                      Icons.qr_code_scanner_rounded,
                      "Scanner",
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: quickAction(
                      Colors.orange,
                      Icons.account_balance_wallet_outlined,
                      "Retrait",
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// ================= RAPID PAYMENTS =================
              sectionTitle("Paiements rapides"),

              const SizedBox(height: 8),

              Container(
                height: 92,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    paymentItem(Icons.receipt_long, "Facture"),
                    paymentItem(Icons.groups, "Tontine"),
                    paymentItem(Icons.lightbulb, "Électricité"),
                    paymentItem(Icons.water_drop, "Eau"),
                    paymentItem(Icons.tv, "TV"),
                    paymentItem(Icons.more_horiz, "Plus"),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// ================= HORIZONTAL CARDS =================
              Expanded(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    giftCard(
                      title: "Carte THIX ID",
                      subtitle: "Payez partout avec votre carte",
                      color1: const Color(0xffE9EDFF),
                      color2: Colors.white,
                      button: "Voir carte",
                      image:
                          "https://images.unsplash.com/photo-1640161704729-cbe966a08476?q=80&w=1200&auto=format&fit=crop",
                    ),

                    giftCard(
                      title: "THIX Tontine",
                      subtitle: "Épargnez et atteignez vos objectifs",
                      color1: const Color(0xff011B7A),
                      color2: const Color(0xff052FBF),
                      button: "Rejoindre",
                      image:
                          "https://images.unsplash.com/photo-1529156069898-49953e39b3ac?q=80&w=1200&auto=format&fit=crop",
                      dark: true,
                    ),

                    giftCard(
                      title: "Parrainez & gagnez",
                      subtitle: "Invitez vos proches",
                      color1: const Color(0xffE8FFF0),
                      color2: const Color(0xffF5FFF8),
                      button: "Inviter",
                      image:
                          "https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?q=80&w=1200&auto=format&fit=crop",
                    ),

                    giftCard(
                      title: "Crypto Wallet",
                      subtitle: "Achetez Bitcoin & USDT",
                      color1: const Color(0xff191919),
                      color2: const Color(0xff303030),
                      button: "Investir",
                      image:
                          "https://images.unsplash.com/photo-1621761191319-c6fb62004040?q=80&w=1200&auto=format&fit=crop",
                      dark: true,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= WIDGETS =================

  Widget navItem(IconData icon, String label, int index) {
    final active = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: active ? Colors.blue : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: active ? Colors.blue : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget centerButton() {
    return Transform.translate(
      offset: const Offset(0, -18),
      child: Container(
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              Color(0xff2563FF),
              Color(0xff003CFF),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(.4),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.qr_code_scanner,
                color: Colors.white, size: 28),
            SizedBox(height: 2),
            Text(
              "QR",
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget actionButton(IconData icon, String text) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget miniButton(IconData icon) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white24,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  Widget quickAction(
    Color color,
    IconData icon,
    String title,
  ) {
    return Container(
      height: 105,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),

          const SizedBox(height: 10),

          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget paymentItem(IconData icon, String title) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 22,
          backgroundColor: const Color(0xffF5F6FA),
          child: Icon(icon, color: Colors.blue),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget sectionTitle(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Color(0xff091B4A),
          ),
        ),

        const Icon(
          Icons.arrow_forward_ios_rounded,
          size: 16,
          color: Colors.grey,
        ),
      ],
    );
  }

  Widget giftCard({
    required String title,
    required String subtitle,
    required Color color1,
    required Color color2,
    required String button,
    required String image,
    bool dark = false,
  }) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [color1, color2],
        ),
      ),

      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: dark ? Colors.white : Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  subtitle,
                  style: TextStyle(
                    color: dark
                        ? Colors.white70
                        : Colors.black54,
                    fontSize: 13,
                  ),
                ),

                const Spacer(),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: dark
                        ? Colors.white
                        : const Color(0xff003CFF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    button,
                    style: TextStyle(
                      color: dark
                          ? Colors.black
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              image,
              width: 120,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
