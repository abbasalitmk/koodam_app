import 'package:flutter/material.dart';
import '../../core/network/api_service.dart';
import '../../core/theme/app_theme.dart';
import '../../models/models.dart';

class RadarMapScreen extends StatefulWidget {
  final ApiService apiService;
  const RadarMapScreen({super.key, required this.apiService});

  @override
  State<RadarMapScreen> createState() => _RadarMapScreenState();
}

class _RadarMapScreenState extends State<RadarMapScreen> {
  List<EventItem> _events = [];
  

  @override
  void initState() {
    super.initState();
    _loadMapItems();
  }

  Future<void> _loadMapItems() async {
    final list = await widget.apiService.getEvents();
    setState(() {
      _events = list;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Visual Map Radar Canvas
          Container(
            color: const Color(0xFF0B132B),
            child: CustomPaint(
              size: Size.infinite,
              painter: _RadarGridPainter(),
            ),
          ),

          // Top Header Overlay
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.surface.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.cardBorder),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.radar_rounded, color: AppColors.primaryTeal, size: 18),
                            SizedBox(width: 8),
                            Text('Kerala Live Radar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.kasavuGold.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.kasavuGold.withOpacity(0.3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.security_rounded, size: 14, color: AppColors.kasavuGold),
                            SizedBox(width: 6),
                            Text('Ghost Centroid: ~500m Blur', style: TextStyle(fontSize: 11, color: AppColors.kasavuGold, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Visual Pins on Canvas
          Positioned(
            top: 220,
            left: 120,
            child: _buildRadarPin('Fort Kochi Walk', '4 spots left', AppColors.primaryTeal, Icons.local_activity_rounded),
          ),
          Positioned(
            top: 340,
            right: 80,
            child: _buildRadarPin('Infopark Tech Chai', '8 attended', AppColors.kasavuGold, Icons.coffee_rounded),
          ),
          Positioned(
            top: 420,
            left: 90,
            child: _buildRadarPin('Aparna (Intentional)', '4.8 km away', AppColors.sunsetCoral, Icons.favorite_rounded),
          ),

          // Bottom Event Carousel
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _events.length,
                itemBuilder: (context, i) {
                  final ev = _events[i];
                  return Container(
                    width: 280,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.cardBorder),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.primaryTeal.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(ev.date, style: const TextStyle(fontSize: 10, color: AppColors.tealLight, fontWeight: FontWeight.bold)),
                            ),
                            const Spacer(),
                            Text('${ev.attendeeCount}/${ev.capacity} Spots', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(ev.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), maxLines: 1, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text(ev.locationName, style: const TextStyle(fontSize: 11, color: AppColors.textMuted), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadarPin(String title, String subtitle, Color color, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: color),
          ),
          child: Text(title, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 2),
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: color.withOpacity(0.5), blurRadius: 10, spreadRadius: 2),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
      ],
    );
  }
}

class _RadarGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryTeal.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width / 2, size.height / 2 - 40);

    for (double r = 60; r <= 240; r += 60) {
      canvas.drawCircle(center, r, paint);
    }

    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);
    canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
