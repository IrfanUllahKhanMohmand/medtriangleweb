class LabTestModel {
  String id;
  String name;
  String date; // New field for date
  String result; // New field for result

  LabTestModel({
    required this.id,
    required this.name,
    required this.date,
    required this.result,
  });

  factory LabTestModel.fromJson(Map<String, dynamic> json) {
    return LabTestModel(
      id: json['id'],
      name: json['Name'] ?? '',
      date: json['Date'] ?? '',
      result: json['Result'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'Name': name,
      'Date': date,
      'Result': result,
    };
  }
}
