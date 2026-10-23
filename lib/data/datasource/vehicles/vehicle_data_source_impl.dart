import '../../../app/utils/const/api/api_url.dart';
import '../../model/vehicle/vehicle_model.dart';
import '../../network/api_provider.dart';
import 'vehicle_data_source.dart';

class VehicleDataSourceImpl extends VehicleDataSource {
  final ApiProvider _apiProvider;

  VehicleDataSourceImpl({required ApiProvider apiProvider})
    : _apiProvider = apiProvider;

  @override
  Future<VehiclesModel> getVehicleDetail(int id) async {
    final response = await _apiProvider.call(
      ApiUrl.vehicleDetail(id),
      method: MethodRequest.get,
    );

    return VehiclesModel.fromJson(response);
  }
}
