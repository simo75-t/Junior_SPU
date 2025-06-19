class Usermodel {}
// models/user.dart

class User {
  final String username;
  final String email;

  User({required this.username, required this.email});

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
    };
  }
}
