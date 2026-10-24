import '../../domain/entities/people/people_entity.dart';
import '../../domain/repositories/people_repository.dart';
import '../datasource/peoples/people_data_source.dart';
import '../mapper/people_mapper.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  final PeopleDataSource _peopleDataSource;

  PeopleRepositoryImpl({required PeopleDataSource peopleDataSource})
    : _peopleDataSource = peopleDataSource;

  @override
  Future<PeopleEntity> getPeopleDetail(int id) async {
    final response = await _peopleDataSource.getPeopleDetail(id);
    return response.toEntity();
  }
}
