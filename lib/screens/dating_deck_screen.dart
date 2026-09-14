import 'package:flutter/material.dart';
import '../../core/network/api_service.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';

class DatingDeckScreen extends StatefulWidget {
  final ApiService apiService;
  const DatingDeckScreen({super.key, required this.apiService});

  @override
  State<DatingDeckScreen> createState() => _DatingDeckScreenState();
}

class _DatingDeckScreenState extends State<DatingDeckScreen> {
  List<DatingCandidate> _candidates = [];
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCandidates();
  }

  Future<void> _loadCandidates() async {
    setState(() => _isLoading = true);
    final list = await widget.apiService.getDatingDeck();
    setState(() {
      _candidates = list;
      _isLoading = false;
      _currentIndex = 0;
    });
  }

  void _nextCandidate() {
    if (_currentIndex < _candidates.length - 1) {
      setState(() => _currentIndex++);
    } else {
      setState(() => _currentIndex = _candidates.length);
    }
  }

  void _openSendLoveDialog(DatingCandidate candidate) {
    final noteController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.favorite_rounded, color: AppColors.sunsetCoral, size: 24),
                  const SizedBox(width: 8),
                  Text('Send Love Request', style: Theme.of(context).textTheme.titleLarge),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                'Intentional note for ${candidate.displayName} (Max 140 chars). Expires in 48 hours.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                maxLength: 140,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'e.g. Loved your perspective on Kerala architecture! Would love to connect over chai.',
                  hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  filled: true,
                  fillColor: AppColors.cardBg,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    Navigator.pop(ctx);
                    await widget.apiService.sendLoveRequest(candidate.id, noteController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('💌 Love Request sent to ${candidate.displayName}!')),
                    );
                    _nextCandidate();
                  },
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Send Intentional Request'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.sunsetCoral),
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
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppColors.sunsetCoral)),
      );
    }

    if (_currentIndex >= _candidates.length) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline_rounded, size: 64, color: AppColors.primaryTeal),
              const SizedBox(height: 16),
              Text('You are all caught up!', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 8),
              const Text('Check back later for fresh candidates in your district.', style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _loadCandidates, child: const Text('Refresh Deck')),
            ],
          ),
        ),
      );
    }

    final candidate = _candidates[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Intentional Dating (കൂടം)'),
        actions: [
          IconButton(icon: const Icon(Icons.tune_rounded), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: AppColors.cardBorder),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Candidate Photo
                    if (candidate.photos.isNotEmpty)
                      Image.network(
                        candidate.photos[0],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(color: AppColors.surface),
                      ),
                    // Gradient Scrim
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.4),
                            Colors.black.withOpacity(0.9),
                          ],
                          stops: const [0.5, 0.7, 1.0],
                        ),
                      ),
                    ),
                    // Content Overlay
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${candidate.displayName}, ${candidate.age}',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
                              ),
                              if (candidate.isVerified) ...[
                                const SizedBox(width: 8),
                                const Icon(Icons.verified, color: AppColors.tealLight, size: 20),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: AppColors.kasavuGold),
                              const SizedBox(width: 4),
                              Text(
                                '${candidate.homeDistrict} Native • Exploring ${candidate.currentDistrict} (${candidate.distanceKm} km away)',
                                style: const TextStyle(color: AppColors.kasavuGold, fontSize: 12, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            candidate.bio,
                            style: const TextStyle(color: Colors.white70, fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: [
                              ...candidate.intentions.map((intent) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.sunsetCoral.withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: AppColors.sunsetCoral.withOpacity(0.6)),
                                    ),
                                    child: Text(
                                      intent.replaceAll('_', ' '),
                                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  )),
                              ...candidate.interests.map((interest) => Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(interest, style: const TextStyle(color: Colors.white, fontSize: 11)),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Action Buttons Bar
          Padding(
            padding: const EdgeInsets.only(bottom: 24, left: 32, right: 32),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  heroTag: 'skip_btn',
                  onPressed: _nextCandidate,
                  backgroundColor: AppColors.cardBg,
                  child: const Icon(Icons.close_rounded, color: Colors.white70, size: 28),
                ),
                FloatingActionButton.extended(
                  heroTag: 'love_btn',
                  onPressed: () => _openSendLoveDialog(candidate),
                  backgroundColor: AppColors.sunsetCoral,
                  icon: const Icon(Icons.favorite_rounded, color: Colors.white),
                  label: const Text('Send Love (140 chars)', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
