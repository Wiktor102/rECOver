class User {
  final int id;
  final String email;
  final String nickname;
  final String accessToken;
  List<String>? tags;

  User({
    required this.id,
    required this.email,
    required this.nickname,
    required this.accessToken,
    this.tags,
  });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//     );
//   }
}
