class AppUser {
  final String uid;
  final String email;
  final String name;
  final String role; // 'user' or 'admin'
  final String avatarUrl;
  final String phone;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.phone,
  });

  factory AppUser.fromMap(String uid, Map<String, dynamic> map) => AppUser(
    uid: uid,
    email: map['email'] ?? '',
    name: map['name'] ?? '',
    role: map['role'] ?? 'User',
    avatarUrl: map['avatarUrl'] ?? '',
    phone: map['phone'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'email': email,
    'name': name,
    'role': role,
    'avatarUrl': avatarUrl,
    'phone': phone,
  };
}
