import 'package:animation_playground/classes/vector.dart';
import 'package:animation_playground/classes/card.dart';
import 'package:flutter/material.dart';

class Player {
  final int tablePlace;
  final String avatar;
  final String name;
  List<GlobalKey<CardItemState>> playerCards = [];
  double left;
  double top;
  Player({this.tablePlace, this.avatar, this.name});
  get playerPosition => new Vector(left, top);
  addCard(GlobalKey<CardItemState> newCard) {
    playerCards.add(newCard);
    if (tablePlace != 0) {
      switch (playerCards.length) {
        case 1:
          newCard.currentState.moveTo(Vector(left - 17.5 - 15, top));
          newCard.currentState.setAngle(15);
          break;
        case 2:
          newCard.currentState.moveTo(Vector(left - 17.5, top + 3));
          break;
        case 3:
          newCard.currentState.moveTo(Vector(left - 17.5 + 15, top));
          newCard.currentState.setAngle(-15);
          break;
        default:
      }
      //newCard.currentState.moveTo(playerPosition);
      newCard.currentState.scaleTo(Vector(35, 50));
    } else {
      switch (playerCards.length) {
        case 1:
          newCard.currentState.moveTo(Vector(left - 80, top - 40));
          newCard.currentState.setAngle(-10);
          break;
        case 2:
          newCard.currentState.moveTo(Vector(left, top - 50));
          break;
        case 3:
          newCard.currentState.moveTo(Vector(left + 80, top - 40));
          newCard.currentState.setAngle(10);
          break;
        default:
      }
      //newCard.currentState.moveTo(playerPosition);
      newCard.currentState.setDraggable = true;
      newCard.currentState.scaleTo(Vector(100, 142.8));
    }
  }
}
