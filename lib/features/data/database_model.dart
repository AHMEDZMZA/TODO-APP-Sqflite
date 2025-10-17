class DatabaseModel {
  final int? id;
  final String title;
  final String description;
  final String dateTime;
  late final String? image;
  final String? date;

  DatabaseModel({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.dateTime,
    this.image,
  });

  factory DatabaseModel.fromMap(Map<String, dynamic> map) {
    return DatabaseModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      date: map['date'],
      image: map['image'],
      dateTime: map['dateTime'],
    );
  }
}
