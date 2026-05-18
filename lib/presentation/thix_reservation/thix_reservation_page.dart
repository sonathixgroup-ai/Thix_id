import 'package:flutter/material.dart';

class ThixReservationPage extends StatefulWidget {
  const ThixReservationPage({super.key});

  @override
  State<ThixReservationPage> createState() =>
      _ThixReservationPageState();
}

class _ThixReservationPageState
    extends State<ThixReservationPage> {
  int currentIndex = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),

      /// ================= BOTTOM NAV =================
      bottomNavigationBar: Container(
        height: 86,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 12,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            navItem(Icons.home, "Accueil", 0),
            navItem(Icons.explore_outlined,
                "Explorer", 1),
            centerButton(),
            navItem(Icons.calendar_month,
                "Réservations", 3),
            navItem(Icons.person_outline,
                "Profil", 4),
          ],
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),

              /// ================= HEADER =================
              Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(.04),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        "R",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Colors.blue,
                        ),
                      ),
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
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.w900,
                              color:
                                  Color(0xff101828),
                            ),
                          ),
                          Text(
                            "RÉSERVATION",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight:
                                  FontWeight.w900,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Réservez tout, partout, en toute simplicité.",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  notificationButton(),

                  const SizedBox(width: 12),

                  iconButton(
                    Icons.person_outline,
                  ),
                ],
              ),

              const SizedBox(height: 22),

              /// ================= PROMO BANNER =================
              Container(
                height: 215,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(32),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffF6F3FF),
                      Color(0xffEEF3FF),
                    ],
                  ),
                ),

                child: Stack(
                  children: [
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(
                                32),
                        child: Image.network(
                          "https://images.unsplash.com/photo-1436491865332-7a61a109cc05?q=80&w=1200&auto=format&fit=crop",
                          width: 220,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Padding(
                      padding:
                          const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          const Text(
                            "⚡ PROMO FLASH",
                            style: TextStyle(
                              color: Colors.orange,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 16),

                          RichText(
                            text: const TextSpan(
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 38,
                                fontWeight:
                                    FontWeight.w900,
                              ),
                              children: [
                                TextSpan(
                                  text: "Jusqu'à ",
                                ),
                                TextSpan(
                                  text: "-40%",
                                  style: TextStyle(
                                    color:
                                        Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          const SizedBox(
                            width: 190,
                            child: Text(
                              "sur vos réservations de bus & vols",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.w600,
                                color:
                                    Color(0xff101828),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          const Text(
                            "Valable jusqu'au 30 Juin 2025",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),

                          const Spacer(),

                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          14),
                            ),
                            child: const Text(
                              "Profiter maintenant",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// ================= CATEGORIES =================
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(28),
                ),

                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceAround,
                  children: const [
                    category("🚌", "Bus"),
                    category("✈️", "Vol"),
                    category("🏨", "Hôtel"),
                    category("🚕", "Taxi"),
                    category("🛵", "Livraison"),
                    category("⚪", "Plus"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              sectionTitle("Mes réservations"),

              const SizedBox(height: 14),

              Row(
                children: const [
                  Expanded(
                    child: statsCard(
                      "🧳",
                      "À venir",
                      "3",
                      Colors.blue,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: statsCard(
                      "🟢",
                      "En cours",
                      "1",
                      Colors.green,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Row(
                children: const [
                  Expanded(
                    child: statsCard(
                      "🟣",
                      "Terminées",
                      "8",
                      Colors.purple,
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: statsCard(
                      "❌",
                      "Annulées",
                      "0",
                      Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 26),

              sectionTitle(
                  "Offres spéciales pour vous"),

              const SizedBox(height: 14),

              GridView.count(
                shrinkWrap: true,
                physics:
                    const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: const [
                  offerCard(
                    "Hôtels",
                    "-30%",
                    "https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1200&auto=format&fit=crop",
                  ),
                  offerCard(
                    "Vols",
                    "-20%",
                    "https://images.unsplash.com/photo-1436491865332-7a61a109cc05?q=80&w=1200&auto=format&fit=crop",
                  ),
                  offerCard(
                    "Bus",
                    "-15%",
                    "https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?q=80&w=1200&auto=format&fit=crop",
                  ),
                  offerCard(
                    "Livraison",
                    "-10%",
                    "https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?q=80&w=1200&auto=format&fit=crop",
                  ),
                ],
              ),

              const SizedBox(height: 22),

              /// ================= REFERRAL =================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(24),
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xffF7ECFF),
                      Color(0xffFAF5FF),
                    ],
                  ),
                ),

                child: Row(
                  children: [
                    const Text(
                      "🎁",
                      style: TextStyle(fontSize: 50),
                    ),

                    const SizedBox(width: 14),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            "Parrainez & Gagnez !",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight:
                                  FontWeight.w900,
                              color: Colors.purple,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Invitez vos proches et gagnez jusqu'à 10.000 FC.",
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Row(
                      children: List.generate(
                        4,
                        (index) => Container(
                          margin:
                              const EdgeInsets.only(
                                  left: 4),
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color:
                                    Colors.white,
                                width: 2),
                            image:
                                const DecorationImage(
                              image: NetworkImage(
                                "https://i.pravatar.cc/300",
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              sectionTitle(
                  "Restaurants à proximité"),

              const SizedBox(height: 14),

              SizedBox(
                height: 255,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    restaurantCard(
                      "Le Goût d'Ici",
                      "Africaine",
                      "20-30 min",
                      "4.6",
                      "https://images.unsplash.com/photo-1529042410759-befb1204b468?q=80&w=1200&auto=format&fit=crop",
                    ),
                    SizedBox(width: 14),
                    restaurantCard(
                      "Fast & Good",
                      "Fast Food",
                      "15-25 min",
                      "4.8",
                      "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?q=80&w=1200&auto=format&fit=crop",
                    ),
                    SizedBox(width: 14),
                    restaurantCard(
                      "Pizza Time",
                      "Italienne",
                      "20-30 min",
                      "4.5",
                      "https://images.unsplash.com/photo-1513104890138-7c749659a591?q=80&w=1200&auto=format&fit=crop",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              sectionTitle("Annonces"),

              const SizedBox(height: 14),

              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    annonceCard(
                      "Toyota RAV4 2021",
                      "25.000.000 FC",
                      "À VENDRE",
                      Colors.green,
                      "https://images.unsplash.com/photo-1549399542-7e3f8b79c341?q=80&w=1200&auto=format&fit=crop",
                    ),
                    SizedBox(width: 14),
                    annonceCard(
                      "Appartement 3 pièces",
                      "600.000 FC / mois",
                      "À LOUER",
                      Colors.red,
                      "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=1200&auto=format&fit=crop",
                    ),
                    SizedBox(width: 14),
                    annonceCard(
                      "Ménage à domicile",
                      "À partir de 10.000 FC",
                      "SERVICE",
                      Colors.teal,
                      "https://images.unsplash.com/photo-1581578731548-c64695cc6952?q=80&w=1200&auto=format&fit=crop",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= COMPONENTS =================

  Widget navItem(
      IconData icon, String label, int index) {
    final active = currentIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          currentIndex = index;
        });
      },
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color:
                active ? Colors.blue : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: active
                  ? Colors.blue
                  : Colors.grey,
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
              Colors.blue,
              Color(0xff003CFF),
            ],
          ),
        ),
        child: const Icon(
          Icons.calendar_month,
          color: Colors.white,
          size: 34,
        ),
      ),
    );
  }

  Widget iconButton(IconData icon) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(icon),
    );
  }

  Widget notificationButton() {
    return Stack(
      children: [
        iconButton(Icons.notifications_none),
        Positioned(
          right: 10,
          top: 8,
          child: Container(
            width: 18,
            height: 18,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                "3",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ================= SMALL WIDGETS =================

class category extends StatelessWidget {
  final String emoji;
  final String title;

  const category(this.emoji, this.title,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          emoji,
          style: const TextStyle(fontSize: 38),
        ),
        const SizedBox(height: 8),
        Text(title),
      ],
    );
  }
}

class statsCard extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color color;

  const statsCard(
    this.icon,
    this.title,
    this.value,
    this.color, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(icon,
              style:
                  const TextStyle(fontSize: 24)),
          const SizedBox(height: 10),
          Text(
            title,
            style:
                const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class offerCard extends StatelessWidget {
  final String title;
  final String promo;
  final String image;

  const offerCard(
    this.title,
    this.promo,
    this.image, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.white.withOpacity(.72),
            BlendMode.lighten,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              promo,
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w900,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget sectionTitle(String title) {
  return Row(
    mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.w900,
        ),
      ),
      const Text(
        "Voir tout",
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    ],
  );
}

class restaurantCard extends StatelessWidget {
  final String title;
  final String type;
  final String time;
  final String rate;
  final String image;

  const restaurantCard(
    this.title,
    this.type,
    this.time,
    this.rate,
    this.image, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: Image.network(
                  image,
                  height: 140,
                  width: 220,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    "⭐ $rate",
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  type,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,
                  children: [
                    Text(time),
                    const Text("\$\$"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class annonceCard extends StatelessWidget {
  final String title;
  final String price;
  final String badge;
  final Color badgeColor;
  final String image;

  const annonceCard(
    this.title,
    this.price,
    this.badge,
    this.badgeColor,
    this.image, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(
                  top: Radius.circular(28),
                ),
                child: Image.network(
                  image,
                  height: 150,
                  width: 240,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: badgeColor,
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
