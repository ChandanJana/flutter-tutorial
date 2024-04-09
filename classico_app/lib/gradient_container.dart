import 'package:classico_app/dice_roller.dart';
import 'package:classico_app/style_text.dart';
import 'package:flutter/material.dart';

/// In Flutter, a StatelessWidget is a fundamental building block used to
/// create the user interface of your application. A StatelessWidget
/// represents part of your app's user interface that does not change over
/// time (it is "stateless"). This means that once you create and build a
/// StatelessWidget, its properties and appearance remain constant and do
/// not depend on any internal state changes.
/// Key characteristics of StatelessWidget: Immutable Properties, No Internal State

// Declare variables
var startAlignment = Alignment.topLeft;
var endAlignment = Alignment.bottomRight;

class GradientContainer extends StatelessWidget {
  /// const GradientContainer({super.key}); equivalent to const GradientContainer({key}) : super(key: key);

  /// Generally named parameter is optional by default but we make it mandatory/required
  /// parameter by adding required key before and here text is positional parameter, it is
  /// by default required/mandatory
  const GradientContainer(this.text, {super.key, required this.colorList});

  //Here purple is constructor(another way of declaring constructor)
  GradientContainer.purple({super.key}) :
        colorList = [Colors.deepPurpleAccent, Colors.yellow],
        text = 'Hello';

  final List<Color> colorList;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colorList,
          begin: startAlignment,
          end: endAlignment,
        ),
      ),
      child: Center(
        //child: StyleText(text),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StyleText(text),
            const SizedBox(height: 20,),
            const DiceRoller()
          ],
        ),
      ),
    );
  }
}
