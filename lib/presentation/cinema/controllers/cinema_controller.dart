import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/cinema/cinema_entity.dart';
import '../../../domain/entities/cinema/cinema_route_entity.dart';
import '../../../domain/usecase/cinema/get_cinema_route_usecase.dart';
import '../../../domain/usecase/cinema/get_cinemas_usecase.dart';

class CinemaController extends GetxController {
  final GetCinemasUseCase _getCinemasUseCase;
  final GetCinemaRouteUseCase _getCinemaRouteUseCase;

  CinemaController({
    required GetCinemasUseCase getCinemasUseCase,
    required GetCinemaRouteUseCase getCinemaRouteUseCase,
  }) : _getCinemasUseCase = getCinemasUseCase,
       _getCinemaRouteUseCase = getCinemaRouteUseCase;

  // fallback default coordinate
  static const double defaultLat = -6.2088;
  static const double defaultLng = 106.8456;

  final isLoading = true.obs;
  final isRouteLoading = false.obs;
  final errorMessage = ''.obs;

  final cinemas = <CinemaEntity>[].obs;
  final filteredCinemas = <CinemaEntity>[].obs;
  final selectedCinema = Rxn<CinemaEntity>();
  final currentRoute = Rxn<CinemaRouteEntity>();

  final userPosition = Rxn<LatLng>();
  final isUsingFallbackLocation = false.obs;

  final selectedCity = 'All'.obs;
  final selectedChain = 'All'.obs;

  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;

  GoogleMapController? mapController;

  final cities = const ['All', 'Jakarta', 'Bandung', 'Surabaya', 'Semarang'];
  final chains = const ['All', 'CGV', 'Cinema XXI'];

  @override
  void onInit() {
    super.onInit();
    initLocationAndCinemas();
  }

  Future<void> initLocationAndCinemas() async {
    isLoading.value = true;
    errorMessage.value = '';

    await _determineUserPosition();
    await _loadCinemas();

    isLoading.value = false;
  }

