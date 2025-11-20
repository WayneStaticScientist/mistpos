import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/widgets/buttons/mist_form_button.dart';
import 'package:mistpos/screens/basic/screen_subscription.dart';

class SubscriptionAlert extends StatelessWidget {
  const SubscriptionAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return [
          Iconify(
            Bx.block,
            size: 64,
            color: Colors.grey,
          ).padding(EdgeInsets.only(bottom: 12)),
          Text(
            'Your current subscription does not allow access to this feature. Please upgrade your plan to continue using this feature.',
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ).padding(EdgeInsets.only(bottom: 12)),
          SizedBox(height: 16),
          MistFormButton(
            label: 'Renew Subscription',
            fillColor: Get.theme.colorScheme.secondary,
            onTap: () => Get.to(() => ScreenSubscription()),
          ),
        ]
        .column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
        .padding(EdgeInsets.all(9))
        .center();
  }
}
