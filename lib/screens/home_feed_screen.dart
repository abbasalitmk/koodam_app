import 'package:flutter/material.dart';
import '../../core/constants/kerala_districts.dart';
import '../../core/network/api_service.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';

class HomeFeedScreen extends StatefulWidget {
  final ApiService apiService;
  const HomeFeedScreen({super.key, required this.apiService});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  DistrictInfo _selectedDistrict = KeralaDistricts.all.firstWhere((d) => d.code == 'KL-EKM');
  String _selectedCategory = 'ALL';
  List<EventItem> _events = [];
  bool _isLoading = true;

  final List<Map<String, String>> _categories = [
    {'id': 'ALL', 'label': 'All Gatherings'},
    {'id': 'CULTURE_HERITAGE', 'label': 'Culture & Heritage'},
    {'id': 'SPORTS_TURF', 'label': 'Turf & Football'},
    {'id': 'TECH_STARTUP', 'label': 'Tech & Chai'},
    {'id': 'MUSIC_ARTS', 'label': 'Indie Arts'},
  ];

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    final list = await widget.apiService.getEvents(district: _selectedDistrict.code);
    setState(() {
      _events = list;
      _isLoading = false;
    });
  }

  void _showDistrictPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Kerala District / Diaspora',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: KeralaDistricts.all.length,
                  itemBuilder: (context, i) {
                    final d = KeralaDistricts.all[i];
                    final isSelected = d.code == _selectedDistrict.code;
                    return ListTile(
                      title: Text(d.nameEn, style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                      subtitle: Text('${d.nameMl} • ${d.iconicSpot}'),
                      trailing: isSelected ? const Icon(Icons.check_circle, color: AppColors.primaryTeal) : null,
                      onTap: () {
                        setState(() => _selectedDistrict = d);
                        Navigator.pop(ctx);
                        _loadEvents();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('കൂടം', style: TextStyle(fontSize: 16, color: AppColors.kasavuGold, fontWeight: FontWeight.bold)),
                const SizedBox(width: 6),
                Text('Koodam', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontSize: 20)),
              ],
            ),
            GestureDetector(
              onTap: _showDistrictPicker,
              child: Row(
                children: [
                  const Icon(Icons.location_on, size: 14, color: AppColors.primaryTeal),
                  const SizedBox(width: 4),
                  Text('${_selectedDistrict.nameEn} (${_selectedDistrict.nameMl})',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.primaryTeal, fontWeight: FontWeight.w600)),
                  const Icon(Icons.arrow_drop_down, size: 18, color: AppColors.primaryTeal),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadEvents,
        color: AppColors.primaryTeal,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Category Filter Pills
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) {
                  final cat = _categories[i];
                  final isSelected = cat['id'] == _selectedCategory;
                  return ChoiceChip(
                    label: Text(cat['label']!),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedCategory = cat['id']!),
                    selectedColor: AppColors.primaryTeal,
                    backgroundColor: AppColors.cardBg,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: isSelected ? AppColors.primaryTeal : AppColors.cardBorder),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Single Day Safety Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryTeal.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, color: AppColors.primaryTeal, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Strict Single-Day Policy: All gatherings are 8 hours or under with 3-peer verified host trust.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Event Cards
            if (_isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator(color: AppColors.primaryTeal)))
            else
              ..._events.map((event) => _buildEventCard(event)),
          ],
        ),
      ),
    );
  }

  Widget _buildEventCard(EventItem event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: event.isFeatured ? AppColors.kasavuGold : AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (event.isFeatured)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: const BoxDecoration(
                color: AppColors.kasavuGold,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.star, size: 14, color: Colors.black),
                  SizedBox(width: 4),
                  Text('Featured Kerala Gathering', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 11)),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        event.date,
                        style: const TextStyle(color: AppColors.tealLight, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                    Text(
                      '${event.startTime} - ${event.endTime}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(event.title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 6),
                Text(event.description, style: Theme.of(context).textTheme.bodyMedium, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.place_outlined, size: 16, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        event.locationName,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24, color: AppColors.cardBorder),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.people_alt_outlined, size: 16, color: AppColors.primaryTeal),
                        const SizedBox(width: 4),
                        Text(
                          '${event.attendeeCount}/${event.capacity} Spots',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        if (event.genderBalanceEnabled) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.kasavuGold.withOpacity(0.5)),
                            ),
                            child: const Text('50:50 Balance', style: TextStyle(fontSize: 10, color: AppColors.kasavuGold)),
                          ),
                        ],
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () => _joinEventDialog(event),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        backgroundColor: AppColors.primaryTeal,
                      ),
                      child: const Text('Join Spot', style: TextStyle(fontSize: 13)),
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

  void _joinEventDialog(EventItem event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text('Join Gathering', style: Theme.of(context).textTheme.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(event.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('Date: ${event.date} (${event.startTime} - ${event.endTime})'),
            Text('Venue: ${event.locationName}'),
            const SizedBox(height: 12),
            const Text(
              'Your entry QR Pass (#KD-8492) will be generated automatically upon confirmation.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🎉 Spot Reserved! QR Pass generated in My Gatherings.')),
              );
            },
            child: const Text('Confirm RSVP'),
          ),
        ],
      ),
    );
  }
}
