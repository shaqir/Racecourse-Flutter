import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/authentication/view_model/sign_in_view_model.dart';
import 'package:racecourse_tracks/utils/request_state.dart';
import 'package:racecourse_tracks/ui/authentication/widgets/sign_up_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, required this.viewModel});
  final SignInViewModel viewModel;

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return Padding(
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
                if (widget.viewModel.signInWithEmailAndPasswordRequestState == RequestState.failed)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      widget.viewModel.signInWithEmailAndPasswordErrorMessage ?? 'An error occurred',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => widget.viewModel.signInWithEmailAndPassword(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  ),
                  child: widget.viewModel.signInWithEmailAndPasswordRequestState == RequestState.pending
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
                          builder: (context) => const SignUpScreen(),
                        ));
                  },
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}
