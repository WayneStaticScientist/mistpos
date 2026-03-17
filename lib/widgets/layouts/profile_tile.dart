import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/controllers/user_controller.dart';
import 'package:mistpos/controllers/inventory_controller.dart';
import 'package:mistpos/screens/auth/screen_user_profile.dart';

class ProfileTile extends StatefulWidget {
  const ProfileTile({super.key});

  @override
  State<ProfileTile> createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  final _userController = Get.find<UserController>();
  final _invController = Get.find<InventoryController>();
  @override
  Widget build(BuildContext context) {
    if (_userController.user.value == null) {
      return const SizedBox.shrink();
    }
    return Obx(() {
      final user = _userController.user.value!;
      return [
            [
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
            ].row(),
            Obx(() {
              final company = _invController.company.value;
              final daysLeft = company != null
                  ? MistDateUtils.getDaysDifference(
                      company.subscriptionType.validUntil!,
                    )
                  : 0;
              if (company == null) {
                return SizedBox();
              }
              return [
                8.gapHeight,
                "Version: ${company.subscriptionType.type}".text(
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                if (company.subscriptionType.type != "free") ...[
                  [
                    "Expiry Date: ${company.subscriptionType.validUntil != null ? MistDateUtils.getInformalShortDate(company.subscriptionType.validUntil!) : 'N/A'}"
                        .text(
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                  ].row(),
                  if (company.subscriptionType.validUntil != null &&
                      company.subscriptionType.type != "free") ...[
                    4.gapWidth,
                    (daysLeft < 0
                            ? "Expired"
                            : MistDateUtils.getDifferenxeInApproximate(
                                company.subscriptionType.validUntil!,
                              ))
                        .text(
                          style: TextStyle(
                            color:
                                MistDateUtils.getDaysDifference(
                                      company.subscriptionType.validUntil!,
                                    ) <=
                                    7
                                ? Colors.red
                                : Colors.green,
                          ),
                        )
                        .textIconButton(
                          onPressed: () {},
                          icon: Iconify(
                            Bx.time,
                            size: 14,
                            color:
                                MistDateUtils.getDaysDifference(
                                      company.subscriptionType.validUntil!,
                                    ) <=
                                    7
                                ? Colors.red
                                : Colors.green,
                          ),
                        ),
                  ],
                ],
              ].column();
            }),
          ]
          .column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
          )
          .onTap(_dropDown)
          .padding(EdgeInsets.symmetric(horizontal: 9, vertical: 12));
    });
  }

  void _dropDown() {
    Get.to(() => ScreenUserProfile());
  }
}
