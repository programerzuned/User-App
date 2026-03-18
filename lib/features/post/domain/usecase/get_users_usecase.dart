import '../../../../data/models/user_post_model.dart';
import '../repositories/user_repository_interface.dart';

class GetUsersUseCase {
  final UserRepositoryInterface repository;
  GetUsersUseCase(this.repository);

  Future<List<User>> call({int limit = 10, int skip = 0, String? gender,}) async {
    return await repository.fetchUsers(limit: limit, skip: skip, gender: gender,);
  }
}
