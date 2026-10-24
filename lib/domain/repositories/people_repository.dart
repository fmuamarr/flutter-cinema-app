import '../entities/people/people_entity.dart';

abstract class PeopleRepository {
  Future<PeopleEntity> getPeopleDetail(int id);
}
