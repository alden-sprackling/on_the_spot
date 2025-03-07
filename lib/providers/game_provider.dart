import 'package:flutter/material.dart';

class GameProvider with ChangeNotifier {
  final List<Map<String, String>> _players = [];

  List<Map<String, String>> get players => _players;

  void addPlayer(Map<String, String> player) {
    _players.add(player);
    notifyListeners();
  }

  void removePlayer(String playerName) {
    _players.removeWhere((player) => player["name"] == playerName);
    notifyListeners();
  }
}