// ============================================================================
// FICHIER: lib/pages/dashboard/user_event_dashboard.dart
// ============================================================================
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:thix_id/models/event_item.dart';
import 'package:thix_id/models/event_registration.dart';
import 'package:thix_id/nav.dart';
import 'package:thix_id/services/event_service.dart';

// ============================================================================
// MODÈLES
// ============================================================================
enum TicketStatus {
  upcoming('À venir', Icons.event_available, Colors.green),
  today('Aujourd\'hui', Icons.today, Colors.orange),
  past('Passé', Icons.history, Colors.grey),
  cancelled('Annulé', Icons.cancel, Colors.red);

  final String label;
  final IconData icon;
  final Color color;

  const TicketStatus(this.label, this.icon, this.color);
}

class UserTicketWithEvent {
  final EventRegistration registration;
  final EventItem event;
  final TicketStatus status;

  UserTicketWithEvent({
    required this.registration,
    required this.event,
    required this.status,
  });

  bool get isUpcoming => status == TicketStatus.upcoming;
  bool get isToday => status == TicketStatus.today;
  bool get isPast => status == TicketStatus.past;
  bool get isCancelled => status == TicketStatus.cancelled;
}

// ============================================================================
// CONTROLLER
// ============================================================================
class UserDashboardController extends ChangeNotifier {
  final EventService _eventService;
  final String userId;

  List<UserTicketWithEvent> _allTickets = [];
  List<UserTicketWithEvent> _filteredTickets = [];
  TicketStatus _selectedFilter = TicketStatus.upcoming;
  bool _isLoading = true;
  String? _errorMessage;
  String _searchQuery = '';

  UserDashboardController({
    required EventService eventService,
    required this.userId,
  }) : _eventService = eventService;

  List<UserTicketWithEvent> get displayedTickets => _filteredTickets;
  TicketStatus get selectedFilter => _selectedFilter;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  int get upcomingCount => _allTickets.where((t) => t.isUpcoming).length;
  int get todayCount => _allTickets.where((t) => t.isToday).length;
  int get pastCount => _allTickets.where((t) => t.isPast).length;
  int get totalTickets => _allTickets.length;

  Future<void> loadUserTickets() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final registrations = await _eventService.getUserRegistrations(userId);
      final List<UserTicketWithEvent> tickets = [];

      for (final registration in registrations) {
        final event = await _eventService.getEventById(registration.eventId);
        if (event != null) {
          tickets.add(UserTicketWithEvent(
            registration: registration,
            event: event,
            status: _determineTicketStatus(event),
          ));
        }
      }

      tickets.sort((a, b) => a.event.eventDate.compareTo(b.event.eventDate));
      _allTickets = tickets;
      _applyFilters();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  TicketStatus _determineTicketStatus(EventItem event) {
    final now = DateTime.now();
    final eventDate = event.eventDate;

    if (eventDate.isBefore(now)) {
      return TicketStatus.past;
    }

    if (DateFormat('yyyyMMdd').format(eventDate) ==
        DateFormat('yyyyMMdd').format(now)) {
      return TicketStatus.today;
    }

    return TicketStatus.upcoming;
  }

  void filterByStatus(TicketStatus status) {
    _selectedFilter = status;
    _applyFilters();
    notifyListeners();
  }

