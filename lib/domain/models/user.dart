class User {
  final String id;
  final String name;
  final String email;
  final String? role;
  final String? subscription;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.subscription,
  });

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, role: $role}';
  }

  factory User.fromMap(Map<String, dynamic> data, String id) {
    final subscription = (data['subscriptions'] as Map<String, dynamic>?)?.values.firstOrNull as Map<String, dynamic>?;
    final periodType = subscription?['period_type'] as String?;
    return User(
      id: id,
      name: data['displayName'] ?? '',
      email: data['email'] ?? '',
      role: data['role'],
      subscription: switch (periodType) {
        'trial' => 'Trial',
        'normal' => 'Pro',
        _ => 'Free'
      }
    );
  }
}