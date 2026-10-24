import '../entities/vehicle/vehicle_entity.dart';

abstract class VehicleRepository {
  Future<VehicleEntity> getVehicleDetail(int id);
}
