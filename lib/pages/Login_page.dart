import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  GoogleSignInAccount? _user;

  Future<void> _handleSignIn() async {
    try {
      final user = await _googleSignIn.signIn();
      setState(() {
        _user = user;
      });

      if (user != null) {
        // You can navigate to the next page or display the user details
        print('User signed in: ${user.displayName}');
      }
    } catch (error) {
      print('Error signing in: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              const Icon(
                Icons.lock_outline,
                size: 100,
                color: Colors.blueGrey,
              ),
              const SizedBox(height: 20),
              const Text(
                "Welcome Back!",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sign in to continue",
                style: TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              const SizedBox(height: 50),

              // Google Sign-In Button
              GestureDetector(
                onTap: _handleSignIn,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google_logo.png', // Add this image to your project
                        height: 24,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        "Sign in with Google",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // User Info (Optional)
              if (_user != null) ...[
                const SizedBox(height: 30),
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(_user!.photoUrl ?? ''),
                ),
                const SizedBox(height: 10),
                Text(
                  _user!.displayName ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _user!.email,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}