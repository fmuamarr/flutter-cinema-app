import '../../model/vehicle/vehicle_model.dart';

abstract class VehicleDataSource {
  Future<VehiclesModel> getVehicleDetail(int id);
}
