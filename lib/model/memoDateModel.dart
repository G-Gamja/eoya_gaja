class memoDateModel {
  final int? id;
  final String enrolledDate;

  memoDateModel({this.id, required this.enrolledDate});

  factory memoDateModel.fromMap(Map<String, dynamic> json) => memoDateModel(
        id: json['id'],
        enrolledDate: json['enrolledDate'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'enrolledDate': enrolledDate,
    };
  }
}
