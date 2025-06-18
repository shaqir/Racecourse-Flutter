import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/ui/authentication/view_model/sign_in_view_model.dart';
import 'package:racecourse_tracks/ui/profile/view_model/all_users_view_model.dart';
import 'package:racecourse_tracks/ui/profile/view_model/profile_view_model.dart';
import 'package:racecourse_tracks/ui/profile/view_model/settings_view_model.dart';
import 'package:racecourse_tracks/ui/profile/widgets/all_users_screen.dart';
import 'package:racecourse_tracks/ui/profile/widgets/settings_screen.dart';
import 'package:racecourse_tracks/ui/authentication/widgets/sign_in_screen.dart';
import 'package:racecourse_tracks/utils/request_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.viewModel});
  final ProfileViewModel viewModel;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(() {
      if(widget.viewModel.signOutRequestState == RequestState.completed) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(viewModel: SignInViewModel(context.read())),
          ),
        );
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0.5,
      ),
      body: ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            if (widget.viewModel.loadRequestState == RequestState.pending) {
              return const Center(child: CircularProgressIndicator());
            }
            if (widget.viewModel.loadRequestState == RequestState.failed) {
              return Center(
                child: Text(
                  widget.viewModel.errorMessage ?? 'An error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (widget.viewModel.currentUser == null) {
              return const Center(
                child: Text('No user data available'),
              );
            }
            final user = widget.viewModel.currentUser!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    child: Icon(Icons.person, size: 50),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user.name,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.black12),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: const Text('App Settings'),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(
                          viewModel: SettingsViewModel(context.read()),
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.help),
                    title: const Text('Contact Us'),
                    onTap: () {
                      launchUrl(Uri.parse(
                          'mailto:Racecourse.Tracks@gmail.com?subject=Support Request&body=Hello, I need help with...'));
                    },
                  ),
                  if (user.role == 'admin')
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings),
                      title: const Text('Admin Dashboard'),
                      onTap: () {
                        // Navigate to admin dashboard
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AllUsersScreen(viewModel: AllUsersViewModel(context.read()),)));
                      },
                    ),
                  // Restore purchase button
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: widget.viewModel.restorePurchases,
                          child: widget.viewModel.restorePurchasesRequestState ==
                                  RequestState.pending
                              ? CircularProgressIndicator()
                              : const Text('Restore Purchases')),
                    ],
                  ),
                  const Divider(color: Colors.black12),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: widget.viewModel.signOutRequestState ==
                            RequestState.pending
                        ? const CircularProgressIndicator()
                        : const Text('Logout'),
                    onTap: () => widget.viewModel.signOut(),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
