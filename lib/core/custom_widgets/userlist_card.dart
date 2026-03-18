import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/route_helper.dart';
class UserCard extends StatelessWidget {
  final dynamic user;
  const UserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Get.toNamed(RouteHelper.getProfileRoute(), arguments: user),
        child: ListTile(
          leading: CircleAvatar(
            radius: 26,
            backgroundColor: theme.dividerColor,
            backgroundImage: user.image.isNotEmpty ? NetworkImage(user.image) : null,
            child: user.image.isEmpty ? const Icon(Icons.person) : null,
          ),
          title: Text("${user.firstName} ${user.lastName ?? ''}",
              style: theme.textTheme.titleMedium),
          subtitle: Text(user.email, style: theme.textTheme.bodySmall),
          trailing: Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}