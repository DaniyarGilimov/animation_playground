import 'package:animation_playground/classes/cardEngine.dart';
import 'package:animation_playground/classes/vector.dart';
import 'package:animation_playground/main.dart';
import 'package:flutter/material.dart';

class CardItem extends StatefulWidget {
  CardItem(
      {Key key, this.color, this.value, this.screenWidth, this.screenHeight})
      : super(key: key);

  final int value;
  final Color color;
  final double screenWidth;
  final double screenHeight;

  CardItemState createState() => CardItemState();
}

class CardItemState extends State<CardItem> with TickerProviderStateMixin {
  AnimationController controller;
  Tween<double> animationTween;
  Animation<double> animation;

  bool isDragging = false; //shows if card is dragging by finger
  bool isAnimating = false; //shows if card is thowing(sliding)
  bool isAnimatingBeginning = false; //shows if card is distributing
  bool isScalling = false; //shows if card changing it's scale
  bool isDraggable = false;

  // Animation used to center the card, after finger touches card
  AnimationController controllerCentering;
  Tween<double> animationCenteringTween;
  Animation<double> animationCentering;

  AnimationController controllerDistribution;
  Animation<double> animationDistribution;

  AnimationController controllerScalling;
  Tween<double> animationScallingTween;
  Animation<double> animationScalling;

  //varibles used to center the card, after finger touches card
  double dx = 0;
  double dy = 0;
  double dxx = 0;
  double dyy = 0;

  double x; //card position in X axis
  double y; //card position in Y axis

  // Current position of finger while dragging
  double currentPanPositionX = 0;
  double currentPanPositionY = 0;

  // Position of finger when it starts dragging
  double firstPanPositionX = 0;
  double firstPanPositionY = 0;

  // Position of card and final position
  Vector finalPosition;
  Vector initialPosition;
  Vector initialScale = Vector(75, 125);
  Vector finalScale = Vector(75, 125);

  double endPointX = 0;
  Vector startPosition = new Vector(0, 0);

  @override
  void initState() {
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animationTween = Tween(begin: x, end: endPointX);
    animation = animationTween
        .chain(new CurveTween(
          curve: Curves.easeOutQuad,
        ))
        .animate(controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                print("Is animation" + isAnimating.toString());
                isAnimating = false;
                x = animation.value;
                print(isAnimatingBeginning.toString() + y.toString());
              });
            }
          });

    controllerCentering = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animationCentering = Tween<double>(begin: 0, end: 1)
        .chain(new CurveTween(
          curve: Curves.easeOutQuad,
        ))
        .animate(controllerCentering)
          ..addListener(() {
            setState(() {
              dx = dxx + (initialScale.x / 2 - dxx) * animationCentering.value;

              dy = dyy + (initialScale.y + 25 - dyy) * animationCentering.value;
              x = currentPanPositionX - dx;
              y = currentPanPositionY - dy;
            });
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                dx = initialScale.x / 2;
                dy = initialScale.y + 25;
              });
            }
          });

    controllerDistribution = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animationDistribution = Tween<double>(begin: 0, end: 1)
        .chain(new CurveTween(
          curve: Curves.easeOutQuad,
        ))
        .animate(controllerDistribution)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                x = finalPosition.x;
                y = finalPosition.y;
                initialPosition = finalPosition;
                isAnimatingBeginning = false;
              });
            }
          });

    controllerScalling = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animationScallingTween = Tween<double>(begin: 0, end: 1);
    animationScalling = animationScallingTween
        .chain(new CurveTween(
          curve: Curves.easeOutQuad,
        ))
        .animate(controllerDistribution)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                initialScale = finalScale;
              });
            }
          });

    isDragging = false;
    x = 0;
    y = (screenHeight * 0.65) - initialScale.x;
    initialPosition = Vector(x, y);
    initialScale = Vector(75, 125);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // dragging card
  void _onTapUpdate(DragUpdateDetails details) {
    if (isAnimating || !isDraggable) return;
    setState(() {
      // setting finger position to card position, dx and dy describes centering the card after first touch
      x = details.globalPosition.dx - dx;
      y = details.globalPosition.dy - dy;

      //setting current drag position
      currentPanPositionX = details.globalPosition.dx;
      currentPanPositionY = details.globalPosition.dy;

      if (!isDragging) isDragging = true;
      if (isAnimating) isAnimating = false;
    });
  }

  //when finger touches the card
  void _onPanStart(DragStartDetails startDetails) {
    if (!isDraggable) return;
    setState(() {
      //setting finger first touch details
      firstPanPositionX = startDetails.globalPosition.dx;
      firstPanPositionY = startDetails.globalPosition.dy;

      currentPanPositionX = firstPanPositionX;
      currentPanPositionY = firstPanPositionY;

      //centering the card
      dxx = (x - firstPanPositionX).abs();
      dyy = (y - firstPanPositionY).abs();
    });
    controllerCentering.reset();
    controllerCentering.forward();
  }

  //when dragging is ended, and card slides to some position, in our case to endPointX
  void _onPanEnd(DragEndDetails endDetails) {
    // checking if card position on left side or on right side
    if (!isDraggable) return;
    controller.reset();
    setState(() {
      isDragging = false;
      isAnimating = true;
      if (x < MediaQuery.of(context).size.width / 2) {
        endPointX = 0;
      } else {
        endPointX = MediaQuery.of(context).size.width - 70;
      }
      animationTween.begin = x;
      animationTween.end = endPointX;
    });

    controller.forward();
  }

  //Change positino of the card
  void moveTo(Vector newPosition) {
    controllerDistribution.reset();
    setState(() {
      isAnimatingBeginning = true;
      finalPosition = newPosition;
    });
    controllerDistribution.forward();
  }

  // Change size of the card
  void scaleTo(Vector newScale) {
    controllerScalling.reset();
    setState(() {
      isScalling = true;
      finalScale = newScale;
    });
    controllerScalling.forward();
  }

  // Change draggableness of the card
  set setDraggable(bool newValue) {
    setState(() {
      isDraggable = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: (isDragging)
          ? x
          : (isAnimating)
              ? animation.value
              : (isAnimatingBeginning)
                  ? initialPosition.x +
                      (finalPosition.x - initialPosition.x) *
                          animationDistribution.value
                  : x,
      top: (isDragging)
          ? y
          : (isAnimatingBeginning)
              ? initialPosition.y +
                  (finalPosition.y - initialPosition.y) *
                      animationDistribution.value
              : y,
      child: SizedBox(
          width: (isScalling)
              ? initialScale.x +
                  (finalScale.x - initialScale.x) * animationScalling.value
              : initialScale.x,
          height: (isScalling)
              ? initialScale.y +
                  (finalScale.y - initialScale.y) * animationScalling.value
              : initialScale.y,
          child: GestureDetector(
            onPanUpdate: (DragUpdateDetails details) {
              if (!isAnimating) {
                _onTapUpdate(details);
              }
            },
            onPanEnd: (DragEndDetails endDetails) => _onPanEnd(endDetails),
            onPanStart: (DragStartDetails startDetails) {
              if (!isAnimating) {
                _onPanStart(startDetails);
              }
            },
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: ExactAssetImage('assets/images/cross-ace.png'),
                      fit: BoxFit.contain),
                  color: Colors.black12),
              width: double.infinity,
              height: double.infinity,
            ),
          )),
    );
  }
}
