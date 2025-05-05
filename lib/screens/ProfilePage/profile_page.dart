import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:racecourse_tracks/screens/SettingsPage.dart/settings_page.dart';
import 'package:racecourse_tracks/screens/SignInPage/sign_in_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    const String userName = 'User Name';
    const String userEmail = 'user@example.com';
    final auth = context.read<FirebaseAuth>();

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            const Text(
              userName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const Text(
              userEmail,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Divider(color: Colors.black12),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('App Settings'),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (context) => const SettingsPage(),
              )),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title:
                  const Text('Logout'),
              onTap: () {
                // Add logout logic
                auth.signOut();
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const SignInPage(),
                ));
              },
            ),
          ],
        ),
      ),
    );
  }
}
