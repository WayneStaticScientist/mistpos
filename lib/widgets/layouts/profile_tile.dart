import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/tabler.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/auth/screen_account_selection.dart';

class ProfileTile extends StatefulWidget {
  const ProfileTile({super.key});

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  final _userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    if (_userController.user.value == null) {
      return const SizedBox.shrink();
    }
    return Obx(() {
      final user = _userController.user.value!;
      return ListTile(
        onTap: _dropDown,
        leading: CircleAvatar(child: user.fullName[0].text()),
        title: user.fullName.text(),
        subtitle: user.role.text(),
        trailing: IconButton(
          onPressed: _dropDown,
          icon: Iconify(Tabler.switch_horizontal, color: Colors.grey),
        ),
      );
    });
  }

  void _dropDown() {
    Get.to(() => ScreenAccountSelection());
  }
}
