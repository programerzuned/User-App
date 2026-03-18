import 'package:test_getx/features/post/domain/services/user_service_interface.dart';
import '../../../../data/models/user_post_model.dart';
import '../repositories/user_repository.dart';

class UserService implements UserServiceInterface {
  final UserRepository _userRepository;
  UserService(this._userRepository);

  @override
  Future<List<User>> fetchUsers({int limit = 10, int skip = 0, String? gender,}) async {
    return await _userRepository.fetchUsers(limit: limit, skip: skip, gender: gender,);
  }

}