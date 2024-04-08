// User Information
class UserModel {
  String? userID;
  String? userMail;
  String? userName;
  String? userProfileImage;
  String? userCoverImage;

  String? userBio;
  String? userCountry;
  String? userDateOfBirth;

  UserModel(
      {this.userID,
      this.userMail,
      this.userName,
      this.userProfileImage,
      this.userCoverImage,
      this.userBio,
      this.userCountry,
      this.userDateOfBirth});

  // Receiving Data From Server
  factory UserModel.fromMap(map) {
    return UserModel(
        userID: map['uid'],
        userMail: map['email'],
        userName: map['name'],
        userProfileImage: map['profile_image'],
        userCoverImage: map['cover_image'],
        userBio: map['bio'],
        userCountry: map['country'],
        userDateOfBirth: map['date_of_birth']);
  }

  // Sending Data to Our Server
  Map<String, dynamic> toMap() {
    return {
      'uid': userID,
      'email': userMail,
      'name': userName,
      'profile_image': userProfileImage,
      'cover_image': userCoverImage,
      'bio': userBio,
      'country': userCountry,
      'date_of_birth': userDateOfBirth,
    };
  }
}
