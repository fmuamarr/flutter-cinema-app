import '../entities/people/people_entity.dart';
import '../repositories/people_repository.dart';

class GetPeopleDetailUseCase {
  final PeopleRepository _repository;

  GetPeopleDetailUseCase(this._repository);

  Future<PeopleEntity> call(int id) {
    return _repository.getPeopleDetail(id);
  }
}
