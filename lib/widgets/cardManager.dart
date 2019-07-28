import 'package:flutter/material.dart';
import 'package:animation_playground/classes/card.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:animation_playground/models/card_manager_model.dart';

class CardManager extends StatefulWidget {
  CardManager({Key key, this.allCardKey, this.screenWidth, this.screenHight})
      : super(key: key);
  final double screenWidth;
  final double screenHight;
  final List<GlobalKey<CardItemState>> allCardKey;
  _CardManagerState createState() => _CardManagerState();
}

class _CardManagerState extends State<CardManager> {
  List<CardItem> allCards = [];
  @override
  void initState() {
    for (var i = 0; i < widget.allCardKey.length; i++) {
      print(i);
      allCards.add(CardItem(
        key: widget.allCardKey[i],
        color: Colors.black12,
        value: i + 1,
        screenWidth: widget.screenWidth,
        screenHeight: widget.screenHight,
      ));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CardManagerModel>(
      builder: (context, child, model) => Stack(
        children: <Widget>[
          (!model.distributed)
              ? Align(
                  alignment: Alignment(0, 0),
                  child: RaisedButton(
                    child: Text("Distribute"),
                    onPressed: () {
                      setState(() {
                        model.distributed = true;
                      });
                      model.distribute();
                    },
                  ),
                )
              : Text("distributed"),
          Align(
            alignment: Alignment(0, 0.25),
            child: SizedBox(
              width: 75,
              height: 125,
              child: Container(
                decoration: BoxDecoration(color: Colors.black12),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: Text(
                    "there will be placed user card",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
          Stack(
            children: allCards,
          )
        ],
      ),
    );
  }
}
