import 'package:flutter/material.dart';
import 'package:shopeasy/features/auth/data/services/auth_service.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () async {
                  await _authService.forgotPassword(
                    _emailController.text,
                  );
                  Navigator.pop(context);
                },
                child: Text('Reset Password'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
