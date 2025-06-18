import 'package:flutter/material.dart';
import 'package:racecourse_tracks/ui/profile/view_model/all_users_view_model.dart';

class AllUsersScreen extends StatelessWidget {
  const AllUsersScreen({super.key, required this.viewModel});
  final AllUsersViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Users')),
      body: StreamBuilder(
        stream: viewModel.getAllUsers(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                title: Text(user.name),
                subtitle: Text(user.email),
                trailing: Text(user.role ?? 'user'),
              );
            },
          );
        },
      ),
    );
  }
}