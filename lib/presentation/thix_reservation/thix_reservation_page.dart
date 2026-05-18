import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      extendBody: true,
      backgroundColor: const Color(0xffF5F6FA),

      bottomNavigationBar: _bottomBar(),

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              left: 16,
              right: 16,
              top: 10,
              bottom: 120,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                /// HEADER
                Row(
                  children: [
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                                16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withOpacity(.03),
                            blurRadius: 8,
                            offset:
                                const Offset(
                                    0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          "R",
                          style:
                              GoogleFonts.poppins(
                            fontSize: 32,
                            fontWeight:
                                FontWeight.w900,
                            color: const Color(
                                0xff2563FF),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "THIX ",
                                  style:
                                      GoogleFonts
                                          .poppins(
                                    color: Colors
                                        .black,
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),
                                TextSpan(
                                  text:
                                      "RÉSERVATION",
                                  style:
                                      GoogleFonts
                                          .poppins(
                                    color:
                                        const Color(
                                            0xff2563FF),
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(
                              height: 2),

                          Text(
                            "Réservez tout, partout, en toute simplicité.",
                            style:
                                GoogleFonts.poppins(
                              color:
                                  Colors.grey,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),

                    _topIcon(
                        Icons.notifications_none),

                    const SizedBox(width: 10),

                    _topIcon(Icons.person_outline),
                  ],
                ),

                const SizedBox(height: 14),

                /// HERO CARD
                Container(
                  height: 178,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(
                            20),
                    gradient:
                        const LinearGradient(
                      colors: [
                        Color(0xffF4F2FF),
                        Color(0xffEEF3FF),
                      ],
                    ),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.all(
                                18),
                        child: Row(
                          children: [
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
                                    child: Text(
                                      "⚡ PROMO FLASH",
                                      style:
                                          GoogleFonts
                                              .poppins(
                                        fontSize:
                                            10,
                                        fontWeight:
                                            FontWeight
                                                .w700,
                                        color: const Color(
                                            0xffF5A623),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          10),

                                  RichText(
                                    text:
                                        TextSpan(
                                      children: [
                                        TextSpan(
                                          text:
                                              "Jusqu’à ",
                                          style:
                                              GoogleFonts.poppins(
                                            fontSize:
                                                18,
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
                                              GoogleFonts.poppins(
                                            fontSize:
                                                18,
                                            color:
                                                const Color(0xff6B4EFF),
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

                                  Text(
                                    "sur vos réservations de bus & vols",
                                    style:
                                        GoogleFonts
                                            .poppins(
                                      fontSize:
                                          12,
                                      fontWeight:
                                          FontWeight
                                              .w500,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          8),

                                  Text(
                                    "Valable jusqu'au 30 Juin 2025",
                                    style:
                                        GoogleFonts
                                            .poppins(
                                      fontSize:
                                          10,
                                      color: Colors
                                          .grey,
                                    ),
                                  ),

                                  const Spacer(),

                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .symmetric(
                                      horizontal:
                                          16,
                                      vertical:
                                          10,
                                    ),
                                    decoration:
                                        BoxDecoration(
                                      color: const Color(
                                          0xff2563FF),
                                      borderRadius:
                                          BorderRadius.circular(
                                              12),
                                    ),
                                    child: Text(
                                      "Profiter maintenant",
                                      style:
                                          GoogleFonts
                                              .poppins(
                                        color: Colors
                                            .white,
                                        fontWeight:
                                            FontWeight
                                                .w600,
                                        fontSize:
                                            11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: 0,
                                    right: 10,
                                    child:
                                        Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/744/744465.png",
                                      height:
                                          80,
                                    ),
                                  ),

                                  Positioned(
                                    right: 0,
                                    bottom: 0,
                                    child:
                                        Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/1995/1995470.png",
                                      height:
                                          105,
                                    ),
                                  ),

                                  Positioned(
                                    bottom: 10,
                                    right: 85,
                                    child:
                                        Image.network(
                                      "https://cdn-icons-png.flaticon.com/512/3081/3081559.png",
                                      height:
                                          45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Positioned(
                        left: 8,
                        top: 72,
                        child: _arrowButton(
                            Icons.chevron_left),
                      ),

                      Positioned(
                        right: 8,
                        top: 72,
                        child: _arrowButton(
                            Icons.chevron_right),
                      ),

                      Positioned(
                        bottom: 12,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment
                                  .center,
                          children: [
                            _indicator(true),
                            _indicator(false),
                            _indicator(false),
                            _indicator(false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                /// SERVICES
                Container(
                  height: 108,
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(
                            20),
                  ),
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceAround,
                    children: [
                      _service(
                        "🚌",
                        "Bus",
                      ),
                      _service(
                        "✈️",
                        "Vol",
                      ),
                      _service(
                        "🏨",
                        "Hôtel",
                      ),
                      _service(
                        "🚕",
                        "Taxi",
                      ),
                      _service(
                        "🛵",
                        "Livraison",
                      ),
                      _service(
                        "◻️",
                        "Plus",
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                _sectionHeader(
                    "Mes réservations"),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: _bookingCard(
                        Colors.blue,
                        Icons.luggage,
                        "À venir",
                        "3",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _bookingCard(
                        Colors.green,
                        Icons.timelapse,
                        "En cours",
                        "1",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _bookingCard(
                        Colors.purple,
                        Icons.check_circle,
                        "Terminées",
                        "8",
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _bookingCard(
                        Colors.red,
                        Icons.cancel,
                        "Annulées",
                        "0",
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _sectionHeader(
                    "Offres spéciales pour vous"),

                const SizedBox(height: 12),

                SizedBox(
                  height: 126,
                  child: ListView(
                    scrollDirection:
                        Axis.horizontal,
                    children: [
                      _offerCard(
                          "Hôtels",
                          "-30%"),
                      _offerCard(
                          "Vols", "-20%"),
                      _offerCard(
                          "Bus", "-15%"),
                      _offerCard(
                          "Livraison",
                          "-10%"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topIcon(IconData icon) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.03),
            blurRadius: 8,
          ),
        ],
      ),
      child: Icon(
        icon,
        size: 22,
      ),
    );
  }

  Widget _arrowButton(IconData icon) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.03),
            blurRadius: 6,
          ),
        ],
      ),
      child: Icon(icon, size: 18),
    );
  }

  Widget _indicator(bool active) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
              horizontal: 3),
      width: active ? 14 : 7,
      height: 7,
      decoration: BoxDecoration(
        color: active
            ? const Color(0xff2563FF)
            : Colors.grey.shade300,
        borderRadius:
            BorderRadius.circular(10),
      ),
    );
  }

  Widget _service(
      String emoji, String title) {
    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Text(
          emoji,
          style:
              const TextStyle(fontSize: 30),
        ),

        const SizedBox(height: 6),

        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _bookingCard(
    Color color,
    IconData icon,
    String title,
    String count,
  ) {
    return Container(
      height: 92,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 15,
            backgroundColor:
                color.withOpacity(.12),
            child: Icon(
              icon,
              color: color,
              size: 16,
            ),
          ),

          const Spacer(),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.black54,
            ),
          ),

          Text(
            count,
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _offerCard(
      String title, String percent) {
    return Container(
      width: 150,
      margin:
          const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight:
                  FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            percent,
            style: GoogleFonts.poppins(
              fontSize: 28,
              color:
                  const Color(0xff2563FF),
              fontWeight:
                  FontWeight.w800,
            ),
          ),

          const Spacer(),

          Text(
            "Offre spéciale",
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),

        Row(
          children: [
            Text(
              "Voir tout",
              style:
                  GoogleFonts.poppins(
                fontSize: 11,
                color: Colors.grey,
              ),
            ),

            const SizedBox(width: 4),

            const Icon(
              Icons.chevron_right_rounded,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ],
    );
  }

  Widget _bottomBar() {
    return Container(
      height: 82,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            const BorderRadius.vertical(
          top: Radius.circular(26),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(.04),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          _navItem(
              Icons.home, "Accueil", 0),
          _navItem(Icons.explore_outlined,
              "Explorer", 1),

          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient:
                  const LinearGradient(
                colors: [
                  Color(0xff2563FF),
                  Color(0xff0047FF),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),

                const SizedBox(height: 2),

                Text(
                  "Réserver",
                  style:
                      GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),

          _navItem(Icons.receipt_long,
              "Mes réservations", 3),

          _navItem(Icons.person_outline,
              "Profil", 4),
        ],
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String title,
    int index,
  ) {
    final active = currentIndex == index;

    return Column(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 22,
          color: active
              ? const Color(0xff2563FF)
              : Colors.grey,
        ),

        const SizedBox(height: 4),

        Text(
          title,
          style: GoogleFonts.poppins(
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
