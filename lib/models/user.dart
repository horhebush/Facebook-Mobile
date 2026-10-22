// A user, as returned by /auth/login, by /users, or read back from preferences.
class User {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String gender;
  final String image;
  final String accessToken;
  final String refreshToken;

  User({
    required this.id,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.image,
    this.email = '',
    this.gender = '',
    this.accessToken = '',
    this.refreshToken = '',
  });

  // Builds a user from any of the three sources; missing keys become empty.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'] ?? '',
      gender: json['gender'] ?? '',
      image: json['image'] ?? '',
      // The API calls it accessToken; older responses only had token.
      accessToken: json['accessToken'] ?? json['token'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  // Turns the user back into JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'gender': gender,
      'image': image,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  // First and last name together, for headers and cards.
  String get fullName => '$firstName $lastName'.trim();
}
