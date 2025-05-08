import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/core/common/request_state.dart';
import 'package:racecourse_tracks/screens/DashboardHomepage/homepage_container.dart';
import 'package:racecourse_tracks/screens/SignInPage/sign_in_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  RequestState createAccountRequestState = RequestState.initial;
  RequestState signUpWithGoogleRequestState = RequestState.initial;
  String? errorMessage;
  String? errorMessageGoogle;
  late final _auth = context.read<FirebaseAuth>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Full Name
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
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
              const SizedBox(height: 16),
              TextField(
                controller: confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirm Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  // Handle account creation logic
                  if (passwordController.text.trim() !=
                      confirmPasswordController.text.trim()) {
                    setState(() {
                      errorMessage = 'Passwords do not match';
                    });
                    return;
                  }
                  setState(() {
                    createAccountRequestState = RequestState.loading;
                  });
                  final String emailAddress = emailController.text.trim();
                  final String password = passwordController.text.trim();
                  try {
                    final credential = await _auth
                        .createUserWithEmailAndPassword(
                      email: emailAddress,
                      password: password,
                    );
                    if (credential.user != null) {
                      // Account created successfully
                      await _auth.currentUser?.updateProfile(
                        displayName: nameController.text.trim(),
                      );
                      if (context.mounted) {
                        setState(() {
                          createAccountRequestState = RequestState.loaded;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePageContainer()));
                      }
                      
                    } else {
                      // Handle account creation failure
                      setState(() {
                        createAccountRequestState = RequestState.error;
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      createAccountRequestState = RequestState.error;
                      errorMessage = e.message;
                    });
                    if (e.code == 'weak-password') {
                      if (kDebugMode) {
                        print('The password provided is too weak.');
                      }
                    } else if (e.code == 'email-already-in-use') {
                      if (kDebugMode) {
                        print('The account already exists for that email.');
                      }
                    }
                  } catch (e) {
                    if (kDebugMode) {
                      print(e);
                    }
                  }
                },
                child: createAccountRequestState == RequestState.loading
                    ? CircularProgressIndicator()
                    : const Text('Create Account'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  // Handle Google sign-up logic
                },
                icon: const Icon(Icons.g_mobiledata),
                label: signUpWithGoogleRequestState == RequestState.loading
                    ? CircularProgressIndicator()
                    : const Text('Sign up with Google'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navigate to the Sign-In screen
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const SignInPage(),
                  ));
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
