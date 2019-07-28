import 'package:animation_playground/models/card_manager_model.dart';
import 'package:flutter/material.dart';
import 'package:animation_playground/classes/card.dart';
import 'package:animation_playground/models/app_model.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:animation_playground/widgets/cardManager.dart';
import 'package:animation_playground/classes/player.dart';

final AppModel model = AppModel();
double screenWidth;
double screenHeight;

void main() async {
  await model.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo Card Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Card Game Home Page'),
    );
  }
}

GlobalKey<CardItemState> cardEngineKey1 = GlobalKey();
GlobalKey<CardItemState> cardEngineKey2 = GlobalKey();
GlobalKey<CardItemState> cardEngineKey3 = GlobalKey();
GlobalKey<CardItemState> cardEngineKey4 = GlobalKey();
GlobalKey<CardItemState> cardEngineKey5 = GlobalKey();
GlobalKey<CardItemState> cardEngineKey6 = GlobalKey();
GlobalKey<CardItemState> cardEngineKey7 = GlobalKey();
GlobalKey<CardItemState> cardEngineKey8 = GlobalKey();
GlobalKey<CardItemState> cardEngineKey9 = GlobalKey();

List<GlobalKey<CardItemState>> allC = [
  cardEngineKey1,
  cardEngineKey2,
  cardEngineKey3,
  cardEngineKey4,
  cardEngineKey5,
  cardEngineKey6
];

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  @override
  void dispose() {
    super.dispose();
  }

  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;
    return ScopedModel<AppModel>(
        model: model,
        child: ScopedModelDescendant<AppModel>(
            builder: (context, child, model) => Scaffold(
                appBar: AppBar(
                    title: Text(widget.title),
                    leading: IconButton(
                      icon: Icon(Icons.access_alarm),
                      onPressed: () {},
                    )),
                body: ScopedModel<CardManagerModel>(
                    model: CardManagerModel()
                      ..init(
                          allC: allC,
                          screenHeight: screenHeight,
                          screenWidth: screenWidth),
                    child: CardManager(
                      allCardKey: allC,
                      screenHight: screenHeight,
                      screenWidth: screenWidth,
                    )))));
  }
}
