
import 'package:flutter/cupertino.dart';


class ImageSize {
  static double ratio = 0;
  static Size screenSize = 0 as Size;
  static Size inputImageSize = 0 as Size;
  static Size get actualPreviewSize =>
      Size(screenSize.width, screenSize.width * ratio);
}

class RecognitionUtils {

  int _id;
  String _label;
  double _score;
  Rect _location;

  RecognitionUtils(this._id, this._label, this._score, this._location);

  int get id => _id;

  String get label => _label;

  double get score => _score;

  Rect get location => _location;

  Rect get renderLocation {
    Rect transformedRect = Rect.fromLTWH(-1.0, 0, 300, 300);
    return transformedRect;
  }

  @override
  String toString() {
    return 'Recognition(id: $id, label: $label, score: $score, location: $location)';
  }
}
