import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/authentication/view_model/sign_in_view_model.dart';
import 'package:racecourse_tracks/ui/authentication/view_model/sign_up_view_model.dart';
import 'package:racecourse_tracks/ui/core/ui/page_container.dart';
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
  void initState() {
    super.initState();
    widget.viewModel.addListener(() {
      if (widget.viewModel.signInWithEmailAndPasswordRequestState == RequestState.completed ||
          widget.viewModel.signInWithGoogleRequestState == RequestState.completed ||
          widget.viewModel.signInWithAppleRequestState == RequestState.completed) {
        // Navigate to the home screen or another screen after successful sign-in
        Navigator.push(context, MaterialPageRoute(builder: (context) => PageContainer(),));
      } else if (widget.viewModel.signInWithEmailAndPasswordRequestState == RequestState.failed ||
                 widget.viewModel.signInWithGoogleRequestState == RequestState.failed ||
                 widget.viewModel.signInWithAppleRequestState == RequestState.failed) {
        // Show an error message if sign-in failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.viewModel.signInWithEmailAndPasswordErrorMessage ?? 'Sign-in failed')),
        );
      }
    });
  }

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
                // Or Sign in with Google button
                Text('Or sign in with:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () => widget.viewModel.signInWithGoogle(),
                  icon: const Icon(Icons.login),
                  label: widget.viewModel.signInWithGoogleRequestState == RequestState.pending
                      ? CircularProgressIndicator()
                      : const Text('Sign in with Google'),
                ),
                const SizedBox(height: 16),
                // Sign in with Apple button
                ElevatedButton.icon(
                  onPressed: () => widget.viewModel.signInWithApple(),
                  icon: const Icon(Icons.apple),
                  label: widget.viewModel.signInWithAppleRequestState == RequestState.pending
                      ? CircularProgressIndicator()
                      : const Text('Sign in with Apple'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Navigate to sign-up screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpScreen(viewModel: SignUpViewModel(context.read()),),
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
