import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_colors.dart';
import '../../features/post/controllers/user_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UserController>();
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Obx(
          () => Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 55),
        width: size.width,
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Filter & Sort',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  Row(
                    children: [
                      if (controller.selectedGenders.isNotEmpty ||
                          controller.selectedSort.isNotEmpty)
                        TextButton(
                          onPressed: controller.clearFilter,
                          child: Text('Clear',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500)),
                        ),
                      IconButton(
                          onPressed: Get.back,
                          icon: Icon(Icons.close, color: Colors.grey[600])),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Gender filter
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Gender',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500))),
              const SizedBox(height: 8),
              ...['male', 'female'].map((gender) {
                final isSelected = controller.selectedGenders.contains(gender);
                final displayText = gender.capitalizeFirst ?? gender;
                final color = gender == 'male'
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor;
                return InkWell(
                  onTap: () => controller.toggleGender(gender),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected ? color : Colors.grey[400],
                            size: 22),
                        const SizedBox(width: 10),
                        Text(displayText,
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected ? color : Colors.grey[700],
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            )),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 12),
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Sort by',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w500))),
              const SizedBox(height: 8),
              ...['asc', 'desc'].map((sort) {
                final isSelected = controller.selectedSort.value == sort;
                final displayText = sort == 'asc' ? 'A → Z' : 'Z → A';
                final color = AppColors.accentColor;
                return InkWell(
                  onTap: () => controller.sortByName(sort),
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Icon(
                            isSelected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_unchecked,
                            color: isSelected ? color : Colors.grey[400],
                            size: 22),
                        const SizedBox(width: 10),
                        Text(displayText,
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected ? color : Colors.grey[700],
                              fontWeight: isSelected
                                  ? FontWeight.w500
                                  : FontWeight.normal,
                            )),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    controller.applyFilter();
                    Get.back();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Done',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}