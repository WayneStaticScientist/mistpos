class ChecklistItem {
  final String text;
  bool isDone;

  ChecklistItem({
    required this.text,
    this.isDone = false,
  });

  factory ChecklistItem.fromJson(Map<String, dynamic> json) {
    return ChecklistItem(
      text: json['text'] ?? '',
      isDone: json['isDone'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'isDone': isDone,
    };
  }
}

class GoalTaskModel {
  final String id;
  final String title;
  final String description;
  final String company;
  final String goalType; // daily, monthly, yearly
  final DateTime dueDate;
  bool isCompleted;
  final DateTime? completionDate;
  final List<ChecklistItem> checklist;
  final DateTime createdAt;
  final DateTime updatedAt;

  GoalTaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.company,
    required this.goalType,
    required this.dueDate,
    required this.isCompleted,
    this.completionDate,
    required this.checklist,
    required this.createdAt,
    required this.updatedAt,
  });

  factory GoalTaskModel.fromJson(Map<String, dynamic> json) {
    return GoalTaskModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      company: json['company'] ?? '',
      goalType: json['goalType'] ?? 'daily',
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']).toLocal() : DateTime.now(),
      isCompleted: json['isCompleted'] ?? false,
      completionDate: json['completionDate'] != null ? DateTime.parse(json['completionDate']).toLocal() : null,
      checklist: (json['checklist'] as List?)
              ?.map((item) => ChecklistItem.fromJson(item))
              .toList() ??
          [],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']).toLocal() : DateTime.now(),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']).toLocal() : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'description': description,
      'company': company,
      'goalType': goalType,
      'dueDate': dueDate.toIso8601String(),
      'isCompleted': isCompleted,
      if (completionDate != null) 'completionDate': completionDate!.toIso8601String(),
      'checklist': checklist.map((item) => item.toJson()).toList(),
    };
  }
}
