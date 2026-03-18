import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/network/api_client.dart';
import '../../../../core/services/storage/hive_storage.dart';
import '../../../../data/models/user_post_model.dart';
import 'user_repository_interface.dart';

class UserRepository implements UserRepositoryInterface {
  final ApiClient _apiClient;
  static const _boxName = "users";
  UserRepository(this._apiClient);

  @override
  Future<List<User>> fetchUsers({
    int limit = 10,
    int skip = 0,
    String? gender,
  }) async {
    try {
      final queryParameters = {
        "limit": limit,
        "skip": skip,
        if (gender?.isNotEmpty ?? false) "gender": gender,
      };

      final response = await _apiClient.get(AppConstants.users,
          queryParameters: queryParameters);

      if (response.statusCode != 200) {
        throw Exception("API failed with status: ${response.statusCode}");
      }

      final usersData = response.data?['users'] ?? [];

      // Save to Hive for offline use
      await HiveStorage.putAll(
        _boxName,
        {for (var u in usersData) u['id'].toString(): u},
      );

      return _mapUsers(usersData);
    } catch (e) {
      debugPrint("⚠️ API Error: $e");

      // fallback to local cache
      final localData = await HiveStorage.getAll(_boxName);
      if (localData.isNotEmpty) {
        return _mapUsers(localData);
      }

      rethrow;
    }
  }

  List<User> _mapUsers(List data) {
    return data.map((e) => User.fromJson(Map<String, dynamic>.from(e))).toList();
  }
}