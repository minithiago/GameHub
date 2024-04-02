class UserLogData {
  int id;
  String token;
  String type;
  String nickname;
  String email;

  UserLogData({
    required this.id,
    required this.token,
    required this.type,
    required this.nickname,
    required this.email,
  });

  factory UserLogData.fromJson(Map<String, dynamic> json) => UserLogData(
        id: json["id"],
        token: json["token"],
        type: json["type"],
        nickname: json["nickname"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "token": token,
        "type": type,
        "nickname": nickname,
        "email": email,
      };

  getUserId() {
    return id;
  }
}
