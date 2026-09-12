
class UserEntity {
  String? fullName;
  String? email;
  String? imageURL;
  int? followers;
  int? following;

  UserEntity(
      {required this.fullName,
      required this.email,
      this.imageURL,
      this.followers,
      this.following});
}
