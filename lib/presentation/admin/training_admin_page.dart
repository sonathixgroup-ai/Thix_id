import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thix_id/theme.dart';

class TrainingAdminPage extends StatefulWidget {
  const TrainingAdminPage({super.key});

  @override
  State<TrainingAdminPage> createState() => _TrainingAdminPageState();
}

class _TrainingAdminPageState extends State<TrainingAdminPage> {
  final _supabase = Supabase.instance.client;
  List<dynamic> _trainings = [];
  bool _loading = true;

  static const _brandPurple = Color(0xFF6366F1);
  static const _bgLight = Color(0xFFF8FAFC);
  static const _textDark = Color(0xFF1E293B);
  static const _textGrey = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _loadTrainings();
  }

  Future<void> _loadTrainings() async {
    setState(() => _loading = true);
    try {
      final res = await _supabase.from('thix_trainings').select('*');
      if (!mounted) return;
      setState(() => _trainings = res is List ? res : []);
    } catch (e) {
      debugPrint('Error loading trainings: \$e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: \$e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showCreateTrainingDialog() {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    final priceCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Créer une formation'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(hintText: 'Titre'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descCtrl,
                decoration: const InputDecoration(hintText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceCtrl,
                decoration: const InputDecoration(hintText: 'Prix'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  '⚠️ La formation sera créée en BROUILLON et invisible aux utilisateurs jusqu\'à publication.',
                  style: TextStyle(
                    color: Color(0xFF92400e),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _supabase.from('thix_trainings').insert({
                  'title': titleCtrl.text,
                  'description': descCtrl.text,
                  'price_amount': double.tryParse(priceCtrl.text),
                  'is_published': false,
                  'category': 'General',
                  'level': 'Beginner',
                  'language': 'FR',
                  'delivery_mode': 'online',
                  'currency': 'USD',
                  'is_free': false,
                  'certification_included': true,
                  'is_featured': false,
                });
                if (!mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Formation créée en brouillon!'),
                    backgroundColor: Colors.green,
                  ),
                );
                _loadTrainings();
              } catch (e) {
                debugPrint('Error creating training: \$e');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _brandPurple,
            ),
            child: const Text(
              'Créer',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _publishTraining(dynamic training) async {
    try {
      await _supabase
          .from('thix_trainings')
          .update({'is_published': true})
          .eq('id', training['id']);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ "${training['title']}" publiée!'),
          backgroundColor: Colors.green,
        ),
      );
      _loadTrainings();
    } catch (e) {
      debugPrint('Error publishing: \$e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: \$e')),
      );
    }
  }

  Future<void> _unpublishTraining(dynamic training) async {
    try {
      await _supabase
          .from('thix_trainings')
          .update({'is_published': false})
          .eq('id', training['id']);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⏸️ "${training['title']}" dépubliée'),
          backgroundColor: Colors.orange,
        ),
      );
      _loadTrainings();
    } catch (e) {
      debugPrint('Error unpublishing: \$e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: \$e')),
      );
    }
  }

  Future<void> _deleteTraining(dynamic training) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Supprimer cette formation?'),
        content: Text('Êtes-vous sûr de vouloir supprimer "${training['title']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _supabase
          .from('thix_trainings')
          .delete()
          .eq('id', training['id']);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Formation supprimée'),
          backgroundColor: Colors.red,
        ),
      );
      _loadTrainings();
    } catch (e) {
      debugPrint('Delete error: \$e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: \$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgLight,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text(
          'Gestion des Formations',
          style: TextStyle(
            color: _textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _loadTrainings,
            icon: const Icon(Icons.refresh_rounded, color: _brandPurple),
          ),
        ],
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: _brandPurple),
            )
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                // INFORMATION BANNER
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    border: Border.all(color: _brandPurple.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_rounded, color: _brandPurple, size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              '📋 Brouillon = Invisible aux utilisateurs',
                              style: TextStyle(
                                color: _textDark,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Cliquez "Publier" pour rendre visible dans THIX FORMATION',
                              style: TextStyle(
                                color: _textGrey,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // STATS
                Row(
                  children: [
                    _buildStatCard('Total', _trainings.length.toString()),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      'Publiées',
                      _trainings
                          .where((t) => t['is_published'] == true)
                          .length
                          .toString(),
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      'Brouillons',
                      _trainings
                          .where((t) => t['is_published'] != true)
                          .length
                          .toString(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // LIST
                ..._trainings
                    .map((t) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: (t['is_published'] ?? false)
                                  ? Colors.green.shade300
                                  : const Color(0xFFE2E8F0),
                              width: (t['is_published'] ?? false) ? 2 : 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      t['title'] ?? 'Sans titre',
                                      style: const TextStyle(
                                        color: _textDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: (t['is_published'] ?? false)
                                          ? Colors.green.shade100
                                          : Colors.orange.shade100,
                                      borderRadius:
                                          BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      (t['is_published'] ?? false)
                                          ? '✅ Publiée'
                                          : '📋 Brouillon',
                                      style: TextStyle(
                                        color: (t['is_published'] ?? false)
                                            ? Colors.green
                                            : Colors.orange,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'Prix: ${t['price_amount'] ?? 0} '
                                    '${t['currency'] ?? 'USD'}',
                                    style: const TextStyle(
                                      color: _textGrey,
                                      fontSize: 11,
                                    ),
                                  ),
                                  const Spacer(),
                                  // PUBLISH/UNPUBLISH BUTTON
                                  if (t['is_published'] == true)
                                    IconButton(
                                      onPressed: () => _unpublishTraining(t),
                                      icon: const Icon(
                                        Icons.visibility_off_rounded,
                                        color: Colors.orange,
                                        size: 18,
                                      ),
                                      tooltip: 'Dépublier',
                                    )
                                  else
                                    IconButton(
                                      onPressed: () => _publishTraining(t),
                                      icon: const Icon(
                                        Icons.visibility_rounded,
                                        color: _brandPurple,
                                        size: 18,
                                      ),
                                      tooltip: 'Publier',
                                    ),
                                  // EDIT BUTTON
                                  IconButton(
                                    onPressed: () {
                                      // TODO: Edit training
                                    },
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      color: _brandPurple,
                                      size: 18,
                                    ),
                                    tooltip: 'Éditer',
                                  ),
                                  // DELETE BUTTON
                                  IconButton(
                                    onPressed: () => _deleteTraining(t),
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      color: Colors.red,
                                      size: 18,
                                    ),
                                    tooltip: 'Supprimer',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ))
                    .toList(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: _brandPurple,
        onPressed: _showCreateTrainingDialog,
        child: const Icon(Icons.add_rounded, color: Colors.white),
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: _textGrey,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                color: _brandPurple,
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
