import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/auth/screen_account_selection.dart';

class ScreenUserProfile extends StatefulWidget {
  const ScreenUserProfile({super.key});

  @override
  State<ScreenUserProfile> createState() => _ScreenUserProfileState();
}

class _ScreenUserProfileState extends State<ScreenUserProfile> {
  TextStyle get _subtitleStyle =>
      const TextStyle(color: Colors.grey, fontSize: 12);
  final _userController = Get.find<UserController>();

  Widget _buildSectionContainer({required Widget child}) {
    return Padding(padding: const EdgeInsets.all(8.0), child: child);
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _subtitleStyle.copyWith(fontSize: 10)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Profile & Settings')),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          _buildSectionContainer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                  "Full Name",
                  _userController.user.value!.fullName,
                ),
                _buildDetailRow("Email", _userController.user.value!.email),
                _buildDetailRow(
                  "Company",
                  _userController.user.value!.companyName,
                ),
                _buildDetailRow("Role", _userController.user.value!.role),
                if (_userController.user.value!.role == 'cashier')
                  _buildDetailRow(
                    "Till",
                    _userController.user.value!.till.toString(),
                  ),
              ],
            ),
          ),
          18.gapHeight,
          [
                "User Settings"
                    .text(style: TextStyle(fontWeight: FontWeight.bold))
                    .padding(EdgeInsets.all(14)),

                ListTile(
                  onTap: () => Get.to(() => ScreenAccountSelection()),
                  leading: Iconify(
                    Tabler.switch_horizontal,
                    color: AppTheme.color(context),
                  ),
                  title: "Switch Account".text(),
                ),
                ListTile(
                  onTap: () => Get.to(() => ScreenAccountSelection()),
                  leading: Iconify(Bx.lock, color: AppTheme.color(context)),
                  title: "Change Password".text(),
                ),
                ListTile(
                  onTap: () => Get.to(() => ScreenAccountSelection()),
                  leading: Iconify(Bx.log_out, color: AppTheme.color(context)),
                  title: "Logout".text(),
                ),
              ]
              .column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
              )
              .decoratedBox(
                decoration: BoxDecoration(
                  color: AppTheme.surface(context),
                  borderRadius: BorderRadius.circular(20),
                ),
              )
              .padding(EdgeInsets.all(8)),
        ],
      ),
    );
  }
}
