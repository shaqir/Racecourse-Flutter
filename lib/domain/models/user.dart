class User {
  final String id;
  final String name;
  final String email;
  final String? role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, role: $role}';
  }
}