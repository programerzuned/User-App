import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_post_model.dart';
import '../domain/usecase/get_users_usecase.dart';

class UserController extends GetxController {
  final GetUsersUseCase _getUsersUseCase;
  UserController(this._getUsersUseCase);

  final posts = <User>[].obs;
  final filteredPosts = <User>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final isLastPage = false.obs;
  final hasError = false.obs;
  final errorMessage = "".obs;
  final loadMoreError = false.obs;
  final loadMoreErrorMessage = "".obs;

  int page = 0;
  final int limit = 10;
  final selectedGenders = <String>[].obs;
  final selectedSort = "".obs;
  String searchQuery = "";
  final searchController = TextEditingController();
  final isSearching = false.obs;
  final scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchUsers();

    scrollController.addListener(() {
      if (!isLoadingMore.value &&
          !isLastPage.value &&
          scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
  }

  Future<void> fetchUsers({bool reset = true}) async {
    if (reset) {
      isLoading.value = true;
      posts.clear();
      page = 0;
      isLastPage.value = false;
      loadMoreError.value = false;
    }

    hasError.value = false;
    errorMessage.value = "";

    try {
      String? genderParam;
      if (selectedGenders.isNotEmpty) {
        genderParam = selectedGenders.length == 1 ? selectedGenders.first : null;
      }

      final result = await _getUsersUseCase(
        limit: limit,
        skip: page * limit,
        gender: genderParam,
      );

      if (reset) {
        posts.assignAll(result);
      } else {
        posts.addAll(result);
      }

      if (result.length < limit) isLastPage.value = true;
      loadMoreError.value = false;

      applyFilter();
    } catch (e) {
      final isNetworkError = e.toString().toLowerCase().contains("socket") ||
          e.toString().toLowerCase().contains("connection") ||
          e.toString().toLowerCase().contains("host");

      if (reset) {
        hasError.value = true;
        errorMessage.value = isNetworkError
            ? "No Internet Connection"
            : "Something went wrong";
      } else {
        loadMoreError.value = true;
        loadMoreErrorMessage.value = isNetworkError
            ? "No Internet Connection"
            : "No Internet Connection";
        page--;
        Get.snackbar(
          "Error",
          loadMoreErrorMessage.value,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
          margin: const EdgeInsets.all(12),
          duration: const Duration(seconds: 3),
        );
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Future<void> loadMore() async {
    if (isLoadingMore.value || isLastPage.value) return;
    isLoadingMore.value = true;
    loadMoreError.value = false;
    page++;
    await fetchUsers(reset: false);
  }

  void retryLoadMore() {
    if (loadMoreError.value) {
      loadMore();
    }
  }

  void applyFilter() {
    List<User> list = [...posts];

    if (selectedGenders.length > 1) {
      list = list.where((u) => selectedGenders.contains(u.gender.toLowerCase())).toList();
    }

    if (searchQuery.isNotEmpty) {
      list = list.where((u) {
        final fullName =
            "${u.firstName.toLowerCase()} ${u.lastName?.toLowerCase() ?? ''}";
        return fullName.contains(searchQuery.toLowerCase());
      }).toList();
    }

    if (selectedSort.value == "asc") {
      list.sort((a, b) => a.firstName.compareTo(b.firstName));
    } else if (selectedSort.value == "desc") {
      list.sort((a, b) => b.firstName.compareTo(a.firstName));
    }

    filteredPosts.assignAll(list);
  }

  void search(String value) {
    searchQuery = value;
    isSearching.value = value.isNotEmpty;
    applyFilter();
  }

  void clearSearch() {
    searchController.clear();
    searchQuery = "";
    isSearching.value = false;
    applyFilter();
  }

  void sortByName(String sortOrder) {
    selectedSort.value = selectedSort.value == sortOrder ? "" : sortOrder;
    applyFilter();
  }

  void toggleGender(String gender) {
    if (selectedGenders.contains(gender)) {
      selectedGenders.remove(gender);
    } else {
      selectedGenders.add(gender);
    }

    if (selectedGenders.length == 1) {
      page = 0;
      fetchUsers();
    } else {
      applyFilter();
    }
  }

  Future<void> refreshData() async {
    await fetchUsers();
  }

  void clearFilter() {
    selectedGenders.clear();
    selectedSort.value = "";
    fetchUsers();
  }

  @override
  void onClose() {
    scrollController.dispose();
    searchController.dispose();
    super.onClose();
  }
}