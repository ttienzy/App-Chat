class TaskParameters {
  String name;
  String assignee;
  DateTime startDate;
  DateTime endDate;
  String idProject;
  String status = 'ongoing';

  TaskParameters({
    required this.name,
    required this.assignee,
    required this.startDate,
    required this.endDate,
    required this.idProject,
    this.status = 'ongoing',
  });
}
