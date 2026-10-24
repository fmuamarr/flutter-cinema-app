import 'package:flutter_test/flutter_test.dart';
import 'package:movies_app/data/mapper/cinema_mapper.dart';
import 'package:movies_app/data/model/cinema/cinema_model.dart';
import 'package:movies_app/domain/entities/cinema/cinema_entity.dart';
import 'package:movies_app/domain/entities/cinema/cinema_route_entity.dart';
import 'package:movies_app/domain/repositories/cinema_repository.dart';
import 'package:movies_app/domain/usecase/cinema/get_cinema_route_usecase.dart';
import 'package:movies_app/domain/usecase/cinema/get_cinemas_usecase.dart';

class MockCinemaRepository implements CinemaRepository {
  @override
  Future<List<CinemaEntity>> getCinemas() async {
    return [
      CinemaEntity(
        id: 'bdg-01',
        name: 'CGV Paris Van Java',
        city: 'Bandung',
        chain: 'CGV',
        address: 'Jl. Sukajadi No.137-139',
        latitude: -6.8893,
        longitude: 107.5960,
        distanceInKm: 3.5,
        etaMinutes: 12,
      ),
      CinemaEntity(
        id: 'bdg-06',
        name: 'Ciwalk XXI',
        city: 'Bandung',
        chain: 'Cinema XXI',
        address: 'Jl. Cihampelas No.160',
        latitude: -6.8943,
        longitude: 107.6046,
        distanceInKm: 4.8,
        etaMinutes: 16,
      ),
    ];
  }

  @override
  Future<CinemaRouteEntity> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    return CinemaRouteEntity(
      points: [
        RoutePoint(originLat, originLng),
        RoutePoint(destLat, destLng),
      ],
      distanceMeters: 3500,
      durationSeconds: 720,
    );
  }
}

void main() {
  group('Cinema Unit Tests', () {
    test('CinemaModel fromJson should parse mock cinema data correctly', () {
      final json = {
        'id': 'bdg-01',
        'name': 'CGV Paris Van Java',
        'city': 'Bandung',
        'chain': 'CGV',
        'address': 'Jl. Sukajadi No.137-139',
        'latitude': -6.8893,
        'longitude': 107.5960,
      };

      final model = CinemaModel.fromJson(json);
      expect(model.id, 'bdg-01');
      expect(model.name, 'CGV Paris Van Java');
      expect(model.city, 'Bandung');
      expect(model.chain, 'CGV');
      expect(model.latitude, -6.8893);
      expect(model.longitude, 107.5960);

      final entity = model.toEntity();
      expect(entity.id, 'bdg-01');
      expect(entity.name, 'CGV Paris Van Java');
      expect(entity.distanceFormatted, '-- km');
      expect(entity.etaFormatted, '-- min');
    });

    test('CinemaEntity distanceFormatted and etaFormatted formatting', () {
      final entity1 = CinemaEntity(
        id: '1',
        name: 'Cinema 1',
        city: 'Bandung',
        chain: 'CGV',
        address: 'Addr',
        latitude: 0,
        longitude: 0,
        distanceInKm: 0.75,
        etaMinutes: 45,
      );
      expect(entity1.distanceFormatted, '750 m');
      expect(entity1.etaFormatted, '45 min');

      final entity2 = CinemaEntity(
        id: '2',
        name: 'Cinema 2',
        city: 'Bandung',
        chain: 'CGV',
        address: 'Addr',
        latitude: 0,
        longitude: 0,
        distanceInKm: 12.4,
        etaMinutes: 75,
      );
      expect(entity2.distanceFormatted, '12.4 km');
      expect(entity2.etaFormatted, '1h 15m');
    });

    test('CinemaRouteEntity getters calculation', () {
      final route = CinemaRouteEntity(
        points: const [RoutePoint(0, 0), RoutePoint(1, 1)],
        distanceMeters: 14500,
        durationSeconds: 1500,
      );

      expect(route.distanceInKm, 14.5);
      expect(route.durationMinutes, 25);
      expect(route.distanceFormatted, '14.5 km');
      expect(route.durationFormatted, '25 min');
    });

    test('GetCinemasUseCase returns mock cinemas', () async {
      final repo = MockCinemaRepository();
      final useCase = GetCinemasUseCase(repo);

      final result = await useCase();
      expect(result.length, 2);
      expect(result.first.name, 'CGV Paris Van Java');
      expect(result.last.chain, 'Cinema XXI');
    });

    test('GetCinemaRouteUseCase returns route and ETA', () async {
      final repo = MockCinemaRepository();
      final useCase = GetCinemaRouteUseCase(repo);

      final result = await useCase(
        originLat: -6.9175,
        originLng: 107.6191,
        destLat: -6.8893,
        destLng: 107.5960,
      );

      expect(result.distanceInKm, 3.5);
      expect(result.durationMinutes, 12);
      expect(result.points.length, 2);
    });
  });
}
