class SignupModel {
  final String name;
  final String dob;
  final String fatherName;
  final String nrc;
  final String education;
  final String phoneNumber;
  final String email;
  final String address;
  final String clubName;
  final String playerStartDate;
  final String coachStartDate;
  final String classLevel;

  SignupModel({
    required this.name,
    required this.dob,
    required this.fatherName,
    required this.nrc,
    required this.education,
    required this.phoneNumber,
    required this.email,
    required this.address,
    required this.clubName,
    required this.playerStartDate,
    required this.coachStartDate,
    required this.classLevel,
  });

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      name: json['name'] ?? '',
      dob: json['dob'] ?? '',
      fatherName: json['fatherName'] ?? '',
      nrc: json['nrc'] ?? '',
      education: json['education'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'] ?? '',
      address: json['address'] ?? '',
      clubName: json['clubName'] ?? '',
      playerStartDate: json['playerStartDate'],
      coachStartDate: json['coachStartDate'] ?? '',
      classLevel: json['classLevel'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dob': dob,
      'fatherName': fatherName,
      'nrc': nrc,
      'education': education,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'clubName': clubName,
      'playerStartDate': playerStartDate,
      'coachStartDate': coachStartDate,
      'classLevel': classLevel,
    };
  }
}
