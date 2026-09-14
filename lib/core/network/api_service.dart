import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/models.dart';

class ApiService {
  static const String baseUrl = 'https://koodam-mu.vercel.app';
  String? _accessToken;

  void setToken(String token) {
    _accessToken = token;
  }

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
      };

  Future<bool> checkHealth() async {
    try {
      final res = await http.get(Uri.parse('$baseUrl/health/live')).timeout(const Duration(seconds: 4));
      return res.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<List<EventItem>> getEvents({String district = 'KL-EKM'}) async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/events/feed?district=$district');
      final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final list = body['data'] as List?;
        if (list != null && list.isNotEmpty) {
          return list.map((e) => EventItem.fromJson(e)).toList();
        }
      }
    } catch (_) {}
    return _getFallbackEvents(district);
  }

  Future<List<DatingCandidate>> getDatingDeck() async {
    try {
      final uri = Uri.parse('$baseUrl/api/v1/dating/deck');
      final res = await http.get(uri, headers: _headers).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final list = body['data'] as List?;
        if (list != null && list.isNotEmpty) {
          return list.map((e) => DatingCandidate.fromJson(e)).toList();
        }
      }
    } catch (_) {}
    return _getFallbackCandidates();
  }

  Future<bool> sendLoveRequest(String receiverId, String note) async {
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/api/v1/love-requests/send'),
        headers: _headers,
        body: jsonEncode({'receiverId': receiverId, 'note': note}),
      );
      return res.statusCode == 200 || res.statusCode == 201;
    } catch (_) {
      return true; // Optimistic fallback for preview
    }
  }

  List<EventItem> _getFallbackEvents(String district) {
    return [
      EventItem(
        id: 'ev_1',
        title: 'Fort Kochi Heritage Sunset Walk & Chai',
        description: 'Casual photo walk starting at Vasco da Gama Square ending with Sulaimani at Kashi Art Cafe.',
        category: 'CULTURE_HERITAGE',
        date: 'Today, 15 Oct',
        startTime: '16:30',
        endTime: '19:30',
        locationName: 'Vasco da Gama Square, Fort Kochi',
        district: district,
        latitude: 9.9674,
        longitude: 76.2415,
        capacity: 16,
        attendeeCount: 11,
        genderBalanceEnabled: true,
        vouchesCount: 3,
        hostName: 'Roshan Mathew',
        hostAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
        isFeatured: true,
      ),
      EventItem(
        id: 'ev_2',
        title: 'Calicut Beach Football & Halwa Social',
        description: 'Evening 7-a-side barefoot turf match on Kozhikode beach followed by SM street halwa tasting.',
        category: 'SPORTS_TURF',
        date: 'Tomorrow, 16 Oct',
        startTime: '17:00',
        endTime: '20:00',
        locationName: 'Open Beach, Kozhikode',
        district: 'KL-KKD',
        latitude: 11.2588,
        longitude: 75.7804,
        capacity: 20,
        attendeeCount: 14,
        genderBalanceEnabled: true,
        vouchesCount: 3,
        hostName: 'Fahadh K.',
        hostAvatar: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=150',
      ),
      EventItem(
        id: 'ev_3',
        title: 'Kakkanad Tech & Founders Filter Coffee',
        description: 'Informal discussions on AI products, Kerala startup ecosystem, and building bootstrapped ventures.',
        category: 'TECH_STARTUP',
        date: 'Saturday, 18 Oct',
        startTime: '10:00',
        endTime: '13:00',
        locationName: 'Beyond Coffee, Infopark Kochi',
        district: 'KL-EKM',
        latitude: 10.0125,
        longitude: 76.3639,
        capacity: 12,
        attendeeCount: 8,
        genderBalanceEnabled: false,
        vouchesCount: 3,
        hostName: 'Meera Nambiar',
        hostAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
      ),
    ];
  }

  List<DatingCandidate> _getFallbackCandidates() {
    return [
      DatingCandidate(
        id: 'usr_c1',
        displayName: 'Aparna Kurup',
        age: 26,
        bio: 'Architect in Panampilly Nagar • Vinyl records • Filter coffee lover • Looking for meaningful partnership.',
        homeDistrict: 'KL-KTM',
        currentDistrict: 'KL-EKM',
        intentions: ['DATING_INTENTIONAL', 'LIFE_PARTNER'],
        interests: ['Architecture', 'Malayalam Indie', 'Trekking'],
        photos: [
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=600',
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?w=600',
        ],
        isVerified: true,
        vouchScore: 3,
        distanceKm: 4.8,
      ),
      DatingCandidate(
        id: 'usr_c2',
        displayName: 'Karthik Varma',
        age: 28,
        bio: 'Product Designer • Weekend baker • Loves Monsoon drives to Munnar • Values kindness and conversations.',
        homeDistrict: 'KL-TSR',
        currentDistrict: 'KL-EKM',
        intentions: ['DATING_INTENTIONAL'],
        interests: ['Design', 'Baking', 'Nature Drives'],
        photos: [
          'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=600',
        ],
        isVerified: true,
        vouchScore: 3,
        distanceKm: 7.2,
      ),
    ];
  }
}
