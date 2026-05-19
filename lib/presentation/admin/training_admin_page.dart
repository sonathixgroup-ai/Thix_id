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
                              color: const Color(0xFFE2E8F0),
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
                                          ? 'Publiée'
                                          : 'Brouillon',
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
                                  IconButton(
                                    onPressed: () {
                                      // TODO: Edit training
                                    },
                                    icon: const Icon(
                                      Icons.edit_rounded,
                                      color: _brandPurple,
                                      size: 18,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      try {
                                        await _supabase
                                            .from('thix_trainings')
                                            .delete()
                                            .eq('id', t['id']);
                                        _loadTrainings();
                                      } catch (e) {
                                        debugPrint('Delete error: \$e');
                                      }
                                    },
                                    icon: const Icon(
                                      Icons.delete_rounded,
                                      color: Colors.red,
                                      size: 18,
                                    ),
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
