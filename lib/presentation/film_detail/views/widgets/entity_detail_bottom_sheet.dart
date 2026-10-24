import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/infrastructure/theme/theme.dart';
import '../../../../app/utils/const/borderradius_const.dart';
import '../../../../domain/entities/people/people_entity.dart';
import '../../../../domain/entities/planet/planet_entity.dart';
import '../../../../domain/entities/species/species_entity.dart';
import '../../../../domain/entities/starship/starship_entity.dart';
import '../../../../domain/entities/vehicle/vehicle_entity.dart';
import '../../controllers/film_detail_controller.dart';

class EntityDetailBottomSheet extends StatelessWidget {
  final FilmDetailController controller;
  final String entityType;
  final String url;

  const EntityDetailBottomSheet({
    super.key,
    required this.controller,
    required this.entityType,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      decoration: BoxDecoration(
        color: AppTheme.disneyDeepBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag handle
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Header Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.disneyBlue,
                      borderRadius: BorderradiusConst.radiusAllVerySmall,
                    ),
                    child: Text(
                      entityType.toUpperCase(),
                      style: context.textTheme.displaySmall?.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close_rounded),
                    color: AppTheme.disneySilver,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () => Get.back(),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10, height: 1),
            //body
            Flexible(
              child: Obx(() {
                if (controller.isEntityLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          color: AppTheme.disneyCyanAccent,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Memuat detail $entityType...',
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.disneySilver,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.entityError.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline_rounded,
                          color: AppTheme.yellowCrawl,
                          size: 40,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          controller.entityError.value,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyMedium?.copyWith(
                            color: AppTheme.disneySilver,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () => controller.fetchEntityDetail(
                            type: entityType,
                            url: url,
                          ),
                          icon: const Icon(Icons.refresh_rounded, size: 18),
                          label: Text(
                            'Coba Lagi',
                            style: context.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.disneySilver,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final entity = controller.selectedEntity.value;
                if (entity == null) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Text(
                        'Data tidak ditemukan.',
                        style: context.textTheme.bodyMedium?.copyWith(
                          color: AppTheme.disneySilver,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }

                final (title, fields) = _extractEntityInfo(entity);

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: context.textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Text(
                      //   url,
                      //   style: context.textTheme.bodyMedium?.copyWith(
                      //     color: AppTheme.disneySilver.withValues(alpha: 0.6),
                      //     fontSize: 12,
                      //   ),
                      // ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.disneyCardSurface,
                          borderRadius: BorderradiusConst.radiusAllSemiBig,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Column(
                          children: fields.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 120,
                                    child: Text(
                                      entry.key,
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: AppTheme.disneySilver,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      entry.value ?? '-',
                                      style: context.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  (String, Map<String, String?>) _extractEntityInfo(dynamic entity) {
    return switch (entity) {
      PeopleEntity e => (
        e.name ?? 'Character',
        {
          'Birth Year': e.birthYear,
          'Gender': e.gender,
          'Height': e.height,
          'Mass': e.mass,
          'Hair Color': e.hairColor,
          'Skin Color': e.skinColor,
          'Eye Color': e.eyeColor,
        },
      ),
      PlanetEntity e => (
        e.name ?? 'Planet',
        {
          'Climate': e.climate,
          'Terrain': e.terrain,
          'Population': e.population,
          'Diameter': e.diameter,
          'Gravity': e.gravity,
          'Orbital Period': e.orbitalPeriod,
          'Rotation Period': e.rotationPeriod,
          'Surface Water': e.surfaceWater,
        },
      ),
      SpeciesEntity e => (
        e.name ?? 'Species',
        {
          'Classification': e.classification,
          'Designation': e.designation,
          'Average Height': e.averageHeight,
          'Average Lifespan': e.averageLifespan,
          'Language': e.language,
          'Eye Colors': e.eyeColors,
          'Hair Colors': e.hairColors,
          'Skin Colors': e.skinColors,
        },
      ),
      StarshipEntity e => (
        e.name ?? 'Starship',
        {
          'Model': e.model,
          'Manufacturer': e.manufacturer,
          'Starship Class': e.starshipClass,
          'Cost': e.costInCredits,
          'Length': e.length,
          'Crew': e.crew,
          'Passengers': e.passengers,
          'Hyperdrive Rating': e.hyperdriveRating,
          'MGLT': e.mglt,
        },
      ),
      VehicleEntity e => (
        e.name ?? 'Vehicle',
        {
          'Model': e.model,
          'Manufacturer': e.manufacturer,
          'Vehicle Class': e.vehicleClass,
          'Cost': e.costInCredits,
          'Length': e.length,
          'Crew': e.crew,
          'Passengers': e.passengers,
          'Max Speed': e.maxAtmospheringSpeed,
        },
      ),
      _ => ('Detail', <String, String?>{}),
    };
  }
}
