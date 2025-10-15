class DatabaseModel {
  final int? id;
  final String title;
  final String description;
  final String date;

  DatabaseModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
  });

  factory DatabaseModel.fromMap(Map<String, dynamic> map) {
    return DatabaseModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
    );
  }
}
