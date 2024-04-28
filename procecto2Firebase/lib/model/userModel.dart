class UserModel {
  int? id;
  String nickname;
  String email;
  String password;
  String profilePicUrl;
  //List<String> friends;

  UserModel({
    this.id,
    required this.nickname,
    required this.email,
    required this.password,
    required this.profilePicUrl,
    //required this.friends,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        nickname: json["nickname"],
        email: json["email"],
        password: json["password"],
        profilePicUrl: json["profilePicUrl"],
      );

  toJson() {
    return {
//"id": id,
      "nickname": nickname,
      "email": email,
      "password": password,
      "avatar": profilePicUrl,
    };
  }
}
