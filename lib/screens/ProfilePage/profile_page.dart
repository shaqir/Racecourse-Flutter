import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/screens/AllUsersPage/all_users_page.dart';
import 'package:racecourse_tracks/screens/SettingsPage.dart/settings_page.dart';
import 'package:racecourse_tracks/screens/SignInPage/sign_in_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final _auth = context.read<FirebaseAuth>();
  late final _firestore = context.read<FirebaseFirestore>();
  late final _userFuture = _auth.currentUser?.uid != null
      ? _firestore.collection('users').doc(_auth.currentUser!.uid).get()
      : Future.value(null);

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
      body: FutureBuilder(
          future: _userFuture,
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (asyncSnapshot.hasError) {
              return Center(
                child: Text('Error: ${asyncSnapshot.error}'),
              );
            } else if (!asyncSnapshot.hasData || asyncSnapshot.data == null) {
              return const Center(
                child: Text('No user data found. Please sign in.'),
              );
            }
            final userData = asyncSnapshot.data!.data() as Map<String, dynamic>;
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
                    userData['displayName'] ?? 'No Name',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    userData['email'] ?? 'No Email',
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
                          builder: (context) => const SettingsPage(),
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
                  if (userData['role'] == 'admin')
                    ListTile(
                      leading: const Icon(Icons.admin_panel_settings),
                      title: const Text('Admin Dashboard'),
                      onTap: () {
                        // Navigate to admin dashboard
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const AllUsersPage()));
                      },
                    ),
                  ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      // Add logout logic
                      _auth.signOut();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
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
