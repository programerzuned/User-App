import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:test_getx/core/custom_widgets/exit_bottom_sheet.dart';
import '../../../core/custom_widgets/filter_bottom_sheet.dart';
import '../../../core/custom_widgets/user_shimmer.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../routes/route_helper.dart';
import '../controllers/user_controller.dart';
import 'package:lottie/lottie.dart';

class UserListScreen extends StatelessWidget {
  final controller = Get.find<UserController>();
  UserListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await ExitBottomSheet.show(context);
        if (shouldExit) {
          SystemNavigator.pop();
        }
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Users", style: theme.textTheme.displayMedium),
          centerTitle: true,
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.palette, color: theme.colorScheme.onPrimary),
              tooltip: "Theme Options",
              onSelected: (value) {
                final themeController = Get.find<ThemeController>();
                if (value == 'light' && themeController.isDarkMode) {
                  themeController.toggleTheme();
                } else if (value == 'dark' && !themeController.isDarkMode) {
                  themeController.toggleTheme();
                } else if (value == 'system') {
                  themeController.followSystemTheme();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'light', child: Text('Light Mode')),
                PopupMenuItem(value: 'dark', child: Text('Dark Mode')),
                PopupMenuItem(value: 'system', child: Text('Follow System')),
              ],
            ),
          ],
        ),

        body: Obx(() {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: controller.searchController,
                        onChanged: controller.search,
                        style: theme.textTheme.bodyLarge,
                        decoration: InputDecoration(
                          hintText: "Search users...",
                          hintStyle: theme.textTheme.bodyMedium,
                          prefixIcon: Icon(Icons.search,
                              color: theme.colorScheme.primary),
                          suffixIcon: controller.isSearching.value
                              ? IconButton(
                            icon: Icon(Icons.close,
                                color: theme.colorScheme.primary),
                            onPressed: controller.clearSearch,
                          )
                              : null,
                          filled: true,
                          fillColor: theme.cardColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    InkWell(
                      onTap: () => Get.bottomSheet(
                        const FilterBottomSheet(),
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(Icons.filter_list,
                            color: theme.colorScheme.primary),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Obx(() {
                  final isLoading = controller.isLoading.value;
                  final isLoadingMore = controller.isLoadingMore.value;
                  final hasError = controller.hasError.value;
                  final filtered = controller.filteredPosts;
                  if (isLoading && controller.posts.isEmpty) {
                    return const UserShimmer();
                  }
                  if (hasError) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: Get.height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 450,
                                  height: 300,
                                  child: Lottie.asset(
                                    'assets/animations/network_error.json',
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  controller.errorMessage.value,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  onPressed: controller.fetchUsers,
                                  child:  Text("Retry",
                                    style: Theme.of(context).textTheme.titleMedium,),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  if (filtered.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: Get.height * 0.7,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_search,
                                    size: 80, color: Theme.of(context).disabledColor),
                                const SizedBox(height: 16),
                                Text("No users found",
                                    style: Theme.of(context).textTheme.titleMedium),
                                const SizedBox(height: 10),
                                TextButton(
                                  onPressed: controller.refreshData,
                                  child: const Text("Refresh"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: controller.refreshData,
                    color: Theme.of(context).colorScheme.primary,
                    child: ListView.builder(
                      controller: controller.scrollController,
                      itemCount: filtered.length + 1,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemBuilder: (context, index) {
                        if (index == filtered.length) {
                          return isLoadingMore
                              ? const Padding(
                            padding: EdgeInsets.all(20),
                            child: Center(child: CircularProgressIndicator()),
                          )
                              : const SizedBox();
                        }
                        final user = filtered[index];
                        return Card(
                          color: Theme.of(context).cardColor,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => Get.toNamed(RouteHelper.getProfileRoute(),
                                arguments: user),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 26,
                                backgroundColor: Theme.of(context).dividerColor,
                                backgroundImage:
                                user.image.isNotEmpty ? NetworkImage(user.image) : null,
                                child: user.image.isEmpty ? const Icon(Icons.person) : null,
                              ),
                              title: Text("${user.firstName} ${user.lastName ?? ''}",
                                  style: Theme.of(context).textTheme.titleMedium),
                              subtitle: Text(user.email,
                                  style: Theme.of(context).textTheme.bodySmall),
                              trailing: Icon(Icons.arrow_forward_ios,
                                  size: 14, color: Theme.of(context).colorScheme.primary),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              )
            ],
          );
        }),
      ),
    );
  }
}