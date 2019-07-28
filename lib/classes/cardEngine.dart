import 'package:flutter/material.dart';
import 'package:animation_playground/classes/card.dart';

class CardEngine extends StatefulWidget {
  CardEngine({Key key, this.cards}) : super(key: key);
  final List<Widget> cards;
  _CardEngineState createState() => _CardEngineState();
}

class _CardEngineState extends State<CardEngine> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: widget.cards,
    );
  }
}

class CardEngines {
  final List<Card> cards;
  CardEngines({this.cards});
}
