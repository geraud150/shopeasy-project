class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['user']['id'] ?? json['id'],
      firstName: json['user']['firstName'] ?? json['firstName'],
      lastName: json['user']['lastName'] ?? json['lastName'],
      email: json['user']['email'] ?? json['email'],
      token: json['token'],
    );
  }
}
