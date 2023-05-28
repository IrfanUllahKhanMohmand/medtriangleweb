class TreatmentModel {
  String medicines;
  String injections;
  String surgery;
  String drops;
  String food;

  TreatmentModel(
      {required this.medicines,
      required this.injections,
      required this.surgery,
      required this.drops,
      required this.food});

  factory TreatmentModel.fromJson(Map<String, dynamic> json) {
    return TreatmentModel(
        medicines: json['Medicines'],
        injections: json['Injections'],
        surgery: json['Surgery'],
        drops: json['Drops'],
        food: json['Food']);
  }

  Map<String, dynamic> toJson() {
    return {
      'Medicines': medicines,
      'Injections': injections,
      'Surgery': surgery,
      'Drops': drops,
      'Food': food
    };
  }
}