  Future<void> _determineUserPosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        userPosition.value = const LatLng(defaultLat, defaultLng);
        isUsingFallbackLocation.value = true;
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          userPosition.value = const LatLng(defaultLat, defaultLng);
          isUsingFallbackLocation.value = true;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        userPosition.value = const LatLng(defaultLat, defaultLng);
        isUsingFallbackLocation.value = true;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 6),
        ),
      );

      userPosition.value = LatLng(position.latitude, position.longitude);
      isUsingFallbackLocation.value = false;
    } catch (_) {
      userPosition.value = const LatLng(defaultLat, defaultLng);
      isUsingFallbackLocation.value = true;
    }
  }

  Future<void> _loadCinemas() async {
    try {
      final list = await _getCinemasUseCase();
      final currentPos =
          userPosition.value ?? const LatLng(defaultLat, defaultLng);

      // calculate dist and eta
      final calculatedList = list.map((c) {
        final distMeters = Geolocator.distanceBetween(
          currentPos.latitude,
          currentPos.longitude,
          c.latitude,
          c.longitude,
        );
        final distKm = distMeters / 1000.0;
        // avg speed 30 km/hour
        final approxMinutes = (distKm / 30.0 * 60).round();

        return c.copyWith(distanceInKm: distKm, etaMinutes: approxMinutes);
      }).toList();

      // sort
      calculatedList.sort(
        (a, b) => (a.distanceInKm ?? 0).compareTo(b.distanceInKm ?? 0),
      );

      cinemas.assignAll(calculatedList);
      _applyFilter();
    } catch (e) {
      errorMessage.value = e.toString();
    }
  }

  void onSelectCity(String city) {
    selectedCity.value = city;
    _applyFilter();
  }

  void onSelectChain(String chain) {
    selectedChain.value = chain;
    _applyFilter();
  }

  void _applyFilter() {
    List<CinemaEntity> result = List.from(cinemas);

    if (selectedCity.value != 'All') {
      result = result
          .where(
            (c) => c.city.toLowerCase() == selectedCity.value.toLowerCase(),
          )
          .toList();
    }

    if (selectedChain.value != 'All') {
      result = result
          .where(
            (c) => c.chain.toLowerCase() == selectedChain.value.toLowerCase(),
          )
          .toList();
    }

    filteredCinemas.assignAll(result);
    _updateMarkers();

    if (selectedCinema.value != null &&
        !result.any((c) => c.id == selectedCinema.value!.id)) {
      clearSelectedCinema();
    }
  }

  void _updateMarkers() {
    final newMarkers = <Marker>{};

    final pos = userPosition.value;
    if (pos != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: pos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan),
          infoWindow: InfoWindow(
            title: 'Lokasi Anda',
            snippet: isUsingFallbackLocation.value
                ? '(Lokasi Default Demo)'
                : 'Posisi saat ini',
          ),
          zIndexInt: 10,
        ),
      );
    }

    for (final cinema in filteredCinemas) {
      final isSelected = selectedCinema.value?.id == cinema.id;
      final hue = cinema.chain.toUpperCase().contains('CGV')
          ? BitmapDescriptor.hueRed
          : BitmapDescriptor.hueYellow;

      newMarkers.add(
        Marker(
          markerId: MarkerId(cinema.id),
          position: LatLng(cinema.latitude, cinema.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            isSelected ? BitmapDescriptor.hueAzure : hue,
          ),
          infoWindow: InfoWindow(
            title: cinema.name,
            snippet:
                '${cinema.distanceFormatted} • '
                'ETA: ${cinema.etaFormatted}',
          ),
          onTap: () => selectCinema(cinema),
          zIndexInt: isSelected ? 5 : 1,
        ),
      );
    }

    markers.assignAll(newMarkers);
  }

  Future<void> selectCinema(CinemaEntity cinema) async {
    selectedCinema.value = cinema;
    _updateMarkers();

    final origin = userPosition.value ?? const LatLng(defaultLat, defaultLng);
    isRouteLoading.value = true;

    try {
      final route = await _getCinemaRouteUseCase(
        originLat: origin.latitude,
        originLng: origin.longitude,
        destLat: cinema.latitude,
        destLng: cinema.longitude,
      );

      currentRoute.value = route;

      // Update cinema
      final updatedCinema = cinema.copyWith(
        distanceInKm: route.distanceInKm,
        etaMinutes: route.durationMinutes,
      );
      selectedCinema.value = updatedCinema;

      // draw polyline
      final polylineCoordinates = route.points
          .map((p) => LatLng(p.latitude, p.longitude))
          .toList();

      polylines.assignAll({
        Polyline(
          polylineId: PolylineId('route_${cinema.id}'),
          points: polylineCoordinates,
          color: Colors.blueAccent,
          width: 4,
          startCap: Cap.roundCap,
          endCap: Cap.roundCap,
        ),
      });

      _focusRoute(
        origin,
        LatLng(cinema.latitude, cinema.longitude),
        polylineCoordinates,
      );
    } catch (_) {
    } finally {
      isRouteLoading.value = false;
    }
  }

  void clearSelectedCinema() {
    selectedCinema.value = null;
    currentRoute.value = null;
    polylines.clear();
    _updateMarkers();
  }

  void _focusRoute(
    LatLng origin,
    LatLng destination,
    List<LatLng> coordinates,
  ) {
    if (mapController == null) return;

    if (coordinates.isEmpty) {
      coordinates = [origin, destination];
    }

    double minLat = coordinates.first.latitude;
    double maxLat = coordinates.first.latitude;
    double minLng = coordinates.first.longitude;
    double maxLng = coordinates.first.longitude;

    for (final c in coordinates) {
      minLat = min(minLat, c.latitude);
      maxLat = max(maxLat, c.latitude);
      minLng = min(minLng, c.longitude);
      maxLng = max(maxLng, c.longitude);
    }

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    mapController?.animateCamera(CameraUpdate.newLatLngBounds(bounds, 70));
  }

  void focusUserLocation() {
    final pos = userPosition.value;
    if (pos != null && mapController != null) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(CameraPosition(target: pos, zoom: 14)),
      );
    }
  }

  Future<void> launchNavigation(CinemaEntity cinema) async {
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination='
      '${cinema.latitude},${cinema.longitude}&travelmode=driving',
    );

    try {
      if (await canLaunchUrl(googleMapsUrl)) {
        await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar(
          'Navigasi',
          'Tidak dapat membuka aplikasi peta.',
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memulai navigasi: $e',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
}
