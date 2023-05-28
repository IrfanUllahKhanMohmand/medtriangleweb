class MedicalInfoModel {
  String name;
  String birthday;
  String gender;
  String bloodType;
  String diagnosis;
  String bp;
  String sugar;
  String bloodTest;

  MedicalInfoModel(
      {required this.name,
      required this.birthday,
      required this.gender,
      required this.bloodType,
      required this.diagnosis,
      required this.bp,
      required this.sugar,
      required this.bloodTest});

  factory MedicalInfoModel.fromJson(Map<String, dynamic> json) {
    return MedicalInfoModel(
        name: json['Name'],
        birthday: json['Birthday'],
        gender: json['Gender'],
        bloodType: json['BloodType'],
        diagnosis: json['Diagnosis'],
        bp: json['BP'],
        sugar: json['Sugar'],
        bloodTest: json['BloodTest']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Birthday': birthday,
      'Gender': gender,
      'BloodType': bloodType,
      'Diagnosis': diagnosis,
      'BP': bp,
      'Sugar': sugar,
      'BloodTest': bloodTest
    };
  }
}
