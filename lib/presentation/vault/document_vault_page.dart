import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart'; // ← SUPPRIMÉ (non utilisé)
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';
import 'package:thix_id/auth/auth_controller.dart';
import 'package:thix_id/models/app_user.dart';
import 'package:thix_id/nav.dart';
import 'package:thix_id/services/document_service.dart';
import '../../theme.dart';

// Couleurs par défaut si LightModeColors n'existe pas
class _DefaultColors {
  static const Color accent = Color(0xFFD4AF37);
  static const Color secondaryText = Color(0xFF64748B);
}

class CategoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const CategoryChip({
    super.key,
    required this.icon,
    required this.label,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: selected ? LightModeColors.accent : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: selected ? Colors.transparent : (Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 18,
            color: selected ? const Color(0xFF0A2F5C) : LightModeColors.secondaryText,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: selected ? const Color(0xFF0A2F5C) : LightModeColors.secondaryText,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class DocItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String date;
  final String size;
  final VoidCallback? onTap;
  final VoidCallback? onMore;

  const DocItem({
    super.key,
    required this.icon,
    required this.title,
    required this.date,
    required this.size,
    this.onTap,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: Theme.of(context).dividerColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(25),
              blurRadius: 6,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppRadius.md),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF9C74F), Color(0xFFD4AF37), Color(0xFFB8860B)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(13),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  )
                ],
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: const Color(0xFF0A2F5C), size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: LightModeColors.secondaryText,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Theme.of(context).dividerColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      Text(
                        size,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: LightModeColors.secondaryText,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: LightModeColors.secondaryText),
              onPressed: onMore,
            ),
          ],
        ),
      ),
    );
  }
}

class DocumentVaultPage extends StatefulWidget {
  const DocumentVaultPage({super.key});

  @override
  State<DocumentVaultPage> createState() => _DocumentVaultPageState();
}

class _DocumentVaultPageState extends State<DocumentVaultPage> {
  late final DocumentService _docs;

  @override
  void initState() {
    super.initState();
    _docs = DocumentService();
  }

  Future<void> _pickAndUpload() async {
    final me = context.read<AuthController>().currentUser;
    if (me == null) return;

    final picked = await FilePicker.pickFiles(withData: kIsWeb);
    if (picked == null || picked.files.isEmpty) return;
    final file = picked.files.first;

    if (!mounted) return;
    final res = await showModalBottomSheet<_UploadDocPayload>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _UploadDocumentSheet(fileName: file.name),
    );
    if (res == null) return;

