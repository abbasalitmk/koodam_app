class EventItem {
  final String id;
  final String title;
  final String description;
  final String category;
  final String date;
  final String startTime;
  final String endTime;
  final String locationName;
  final String district;
  final double latitude;
  final double longitude;
  final int capacity;
  final int attendeeCount;
  final bool genderBalanceEnabled;
  final int vouchesCount;
  final String hostName;
  final String hostAvatar;
  final bool isFeatured;

  EventItem({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.locationName,
    required this.district,
    required this.latitude,
    required this.longitude,
    required this.capacity,
    required this.attendeeCount,
    required this.genderBalanceEnabled,
    required this.vouchesCount,
    required this.hostName,
    required this.hostAvatar,
    this.isFeatured = false,
  });

  factory EventItem.fromJson(Map<String, dynamic> json) {
    return EventItem(
      id: json['id'] ?? '',
      title: json['title'] ?? 'Koodam Gathering',
      description: json['description'] ?? '',
      category: json['category'] ?? 'COMMUNITY',
      date: json['date'] ?? '',
      startTime: json['startTime'] ?? '16:00',
      endTime: json['endTime'] ?? '19:00',
      locationName: json['locationName'] ?? 'Kerala',
      district: json['district'] ?? 'KL-EKM',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 9.9816,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 76.2999,
      capacity: json['capacity'] ?? 20,
      attendeeCount: json['attendeeCount'] ?? 0,
      genderBalanceEnabled: json['genderBalanceEnabled'] ?? true,
      vouchesCount: json['vouchesCount'] ?? 3,
      hostName: json['host']?['displayName'] ?? 'Host',
      hostAvatar: json['host']?['avatarUrl'] ?? '',
      isFeatured: json['isFeatured'] ?? false,
    );
  }
}

class DatingCandidate {
  final String id;
  final String displayName;
  final int age;
  final String bio;
  final String homeDistrict;
  final String currentDistrict;
  final List<String> intentions;
  final List<String> interests;
  final List<String> photos;
  final bool isVerified;
  final int vouchScore;
  final double distanceKm;

  DatingCandidate({
    required this.id,
    required this.displayName,
    required this.age,
    required this.bio,
    required this.homeDistrict,
    required this.currentDistrict,
    required this.intentions,
    required this.interests,
    required this.photos,
    required this.isVerified,
    required this.vouchScore,
    required this.distanceKm,
  });

  factory DatingCandidate.fromJson(Map<String, dynamic> json) {
    return DatingCandidate(
      id: json['id'] ?? '',
      displayName: json['displayName'] ?? 'Malayali Member',
      age: json['age'] ?? 26,
      bio: json['bio'] ?? '',
      homeDistrict: json['homeDistrict'] ?? 'KL-EKM',
      currentDistrict: json['currentDistrict'] ?? 'KL-EKM',
      intentions: List<String>.from(json['intentions'] ?? ['DATING_INTENTIONAL']),
      interests: List<String>.from(json['interests'] ?? ['Cinema', 'Travel']),
      photos: List<String>.from(json['photos'] ?? []),
      isVerified: json['isVerified'] ?? false,
      vouchScore: json['vouchScore'] ?? 3,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 5.2,
    );
  }
}

class ConnectionItem {
  final String id;
  final String otherUserId;
  final String otherUserName;
  final String otherUserAvatar;
  final String type; // 'LOVE' or 'CONNECT_FRIEND'
  final String lastMessage;
  final String lastMessageTime;
  final int unreadCount;

  ConnectionItem({
    required this.id,
    required this.otherUserId,
    required this.otherUserName,
    required this.otherUserAvatar,
    required this.type,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });
}

class ChatMessage {
  final String id;
  final String senderId;
  final String text;
  final String time;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.text,
    required this.time,
    required this.isMe,
  });
}
