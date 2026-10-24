import '../../domain/entities/cinema/cinema_entity.dart';
import '../model/cinema/cinema_model.dart';

extension CinemaModelMapper on CinemaModel {
  CinemaEntity toEntity() {
    return CinemaEntity(
      id: id ?? '',
      name: name ?? 'Bioskop',
      city: city ?? '',
      chain: chain ?? '',
      address: address ?? '',
      latitude: latitude ?? 0.0,
      longitude: longitude ?? 0.0,
    );
  }
}
