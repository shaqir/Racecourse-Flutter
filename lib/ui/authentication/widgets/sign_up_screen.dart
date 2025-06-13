import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/authentication/view_model/sign_in_view_model.dart';
import 'package:racecourse_tracks/ui/authentication/view_model/sign_up_view_model.dart';
import 'package:racecourse_tracks/utils/request_state.dart';
import 'package:racecourse_tracks/ui/core/ui/page_container.dart';
import 'package:racecourse_tracks/ui/authentication/widgets/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, required this.viewModel});
  final SignUpViewModel viewModel;

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();


  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(() {
      if (widget.viewModel.signUpWithEmailAndPasswordRequestState == RequestState.completed
          || widget.viewModel.signUpWithGoogleRequestState == RequestState.completed
      ) {
        // Navigate to the home screen or another screen after successful sign-up
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PageContainer()),
        );
      } else if (widget.viewModel.signUpWithEmailAndPasswordRequestState == RequestState.failed) {
        // Show an error message if sign-up failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.viewModel.signUpWithEmailAndPasswordErrorMessage ?? 'Sign-up failed')),
        );
      } else if (widget.viewModel.signUpWithGoogleRequestState == RequestState.failed) {
        // Show an error message if Google sign-up failed
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(widget.viewModel.signUpWithGoogleErrorMessage ?? 'Google sign-up failed')),
        );
      }
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
              
              if (widget.viewModel.signUpWithEmailAndPasswordErrorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    widget.viewModel.signUpWithEmailAndPasswordErrorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => widget.viewModel.signUpWithEmailAndPassword(
                  emailController.text.trim(),
                  passwordController.text.trim(),
                ),
                child: widget.viewModel.signUpWithEmailAndPasswordRequestState == RequestState.pending
                    ? CircularProgressIndicator()
                    : const Text('Create Account'),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () => widget.viewModel.signUpWithGoogle(),
                icon: const Icon(Icons.g_mobiledata),
                label: widget.viewModel.signUpWithGoogleRequestState == RequestState.pending
                    ? CircularProgressIndicator()
                    : const Text('Sign up with Google'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // Navigate to the Sign-In screen
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => SignInScreen(viewModel: SignInViewModel(context.read()),),
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
