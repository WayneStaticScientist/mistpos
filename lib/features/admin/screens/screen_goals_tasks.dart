import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mistpos/core/themes/app_theme.dart';
import 'package:mistpos/data/models/goal_task_model.dart';
import 'package:mistpos/features/admin/controllers/goals_tasks_controller.dart';
import 'package:mistpos/core/utils/toast.dart';

class ScreenGoalsTasks extends StatefulWidget {
  const ScreenGoalsTasks({super.key});

  @override
  State<ScreenGoalsTasks> createState() => _ScreenGoalsTasksState();
}

class _ScreenGoalsTasksState extends State<ScreenGoalsTasks> with SingleTickerProviderStateMixin {
  final GoalsTasksController _controller = Get.find<GoalsTasksController>();
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _controller.fetchGoalsTasks();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Goals & Tasks',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        bottom: TabBar(
          controller: _tabController,
          labelColor: theme.colorScheme.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: theme.colorScheme.primary,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Daily'),
            Tab(text: 'Monthly'),
            Tab(text: 'Yearly'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [const Color(0xFF1E1E2E), const Color(0xFF121218)]
                : [const Color(0xFFF9FAFC), const Color(0xFFF1F3F9)],
          ),
        ),
        child: Obx(() {
          if (_controller.fetching.value && _controller.goalsTasks.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildTasksList(_controller.goalsTasks),
              _buildTasksList(_controller.goalsTasks.where((t) => t.goalType == 'daily').toList()),
              _buildTasksList(_controller.goalsTasks.where((t) => t.goalType == 'monthly').toList()),
              _buildTasksList(_controller.goalsTasks.where((t) => t.goalType == 'yearly').toList()),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddEditTaskModal(context),
        label: const Text('Add Goal/Task', style: TextStyle(fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add_task),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildTasksList(List<GoalTaskModel> tasks) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_turned_in_outlined, size: 64, color: Colors.grey.withAlpha(100)),
            const SizedBox(height: 16),
            const Text(
              'No goals or tasks found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              'Add tasks with checklists to stay on track!',
              style: TextStyle(fontSize: 13, color: Colors.grey.withAlpha(180)),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskCard(tasks[index]);
      },
    );
  }

  Widget _buildTaskCard(GoalTaskModel task) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final now = DateTime.now();
    final isExpired = !task.isCompleted && task.dueDate.isBefore(now);
    final daysRemaining = task.dueDate.difference(now).inDays;

    int completedItems = task.checklist.where((item) => item.isDone).length;
    int totalItems = task.checklist.length;
    double progress = totalItems > 0 ? (completedItems / totalItems) : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2E2E3E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: task.isCompleted
              ? Colors.green.withAlpha(80)
              : isExpired
                  ? Colors.red.withAlpha(80)
                  : Colors.grey.withAlpha(30),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(isDark ? 30 : 10),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          title: Row(
            children: [
              Transform.scale(
                scale: 1.1,
                child: Checkbox(
                  value: task.isCompleted,
                  activeColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (val) {
                    _controller.updateGoalTask(task.id, {
                      'isCompleted': val,
                    });
                  },
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                        color: task.isCompleted ? Colors.grey : (isDark ? Colors.white : Colors.black87),
                      ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ]
                  ],
                ),
              ),
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(left: 48, top: 4, bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Goal Tag and Expiry Label
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withAlpha(25),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.goalType.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        task.isCompleted
                            ? 'Completed'
                            : isExpired
                                ? 'Expired (${DateFormat('MMM d, yyyy').format(task.dueDate)})'
                                : daysRemaining == 0
                                    ? 'Expires Today'
                                    : 'Due in $daysRemaining days',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted
                              ? Colors.green
                              : isExpired
                                  ? Colors.red
                                  : daysRemaining == 1
                                      ? Colors.orange
                                      : Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
                if (totalItems > 0) ...[
                  const SizedBox(height: 12),
                  // Progress indicator
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: Colors.grey.withAlpha(30),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              task.isCompleted ? Colors.green : theme.colorScheme.primary,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '$completedItems/$totalItems',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          children: [
            const Divider(height: 1),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: isDark ? Colors.black.withAlpha(20) : Colors.grey.withAlpha(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (totalItems > 0) ...[
                    const Text(
                      'Checklist Items:',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(totalItems, (itemIdx) {
                      final item = task.checklist[itemIdx];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Checkbox(
                              value: item.isDone,
                              activeColor: theme.colorScheme.primary,
                              onChanged: (val) {
                                final updatedChecklist = task.checklist.map((it) {
                                  if (it.text == item.text) {
                                    it.isDone = val ?? false;
                                  }
                                  return it;
                                }).toList();

                                _controller.updateGoalTask(task.id, {
                                  'checklist': updatedChecklist.map((it) => it.toJson()).toList(),
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                item.text,
                                style: TextStyle(
                                  decoration: item.isDone ? TextDecoration.lineThrough : null,
                                  color: item.isDone ? Colors.grey : (isDark ? Colors.white70 : Colors.black87),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 12),
                  ],
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, color: Colors.blue, size: 20),
                        onPressed: () => _showAddEditTaskModal(context, task: task),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                        onPressed: () => _confirmDeleteTask(context, task.id),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteTask(BuildContext context, String taskId) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Task?'),
        content: const Text('Are you sure you want to delete this goal/task?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Get.back();
              final success = await _controller.deleteGoalTask(taskId);
              if (success) Toaster.showSuccess("Task deleted successfully");
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddEditTaskModal(BuildContext context, {GoalTaskModel? task}) {
    final titleController = TextEditingController(text: task?.title ?? '');
    final descController = TextEditingController(text: task?.description ?? '');
    final isEdit = task != null;

    RxString goalType = (task?.goalType ?? 'daily').obs;
    Rx<DateTime> dueDate = (task?.dueDate ?? DateTime.now().add(const Duration(days: 1))).obs;
    RxList<ChecklistItem> tempChecklist = (task?.checklist.map((e) => ChecklistItem(text: e.text, isDone: e.isDone)).toList() ?? <ChecklistItem>[]).obs;
    final checklistItemController = TextEditingController();

    Get.bottomSheet(
      DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: const EdgeInsets.all(24),
            child: ListView(
              controller: scrollController,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isEdit ? 'Edit Goal / Task' : 'Add Goal / Task',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() => DropdownButtonFormField<String>(
                      value: goalType.value,
                      decoration: const InputDecoration(
                        labelText: 'Goal Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'daily', child: Text('Daily Goal')),
                        DropdownMenuItem(value: 'monthly', child: Text('Monthly Goal')),
                        DropdownMenuItem(value: 'yearly', child: Text('Yearly Goal')),
                      ],
                      onChanged: (val) {
                        if (val != null) goalType.value = val;
                      },
                    )),
                const SizedBox(height: 16),
                Obx(() => ListTile(
                      title: const Text('Due Date', style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(DateFormat('EEEE, MMM d, yyyy').format(dueDate.value)),
                      trailing: const Icon(Icons.calendar_month),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.grey.withAlpha(80)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: dueDate.value,
                          firstDate: DateTime.now().subtract(const Duration(days: 305)),
                          lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
                        );
                        if (picked != null) {
                          dueDate.value = picked;
                        }
                      },
                    )),
                const SizedBox(height: 24),
                const Text(
                  'Checklist Items',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: checklistItemController,
                        decoration: const InputDecoration(
                          hintText: 'Add new item to checklist...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filled(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        final txt = checklistItemController.text.trim();
                        if (txt.isNotEmpty) {
                          tempChecklist.add(ChecklistItem(text: txt, isDone: false));
                          checklistItemController.clear();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tempChecklist.length,
                      itemBuilder: (context, idx) {
                        final item = tempChecklist[idx];
                        return ListTile(
                          leading: Checkbox(
                            value: item.isDone,
                            onChanged: (val) {
                              item.isDone = val ?? false;
                              tempChecklist.refresh();
                            },
                          ),
                          title: Text(item.text),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => tempChecklist.removeAt(idx),
                          ),
                        );
                      },
                    )),
                const SizedBox(height: 32),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    final title = titleController.text.trim();
                    if (title.isEmpty) {
                      Toaster.showError("Title is required");
                      return;
                    }
                    final Map<String, dynamic> data = {
                      'title': title,
                      'description': descController.text.trim(),
                      'goalType': goalType.value,
                      'dueDate': dueDate.value.toIso8601String(),
                      'checklist': tempChecklist.map((it) => it.toJson()).toList(),
                    };

                    bool success;
                    if (isEdit) {
                      success = await _controller.updateGoalTask(task.id, data);
                    } else {
                      success = await _controller.createGoalTask(data);
                    }

                    if (success) {
                      Get.back();
                      Toaster.showSuccess(isEdit ? "Goal/Task updated" : "Goal/Task created");
                    }
                  },
                  child: Text(
                    isEdit ? 'Save Changes' : 'Create Goal/Task',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
