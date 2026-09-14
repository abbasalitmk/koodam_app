import 'package:flutter/material.dart';
import '../core/network/api_service.dart';
import '../core/theme/app_theme.dart';
import 'chat_screen.dart';
import 'create_event_screen.dart';
import 'dating_deck_screen.dart';
import 'home_feed_screen.dart';
import 'profile_screen.dart';
import 'radar_map_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;
  final ApiService _apiService = ApiService();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeFeedScreen(apiService: _apiService),
      RadarMapScreen(apiService: _apiService),
      CreateEventScreen(apiService: _apiService),
      DatingDeckScreen(apiService: _apiService),
      ChatScreen(apiService: _apiService),
      ProfileScreen(apiService: _apiService),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          border: Border(top: BorderSide(color: AppColors.cardBorder, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex > 4 ? 4 : _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primaryTeal,
          unselectedItemColor: AppColors.textMuted,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.explore_outlined),
              activeIcon: Icon(Icons.explore),
              label: 'Gatherings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.radar_outlined),
              activeIcon: Icon(Icons.radar),
              label: 'Live Radar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline, size: 28),
              activeIcon: Icon(Icons.add_circle, size: 28, color: AppColors.kasavuGold),
              label: 'Host Event',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite, color: AppColors.sunsetCoral),
              label: 'Dating Deck',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble_outline),
              activeIcon: Icon(Icons.chat_bubble),
              label: 'Connections',
            ),
          ],
        ),
      ),
    );
  }
}
