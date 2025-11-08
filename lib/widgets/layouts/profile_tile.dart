import 'package:exui/exui.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/screens/auth/screen_user_profile.dart';

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
      return [
            CircleAvatar(
              child: user.fullName[0].text(
                style: TextStyle(color: Colors.white),
              ),
            ),
            12.gapWidth,
            [
                  user.fullName.text(),
                  "role : ${user.role}".text(
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  user.companyName.text(
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ]
                .column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                )
                .expanded1,
            12.gapWidth,
            "Till ${user.till.toString()}"
                .text(style: TextStyle(fontSize: 12, color: Colors.grey))
                .visibleIf(user.role == "cashier"),
            12.gapWidth,
          ]
          .row()
          .onTap(_dropDown)
          .padding(EdgeInsets.symmetric(horizontal: 9, vertical: 12));
    });
  }

  void _dropDown() {
    Get.to(() => ScreenUserProfile());
  }
}
