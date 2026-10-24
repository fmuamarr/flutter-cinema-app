import '../entities/vehicle/vehicle_entity.dart';
import '../repositories/vehicle_repository.dart';

class GetVehicleDetailUseCase {
  final VehicleRepository _repository;

  GetVehicleDetailUseCase(this._repository);

  Future<VehicleEntity> call(int id) {
    return _repository.getVehicleDetail(id);
  }
}
