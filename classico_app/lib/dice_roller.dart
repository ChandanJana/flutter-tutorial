import 'dart:math';
import 'package:flutter/material.dart';

/// In Flutter, a StatefulWidget is a fundamental building block used to
/// create parts of your application's user interface that can change or
/// have mutable state over time. Unlike StatelessWidget, which represents
/// static or unchanging parts of the UI, a StatefulWidget is used when you
/// need to manage and update the state of a widget dynamically.
/// Key characteristics of StatefulWidget: Mutable State,

final random = Random();

class DiceRoller extends StatefulWidget {

  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }

}

class _DiceRollerState extends State<DiceRoller> {

  var activeDiceRoll = 2;

  void rollDice() {
    // () {} it means anonymous function
    setState(() {
      activeDiceRoll = random.nextInt(6) + 1; // 1 to 6
      print("activeDice $activeDiceRoll");
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20,),
        Image.asset(
          'assets/images/dice-$activeDiceRoll.png',
          width: 200,
        ),
        const SizedBox(height: 20,),
        ElevatedButton(
          //onPressed: (){}, // option1 is anonymous function
          onPressed: rollDice, // option2
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(5),
            textStyle: const TextStyle(fontWeight: FontWeight.bold),
          ),
          child: const Text('Roll Dice'),
        )
      ],
    );
  }

}