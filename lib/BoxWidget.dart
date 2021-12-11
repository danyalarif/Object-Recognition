import 'package:flutter/material.dart';
import 'package:object_recognition/RecognitionUtils.dart';

class BoxWidget extends StatelessWidget {
  final RecognitionUtils result;

  const BoxWidget({Key? key, required this.result}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Color color = Colors.red;
    return Positioned(
      left: result.renderLocation.left,
      top: result.renderLocation.top,
      width: 300,
      height: 350,
      child: Container(
        width: 300,
        height: 350,
        decoration: BoxDecoration(
            border: Border.all(color: color, width: 3),
            borderRadius: BorderRadius.all(Radius.circular(2))),
        child: Align(
          alignment: Alignment.topLeft,
          child: FittedBox(
            child: Container(
              color: color,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(result.label),
                  Text(" " + ((result.score * 100 as num).round()).toString() + "%"),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}