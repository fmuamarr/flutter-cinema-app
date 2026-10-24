import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../app/infrastructure/theme/theme.dart';
import '../controllers/cinema_controller.dart';
import 'widgets/cinema_card.dart';
import 'widgets/cinema_route_sheet.dart';

class CinemaView extends GetView<CinemaController> {
  const CinemaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.disneyDeepBackground,
      appBar: AppBar(
        backgroundColor: AppTheme.disneyDeepBackground,
        title: Text(
          'Cinemas',
          style: context.textTheme.displaySmall?.copyWith(
            color: AppTheme.disneySilver,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: controller.initLocationAndCinemas,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 40,
                  color: Colors.redAccent,
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: controller.initLocationAndCinemas,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        final initialPos =
            controller.userPosition.value ??
            const LatLng(
              CinemaController.defaultLat,
              CinemaController.defaultLng,
            );

        return Column(
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: initialPos,
                      zoom: 12.0,
                    ),
                    onMapCreated: (mapCtrl) {
                      controller.mapController = mapCtrl;
                    },
                    markers: controller.markers,
                    polylines: controller.polylines,
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                  ),
                  Positioned(
                    right: 16,
                    bottom: 16,
                    child: FloatingActionButton.small(
                      heroTag: 'my_location_btn',
                      onPressed: controller.focusUserLocation,
                      child: const Icon(Icons.my_location),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 3,
              child: Container(
                color: AppTheme.disneyDeepBackground,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Theaters (${controller.filteredCinemas.length})',
                            style: context.textTheme.displaySmall?.copyWith(
                              color: AppTheme.disneySilver,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: context.theme.colorScheme.onSurface,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.white12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: controller.selectedCity.value,
                                dropdownColor:
                                    context.theme.colorScheme.onSurface,
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.white70,
                                ),
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.white,
                                ),
                                items: controller.cities.map((city) {
                                  return DropdownMenuItem<String>(
                                    value: city,
                                    child: Text(
                                      city == 'All' ? 'All Cities' : city,
                                      style: context.textTheme.bodySmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (city) {
                                  if (city != null) {
                                    controller.onSelectCity(city);
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (controller.selectedCinema.value != null)
                      CinemaRouteSheet(
                        cinema: controller.selectedCinema.value!,
                        route: controller.currentRoute.value,
                        isLoading: controller.isRouteLoading.value,
                        onClose: controller.clearSelectedCinema,
                        onNavigate: () => controller.launchNavigation(
                          controller.selectedCinema.value!,
                        ),
                      ),

                    Expanded(
                      child: controller.filteredCinemas.isEmpty
                          ? Center(
                              child: Text(
                                'No theaters listed in database for this city.',
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: Colors.white60,
                                ),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(bottom: 16),
                              itemCount: controller.filteredCinemas.length,
                              itemBuilder: (context, index) {
                                final cinema =
                                    controller.filteredCinemas[index];
                                final isSelected =
                                    controller.selectedCinema.value?.id ==
                                    cinema.id;
                                return CinemaCard(
                                  cinema: cinema,
                                  isSelected: isSelected,
                                  onTap: () => controller.selectCinema(cinema),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
