import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:thix_id/theme.dart';

class TrainingAdminPage extends StatefulWidget {
  const TrainingAdminPage({super.key});

  @override
  State<TrainingAdminPage> createState() => _TrainingAdminPageState();
}

class _TrainingAdminPageState extends State<TrainingAdminPage> {
  final SupabaseClient _supabase = Supabase.instance.client;
  List<dynamic> _trainings = [];
  bool _loading = true;
  String _searchQuery = '';
  String _filterStatus = 'all';
  String _filterCategory = 'all';
  List<String> _categories = [];

  static const Color _brandPurple = Color(0xFF6366F1);
  static const Color _bgLight = Color(0xFFF8FAFC);
  static const Color _textDark = Color(0xFF1E293B);
  static const Color _textGrey = Color(0xFF64748B);

  @override
  void initState() {
    super.initState();
    _loadTrainings();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final res = await _supabase.from('thix_trainings').select('category');
      if (res is List) {
        final cats = res.map((e) => e['category'] as String).toSet().toList();
        if (mounted) setState(() => _categories = cats);
      }
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  Future<void> _loadTrainings() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      var query = _supabase.from('thix_trainings').select('*');
      
      if (_searchQuery.isNotEmpty) {
        query = query.ilike('title', '%$_searchQuery%');
      }
      
      final res = await query.order('updated_at', ascending: false);
      
      if (!mounted) return;
      setState(() => _trainings = res is List ? res : []);
    } catch (e) {
      debugPrint('Error loading trainings: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<dynamic> get _filteredTrainings {
    var filtered = List.from(_trainings);
    
    if (_filterStatus == 'published') {
      filtered = filtered.where((t) => t['is_published'] == true).toList();
    } else if (_filterStatus == 'draft') {
      filtered = filtered.where((t) => t['is_published'] != true).toList();
    }
    
    if (_filterCategory != 'all') {
      filtered = filtered.where((t) => t['category'] == _filterCategory).toList();
    }
    
    return filtered;
  }

  void _showCreateTrainingDialog() {
    final TextEditingController titleCtrl = TextEditingController();
    final TextEditingController taglineCtrl = TextEditingController();
    final TextEditingController descCtrl = TextEditingController();
    final TextEditingController priceCtrl = TextEditingController();
    final TextEditingController categoryCtrl = TextEditingController();
    final TextEditingController durationCtrl = TextEditingController();
    final TextEditingController instructorNameCtrl = TextEditingController();
    final TextEditingController instructorTitleCtrl = TextEditingController();
    final TextEditingController requirementsCtrl = TextEditingController();
    bool isFree = false;
    bool certificationIncluded = true;
    bool isFeatured = false;
    String selectedLevel = 'Beginner';
    String selectedLanguage = 'FR';

    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            title: const Text('Créer une formation'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Titre *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: taglineCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Slogan / Accroche',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: priceCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Prix',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedLanguage,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(value: 'FR', child: Text('Français')),
                            DropdownMenuItem<String>(value: 'EN', child: Text('English')),
                            DropdownMenuItem<String>(value: 'SW', child: Text('Swahili')),
                          ],
                          onChanged: (String? v) => setDialogState(() => selectedLanguage = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedLevel,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(value: 'Beginner', child: Text('Débutant')),
                            DropdownMenuItem<String>(value: 'Intermediate', child: Text('Intermédiaire')),
                            DropdownMenuItem<String>(value: 'Advanced', child: Text('Avancé')),
                          ],
                          onChanged: (String? v) => setDialogState(() => selectedLevel = v!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: durationCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Durée (minutes)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: categoryCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Catégorie',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: instructorNameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Nom du formateur',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: instructorTitleCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Titre du formateur',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: requirementsCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Prérequis',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Gratuit'),
                          value: isFree,
                          onChanged: (bool v) => setDialogState(() => isFree = v),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Certificat'),
                          value: certificationIncluded,
                          onChanged: (bool v) => setDialogState(() => certificationIncluded = v),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    title: const Text('À la une'),
                    value: isFeatured,
                    onChanged: (bool v) => setDialogState(() => isFeatured = v),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
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
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _supabase.from('thix_trainings').insert({
                      'title': titleCtrl.text,
                      'tagline': taglineCtrl.text.isEmpty ? null : taglineCtrl.text,
                      'description': descCtrl.text.isEmpty ? null : descCtrl.text,
                      'price_amount': isFree ? 0 : double.tryParse(priceCtrl.text),
                      'currency': 'USD',
                      'is_free': isFree,
                      'certification_included': certificationIncluded,
                      'is_featured': isFeatured,
                      'is_published': false,
                      'category': categoryCtrl.text.isEmpty ? 'General' : categoryCtrl.text,
                      'level': selectedLevel,
                      'language': selectedLanguage,
                      'delivery_mode': 'online',
                      'duration_minutes': int.tryParse(durationCtrl.text),
                      'instructor_name': instructorNameCtrl.text.isEmpty ? null : instructorNameCtrl.text,
                      'instructor_title': instructorTitleCtrl.text.isEmpty ? null : instructorTitleCtrl.text,
                      'requirements': requirementsCtrl.text.isEmpty ? null : requirementsCtrl.text,
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
                    debugPrint('Error creating training: $e');
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
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
          );
        },
      ),
    );
  }

