// lib/src/models/user.dart

class User {
  final String id;
  final String phone;
  final String? name;
  final String? profilePic;
  final int iq;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.phone,
    this.name,
    this.profilePic,
    required this.iq,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as String,
        phone: json['phone'] as String,
        name: json['name'] as String?,
        profilePic: json['profilepic'] as String?,      // match lowercase
        iq: json['iq'] as int,
        createdAt: DateTime.parse(json['createdat'] as String),  // lowercase
        updatedAt: DateTime.parse(json['updatedat'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'phone': phone,
        'name': name,
        'profilepic': profilePic,
        'iq': iq,
        'createdat': createdAt.toIso8601String(),
        'updatedat': updatedAt.toIso8601String(),
      };
}
