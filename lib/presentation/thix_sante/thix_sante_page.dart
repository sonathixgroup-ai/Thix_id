import 'package:flutter/material.dart';

class ThixSantePage extends StatelessWidget {
  const ThixSantePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ========== EN-TÊTE (réduit) ==========
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F172A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'SANTÉ',
                            style: TextStyle(
                              fontSize: 20,
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
                        style: TextStyle(fontSize: 11, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _CompactIconButton(
                        icon: Icons.notifications_none_rounded,
                        onTap: () {},
                        hasBadge: true,
                      ),
                      const SizedBox(width: 8),
                      _CompactIconButton(
                        icon: Icons.person_outline_rounded,
                        onTap: () {},
                        hasBadge: false,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ========== BANNIÈRE HÉRO (très compacte) ==========
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0052CC), Color(0xFF00A8E8), Color(0xFF00F2FE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0052CC).withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -10,
                      bottom: -10,
                      child: Icon(Icons.shield_outlined, size: 100, color: Colors.white.withOpacity(0.15)),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bonjour, Assiyah 🎉',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Votre santé\nentre de bonnes mains',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Consultez, suivez et prenez soin de\nvotre santé au quotidien.',
                          style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.9), height: 1.3),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF0052CC),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.assignment_outlined, size: 16),
                              SizedBox(width: 6),
                              Text('Dossier de santé', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              SizedBox(width: 6),
                              Icon(Icons.arrow_forward_ios_rounded, size: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ========== ACTIONS RAPIDES (5 items, plus compacts) ==========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _TinyActionItem(icon: Icons.calendar_today_rounded, label: 'Rendez-vous', color: const Color(0xFF2563EB)),
                  _TinyActionItem(icon: Icons.health_and_safety_outlined, label: 'Consultation', color: const Color(0xFF10B981)),
                  _TinyActionItem(icon: Icons.biotech_rounded, label: 'Examens', color: const Color(0xFF8B5CF6)),
                  _TinyActionItem(icon: Icons.medication_rounded, label: 'Ordonnances', color: const Color(0xFF1D4ED8)),
                  _TinyActionItem(icon: Icons.favorite_rounded, label: 'Urgences', color: const Color(0xFFEF4444)),
                ],
              ),
              const SizedBox(height: 12),

              // ========== RÉSUMÉ DE SANTÉ (réduit) ==========
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: const [
                            Icon(Icons.favorite_border_rounded, color: Color(0xFF10B981), size: 18),
                            SizedBox(width: 4),
                            Text('Résumé de santé', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                          ],
                        ),
                        TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4), minimumSize: Size.zero),
                          child: const Row(
                            children: [
                              Text('Voir tout ', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, fontSize: 11)),
                              Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Color(0xFF2563EB)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.8,
                      children: [
                        _TinyStatCard(title: 'Consultations', value: '12', subtitle: 'Cette année', color: const Color(0xFFEFF6FF), textColor: const Color(0xFF2563EB)),
                        _TinyStatCard(title: 'Examens', value: '7', subtitle: 'Complétés', color: const Color(0xFFECFDF5), textColor: const Color(0xFF10B981)),
                        _TinyStatCard(title: 'Médicaments', value: '3', subtitle: 'En cours', color: const Color(0xFFF5F3FF), textColor: const Color(0xFF8B5CF6)),
                        _TinyStatCard(title: 'Rendez-vous', value: '2', subtitle: 'À venir', color: const Color(0xFFFFF7ED), textColor: const Color(0xFFF97316)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // ========== SERVICES RAPIDES (grille 2×4, ultra compacte) ==========
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.bolt, color: Color(0xFF2563EB), size: 16),
                      SizedBox(width: 2),
                      Text('Services rapides', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 4), minimumSize: Size.zero),
                    child: const Row(
                      children: [
                        Text('Voir tout ', style: TextStyle(color: Color(0xFF2563EB), fontWeight: FontWeight.w600, fontSize: 11)),
                        Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Color(0xFF2563EB)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.4,
                children: [
                  _TinyServiceCard(
                    icon: Icons.person_search_rounded,
                    title: 'Consulter un médecin',
                    description: 'Parlez à un pro',
                    bgColor: const Color(0xFFEFF6FF),
                    iconColor: const Color(0xFF2563EB),
                  ),
                  _TinyServiceCard(
                    icon: Icons.add_box_rounded,
                    title: 'Dossier médical',
                    description: 'Accédez à votre dossier',
                    bgColor: const Color(0xFFECFDF5),
                    iconColor: const Color(0xFF10B981),
                  ),
                  _TinyServiceCard(
                    icon: Icons.science_outlined,
                    title: 'Résultats d’examens',
                    description: 'Consultez vos analyses',
                    bgColor: const Color(0xFFF5F3FF),
                    iconColor: const Color(0xFF8B5CF6),
                  ),
                  _TinyServiceCard(
                    icon: Icons.assignment_turned_in_rounded,
                    title: 'Mes ordonnances',
                    description: 'Gérez et renouvelez',
                    bgColor: const Color(0xFFFFF7ED),
                    iconColor: const Color(0xFFF97316),
                  ),
                  _TinyServiceCard(
                    icon: Icons.domain_rounded,
                    title: 'Trouver un hôpital',
                    description: 'Hôpitaux proches',
                    bgColor: const Color(0xFFFFF1F0),
                    iconColor: const Color(0xFFEF4444),
                  ),
                  _TinyServiceCard(
                    icon: Icons.local_pharmacy_rounded,
                    title: 'Trouver un médicament',
                    description: 'Vérifiez disponibilité',
                    bgColor: const Color(0xFFE0F2FE),
                    iconColor: const Color(0xFF0284C7),
                  ),
                  _TinyServiceCard(
                    icon: Icons.storefront_rounded,
                    title: 'Pharmacies proches',
                    description: 'Pharmacies à proximité',
                    bgColor: const Color(0xFFE6F9F9),
                    iconColor: const Color(0xFF0891B2),
                  ),
                  _TinyServiceCard(
                    icon: Icons.emergency_rounded,
                    title: 'Urgences proches',
                    description: 'Services 24/7',
                    bgColor: const Color(0xFFFFF1F0),
                    iconColor: const Color(0xFFDC2626),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ========== BANNIÈRE URGENCE (compacte) ==========
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF1F0),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFEE2E2)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.local_hospital_rounded, color: Color(0xFFEF4444), size: 24),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Besoin d’aide immédiate ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0F172A))),
                          Text('Contactez les urgences en un clic', style: TextStyle(fontSize: 10, color: Color(0xFF64748B))),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.call, size: 14),
                      label: const Text('Appeler 15', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ========== COMPOSANTS TRÈS COMPACTS ==========

class _CompactIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool hasBadge;
  const _CompactIconButton({required this.icon, required this.onTap, this.hasBadge = false});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFE2E8F0))),
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: onTap,
            icon: Icon(icon, color: const Color(0xFF1E293B), size: 18),
          ),
        ),
        if (hasBadge)
          Positioned(
            top: 8,
            right: 8,
            child: Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
          ),
      ],
    );
  }
}

class _TinyActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _TinyActionItem({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Center(child: Icon(icon, color: color, size: 22)),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: Color(0xFF475569))),
      ],
    );
  }
}

class _TinyStatCard extends StatelessWidget {
  final String title, value, subtitle;
  final Color color, textColor;
  const _TinyStatCard({required this.title, required this.value, required this.subtitle, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textColor)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                  Text(subtitle, style: const TextStyle(fontSize: 8, color: Color(0xFF94A3B8))),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                child: Icon(Icons.circle, size: 12, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TinyServiceCard extends StatelessWidget {
  final IconData icon;
  final String title, description;
  final Color bgColor, iconColor;
  const _TinyServiceCard({required this.icon, required this.title, required this.description, required this.bgColor, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.01), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                Text(description, style: const TextStyle(fontSize: 9, color: Color(0xFF64748B)), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, size: 10, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}