    try {
      await _docs.uploadPickedFile(
        uid: me.id,
        docId: res.docId,
        title: res.title,
        file: file,
        docType: res.docType,
        expiresAt: res.expiresAt,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document uploadé.')),
      );
    } catch (e) {
      debugPrint('Vault: upload failed err=$e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Upload impossible.')),
      );
    }
  }

  Future<void> _openUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      final ok = await launchUrl(
        uri,
        mode: kIsWeb ? LaunchMode.platformDefault : LaunchMode.externalApplication,
        webOnlyWindowName: kIsWeb ? '_blank' : null,
      );
      if (!ok) {
        throw Exception('launch failed');
      }
    } catch (e) {
      debugPrint('Vault: openUrl failed url=$url err=$e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ouverture impossible.')),
      );
    }
  }

  Future<void> _openDoc(Map<String, dynamic> row) async {
    try {
      final url = await _docs.resolveRowDownloadUrl(row);
      if (url.trim().isEmpty) throw Exception('URL vide');
      await _openUrl(url);
    } catch (e) {
      debugPrint('Vault: openDoc failed err=$e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Téléchargement impossible.')),
      );
    }
  }

  IconData _iconForMime(String? mime) {
    final m = (mime ?? '').toLowerCase();
    if (m.contains('pdf')) return Icons.picture_as_pdf_rounded;
    if (m.contains('image')) return Icons.image_rounded;
    return Icons.description_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final me = context.watch<AuthController>().currentUser;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    _buildCategoriesSection(),
                    const SizedBox(height: AppSpacing.lg),
                    _buildDocumentsSection(me),
                    const SizedBox(height: AppSpacing.lg),
                    _buildSecuritySection(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pickAndUpload,
        icon: const Icon(Icons.add_rounded, color: Color(0xFF0A2F5C)),
        label: Text(
          "DÉPOSER UN DOCUMENT",
          style: Theme.of(context).textTheme.labelLarge?.copyWith(color: const Color(0xFF0A2F5C)),
        ),
        backgroundColor: LightModeColors.accent,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(38),
            blurRadius: 25,
            offset: const Offset(0, 10),
          )
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Opacity(
              opacity: 0.1,
              child: Icon(Icons.fingerprint, size: 280, color: LightModeColors.accent),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      onPressed: () {
                        final auth = context.read<AuthController>();
                        if (auth.isAuthenticated) {
                          final t = auth.currentUser?.accountType;
                          context.popOrGo(t == AccountType.enterprise ? AppRoutes.enterpriseDashboard : AppRoutes.userDashboard);
                          return;
                        }
                        context.popOrGo(AppRoutes.home);
                      },
                    ),
                    Text(
                      "THIX VAULT",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: LightModeColors.accent,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.search_rounded, color: Colors.white, size: 24),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                _buildStorageCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStorageCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(10),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: const Color(0xFFF9C74F).withAlpha(66)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Espace de Stockage",
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: LightModeColors.accent,
                    ),
                  ),
                  Text(
                    "Souverain & Chiffré",
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white.withAlpha(179),
                    ),
                  ),
                ],
              ),
              Text(
                "75%",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: LightModeColors.accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          LinearProgressIndicator(
            value: 0.75,
            backgroundColor: Colors.white.withAlpha(33),
            valueColor: const AlwaysStoppedAnimation<Color>(LightModeColors.accent),
            minHeight: 10,
            borderRadius: BorderRadius.circular(5),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "1.5 GB / 2.0 GB",
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: LightModeColors.accent,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Text(
                  "OPTIMISER",
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF0A2F5C),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Catégories",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Icon(Icons.tune_rounded, color: LightModeColors.secondaryText, size: 20),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        const SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              CategoryChip(icon: Icons.folder_rounded, label: "Tout", selected: true),
              CategoryChip(icon: Icons.account_balance_rounded, label: "Identité", selected: false),
              CategoryChip(icon: Icons.school_rounded, label: "Diplômes", selected: false),
              CategoryChip(icon: Icons.description_rounded, label: "Certificats", selected: false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDocumentsSection(AppUser? me) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Documents Certifiés",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w800,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "Voir tout",
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (me == null)
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Connectez-vous pour voir vos documents.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LightModeColors.secondaryText),
            ),
          )
        else
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _docs.streamDocuments(me.id),
            builder: (context, snap) {
              final docs = snap.data ?? const <Map<String, dynamic>>[];
              if (snap.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Aucun document.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: LightModeColors.secondaryText),
                  ),
                );
              }
              return Column(
                children: docs.map<Widget>((data) {
                  final title = (data['title'] as String?) ?? 'Document';
                  final url = (data['download_url'] as String?) ?? (data['downloadUrl'] as String?) ?? '';
                  final storagePath = (data['storage_path'] as String?) ?? (data['storagePath'] as String?) ?? '';
                  final mime = (data['mime_type'] as String?) ?? (data['mimeType'] as String?);
                  final sizeBytes = (data['size_bytes'] as num?)?.toInt() ?? (data['sizeBytes'] as num?)?.toInt() ?? 0;
                  final createdAt = data['created_at'];
                  final date = createdAt is DateTime
                      ? createdAt
                      : (createdAt is String)
                          ? DateTime.tryParse(createdAt)
                          : null;
                  final dateStr = date == null ? '—' : '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                  final sizeStr = sizeBytes < 1024 * 1024
                      ? '${(sizeBytes / 1024).toStringAsFixed(0)} KB'
                      : '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
                  return DocItem(
                    icon: _iconForMime(mime),
                    title: title,
                    date: dateStr,
                    size: sizeStr,
                    onTap: (url.isEmpty && storagePath.trim().isEmpty) ? null : () => _openDoc(data),
                    onMore: () => _showDocMenu(row: data),
                  );
                }).toList(growable: false),
              );
            },
          ),
      ],
    );
  }

  Widget _buildSecuritySection() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: LightModeColors.accent),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(25),
            blurRadius: 15,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF9C74F).withAlpha(33),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.verified_user_rounded, color: LightModeColors.accent, size: 28),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "SÉCURITÉ INSTITUTIONNELLE",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  "Chiffrement AES-256 de grade militaire. Vos données ne quittent jamais le territoire national.",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: LightModeColors.secondaryText,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDocMenu({required Map<String, dynamic> row}) async {
    final title = (row['title'] as String?) ?? 'Document';
    final url = (row['download_url'] as String?) ?? (row['downloadUrl'] as String?) ?? '';
    final storagePath = (row['storage_path'] as String?) ?? (row['storagePath'] as String?) ?? '';
    final me = context.read<AuthController>().currentUser;

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppRadius.xl), topRight: Radius.circular(AppRadius.xl)),
            border: Border.all(color: Theme.of(context).dividerColor),
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded)),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ElevatedButton.icon(
                onPressed: (url.trim().isEmpty && storagePath.trim().isEmpty) ? null : () => _openDoc(row),
                icon: const Icon(Icons.open_in_new_rounded, color: Color(0xFF0A2F5C)),
                label: const Text('Ouvrir / Télécharger'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightModeColors.accent,
                  foregroundColor: const Color(0xFF0A2F5C),
                  elevation: 0,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              OutlinedButton.icon(
                onPressed: me == null
                    ? null
                    : () async {
                        try {
                          final docRowId = (row['id'] ?? '').toString();
                          if (docRowId.trim().isEmpty) throw Exception('id manquant');
                          await _docs.deleteDocument(uid: me.id, documentId: docRowId, storagePath: storagePath);
                          if (!mounted) return;
                          context.pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Document supprimé.')),
                          );
                        } catch (e) {
                          debugPrint('Vault: delete failed err=$e');
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Suppression impossible.')),
                          );
                        }
                      },
                icon: Icon(Icons.delete_outline_rounded, color: Theme.of(context).colorScheme.error),
                label: Text(
                  'Supprimer',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Theme.of(context).colorScheme.error.withAlpha(128)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _UploadDocPayload {
  final String docId;
  final String title;
  final String docType;
  final DateTime? expiresAt;
  const _UploadDocPayload({required this.docId, required this.title, required this.docType, required this.expiresAt});
}

class _UploadDocumentSheet extends StatefulWidget {
  final String fileName;
  const _UploadDocumentSheet({required this.fileName});

  @override
  State<_UploadDocumentSheet> createState() => _UploadDocumentSheetState();
}

class _UploadDocumentSheetState extends State<_UploadDocumentSheet> {
  final _docIdC = TextEditingController();
  final _titleC = TextEditingController();
  String _type = 'Autre';
  DateTime? _expiresAt;

  @override
  void dispose() {
    _docIdC.dispose();
    _titleC.dispose();
    super.dispose();
  }

  bool get _needsExpiry => _type == 'CIN' || _type == 'Passeport' || _type == 'Permis';

  Future<void> _pickExpiry() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiresAt ?? now,
      firstDate: now.subtract(const Duration(days: 365 * 20)),
      lastDate: now.add(const Duration(days: 365 * 50)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(primary: LightModeColors.accent),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _expiresAt = DateTime(picked.year, picked.month, picked.day));
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    final expiryLabel = _expiresAt == null
        ? 'Choisir une date'
        : '${_expiresAt!.year.toString().padLeft(4, '0')}-${_expiresAt!.month.toString().padLeft(2, '0')}-${_expiresAt!.day.toString().padLeft(2, '0')}';
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppRadius.xl), topRight: Radius.circular(AppRadius.xl)),
          border: Border.all(color: Theme.of(context).dividerColor),
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Déposer un document',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
                IconButton(onPressed: () => context.pop(), icon: const Icon(Icons.close_rounded))
              ],
            ),
            Text(
              widget.fileName,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: LightModeColors.secondaryText),
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              value: _type,
              items: const [
                DropdownMenuItem(value: 'CIN', child: Text('Pièce d\'identité — CIN')),
                DropdownMenuItem(value: 'Passeport', child: Text('Pièce d\'identité — Passeport')),
                DropdownMenuItem(value: 'Permis', child: Text('Pièce d\'identité — Permis')),
                DropdownMenuItem(value: 'Diplôme', child: Text('Diplôme / Attestation')),
                DropdownMenuItem(value: 'PreuveAdresse', child: Text('Preuve d\'adresse')),
                DropdownMenuItem(value: 'Autre', child: Text('Autre')),
              ],
              onChanged: (v) => setState(() {
                _type = v ?? 'Autre';
                if (!_needsExpiry) _expiresAt = null;
              }),
              decoration: InputDecoration(
                labelText: 'Type de document',
                prefixIcon: const Icon(Icons.folder_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _docIdC,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                labelText: 'Doc ID',
                hintText: 'CIN-2023-001',
                prefixIcon: const Icon(Icons.tag_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              controller: _titleC,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                labelText: 'Titre',
                hintText: 'Carte d\'identité nationale',
                prefixIcon: const Icon(Icons.description_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            if (_needsExpiry)
              SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: _pickExpiry,
                  icon: const Icon(Icons.event_available_rounded),
                  label: Text('Date d\'expiration: $expiryLabel'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.primary,
                    side: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: () {
                  final docId = _docIdC.text.trim();
                  if (docId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Doc ID requis.')),
                    );
                    return;
                  }
                  if (_needsExpiry && _expiresAt == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Date d\'expiration requise pour cette pièce.')),
                    );
                    return;
                  }
                  context.pop(_UploadDocPayload(
                    docId: docId,
                    title: _titleC.text,
                    docType: _type,
                    expiresAt: _expiresAt,
                  ));
                },
                icon: const Icon(Icons.cloud_upload_rounded, color: Color(0xFF0A2F5C)),
                label: const Text('UPLOAD'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: LightModeColors.accent,
                  foregroundColor: const Color(0xFF0A2F5C),
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
