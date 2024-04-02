class UserModel {
  int id;
  String nickname;
  String email;
  String password;
  String profilePicUrl;
  //List<String> friends;

  UserModel({
    required this.id,
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

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": nickname,
        "email": email,
        "password": password,
        "profilePicUrl": profilePicUrl,
      };
}
