
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
      backgroundColor: const Color(0xffF7F7FA),

      bottomNavigationBar: bottomBar(),

      body: SafeArea(
        child: SingleChildScrollView(
          physics:
              const BouncingScrollPhysics(),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                /// ================= HEADER =================
                Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius
                                .circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(.03),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "R",
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight:
                                FontWeight
                                    .w900,
                            color: Color(
                                0xff2563FF),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: const [
                          Row(
                            children: [
                              Text(
                                "THIX ",
                                style:
                                    TextStyle(
                                  fontSize:
                                      18,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                ),
                              ),
                              Text(
                                "RÉSERVATION",
                                style:
                                    TextStyle(
                                  fontSize:
                                      18,
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                  color: Color(
                                      0xff2563FF),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 2),

                          Text(
                            "Réservez tout, partout, en toute simplicité.",
                            style: TextStyle(
                              color:
                                  Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    topIcon(
                        Icons.notifications_none),

                    const SizedBox(width: 10),

                    topIcon(Icons.person_outline),
                  ],
                ),

                const SizedBox(height: 22),

                /// ================= HERO =================
                Container(
                  height: 182,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                            28),
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xffF5F2FF),
                        Color(0xffEEF3FF),
                      ],
                    ),
                  ),

                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets
                                .all(20),
                        child: Row(
                          children: [
                            /// LEFT
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal:
                                          10,
                                      vertical:
                                          4,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: Colors
                                          .white,
                                      borderRadius:
                                          BorderRadius.circular(
                                              10),
                                    ),
                                    child:
                                        const Text(
                                      "⚡ PROMO FLASH",
                                      style:
                                          TextStyle(
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Color(
                                            0xffFFB800),
                                        fontSize:
                                            11,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          14),

                                  RichText(
                                    text:
                                        const TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "Jusqu’à ",
                                          style:
                                              TextStyle(
                                            fontSize:
                                                20,
                                            color:
                                                Colors.black,
                                            fontWeight:
                                                FontWeight.w700,
                                          ),
                                        ),
                                        TextSpan(
                                          text:
                                              "-40%",
                                          style:
                                              TextStyle(
                                            fontSize:
                                                20,
                                            color:
                                                Color(0xff6B4EFF),
                                            fontWeight:
                                                FontWeight.w900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          4),

                                  const Text(
                                    "sur vos réservations de bus & vols",
                                    style:
                                        TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          8),

                                  const Text(
                                    "Valable jusqu'au 30 Juin 2025",
                                    style:
                                        TextStyle(
                                      color:
                                          Colors.grey,
                                      fontSize:
                                          12,
                                    ),
                                  ),

                                  const Spacer(),

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal:
                                          18,
                                      vertical:
                                          12,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: const Color(
                                          0xff2563FF),
                                      borderRadius:
                                          BorderRadius.circular(
                                              14),
                                    ),
                                    child:
                                        const Text(
                                      "Profiter maintenant",
                                      style:
                                          TextStyle(
                                        color: Colors
                                            .white,
                                        fontWeight:
                                            FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// RIGHT IMAGE
                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: Image
                                        .network(
                                      "https://cdn-icons-png.flaticon.com/512/744/744465.png",
                                      height:
                                          90,
                                    ),
                                  ),

                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child: Image
                                        .network(
                                      "https://cdn-icons-png.flaticon.com/512/1995/1995470.png",
                                      height:
                                          115,
                                    ),
                                  ),

                                  Positioned(
                                    right: 90,
                                    bottom: 18,
                                    child: Image
                                        .network(
                                      "https://cdn-icons-png.flaticon.com/512/3081/3081559.png",
                                      height:
                                          55,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: 10,
                        top: 76,
                        child: arrowButton(
                            Icons.chevron_left),
                      ),

                      Positioned(
                        right: 10,
                        top: 76,
                        child: arrowButton(
                            Icons.chevron_right),
                      ),

                      Positioned(
                        bottom: 14,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: [
                            indicator(true),
                            indicator(false),
                            indicator(false),
                            indicator(false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// ================= SERVICES =================
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                            24),
                  ),

                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceAround,
                    children: [
                      serviceItem(
                        "https://cdn-icons-png.flaticon.com/512/1995/1995470.png",
                        "Bus",
                      ),
                      serviceItem(
                        "https://cdn-icons-png.flaticon.com/512/744/744465.png",
                        "Vol",
                      ),
                      serviceItem(
                        "https://cdn-icons-png.flaticon.com/512/139/139899.png",
                        "Hôtel",
                      ),
                      serviceItem(
                        "https://cdn-icons-png.flaticon.com/512/3097/3097144.png",
                        "Taxi",
                      ),
                      serviceItem(
                        "https://cdn-icons-png.flaticon.com/512/2972/2972185.png",
                        "Livraison",
                      ),
                      serviceItem(
                        "",
                        "Plus",
                        isMore: true,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// ================= RESERVATIONS =================
                sectionHeader(
                    "Mes réservations"),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: bookingCard(
                        Colors.blue,
                        Icons.luggage,
                        "À venir",
                        "3",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: bookingCard(
                        Colors.green,
                        Icons.access_time,
                        "En cours",
                        "1",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: bookingCard(
                        Colors.purple,
                        Icons.check_circle,
                        "Terminées",
                        "8",
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: bookingCard(
                        Colors.red,
                        Icons.cancel,
                        "Annulées",
                        "0",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                /// ================= OFFERS =================
                sectionHeader(
                    "Offres spéciales pour vous"),

                const SizedBox(height: 14),

                SizedBox(
                  height: 138,
                  child: ListView(
                    scrollDirection:
                        Axis.horizontal,
                    children: [
                      offerCard(
                        "Hôtels",
                        "-30%",
                        "Séjournez plus,\npayez moins",
                        "https://cdn-icons-png.flaticon.com/512/139/139899.png",
                        const Color(
                            0xffF9F3FF),
                      ),
                      offerCard(
                        "Vols",
                        "-20%",
                        "Sur tous les vols",
                        "https://cdn-icons-png.flaticon.com/512/744/744465.png",
                        const Color(
                            0xffEDF7FF),
                      ),
                      offerCard(
                        "Bus",
                        "-15%",
                        "Voyagez en toute\nconfiance",
                        "https://cdn-icons-png.flaticon.com/512/1995/1995470.png",
                        const Color(
                            0xffEEF8FF),
                      ),
                      offerCard(
                        "Livraison",
                        "-10%",
                        "Envoi express",
                        "https://cdn-icons-png.flaticon.com/512/3081/3081559.png",
                        const Color(
                            0xffFFF7EC),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// ================= PARRAINAGE =================
                Container(
                  height: 100,
                  padding:
                      const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(
                        0xffF8F4FF),
                    borderRadius:
                        BorderRadius.circular(
                            24),
                  ),

                  child: Row(
                    children: [
                      Image.network(
                        "https://cdn-icons-png.flaticon.com/512/2583/2583344.png",
                        height: 58,
                      ),

                      const SizedBox(width: 16),

                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            Text(
                              "Parrainez & Gagnez !",
                              style:
                                  TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .w800,
                                color: Color(
                                    0xff7B3AED),
                              ),
                            ),

                            SizedBox(height: 6),

                            Text(
                              "Invitez vos proches et gagnez jusqu'à 10.000 FC par parrainage.",
                              style:
                                  TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            NetworkImage(
                          "https://i.pravatar.cc/300",
                        ),
                      ),

                      const CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            NetworkImage(
                          "https://i.pravatar.cc/301",
                        ),
                      ),

                      const CircleAvatar(
                        radius: 18,
                        backgroundImage:
                            NetworkImage(
                          "https://i.pravatar.cc/302",
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Icon(
                        Icons.chevron_right,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                /// ================= RESTAURANTS =================
                sectionHeader(
                    "Restaurants à proximité"),

                const SizedBox(height: 14),

                SizedBox(
                  height: 220,
                  child: ListView(
                    scrollDirection:
                        Axis.horizontal,
                    children: [
                      restaurantCard(
                        "Le Goût d'Ici",
                        "Africaine",
                        "20-30 min",
                        "4.6",
                        "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=800",
                      ),
                      restaurantCard(
                        "Fast & Good",
                        "Fast Food",
                        "15-25 min",
                        "4.8",
                        "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800",
                      ),
                      restaurantCard(
                        "Pizza Time",
                        "Italienne",
                        "20-30 min",
                        "4.5",
                        "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800",
                      ),
                      restaurantCard(
                        "Sushi House",
                        "Japonaise",
                        "25-35 min",
                        "4.7",
                        "https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=800",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                /// ================= ANNONCES =================
                sectionHeader("Annonces"),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Expanded(
                      child: annonceCard(
                        "À VENDRE",
                        "Toyota RAV4 2021",
                        "25.000.000 FC",
                        Colors.green,
                        "https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=800",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: annonceCard(
                        "À LOUER",
                        "Appartement 3 pièces",
                        "600.000 FC / mois",
                        Colors.pink,
                        "https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=800",
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: annonceCard(
                        "SERVICE",
                        "Ménage à domicile",
                        "À partir de 10.000 FC",
                        Colors.green,
                        "https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=800",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// ================= FOOT FEATURES =================
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceAround,
                  children: const [
                    featureBottom(
                      Icons.shield_outlined,
                      "Paiement sécurisé",
                      "Transactions 100% sûres",
                    ),
                    featureBottom(
                      Icons.headset_mic_outlined,
                      "Support 24/7",
                      "Nous sommes là",
                    ),
                    featureBottom(
                      Icons.workspace_premium_outlined,
                      "Meilleurs prix",
                      "Garantie incluse",
                    ),
                    featureBottom(
                      Icons.cancel_outlined,
                      "Annulation facile",
                      "Flexible et rapide",
                    ),
                  ],
                ),

                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget bottomBar() {
    return Container(
      height: 88,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        ),
      ),

      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          navItem(Icons.home, "Accueil", 0),
          navItem(Icons.explore_outlined,
              "Explorer", 1),

          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xff2563FF),
                  Color(0xff0047FF),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue
                      .withOpacity(.3),
                  blurRadius: 16,
                ),
              ],
            ),
            child: const Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
                SizedBox(height: 2),
                Text(
                  "Réserver",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          navItem(Icons.receipt_long,
              "Mes réservations", 3),
          navItem(Icons.person_outline,
              "Profil", 4),
        ],
      ),
    );
  }

  Widget navItem(
      IconData icon,
      String title,
      int index) {
    final active = currentIndex == index;

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: active
              ? const Color(0xff2563FF)
              : Colors.grey,
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: active
                ? const Color(0xff2563FF)
                : Colors.grey,
          ),
        ),
      ],
    );
  }
}

/// ================= WIDGETS =================

Widget topIcon(IconData icon) {
  return Container(
    width: 52,
    height: 52,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.04),
          blurRadius: 10,
        ),
      ],
    ),
    child: Icon(icon),
  );
}

Widget arrowButton(IconData icon) {
  return Container(
    width: 34,
    height: 34,
    decoration: BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 6,
        ),
      ],
    ),
    child: Icon(icon, size: 20),
  );
}

Widget indicator(bool active) {
  return Container(
    margin:
        const EdgeInsets.symmetric(
            horizontal: 3),
    width: active ? 16 : 8,
    height: 8,
    decoration: BoxDecoration(
      color: active
          ? const Color(0xff2563FF)
          : Colors.grey.shade300,
      borderRadius:
          BorderRadius.circular(10),
    ),
  );
}

Widget serviceItem(
  String image,
  String title, {
  bool isMore = false,
}) {
  return Column(
    children: [
      Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          color: const Color(0xffF7F7FA),
          borderRadius:
              BorderRadius.circular(18),
        ),
        child: isMore
            ? const Icon(
                Icons.grid_view_rounded,
                color: Colors.grey,
                size: 30,
              )
            : Padding(
                padding:
                    const EdgeInsets.all(8),
                child: Image.network(image),
              ),
      ),

      const SizedBox(height: 8),

      Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget sectionHeader(String title) {
  return Row(
    mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      Row(
        children: const [
          Text(
            "Voir tout",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          SizedBox(width: 4),
          Icon(
            Icons.chevron_right,
            size: 18,
            color: Colors.grey,
          ),
        ],
      ),
    ],
  );
}

Widget bookingCard(
  Color color,
  IconData icon,
  String title,
  String count,
) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor:
              color.withOpacity(.12),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          count,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    ),
  );
}

Widget offerCard(
  String title,
  String percent,
  String desc,
  String image,
  Color bg,
) {
  return Container(
    width: 160,
    margin: const EdgeInsets.only(right: 12),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: bg,
      borderRadius:
          BorderRadius.circular(22),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                percent,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w900,
                  color: Color(0xff2563FF),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                desc,
                style: const TextStyle(
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),

        Image.network(
          image,
          width: 56,
        ),
      ],
    ),
  );
}

Widget restaurantCard(
  String title,
  String type,
  String time,
  String rate,
  String image,
) {
  return Container(
    width: 165,
    margin: const EdgeInsets.only(right: 14),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.network(
                image,
                height: 110,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 10,
              right: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      rate,
                      style:
                          const TextStyle(
                        color:
                            Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding:
              const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.favorite_border,
                    size: 18,
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Text(
                type,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),

              const SizedBox(height: 6),

              Row(
                children: [
                  Text(
                    time,
                    style:
                        const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    "\$\$",
                    style: TextStyle(
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget annonceCard(
  String tag,
  String title,
  String price,
  Color color,
  String image,
) {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(20),
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
                top: Radius.circular(20),
              ),
              child: Image.network(
                image,
                height: 105,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                      BorderRadius.circular(
                          10),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),

            const Positioned(
              top: 10,
              right: 10,
              child: CircleAvatar(
                radius: 14,
                backgroundColor:
                    Colors.white,
                child: Icon(
                  Icons.favorite_border,
                  size: 16,
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding:
              const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight:
                      FontWeight.w700,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                price,
                style: const TextStyle(
                  fontWeight:
                      FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class featureBottom extends StatelessWidget {
  final IconData icon;
  final String title;
  final String sub;

  const featureBottom(
    this.icon,
    this.title,
    this.sub, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xff2563FF),
        ),

        const SizedBox(height: 8),

        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          sub,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}
