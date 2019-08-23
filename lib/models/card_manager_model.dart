//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:animation_playground/classes/card.dart';
import 'package:animation_playground/classes/player.dart';

/// APP MODEL
class CardManagerModel extends Model {
  double _screenWidth;
  double _screenHeight;
  List<GlobalKey<CardItemState>> allCards;
  List<Player> players;
  bool distributed = false;

  Future init(
      {List<GlobalKey<CardItemState>> allC,
      List<Player> allPlayers,
      double screenWidth,
      double screenHeight}) async {
    allCards = allC;
    players = allPlayers;

    _screenHeight = screenHeight;
    _screenWidth = screenWidth;

    //Setting player places to player class, however it should be in PlayerItem
    for (var player in players) {
      switch (player.tablePlace) {
        case 0: //Root player table place
          player.left = (_screenWidth / 2) - 50;
          player.top = _screenHeight - 150;
          break;
        case 1:
          player.left = 0;
          player.top = _screenHeight / 2;
          break;
        case 2:
          player.left = 50;
          player.top = 30;
          break;
        case 3: //Fron player table place
          player.left = (_screenWidth / 2);
          player.top = 15;
          break;
        case 4:
          player.left = _screenWidth - 50;
          player.top = 30;
          break;
        case 5:
          player.left = _screenWidth;
          player.top = _screenHeight / 2;
          break;
      }
    }
    //LocalShuffling card
    allC.shuffle();

    notifyListeners();
  }

  Future distribute() async {
    for (var i = 0; i < allCards.length; i++) {
      players[i % players.length].addCard(allCards[i]);
      await Future.delayed(Duration(milliseconds: 300));
    }
    notifyListeners();
  }
}
