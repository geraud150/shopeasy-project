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

  /// Permet de parser un utilisateur depuis une réponse API qui peut être :
  /// { user: {...}, token: ... } ou { id: ..., firstName: ..., ... }
  factory User.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] ?? json;
    return User(
      id: userJson['id'] ?? 0,
      firstName: userJson['firstName'] ?? '',
      lastName: userJson['lastName'] ?? '',
      email: userJson['email'] ?? '',
      token: json['token'] ?? '',
    );
  }
}
