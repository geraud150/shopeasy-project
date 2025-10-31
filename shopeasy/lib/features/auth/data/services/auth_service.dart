class AuthService {
  Future<void> login(String email, String password) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));
    print('User logged in with email: $email');
  }

  Future<void> signUp(String email, String password) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));
    print('User signed up with email: $email');
  }

  Future<void> forgotPassword(String email) async {
    // Simulate a network call
    await Future.delayed(Duration(seconds: 1));
    print('Password reset email sent to: $email');
  }
}
