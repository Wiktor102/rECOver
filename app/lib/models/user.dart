class User {
  final int id;
  final String email;
  final String nickname;
  final String accessToken;

  User(this.id, this.email, this.nickname, this.accessToken);

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       name: json['name'],
//       email: json['email'],
//     );
//   }
}
