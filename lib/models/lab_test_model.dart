class LabTestModel {
  String id;
  String name;
  String date; // New field for date
  String result;
  String imageUrl; // New field for result

  LabTestModel(
      {required this.id,
      required this.name,
      required this.date,
      required this.result,
      required this.imageUrl});

  factory LabTestModel.fromJson(Map<String, dynamic> json) {
    return LabTestModel(
      id: json['id'],
      name: json['Name'] ?? '',
      date: json['Date'] ?? '',
      result: json['Result'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'Date': date,
      'Result': result,
      'imageUrl': imageUrl
    };
  }
}
