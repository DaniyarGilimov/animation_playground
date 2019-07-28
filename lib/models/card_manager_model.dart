//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:animation_playground/classes/card.dart';
import 'package:animation_playground/classes/vector.dart';

/// APP MODEL
class CardManagerModel extends Model {
  double _screenWidth;
  double _screenHeight;
  List<GlobalKey<CardItemState>> allCards;
  bool distributed = false;

  Future init(
      {List<GlobalKey<CardItemState>> allC,
      double screenWidth,
      double screenHeight}) async {
    allCards = allC;
    _screenHeight = screenHeight;
    _screenWidth = screenWidth;
    //LocalShuffling card
    allC.shuffle();

    notifyListeners();
  }

  Future distribute() async {
    for (var i = 0; i < allCards.length; i++) {
      if (i % 2 == 0) {
        allCards[i]
            .currentState
            .moveTo(Vector((_screenWidth / 2) - 37.5, _screenHeight - 125));
        allCards[i].currentState.scaleTo(Vector(100, 150));
        allCards[i].currentState.setDraggable = true;
      } else {
        allCards[i].currentState.moveTo(Vector((_screenWidth / 2) - 37.5, 15));
        allCards[i].currentState.scaleTo(Vector(50, 100));
      }
      await Future.delayed(Duration(milliseconds: 300));
    }
    notifyListeners();
  }
}