  void _showEditTrainingDialog(dynamic training) {
    final TextEditingController titleCtrl = TextEditingController(text: training['title']);
    final TextEditingController taglineCtrl = TextEditingController(text: training['tagline'] ?? '');
    final TextEditingController descCtrl = TextEditingController(text: training['description'] ?? '');
    final TextEditingController priceCtrl = TextEditingController(text: training['price_amount']?.toString() ?? '');
    final TextEditingController categoryCtrl = TextEditingController(text: training['category'] ?? 'General');
    final TextEditingController durationCtrl = TextEditingController(text: training['duration_minutes']?.toString() ?? '');
    final TextEditingController instructorNameCtrl = TextEditingController(text: training['instructor_name'] ?? '');
    final TextEditingController instructorTitleCtrl = TextEditingController(text: training['instructor_title'] ?? '');
    final TextEditingController requirementsCtrl = TextEditingController(text: training['requirements'] ?? '');
    bool isFree = training['is_free'] ?? false;
    bool certificationIncluded = training['certification_included'] ?? true;
    bool isFeatured = training['is_featured'] ?? false;
    String selectedLevel = training['level'] ?? 'Beginner';
    String selectedLanguage = training['language'] ?? 'FR';

    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setDialogState) {
          return AlertDialog(
            title: const Text('Modifier la formation'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Titre *',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: taglineCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Slogan / Accroche',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          controller: priceCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Prix',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedLanguage,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(value: 'FR', child: Text('Français')),
                            DropdownMenuItem<String>(value: 'EN', child: Text('English')),
                            DropdownMenuItem<String>(value: 'SW', child: Text('Swahili')),
                          ],
                          onChanged: (String? v) => setDialogState(() => selectedLanguage = v!),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedLevel,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          items: const <DropdownMenuItem<String>>[
                            DropdownMenuItem<String>(value: 'Beginner', child: Text('Débutant')),
                            DropdownMenuItem<String>(value: 'Intermediate', child: Text('Intermédiaire')),
                            DropdownMenuItem<String>(value: 'Advanced', child: Text('Avancé')),
                          ],
                          onChanged: (String? v) => setDialogState(() => selectedLevel = v!),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: durationCtrl,
                          decoration: const InputDecoration(
                            hintText: 'Durée (minutes)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: categoryCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Catégorie',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: instructorNameCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Nom du formateur',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: instructorTitleCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Titre du formateur',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: requirementsCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Prérequis',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Gratuit'),
                          value: isFree,
                          onChanged: (bool v) => setDialogState(() => isFree = v),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: SwitchListTile(
                          title: const Text('Certificat'),
                          value: certificationIncluded,
                          onChanged: (bool v) => setDialogState(() => certificationIncluded = v),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    title: const Text('À la une'),
                    value: isFeatured,
                    onChanged: (bool v) => setDialogState(() => isFeatured = v),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Annuler'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await _supabase.from('thix_trainings').update({
                      'title': titleCtrl.text,
                      'tagline': taglineCtrl.text.isEmpty ? null : taglineCtrl.text,
                      'description': descCtrl.text.isEmpty ? null : descCtrl.text,
                      'price_amount': isFree ? 0 : double.tryParse(priceCtrl.text),
                      'is_free': isFree,
                      'certification_included': certificationIncluded,
                      'is_featured': isFeatured,
                      'category': categoryCtrl.text.isEmpty ? 'General' : categoryCtrl.text,
                      'level': selectedLevel,
                      'language': selectedLanguage,
                      'duration_minutes': int.tryParse(durationCtrl.text),
                      'instructor_name': instructorNameCtrl.text.isEmpty ? null : instructorNameCtrl.text,
                      'instructor_title': instructorTitleCtrl.text.isEmpty ? null : instructorTitleCtrl.text,
                      'requirements': requirementsCtrl.text.isEmpty ? null : requirementsCtrl.text,
                      'updated_at': DateTime.now().toUtc().toIso8601String(),
                    }).eq('id', training['id']);
                    if (!mounted) return;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Formation modifiée!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    _loadTrainings();
                  } catch (e) {
                    debugPrint('Error updating training: $e');
                    if (!mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Erreur: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brandPurple,
                ),
                child: const Text(
                  'Enregistrer',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _uploadCoverImage(dynamic training) async {
    final String? trainingId = training['id']?.toString();
    if (trainingId == null || trainingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID de formation invalide')),
      );
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      
      if (image == null) return;
      
      final Uint8List bytes = await image.readAsBytes();
      
      const int maxSize = 10 * 1024 * 1024;
      if (bytes.length > maxSize) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fichier trop volumineux (max 10 MB)')),
        );
        return;
      }
      
      if (!mounted) return;
      setState(() => _loading = true);
      
      final String storagePath = 'covers/$trainingId/${DateTime.now().millisecondsSinceEpoch}.jpg';
      
      await _supabase.storage.from('thix-trainings').uploadBinary(
        storagePath,
        bytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );
      
      final String publicUrl = _supabase.storage.from('thix-trainings').getPublicUrl(storagePath);
      
      await _supabase.from('thix_trainings').update({
        'cover_image_path': storagePath,
        'cover_image_url': publicUrl,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      }).eq('id', trainingId);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Image de couverture ajoutée !'),
          backgroundColor: Colors.green,
        ),
      );
      _loadTrainings();
      
    } catch (e) {
      debugPrint('Error uploading cover: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _publishTraining(dynamic training) async {
    final String? trainingId = training['id']?.toString();
    final String trainingTitle = training['title']?.toString() ?? 'Formation';
    
    if (trainingId == null || trainingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID de formation invalide')),
      );
      return;
    }
    
    try {
      if (!mounted) return;
      setState(() => _loading = true);
      
      await _supabase
          .from('thix_trainings')
          .update({'is_published': true})
          .eq('id', trainingId);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ "$trainingTitle" publiée !'),
          backgroundColor: Colors.green,
        ),
      );
      _loadTrainings();
      
    } catch (e) {
      debugPrint('Error publishing: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _unpublishTraining(dynamic training) async {
    final String? trainingId = training['id']?.toString();
    final String trainingTitle = training['title']?.toString() ?? 'Formation';
    
    if (trainingId == null || trainingId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ID de formation invalide')),
      );
      return;
    }
    
    try {
      if (!mounted) return;
      setState(() => _loading = true);
      
      await _supabase
          .from('thix_trainings')
          .update({'is_published': false})
          .eq('id', trainingId);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⏸️ "$trainingTitle" dépubliée'),
          backgroundColor: Colors.orange,
        ),
      );
      _loadTrainings();
      
    } catch (e) {
      debugPrint('Error unpublishing: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _deleteTraining(dynamic training) async {
    final String? trainingId = training['id']?.toString();
    final String trainingTitle = training['title']?.toString() ?? 'cette formation';
    
    if (trainingId == null || trainingId.isEmpty) return;
    
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Supprimer cette formation ?'),
        content: Text('Êtes-vous sûr de vouloir supprimer "$trainingTitle" ? Cette action est irréversible.'),
        actions: <Widget>[
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
      if (!mounted) return;
      setState(() => _loading = true);
      
      await _supabase
          .from('thix_trainings')
          .delete()
          .eq('id', trainingId);
      
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Formation supprimée'),
          backgroundColor: Colors.red,
        ),
      );
      _loadTrainings();
      
    } catch (e) {
      debugPrint('Delete error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<dynamic> filteredTrainings = _filteredTrainings;
    final int publishedCount = _trainings.where((t) => t['is_published'] == true).length;
    final int draftCount = _trainings.where((t) => t['is_published'] != true).length;
    
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
        actions: <Widget>[
          IconButton(
            onPressed: _loadTrainings,
            icon: const Icon(Icons.refresh_rounded, color: _brandPurple),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(14),
            color: Colors.white,
            child: Column(
              children: <Widget>[
                TextField(
                  onChanged: (String value) {
                    setState(() => _searchQuery = value);
                    _loadTrainings();
                  },
                  decoration: InputDecoration(
                    hintText: 'Rechercher une formation...',
                    prefixIcon: const Icon(Icons.search_rounded, color: _brandPurple),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: _bgLight,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SegmentedButton<String>(
                        segments: const <ButtonSegment<String>>[
                          ButtonSegment<String>(value: 'all', label: Text('Toutes')),
                          ButtonSegment<String>(value: 'published', label: Text('Publiées')),
                          ButtonSegment<String>(value: 'draft', label: Text('Brouillons')),
                        ],
                        selected: <String>{_filterStatus},
                        onSelectionChanged: (Set<String> selection) {
                          setState(() => _filterStatus = selection.first);
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _filterCategory,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: <DropdownMenuItem<String>>[
                          const DropdownMenuItem<String>(value: 'all', child: Text('Toutes catégories')),
                          ..._categories.map((String cat) => DropdownMenuItem<String>(
                            value: cat,
                            child: Text(cat),
                          )),
                        ],
                        onChanged: (String? v) => setState(() => _filterCategory = v!),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Container(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: <Widget>[
                _buildStatCard('Total', _trainings.length.toString()),
                const SizedBox(width: 12),
                _buildStatCard('Publiées', publishedCount.toString()),
                const SizedBox(width: 12),
                _buildStatCard('Brouillons', draftCount.toString()),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                border: Border.all(color: _brandPurple.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(Icons.info_rounded, color: _brandPurple, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // L'erreur critique "const" a été supprimée ici pour permettre un affichage dynamique fluide
                      children: const <Widget>[
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
          ),
          
          const SizedBox(height: 14),
          
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: _brandPurple),
                  )
                : filteredTrainings.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(Icons.school_outlined, size: 64, color: _textGrey),
                            const SizedBox(height: 16),
                            Text(
                              _searchQuery.isNotEmpty 
                                  ? 'Aucune formation trouvée pour "$_searchQuery"'
                                  : 'Aucune formation disponible',
                              style: const TextStyle(color: _textGrey),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(14),
                        itemCount: filteredTrainings.length,
                        itemBuilder: (BuildContext context, int index) {
                          final dynamic t = filteredTrainings[index];
                          return Container(
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
                              children: <Widget>[
                                if (t['cover_image_url'] != null) ...
