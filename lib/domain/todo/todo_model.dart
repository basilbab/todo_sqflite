class TodoModel {
  late int todoId;
  late String todoName;
  late String todoStatus;
  TodoModel(
      {required this.todoId, required this.todoName, required this.todoStatus});
  static TodoModel fromMap(Map<String, Object?> map) {
    final id = map['id'] as int;
    final name = map['name'] as String;
    final status = map['status'] as String;
    TodoModel t = TodoModel(todoId: id, todoName: name, todoStatus: status);
    return t;
  }
}
