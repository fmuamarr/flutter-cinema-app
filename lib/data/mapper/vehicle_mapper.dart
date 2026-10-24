import '../../domain/entities/vehicle/vehicle_entity.dart';
import '../model/vehicle/vehicle_model.dart';

extension VehiclesModelMapper on VehiclesModel {
  VehicleEntity toEntity() {
    return VehicleEntity(
      name: name,
      model: model,
      manufacturer: manufacturer,
      costInCredits: costInCredits,
      length: length,
      maxAtmospheringSpeed: maxAtmospheringSpeed,
      crew: crew,
      passengers: passengers,
      cargoCapacity: cargoCapacity,
      consumables: consumables,
      vehicleClass: vehicleClass,
      pilots: pilots,
      films: films,
      created: created,
      edited: edited,
      url: url,
    );
  }
}
