import 'package:flutter_test/flutter_test.dart';
import 'package:koodam_app/core/constants/kerala_districts.dart';
import 'package:koodam_app/models/models.dart';

void main() {
  test('Kerala Districts catalog contains all 14 districts and diaspora', () {
    expect(KeralaDistricts.all.length, greaterThanOrEqualTo(14));
    expect(KeralaDistricts.all.any((d) => d.code == 'KL-EKM'), isTrue);
    expect(KeralaDistricts.all.any((d) => d.code == 'KL-KKD'), isTrue);
    expect(KeralaDistricts.all.any((d) => d.code == 'KL-TVM'), isTrue);
    expect(KeralaDistricts.all.any((d) => d.code == 'DIA-DXB'), isTrue);
  });

  test('EventItem model integrity test', () {
    final event = EventItem(
      id: 'ev_test',
      title: 'Fort Kochi Walk',
      description: 'Single day gathering',
      category: 'CULTURE_HERITAGE',
      date: 'Today',
      startTime: '16:00',
      endTime: '19:00',
      locationName: 'Vasco da Gama Square',
      district: 'KL-EKM',
      latitude: 9.9674,
      longitude: 76.2415,
      capacity: 16,
      attendeeCount: 10,
      genderBalanceEnabled: true,
      vouchesCount: 3,
      hostName: 'Roshan',
      hostAvatar: '',
    );
    expect(event.title, 'Fort Kochi Walk');
    expect(event.capacity, 16);
    expect(event.genderBalanceEnabled, isTrue);
    expect(event.vouchesCount, 3);
  });

  test('DatingCandidate model integrity test', () {
    final candidate = DatingCandidate(
      id: 'usr_test',
      displayName: 'Aparna',
      age: 26,
      bio: 'Architect in Panampilly Nagar',
      homeDistrict: 'KL-KTM',
      currentDistrict: 'KL-EKM',
      intentions: ['DATING_INTENTIONAL'],
      interests: ['Architecture', 'Malayalam Cinema'],
      photos: [],
      isVerified: true,
      vouchScore: 3,
      distanceKm: 4.8,
    );
    expect(candidate.displayName, 'Aparna');
    expect(candidate.isVerified, isTrue);
    expect(candidate.vouchScore, 3);
  });
}
