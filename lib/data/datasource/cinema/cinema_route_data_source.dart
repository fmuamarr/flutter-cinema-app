import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import '../../../domain/entities/cinema/cinema_route_entity.dart';

abstract class CinemaRouteDataSource {
  Future<CinemaRouteEntity> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  });
}

class CinemaRouteDataSourceImpl implements CinemaRouteDataSource {
  final Dio _dio;

  CinemaRouteDataSourceImpl({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  @override
  Future<CinemaRouteEntity> getRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
  }) async {
    final url =
        'https://router.project-osrm.org/route/v1/driving/'
        '$originLng,$originLat;$destLng,$destLat'
        '?overview=full&geometries=polyline';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data['code'] == 'Ok' &&
            data['routes'] is List &&
            (data['routes'] as List).isNotEmpty) {
          final route = data['routes'][0];
          final geometry = route['geometry'] as String? ?? '';
          final distance = (route['distance'] as num?)?.toDouble() ?? 0.0;
          final duration = (route['duration'] as num?)?.toDouble() ?? 0.0;

          final polylinePoints = PolylinePoints();
          final decoded = polylinePoints.decodePolyline(geometry);

          final points = decoded
              .map((p) => RoutePoint(p.latitude, p.longitude))
              .toList();

          return CinemaRouteEntity(
            points: points.isNotEmpty
                ? points
                : [
                    RoutePoint(originLat, originLng),
                    RoutePoint(destLat, destLng),
                  ],
            distanceMeters: distance,
            durationSeconds: duration,
          );
        }
      }
    } catch (_) {}

    final straightDistance = Geolocator.distanceBetween(
      originLat,
      originLng,
      destLat,
      destLng,
    );
    final estimatedDuration = (straightDistance / 1000.0) / 30.0 * 3600.0;

    return CinemaRouteEntity(
      points: [RoutePoint(originLat, originLng), RoutePoint(destLat, destLng)],
      distanceMeters: straightDistance,
      durationSeconds: estimatedDuration,
    );
  }
}
