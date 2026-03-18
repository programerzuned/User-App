import 'dart:async';
import '../../../../data/models/user_post_model.dart';

abstract class UserRepositoryInterface {
  Future<List<User>> fetchUsers({
    int limit = 10,
    int skip = 0,
    String? gender,
  });
}