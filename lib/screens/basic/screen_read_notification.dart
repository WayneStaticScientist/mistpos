import 'package:get/get.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:mistpos/models/notification_model.dart';
import 'package:mistpos/controllers/firebase_controller.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ScreenReadNotification extends StatefulWidget {
  final NotificationModel notificationModel;
  const ScreenReadNotification({super.key, required this.notificationModel});

  @override
  State<ScreenReadNotification> createState() => _ScreenReadNotificationState();
}

class _ScreenReadNotificationState extends State<ScreenReadNotification> {
  final _firebaseController = Get.find<FirebaseController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timer) {
      _firebaseController.readModel(widget.notificationModel);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: widget.notificationModel.title.text()),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: HtmlWidget(
          widget.notificationModel.message,
          renderMode: RenderMode.listView,
        ),
      ),
    );
  }
}
