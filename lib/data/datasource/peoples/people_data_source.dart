import '../../model/people/people_model.dart';

abstract class PeopleDataSource {
  Future<PeopleModel> getPeopleDetail(int id);
}
