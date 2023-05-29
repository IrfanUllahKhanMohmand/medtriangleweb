class PatientInfoModel {
  String name;
  String birthday;
  String gender;
  String cnic;
  String phone;
  String address;
  String email;
  String bloodType;
  String consultDr;
  String ward;
  String bed;
  String appointNumber;
  String doctorNumber;
  String imageUrl;

  PatientInfoModel(
      {required this.name,
      required this.birthday,
      required this.gender,
      required this.cnic,
      required this.phone,
      required this.address,
      required this.email,
      required this.bloodType,
      required this.consultDr,
      required this.ward,
      required this.bed,
      required this.appointNumber,
      required this.doctorNumber,
      required this.imageUrl});

  factory PatientInfoModel.fromJson(Map<String, dynamic> json) {
    return PatientInfoModel(
      name: json['Name'],
      birthday: json['Birthday'],
      gender: json['Gender'],
      cnic: json['CNIC'],
      phone: json['Phone'],
      address: json['Adress'],
      email: json['Email'],
      bloodType: json['BloodType'],
      consultDr: json['ConsultDr'],
      ward: json['Ward'],
      bed: json['Bed'],
      appointNumber: json['appointNumber'],
      doctorNumber: json['doctorNumber'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Name': name,
      'Birthday': birthday,
      'Gender': gender,
      'CNIC': cnic,
      'Phone': phone,
      'Adress': address,
      'Email': email,
      'BloodType': bloodType,
      'ConsultDr': consultDr,
      'Ward': ward,
      'Bed': bed,
      'appointNumber': appointNumber,
      'doctorNumber': doctorNumber,
      'imageUrl': imageUrl
    };
  }
}
