import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/profile/view_model/profile_view_model.dart';
import 'package:racecourse_tracks/ui/profile/widgets/all_users_screen.dart';
import 'package:racecourse_tracks/ui/profile/widgets/settings_screen.dart';
import 'package:racecourse_tracks/ui/authentication/widgets/sign_in_screen.dart';
import 'package:racecourse_tracks/utils/request_state.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.viewModel});
  final ProfileViewModel viewModel;

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
          listenable: viewModel,
          builder: (context, _) {
            if (viewModel.loadRequestState == RequestState.pending) {
              return const Center(child: CircularProgressIndicator());
            }
            if (viewModel.loadRequestState == RequestState.failed) {
              return Center(
                child: Text(
                  viewModel.errorMessage ?? 'An error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            final user = viewModel.currentUser!;
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
                          builder: (context) => const SettingsScreen(),
                        )),
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
                                builder: (context) => const AllUsersScreen()));
                      },
                    ),
                  // Restore purchase button
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: viewModel.restorePurchases,
                          child: viewModel.restorePurchasesRequestState ==
                                  RequestState.pending
                              ? CircularProgressIndicator()
                              : const Text('Restore Purchases')),
                    ],
                  ),
                  const Divider(color: Colors.black12),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      // Add logout logic
                      viewModel.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInScreen(),
                          ));
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
