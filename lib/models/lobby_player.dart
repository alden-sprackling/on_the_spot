// lib/src/models/lobby_player.dart

class LobbyPlayer {
  final String id;
  final String? name;
  final String? profilePicture;
  final int iq;
  final String phoneNumber;

  LobbyPlayer({
    required this.id,
    this.name,
    this.profilePicture,
    required this.iq,
    required this.phoneNumber,
  });

  factory LobbyPlayer.fromJson(Map<String, dynamic> json) => LobbyPlayer(
        id: json['id'] as String,
        name: json['name'] as String?,
        profilePicture: json['profilePicture'] as String?,
        iq: json['iq'] as int,
        phoneNumber: json['phoneNumber'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'profilePicture': profilePicture,
        'iq': iq,
        'phoneNumber': phoneNumber,
      };
}
