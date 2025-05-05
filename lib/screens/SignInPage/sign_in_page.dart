import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/request_state.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/homepage_container.dart';
import 'package:racecourse_tracks/screens/SignUpPage/sign_up_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;
  String? errorMessageGoogle;
  RequestState signInRequestState = RequestState.initial;
  RequestState signInWithGoogleRequestState = RequestState.initial;
  late final _auth = context.read<FirebaseAuth>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            if (signInRequestState == RequestState.error)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  errorMessage ?? 'An error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Handle sign-in logic

                setState(() {
                  signInRequestState = RequestState.loading;
                });
                final String emailAddress = emailController.text.trim();
                final String password = passwordController.text.trim();
                try {
                  final credential = await _auth
                      .signInWithEmailAndPassword(
                          email: emailAddress, password: password);
                  if (credential.user != null) {
                    if(context.mounted) {
                      setState(() {
                      signInRequestState = RequestState.loaded;
                      errorMessage = null;
                    });
                    // Navigate to home page
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomePageContainer(),
                        ));
                    }
                  }
                } on FirebaseAuthException catch (e) {
                  setState(() {
                    signInRequestState = RequestState.error;
                    errorMessage = e.message;
                  });
                  if (e.code == 'user-not-found') {
                    if (kDebugMode) {
                      print('No user found for that email.');
                    }
                  } else if (e.code == 'wrong-password') {
                    if (kDebugMode) {
                      print('Wrong password provided for that user.');
                    }
                  }
                }
              },
              child: signInRequestState == RequestState.loading
                  ? CircularProgressIndicator()
                  : const Text('Sign In'),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                // Handle Google sign-in logic
              },
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                // Navigate to sign-up screen
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUpPage(),
                    ));
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
