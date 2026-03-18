import 'package:flutter/material.dart';
import '../../../core/custom_widgets/profile_card.dart';
import '../../../data/models/user_post_model.dart';

class ProfileScreen extends StatelessWidget {
  final User user;
  const ProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile", style: theme.textTheme.titleLarge),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewPadding.bottom + 20,
          ),
          child: Column(
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 60,
                backgroundColor: theme.cardColor,
                backgroundImage: user.image.isNotEmpty ? NetworkImage(user.image) : null,
                child: user.image.isEmpty
                    ? Icon(Icons.person, size: 40, color: theme.disabledColor)
                    : null,
              ),
              const SizedBox(height: 10),
              Text(
                "${user.firstName} ${user.lastName}",
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              Text(
                user.email,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.disabledColor),
              ),
              const SizedBox(height: 20),

              ProfileCard(
                title: "Basic Info",
                rows: [
                  ProfileRowData(icon: Icons.person, label: "Username", value: user.username),
                  ProfileRowData(icon: Icons.phone, label: "Phone", value: user.phone),
                  ProfileRowData(icon: Icons.calendar_today, label: "Age", value: user.age.toString()),
                  ProfileRowData(icon: Icons.transgender, label: "Gender", value: user.gender),
                  ProfileRowData(icon: Icons.bloodtype, label: "Blood Group", value: user.bloodGroup),
                  ProfileRowData(icon: Icons.height, label: "Height", value: "${user.height} cm"),
                  ProfileRowData(icon: Icons.monitor_weight, label: "Weight", value: "${user.weight} kg"),
                  ProfileRowData(icon: Icons.remove_red_eye, label: "Eye Color", value: user.eyeColor),
                  ProfileRowData(icon: Icons.cut, label: "Hair", value: "${user.hair.color}, ${user.hair.type}"),
                ],
              ),

              ProfileCard(
                title: "Address",
                rows: [
                  ProfileRowData(icon: Icons.location_city, label: "Address", value: user.address.address),
                  ProfileRowData(icon: Icons.location_city, label: "City", value: user.address.city),
                  ProfileRowData(icon: Icons.map, label: "State", value: user.address.state),
                  ProfileRowData(icon: Icons.local_post_office, label: "Postal Code", value: user.address.postalCode),
                  ProfileRowData(icon: Icons.public, label: "Country", value: user.address.country),
                ],
              ),

              ProfileCard(
                title: "Company",
                rows: [
                  ProfileRowData(icon: Icons.business, label: "Name", value: user.company.name),
                  ProfileRowData(icon: Icons.work, label: "Department", value: user.company.department),
                  ProfileRowData(icon: Icons.badge, label: "Title", value: user.company.title),
                ],
              ),
              ProfileCard(
                title: "Bank",
                rows: [
                  ProfileRowData(icon: Icons.credit_card, label: "Card Number", value: user.bank.cardNumber),
                  ProfileRowData(icon: Icons.date_range, label: "Card Expire", value: user.bank.cardExpire),
                  ProfileRowData(icon: Icons.credit_card, label: "Card Type", value: user.bank.cardType),
                ],
              ),
              ProfileCard(
                title: "Crypto",
                rows: [
                  ProfileRowData(icon: Icons.currency_bitcoin, label: "Coin", value: user.crypto.coin),
                  ProfileRowData(icon: Icons.account_balance_wallet, label: "Wallet", value: user.crypto.wallet),
                  ProfileRowData(icon: Icons.network_wifi, label: "Network", value: user.crypto.network),
                ],
              ),

              ProfileCard(
                title: "Role",
                rows: [
                  ProfileRowData(icon: Icons.badge, label: "Role", value: user.role),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}