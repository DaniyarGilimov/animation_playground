import 'package:animation_playground/classes/cardEngine.dart';
import 'package:animation_playground/classes/vector.dart';
import 'package:flutter/material.dart';

class CardItemAligned extends StatefulWidget {
  CardItemAligned({Key key, this.color, this.value}) : super(key: key);

  final int value;
  final Color color;

  CardItemAlignedState createState() => CardItemAlignedState();
}

class CardItemAlignedState extends State<CardItemAligned>
    with TickerProviderStateMixin {
  AnimationController controller;
  Tween<double> animationTween;
  Animation<double> animation;

  bool isDragging = false; //shows if card is dragging by finger
  bool isAnimating = false; //shows if card is thowing(sliding)
  bool isAnimatingBeginning = false;

  double x = 0; //card position in X axis
  double y = 0; //card position in Y axis

  // Animation used to center the card, after finger touches card
  AnimationController controllerCentering;
  Tween<double> animationCenteringTween;
  Animation<double> animationCentering;

  AnimationController controllerDistribution;
  Animation<double> animationDistribution;

  //varibles used to center the card, after finger touches card
  double dx = 0;
  double dy = 0;
  double dxx = 0;
  double dyy = 0;

  // Current position of finger while dragging
  double currentPanPositionX = 0;
  double currentPanPositionY = 0;

  // Position of finger when it starts dragging
  double firstPanPositionX = 0;
  double firstPanPositionY = 0;

  Vector finalPosition;
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
              dx = dxx + (37.5 - dxx) * animationCentering.value;

              dy = dyy + (175 - dyy) * animationCentering.value;

              x = currentPanPositionX - dx;
              y = currentPanPositionY - dy;
            });
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                dx = 37.5;
                dy = 175;
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
            print(animationDistribution.value);
            print(isAnimatingBeginning);
            setState(() {});
          })
          ..addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                x = finalPosition.x;
                y = finalPosition.y;

                print("calling");
                isAnimatingBeginning = false;
              });
            }
          });

    isDragging = false;
    x = 0;
    y = 0;

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  // dragging card
  void _onTapUpdate(DragUpdateDetails details) {
    if (isAnimating) return;
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
    print("endpint is: " + endPointX.toString());

    controller.forward();
  }

  void moveTo(Vector newPosition) {
    controllerDistribution.reset();
    setState(() {
      isAnimatingBeginning = true;
      finalPosition = newPosition;
    });
    print(finalPosition.x);
    controllerDistribution.forward();
  }

  @override
  Widget build(BuildContext context) {
    print("value in build is" + animation.value.toString());
    return Align(
      alignment: Alignment(
          (isDragging)
              ? x
              : (isAnimating)
                  ? animation.value
                  : (isAnimatingBeginning)
                      ? (animationDistribution.value * finalPosition.x)
                      : x,
          (isDragging)
              ? y
              : (isAnimatingBeginning)
                  ? (animationDistribution.value * finalPosition.y)
                  : y),
      // left: (isDragging)
      //     ? x
      //     : (isAnimating)
      //         ? animation.value
      //         : (isAnimatingBeginning)
      //             ? (animationDistribution.value * finalPosition.x)
      //             : x,
      // top: (isDragging)
      //     ? y
      //     : (isAnimatingBeginning)
      //         ? (animationDistribution.value * finalPosition.y)
      //         : y,
      child: SizedBox(
          width: 75,
          height: 125,
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
