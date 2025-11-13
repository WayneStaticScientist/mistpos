import 'dart:async';

import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:exui/material.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/themes/app_theme.dart';
import 'package:iconify_flutter/icons/bx.dart';
import 'package:mistpos/utils/date_utils.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:mistpos/models/notification_model.dart';
import 'package:mistpos/widgets/inputs/search_field.dart';
import 'package:mistpos/controllers/firebase_controller.dart';
import 'package:mistpos/screens/basic/screen_read_notification.dart';

class ScreenNotifications extends StatefulWidget {
  const ScreenNotifications({super.key});

  @override
  State<ScreenNotifications> createState() => _ScreenNotificationsState();
}

class _ScreenNotificationsState extends State<ScreenNotifications> {
  final _firebaseController = Get.find<FirebaseController>();
  final _searchController = TextEditingController();
  Timer? _debouncer;
  String _searchKey = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((time) {
      _firebaseController.listAllNotifications();
      _firebaseController.notificationSize.value = 0;
    });
    _initDebouncer();
  }

  @override
  void dispose() {
    _debouncer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: "Notifications".text(),
        actions: [
          Obx(
            () => IconButton(
              onPressed: _clearAllNotifications,
              icon: Icon(Icons.close),
            ).visibleIf(_firebaseController.notifications.isNotEmpty),
          ),
        ],
      ),
      body: [
        MistSearchField(
          controller: _searchController,
          label: "search notifications",
        ).padding(EdgeInsets.all(8)),
        14.gapHeight,
        Obx(
          () => _firebaseController.notifications.isEmpty
              ? _emptyWidget()
              : ListView.builder(
                  itemBuilder: (context, index) =>
                      _buidTile(_firebaseController.notifications[index]),
                  itemCount: _firebaseController.notifications.length,
                ),
        ).expanded1,
      ].column(),
    );
  }

  Widget _buidTile(NotificationModel model) {
    return ListTile(
      tileColor: model.read ? null : Colors.green.withAlpha(50),
      onTap: () =>
          Get.to(() => ScreenReadNotification(notificationModel: model)),
      trailing: MistDateUtils.getInformalShortDate(model.updatedAt).text(),
      title: model.title.text(),
      leading: Iconify(Bx.bell, color: Get.theme.colorScheme.primary),
      subtitle:
          (model.message.length > 20
                  ? "${model.message.substring(0, 20)}..."
                  : model.message)
              .text(maxLines: 1, overflow: TextOverflow.ellipsis),
    );
  }

  void _clearAllNotifications() {
    Get.defaultDialog(
      title: "Clear Notifications",
      content: "This operation will delete all notifications in your phone only"
          .text(),
      cancel: "close".text().textButton(onPressed: () => Get.back()),
      confirm: "delete".text().textButton(
        onPressed: () {
          Get.back();
          _firebaseController.deleteAllNotifications();
        },
      ),
    );
  }

  Widget _emptyWidget() {
    return [
          Iconify(Bx.bell, color: AppTheme.color(context), size: 32),
          18.gapHeight,
          "No notifications in list".text(),
        ]
        .column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        )
        .center();
  }

  void _initDebouncer() {
    _debouncer = Timer.periodic(Duration(milliseconds: 500), (time) {
      if (_searchKey != _searchController.text) {
        _searchKey = _searchController.text;
        _firebaseController.listAllNotifications(search: _searchKey);
      }
    });
  }
}
