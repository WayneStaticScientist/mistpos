import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mistpos/core/services/api/network_wrapper.dart';
import 'package:mistpos/core/utils/toast.dart';
import 'package:mistpos/data/models/goal_task_model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mistpos/core/services/firebase/firebase_bg_notification_handler.dart';

class GoalsTasksController extends GetxController {
  RxList<GoalTaskModel> goalsTasks = RxList([]);
  RxBool fetching = false.obs;
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    fetchGoalsTasks();
    super.onInit();
  }

  Future<void> fetchGoalsTasks() async {
    if (fetching.value) return;
    fetching.value = true;
    final response = await Net.get("/admin/goals-tasks");
    fetching.value = false;
    if (response.hasError) {
      Toaster.showError(response.response);
      return;
    }
    final list = response.body['list'] as List<dynamic>?;
    goalsTasks.clear();
    if (list != null) {
      goalsTasks.assignAll(list.map((e) => GoalTaskModel.fromJson(e)));
    }
    checkTaskExpiries();
  }

  Future<bool> createGoalTask(Map<String, dynamic> data) async {
    final response = await Net.post("/admin/goals-tasks", data: data);
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    fetchGoalsTasks();
    return true;
  }

  Future<bool> updateGoalTask(String id, Map<String, dynamic> data) async {
    final response = await Net.put("/admin/goals-tasks/$id", data: data);
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    fetchGoalsTasks();
    return true;
  }

  Future<bool> deleteGoalTask(String id) async {
    final response = await Net.delete("/admin/goals-tasks/$id");
    if (response.hasError) {
      Toaster.showError(response.response);
      return false;
    }
    fetchGoalsTasks();
    return true;
  }

  void checkTaskExpiries() {
    final now = DateTime.now();
    for (var task in goalsTasks) {
      if (!task.isCompleted && task.dueDate.isBefore(now)) {
        final key = "alerted_task_${task.id}";
        if (_storage.read(key) != true) {
          _storage.write(key, true);
          flutterLocalNotificationsPlugin.show(
            id: task.id.hashCode,
            title: "Task Expired: ${task.title}",
            body: "The deadline for this goal/task has been reached.",
            notificationDetails: const NotificationDetails(
              android: AndroidNotificationDetails(
                'high_importance_channel',
                'High Importance Notifications',
                channelDescription: 'This channel is used for important notifications.',
                importance: Importance.max,
                priority: Priority.high,
              ),
            ),
          );
        }
      }
    }
  }
}
