/// Represents a user's profile.
class User {
  final int id; // ID of the user
  String username; 
  ProfilePicture profilePicture;
  int iqPoints; // Ranking points

  User({
    required this.id,
    required this.username,
    required this.profilePicture,
    required this.iqPoints,
  });

  /// Creates a [User] from JSON.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      profilePicture: ProfilePicture.fromJson(json['profile_picture']),
      iqPoints: json['iq_points'],
    );
  }

  /// Converts a [User] to JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profile_picture': profilePicture.toJson(),
      'iq_points': iqPoints,
    };
  }
}

class ProfilePicture {
  final String image;
  final int minIqPoints;

  const ProfilePicture({
    required this.image,
    required this.minIqPoints,
  });

  // Create a ProfilePicture from a JSON map
  factory ProfilePicture.fromJson(Map<String, dynamic> json) {
    return ProfilePicture(
      image: json['image'] as String,
      minIqPoints: json['minIqPoints'] as int,
    );
  }

  // Convert a ProfilePicture to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'image': image,
      'minIqPoints': minIqPoints,
    };
  }
}