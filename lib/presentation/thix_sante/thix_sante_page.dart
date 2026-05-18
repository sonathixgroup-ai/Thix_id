import 'package:flutter/material.dart';

class ThixSantePage extends StatelessWidget {
  const ThixSantePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ========== EN-TÊTE ==========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'THIX ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'SANTÉ',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF00A896),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Votre santé, notre priorité.',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _NotificationIconButton(onTap: () {}),
                      const SizedBox(width: 12),
                      _ProfileIconButton(onTap: () {}),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ========== BANNIÈRE HÉRO ==========
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0052CC), Color(0xFF00A8E8), Color(0xFF00F2FE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0052CC).withOpacity(0.15),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(
                        Icons.shield_outlined,
                        size: 130,
                        color: Colors.white.withOpacity(0.15),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Bonjour, Assiyah 🎉',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Votre santé\nentre de bonnes mains',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Consultez, suivez et prenez soin de\nvotre santé au quotidien.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0052CC),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.assignment_outlined, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Dossier de santé',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_ios_rounded, size: 12),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ========== ACTIONS RAPIDES (5 icônes) ==========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickActionItem(
                    icon: Icons.calendar_today_rounded,
                    label: 'Rendez-vous',
                    color: const Color(0xFF2563EB),
                  ),
                  _QuickActionItem(
                    icon: Icons.health_and_safety_outlined,
                    label: 'Consultation',
                    color: const Color(0xFF10B981),
                  ),
                  _QuickActionItem(
                    icon: Icons.biotech_rounded,
                    label: 'Examens',
                    color: const Color(0xFF8B5CF6),
                  ),
                  _QuickActionItem(
                    icon: Icons.medication_rounded,
                    label: 'Ordonnances',
                    color: const Color(0xFF1D4ED8),
                  ),
                  _QuickActionItem(
                    icon: Icons.favorite_rounded,
                    label: 'Urgences',
                    color: const Color(0xFFEF4444),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ========== RÉSUMÉ DE SANTÉ ==========
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.favorite_border_rounded, color: Color(0xFF10B981), size: 22),
                            SizedBox(width: 8),
                            Text(
                              'Résumé de santé',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Row(
                            children: const [
                              Text('Voir tout ', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
                              Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF2563EB)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1.6,
                      children: [
                        _StatCard(
                          title: 'Consultations',
                          value: '12',
                          subtitle: 'Cette année',
                          icon: Icons.calendar_today_rounded,
                          color: const Color(0xFFEFF6FF),
                          textColor: const Color(0xFF2563EB),
                        ),
                        _StatCard(
                          title: 'Examens',
                          value: '7',
                          subtitle: 'Complétés',
                          icon: Icons.biotech_rounded,
                          color: const Color(0xFFECFDF5),
                          textColor: const Color(0xFF10B981),
                        ),
                        _StatCard(
                          title: 'Médicaments',
                          value: '3',
                          subtitle: 'En cours',
                          icon: Icons.medical_services_outlined,
                          color: const Color(0xFFF5F3FF),
                          textColor: const Color(0xFF8B5CF6),
                        ),
                        _StatCard(
                          title: 'Rendez-vous',
                          value: '2',
                          subtitle: 'À venir',
                          icon: Icons.event_note_rounded,
                          color: const Color(0xFFFFF7ED),
                          textColor: const Color(0xFFF97316),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ========== SERVICES RAPIDES (8 cartes) ==========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.bolt, color: Color(0xFF2563EB), size: 22),
                      SizedBox(width: 4),
                      Text(
                        'Services rapides',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: const [
                        Text('Voir tout ', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600)),
                        Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF2563EB)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1.5,
                children: [
                  _ServiceCard(
                    icon: Icons.person_search_rounded,
                    title: 'Consulter un médecin',
                    description: 'Parlez à un professionnel',
                    bgColor: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF2563EB),
                  ),
                  _ServiceCard(
                    icon: Icons.add_box_rounded,
                    title: 'Dossier médical',
                    description: 'Accédez à votre dossier de santé',
                    bgColor: const Color(0xFFECFDF5),
                    iconColor: const Color(0xFF10B981),
                  ),
                  _ServiceCard(
                    icon: Icons.science_outlined,
                    title: 'Résultats d’examens',
                    description: 'Consultez vos analyses',
                    bgColor: const Color(0xFFF5F3FF),
                    iconColor: const Color(0xFF8B5CF6),
                  ),
                  _ServiceCard(
                    icon: Icons.assignment_turned_in_rounded,
                    title: 'Mes ordonnances',
                    description: 'Gérez et renouvelez vos ordonnances',
                    bgColor: const Color(0xFFFFF7ED),
                    iconColor: const Color(0xFFF97316),
                  ),
                  _ServiceCard(
                    icon: Icons.domain_rounded,
                    title: 'Trouver un hôpital',
                    description: 'Trouvez l’hôpital le plus proche',
                    bgColor: const Color(0xFFFFF1F0),
                    iconColor: const Color(0xFFEF4444),
                  ),
                  _ServiceCard(
                    icon: Icons.local_pharmacy_rounded,
                    title: 'Trouver un médicament',
                    description: 'Vérifiez la disponibilité',
                    bgColor: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0284C7),
                  ),
                  _ServiceCard(
                    icon: Icons.storefront_rounded,
                    title: 'Pharmacies proches',
                    description: 'Trouvez la pharmacie la plus proche',
                    bgColor: const Color(0xFFE6F9F9),
                    iconColor: const Color(0xFF0891B2),
                  ),
                  _ServiceCard(
                    icon: Icons.emergency_rounded,
                    title: 'Urgences proches',
                    description: 'Services d’urgence disponibles 24/7',
                    bgColor: const Color(0xFFFFF1F0),
                    iconColor: const Color(0xFFDC2626),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ========== BANNIÈRE URGENCE ==========
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F0),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFFEE2E2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.local_hospital_rounded, color: Color(0xFFEF4444), size: 28),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Besoin d’aide immédiate ?',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Contactez les urgences en un clic',
                            style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.call, size: 16),
                      label: const Text('Appeler 15', style: TextStyle(fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== COMPOSANTS ==========

class _NotificationIconButton extends StatelessWidget {
  final VoidCallback onTap;
  const _NotificationIconButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Stack(
        children: [
          IconButton(
            onPressed: onTap,
            icon: const Icon(Icons.notifications_none_rounded, color: Color(0xFF1E293B), size: 24),
          ),
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileIconButton extends StatelessWidget {
  final VoidCallback onTap;
  const _ProfileIconButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.person, color: Colors.white, size: 22),
      ),
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(icon, color: color, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Color textColor;
  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(icon, size: 18, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color bgColor;
  final Color iconColor;
  const _ServiceCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.bgColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(14)),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}
