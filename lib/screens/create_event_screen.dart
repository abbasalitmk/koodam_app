import 'package:flutter/material.dart';
import '../../core/constants/kerala_districts.dart';
import '../../core/network/api_service.dart';
import '../../core/theme/app_theme.dart';

class CreateEventScreen extends StatefulWidget {
  final ApiService apiService;
  const CreateEventScreen({super.key, required this.apiService});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();
  DistrictInfo _selectedDistrict = KeralaDistricts.all.firstWhere((d) => d.code == 'KL-EKM');

  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  double _durationHours = 3.0; // Max 8 hours strict policy
  int _capacity = 16;
  bool _genderBalance = true;
  String _category = 'CULTURE_HERITAGE';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Single-Day Gathering'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Strict Policy Alert Banner
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.kasavuGold.withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.kasavuGold.withOpacity(0.4)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.rule_rounded, color: AppColors.kasavuGold, size: 22),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Koodam Single-Day Policy', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.kasavuGold)),
                      SizedBox(height: 4),
                      Text(
                        'Gatherings must start and conclude on the same calendar day. Maximum duration is strictly 8 hours to foster safe and focused local connection.',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Title
          Text('Gathering Title', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14)),
          const SizedBox(height: 6),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'e.g. Fort Kochi Photo Walk & Sulaimani Chai',
              filled: true,
              fillColor: AppColors.cardBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          // District & Venue
          Text('Kerala District', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<DistrictInfo>(
              value: _selectedDistrict,
              isExpanded: true,
              underline: const SizedBox(),
              items: KeralaDistricts.all.map((d) {
                return DropdownMenuItem(value: d, child: Text('${d.nameEn} (${d.nameMl})'));
              }).toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedDistrict = val);
              },
            ),
          ),
          const SizedBox(height: 16),

          Text('Exact Venue / Meeting Spot', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 14)),
          const SizedBox(height: 6),
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'e.g. Vasco da Gama Square near Chinese Fishing Nets',
              filled: true,
              fillColor: AppColors.cardBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),

          // Duration Slider (Strict Max 8 Hours)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Duration: ${_durationHours.toStringAsFixed(1)} Hours', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text('Max 8.0h Allowed', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
            ],
          ),
          Slider(
            value: _durationHours,
            min: 1.0,
            max: 8.0,
            divisions: 14,
            activeColor: AppColors.primaryTeal,
            inactiveColor: AppColors.cardBorder,
            onChanged: (val) => setState(() => _durationHours = val),
          ),
          const SizedBox(height: 16),

          // 50:50 Gender Balance Toggle
          SwitchListTile(
            value: _genderBalance,
            onChanged: (v) => setState(() => _genderBalance = v),
            title: const Text('50:50 Gender Equilibrium', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Ensures balanced male and female discovery seats for a comfortable environment.', style: TextStyle(fontSize: 12)),
            activeColor: AppColors.primaryTeal,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),

          // Submit & 3-Peer Vouch Button
          ElevatedButton.icon(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppColors.surface,
                  title: const Text('3-Peer Vouch Required'),
                  content: const Text(
                    'Your event draft is created! To protect community safety, share your tokenized vouch link with 3 verified Malayali peers on WhatsApp. Once confirmed, it will publish instantly on the Kerala discovery map.',
                    style: TextStyle(fontSize: 13),
                  ),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Later')),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('📱 WhatsApp Vouch link copied to clipboard!')),
                        );
                      },
                      icon: const Icon(Icons.share_rounded, size: 16),
                      label: const Text('Share WhatsApp Link'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.check_circle_outline_rounded),
            label: const Text('Create Event & Get 3 Vouches'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppColors.primaryTeal,
            ),
          ),
        ],
      ),
    );
  }
}
