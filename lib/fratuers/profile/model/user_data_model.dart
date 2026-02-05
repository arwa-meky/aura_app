class UserModel {
  final String? fullName;
  final String? email;
  final String? gender;
  final String? age;
  final String? weight;
  final String? height;
  final String? photoUrl;
  final String? phoneNumber;

  UserModel({
    this.fullName,
    this.email,
    this.gender,
    this.age,
    this.weight,
    this.height,
    this.photoUrl,
    this.phoneNumber,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    var userData = json['data'];

    return UserModel(
      fullName: userData['name'] ?? "User",
      email: userData['email'] ?? "",
      gender: userData['gender'] ?? "Unknown",
      age: userData['age']?.toString() ?? "0",
      weight: userData['weight']?.toString() ?? "0",
      height: userData['height']?.toString() ?? "0",

      photoUrl: userData['photoUrl'],
      phoneNumber: userData['mobilePhone'],
    );
  }
}
