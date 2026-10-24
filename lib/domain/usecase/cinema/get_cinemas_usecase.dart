import '../../entities/cinema/cinema_entity.dart';
import '../../repositories/cinema_repository.dart';

class GetCinemasUseCase {
  final CinemaRepository _repository;

  GetCinemasUseCase(this._repository);

  Future<List<CinemaEntity>> call() {
    return _repository.getCinemas();
  }
}
