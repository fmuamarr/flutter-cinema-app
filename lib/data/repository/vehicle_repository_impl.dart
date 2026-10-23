import '../../domain/entities/vehicle/vehicle_entity.dart';
import '../../domain/repositories/vehicle_repository.dart';
import '../datasource/vehicles/vehicle_data_source.dart';
import '../mapper/vehicle_mapper.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final VehicleDataSource _vehicleDataSource;

  VehicleRepositoryImpl({required VehicleDataSource vehicleDataSource})
    : _vehicleDataSource = vehicleDataSource;

  @override
  Future<VehicleEntity> getVehicleDetail(int id) async {
    final response = await _vehicleDataSource.getVehicleDetail(id);
    return response.toEntity();
  }
}
