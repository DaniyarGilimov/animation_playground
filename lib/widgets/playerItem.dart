import 'package:flutter/material.dart';

class PlayerItem extends StatelessWidget {
  const PlayerItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Text("Player"),
      width: 40,
      height: 40,
    );
  }
}
