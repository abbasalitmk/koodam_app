import 'package:flutter/material.dart';
import '../../core/network/api_service.dart';
import '../../core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final ApiService apiService;
  const ProfileScreen({super.key, required this.apiService});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _privateMode = false;
  bool _showInDiscover = true;
  bool _ghostCentroidActive = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile (കൂടം)'),
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header Card
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 54,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=300'),
                ),
                Positioned(
                  right: 4,
                  bottom: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: AppColors.primaryTeal, shape: BoxShape.circle),
                    child: const Icon(Icons.verified_rounded, size: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Column(
              children: [
                Text('Abbas Ali', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                const Text('Founder & Software Architect • Kochi', style: TextStyle(color: AppColors.textSecondary)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.kasavuGold.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.kasavuGold.withOpacity(0.4)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.shield_rounded, size: 14, color: AppColors.kasavuGold),
                          SizedBox(width: 4),
                          Text('3/3 Peer Vouches Verified', style: TextStyle(fontSize: 11, color: AppColors.kasavuGold, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryTeal.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryTeal.withOpacity(0.4)),
                      ),
                      child: const Text('KL-EKM Native', style: TextStyle(fontSize: 11, color: AppColors.tealLight, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Photos Grid
          Text('Profile Gallery (Max 6 Photos)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
          const SizedBox(height: 10),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            children: [
              _buildPhotoTile('https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200', isPrimary: true),
              _buildPhotoTile('https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200'),
              _buildPhotoTile('https://images.unsplash.com/photo-1492562080023-ab3db95bfbce?w=200'),
              _buildAddPhotoTile(),
              _buildAddPhotoTile(),
              _buildAddPhotoTile(),
            ],
          ),
          const SizedBox(height: 24),

          // Privacy & Ghost Centroid Settings
          Text('Hyperlocal Privacy & Safety', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 15)),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: _ghostCentroidActive,
                  onChanged: (v) => setState(() => _ghostCentroidActive = v),
                  title: const Text('Ghost Centroid Obfuscation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Blurs your GPS pin by 400m–900m to prevent exact location tracing.', style: TextStyle(fontSize: 12)),
                  activeColor: AppColors.primaryTeal,
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                SwitchListTile(
                  value: _showInDiscover,
                  onChanged: (v) => setState(() => _showInDiscover = v),
                  title: const Text('Show in Intentional Dating Deck', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Opt in to be discovered by intentional Malayali candidates.', style: TextStyle(fontSize: 12)),
                  activeColor: AppColors.primaryTeal,
                ),
                const Divider(height: 1, color: AppColors.cardBorder),
                SwitchListTile(
                  value: _privateMode,
                  onChanged: (v) => setState(() => _privateMode = v),
                  title: const Text('Private Ghost Mode', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  subtitle: const Text('Only visible to people you have explicitly connected with.', style: TextStyle(fontSize: 12)),
                  activeColor: AppColors.primaryTeal,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Live Backend Health Probe Status
          FutureBuilder<bool>(
            future: widget.apiService.checkHealth(),
            builder: (context, snapshot) {
              final isOnline = snapshot.data ?? true;
              return Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: (isOnline ? AppColors.palmGreen : AppColors.sunsetCoral).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: (isOnline ? AppColors.palmGreen : AppColors.sunsetCoral).withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(isOnline ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                        color: isOnline ? AppColors.palmGreen : AppColors.sunsetCoral, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        isOnline ? 'Backend Connected: https://koodam-mu.vercel.app' : 'Backend offline or unreachable',
                        style: TextStyle(fontSize: 12, color: isOnline ? AppColors.palmGreen : AppColors.sunsetCoral, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoTile(String url, {bool isPrimary = false}) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(url, fit: BoxFit.cover),
        ),
        if (isPrimary)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: AppColors.primaryTeal, borderRadius: BorderRadius.circular(4)),
              child: const Text('Avatar', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
      ],
    );
  }

  Widget _buildAddPhotoTile() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardBorder, style: BorderStyle.solid),
      ),
      child: const Icon(Icons.add_photo_alternate_outlined, color: AppColors.textMuted),
    );
  }
}