  void searchTickets(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredTickets = _allTickets.where((ticket) {
      // Filtre par statut
      if (ticket.status != _selectedFilter) return false;

      // Filtre par recherche
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final titleMatch = ticket.event.title.toLowerCase().contains(query);
        final venueMatch = ticket.event.venue.toLowerCase().contains(query);
        final codeMatch = ticket.registration.ticketCode
            .toLowerCase()
            .contains(query);
        if (!titleMatch && !venueMatch && !codeMatch) return false;
      }

      return true;
    }).toList();
  }

  Future<void> cancelTicket(String registrationId) async {
    try {
      await _eventService.cancelRegistration(registrationId);
      await loadUserTickets();
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void refresh() {
    loadUserTickets();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// ============================================================================
// PAGE PRINCIPALE
// ============================================================================
class UserEventDashboard extends StatefulWidget {
  final String userId;

  const UserEventDashboard({super.key, required this.userId});

  @override
  State<UserEventDashboard> createState() => _UserEventDashboardState();
}

class _UserEventDashboardState extends State<UserEventDashboard>
    with SingleTickerProviderStateMixin {
  late UserDashboardController _controller;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _controller = UserDashboardController(
      eventService: context.read<EventService>(),
      userId: widget.userId,
    );
    _tabController = TabController(length: 3, vsync: this);
    _controller.loadUserTickets();

    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        final status = _getStatusFromTabIndex(_tabController.index);
        _controller.filterByStatus(status);
      }
    });
  }

  TicketStatus _getStatusFromTabIndex(int index) {
    switch (index) {
      case 0:
        return TicketStatus.upcoming;
      case 1:
        return TicketStatus.today;
      case 2:
        return TicketStatus.past;
      default:
        return TicketStatus.upcoming;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildStatsHeader(),
          _buildSearchBar(),
          _buildTabBar(),
          Expanded(
            child: ListenableBuilder(
              listenable: _controller,
              builder: (context, _) {
                if (_controller.isLoading) {
                  return _buildLoadingState();
                }

                if (_controller.errorMessage != null) {
                  return _buildErrorState();
                }

                if (_controller.displayedTickets.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildTicketList();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Mes billets'),
      centerTitle: false,
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: AppColors.textDark,
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => _controller.refresh(),
          tooltip: 'Actualiser',
        ),
        IconButton(
          icon: const Icon(Icons.filter_alt_outlined),
          onPressed: () => _showFilterDialog(),
          tooltip: 'Filtrer',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: Colors.grey[200]),
      ),
    );
  }

  Widget _buildStatsHeader() {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Row(
            children: [
              _buildStatCard(
                'À venir',
                _controller.upcomingCount,
                TicketStatus.upcoming.color,
                Icons.event_upcoming,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Aujourd\'hui',
                _controller.todayCount,
                TicketStatus.today.color,
                Icons.today,
              ),
              const SizedBox(width: 12),
              _buildStatCard(
                'Passés',
                _controller.pastCount,
                TicketStatus.past.color,
                Icons.history,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, int count, Color color, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un événement, lieu ou code...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: ListenableBuilder(
            listenable: _controller,
            builder: (context, _) {
              if (_controller.searchQuery.isNotEmpty) {
                return IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.searchTickets('');
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (query) => _controller.searchTickets(query),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: Colors.white,
      child: TabBar(
        controller: _tabController,
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey,
        tabs: const [
          Tab(text: 'À venir'),
          Tab(text: 'Aujourd\'hui'),
          Tab(text: 'Passés'),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Chargement de vos billets...'),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _controller.errorMessage ?? 'Une erreur est survenue',
            style: const TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _controller.loadUserTickets(),
            icon: const Icon(Icons.refresh),
            label: const Text('Réessayer'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    String submessage;

    switch (_controller.selectedFilter) {
      case TicketStatus.upcoming:
        message = 'Aucun billet à venir';
        submessage = 'Réservez votre prochain événement';
        break;
      case TicketStatus.today:
        message = 'Aucun événement aujourd\'hui';
        submessage = 'Profitez pour découvrir nos prochains événements';
        break;
      case TicketStatus.past:
        message = 'Aucun billet passé';
        submessage = 'Vos historiques apparaîtront ici';
        break;
      default:
        message = 'Aucun billet trouvé';
        submessage = '';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            submessage,
            style: TextStyle(color: Colors.grey[600]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.push(Routes.explore),
            icon: const Icon(Icons.explore),
            label: const Text('Découvrir des événements'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketList() {
    return RefreshIndicator(
      onRefresh: () async => _controller.loadUserTickets(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _controller.displayedTickets.length,
        itemBuilder: (context, index) {
          final ticket = _controller.displayedTickets[index];
          return _buildTicketCard(ticket);
        },
      ),
    );
  }

  Widget _buildTicketCard(UserTicketWithEvent ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _navigateToTicket(ticket),
          borderRadius: BorderRadius.circular(16),
          child: Column(
            children: [
              // En-tête avec statut
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: ticket.status.color.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(ticket.status.icon, color: ticket.status.color, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      ticket.status.label,
                      style: TextStyle(
                        color: ticket.status.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      DateFormat('dd MMM yyyy').format(ticket.event.eventDate),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              
              // Contenu principal
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Image ou placeholder
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ticket.event.coverImageUrl != null
                          ? Image.network(
                              ticket.event.coverImageUrl!,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => _buildPlaceholder(),
                            )
                          : _buildPlaceholder(),
                    ),
                    const SizedBox(width: 16),
                    
                    // Infos
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ticket.event.title,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Icon(Icons.location_on, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  ticket.event.venue,
                                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.confirmation_number, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                ticket.registration.ticketCode.substring(0, 12),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'monospace',
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Badge quantité
                    if (ticket.registration.quantity > 1)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'x${ticket.registration.quantity}',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              
              // Actions
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.grey[200]!)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _navigateToTicket(ticket),
                        icon: const Icon(Icons.qr_code_scanner, size: 18),
                        label: const Text('Voir billet'),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                    ),
                    Container(width: 1, height: 30, color: Colors.grey[200]),
                    Expanded(
                      child: TextButton.icon(
                        onPressed: () => _showTicketOptions(ticket),
                        icon: const Icon(Icons.more_horiz, size: 18),
                        label: const Text('Options'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.event, color: Colors.grey),
    );
  }

  Widget _buildFloatingButton() {
    return FloatingActionButton.extended(
      onPressed: () => context.push(Routes.explore),
      backgroundColor: AppColors.primary,
      icon: const Icon(Icons.explore),
      label: const Text('Explorer'),
    );
  }

  void _navigateToTicket(UserTicketWithEvent ticket) {
    context.push(
      Routes.ticketDetails,
      extra: {'registrationId': ticket.registration.id},
    );
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Filtrer par',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...TicketStatus.values.map((status) {
              return ListTile(
                leading: Icon(status.icon, color: status.color),
                title: Text(status.label),
                trailing: _controller.selectedFilter == status
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  _controller.filterByStatus(status);
                  Navigator.pop(context);
                },
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.clear_all),
              title: const Text('Afficher tout'),
              onTap: () {
                _controller.filterByStatus(TicketStatus.upcoming);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showTicketOptions(UserTicketWithEvent ticket) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (ticket.isUpcoming) ...[
              ListTile(
                leading: const Icon(Icons.cancel_outlined, color: Colors.red),
                title: const Text('Annuler ma réservation'),
                subtitle: const Text('Cette action est irréversible'),
                onTap: () {
                  Navigator.pop(context);
                  _showCancelConfirmation(ticket);
                },
              ),
              const Divider(),
            ],
            ListTile(
              leading: const Icon(Icons.download_outlined),
              title: const Text('Télécharger le billet (PDF)'),
              onTap: () {
                Navigator.pop(context);
                _downloadTicket(ticket);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: const Text('Partager le billet'),
              onTap: () {
                Navigator.pop(context);
                _shareTicket(ticket);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text('Ajouter au calendrier'),
              onTap: () {
                Navigator.pop(context);
                _addToCalendar(ticket);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCancelConfirmation(UserTicketWithEvent ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Annuler la réservation'),
        content: Text(
          'Êtes-vous sûr de vouloir annuler votre billet pour "${ticket.event.title}" ? Cette action est irréversible.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Non, garder'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await _controller.cancelTicket(ticket.registration.id);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Réservation annulée'),
                    backgroundColor: Colors.orange,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Oui, annuler'),
          ),
        ],
      ),
    );
  }

  void _downloadTicket(UserTicketWithEvent ticket) {
    // Implémentation du téléchargement PDF
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Téléchargement en cours...'),
      ),
    );
  }

  void _shareTicket(UserTicketWithEvent ticket) {
    // Implémentation du partage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fonctionnalité à venir'),
      ),
    );
  }

  void _addToCalendar(UserTicketWithEvent ticket) {
    // Implémentation calendrier
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ajouté au calendrier'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// ============================================================================
// CONSTANTES
// ============================================================================
class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color textDark = Color(0xFF1E293B);
}
