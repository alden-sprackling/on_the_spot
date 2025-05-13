// lib/src/models/profile_picture.dart

/// Represents a user's avatar eligible based on IQ tier.
class ProfilePicture {
  final String id;
  final String url;
  final int minIq;

  ProfilePicture({
    required this.id,
    required this.url,
    required this.minIq,
  });

  factory ProfilePicture.fromJson(Map<String, dynamic> json) => ProfilePicture(
        id: json['id'] as String,
        url: json['url'] as String,
        minIq: json['minIq'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'url': url,
        'minIq': minIq,
      };
}
