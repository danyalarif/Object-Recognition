import 'dart:math';
import 'dart:ui';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:image/image.dart' as imageLib;
import 'package:object_recognition/RecognitionUtils.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';


/// Classifier
class Classifier {
  Interpreter? _interpreter = null;
  List<String>? _labels = null;
  static const String MODEL_FILE_NAME = "Models/detect.tflite";
  static const String LABEL_FILE_NAME = "assets/Models/labelmap.txt";
  static const int INPUT_SIZE = 300;
  static const double THRESHOLD = 0.5;
  ImageProcessor? imageProcessor = null;
  int padSize = 0;
  late List<List<int>> _outputShapes;
  late List<TfLiteType> _outputTypes;
  static const int NUM_RESULTS = 10;



  Future<void> loadModel() async {
    try {
      _interpreter = interpreter ?? await Interpreter.fromAsset(MODEL_FILE_NAME);
      var outputTensors = _interpreter!.getOutputTensors();
      _outputShapes = [];
      _outputTypes = [];
      outputTensors.forEach((tensor) {
        _outputShapes.add(tensor.shape);
        _outputTypes.add(tensor.type);
      });
    } catch (e) {
      print("Error while creating interpreter: $e");
    }
  }


  Future<void> loadLabels() async {
    try {
      _labels = await FileUtil.loadLabels(LABEL_FILE_NAME);
    } catch (e) {
      print("Error while loading labels: $e");
    }
  }


  TensorImage getProcessedImage(TensorImage inputImage) {
    padSize = max(inputImage.height, inputImage.width);
    if (imageProcessor == null) {
      imageProcessor = ImageProcessorBuilder()
          .add(ResizeWithCropOrPadOp(padSize, padSize))
          .add(ResizeOp(INPUT_SIZE, INPUT_SIZE, ResizeMethod.BILINEAR))
          .build();
    }
    inputImage = imageProcessor!.process(inputImage);
    return inputImage;
  }


  List<RecognitionUtils> predict(imageLib.Image image) {

    //TensorImage inputImage = TensorImage.fromImage(image);
    TensorImage inputImage = TensorImage.fromImage(image);
    inputImage.loadImage(image);
    inputImage = getProcessedImage(inputImage);

    //_interpreter.run(inputImage.buffer, )
    // TensorBuffers for output tensors
    TensorBuffer outputLocations = TensorBufferFloat(_outputShapes[0]);
    TensorBuffer outputClasses = TensorBufferFloat(_outputShapes[1]);
    TensorBuffer outputScores = TensorBufferFloat(_outputShapes[2]);
    TensorBuffer numLocations = TensorBufferFloat(_outputShapes[3]);


    List<Object> inputs = [inputImage.buffer];


    Map<int, Object> outputs = {
      0: outputLocations.buffer,
      1: outputClasses.buffer,
      2: outputScores.buffer,
      3: numLocations.buffer,
    };
    _interpreter!.runForMultipleInputs(inputs, outputs);

    int resultsCount = min(NUM_RESULTS, numLocations.getIntValue(0));

    int labelOffset = 1;

    List<Rect> locations = BoundingBoxUtils.convert(
      tensor: outputLocations,
      valueIndex: [1, 0, 3, 2],
      boundingBoxAxis: 2,
      boundingBoxType: BoundingBoxType.BOUNDARIES,
      coordinateType: CoordinateType.RATIO,
      height: INPUT_SIZE,
      width: INPUT_SIZE,
    );

    List<RecognitionUtils> recognitions = [];
    for (int i = 0; i < resultsCount; i++) {
      var score = outputScores.getDoubleValue(i);
      var labelIndex = outputClasses.getIntValue(i) + labelOffset;
      var label = _labels!.elementAt(labelIndex);

      if (score > THRESHOLD) {
        Rect transformedRect = imageProcessor!.inverseTransformRect(
            locations[i], image.height, image.width);

        recognitions.add(
          RecognitionUtils(i, label, score, transformedRect),
        );
      }
    }
    return recognitions;
  }

  Interpreter? get interpreter => _interpreter;
  List<String>? get labels => _labels;
}
