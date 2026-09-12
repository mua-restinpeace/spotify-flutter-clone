
import 'package:spotify/domain/entities/auth/users.dart';

class UserModel {
  String? fullName;
  String? email;
  String? imageURL;
  int? followers;
  int? following;

  UserModel(
      {required this.fullName,
      required this.email,
      this.imageURL,
      this.followers,
      this.following});

  UserModel.fromJson(Map<String, dynamic> data) {
    fullName = data['name'];
    email = data['email'];
    followers = data['followers'];
    following = data['following'];
  }
}

extension UserModelX on UserModel {
  UserEntity toEntity() {
    return UserEntity(
        email: email!,
        fullName: fullName!,
        imageURL: imageURL!,
        followers: followers!,
        following: following!);
  }
}
