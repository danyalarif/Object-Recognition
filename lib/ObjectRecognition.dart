import 'dart:io';
import 'package:flutter/material.dart';
import 'package:object_recognition/Classifier.dart';
import 'package:image/image.dart' as imageLib;
import 'RecognitionUtils.dart';
import 'Results.dart';

class ObjectRecognition {
  String imagePath;
  List<RecognitionUtils>? results = [];
  ObjectRecognition({Key? key, required this.imagePath, required BuildContext context}){
    startDetection(context);
  }
  Future<void> startDetection(BuildContext context)
  async {
      imageLib.Image? img = imageLib.decodeImage(File(imagePath).readAsBytesSync());
      var classfier = Classifier();
      await classfier.loadModel();
      await classfier.loadLabels();
      //sleep(Duration(seconds: 30));
      Size previewSize = Size(300,300);
      Size screenSize = MediaQuery.of(context).size;
      ImageSize.inputImageSize = previewSize;
      ImageSize.screenSize = screenSize;
      ImageSize.ratio = screenSize.width / screenSize.height;
      results = classfier.predict(img!);
      //boundingBoxes(results!);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Results(imagePath: imagePath, results: results, context: context),
          )
      );
  }
}
