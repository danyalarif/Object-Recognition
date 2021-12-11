import 'dart:async';
import 'dart:io';
import 'dart:developer';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'DBTools.dart';
import 'ObjectRecognition.dart';


class Picture{
  BuildContext context;
  Picture(this.context);
  Future<void> captureImage()
  async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(camera: firstCamera),
        )
    );
  }
  void selectImageFromGallery() async
  {
    ImagePicker picker = ImagePicker();
    XFile? image = await  picker.pickImage(source: ImageSource.gallery, imageQuality: 100, maxHeight: 300, maxWidth: 300);
    String path = image!.path;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: path),
        )
    );
  }
  static Future<void> saveImage(String path)
  async {
    var db = await DBTools.getConnection();
    Image img = Image.file(File(path));
    double? height = img.height;
    double? width = img.width;
    double size = (File(path).lengthSync() / 1024);
    var col = db.collection("Image");
    col.insertOne({
      "imageURL" : path,
      "height" : height,
      "width" : width,
      "size" : size
    });
    db.close();
  }
  void uploadImage(String url) async
  {
    Dio dio = Dio();
    String fileName = url.substring(url.lastIndexOf("/") + 1);
    Directory root = await getTemporaryDirectory();
    String savePath = root.path + "Pics/fileName";
    await dio.download(url, savePath);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(imagePath: savePath),
        )
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    initControllers();
  }
  Future<void> initControllers() async {

    _controller = CameraController(

      widget.camera,

      ResolutionPreset.medium,
    );

    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('OBJECT RECOGNITION'),
        backgroundColor: Colors.purple,
      ),

      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_controller);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(

        onPressed: () async {
          try {

            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: image.path,
                ),
              ),
            );
          } catch (e) {

            log(e.toString());
          }
        },
        child: const Icon(Icons.camera_alt),
        backgroundColor: Colors.purple,
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    num width = WidgetsBinding.instance!.window.physicalSize.width as num;
    return MaterialApp(
        theme: ThemeData(
            fontFamily: 'Georgia',
            textTheme: const TextTheme(
              button: TextStyle(fontSize: 20),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData
              (
                style: ButtonStyle(
                  // backgroundColor: MaterialStateProperty.all(Colors.red),
                  backgroundColor: MaterialStateProperty.all(Color(0xffF178B6)),
                  alignment: Alignment.center,
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(15)),
                )
              //style: Color(0xffF178B6),
            )
        ),
        home: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Images/background.png"),
                    fit: BoxFit.cover)
            ),
            child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(backgroundColor: Colors.purple,
                  title: const Text('Object Recognition'),
                ),
                body: Column(
                  //alignment: Alignment.center,
                    children:  [
                      SizedBox(
                        child: Image(image: AssetImage("assets/Images/logo.png")),
                        height: 150,
                        width: width / 2,
                        //top: -50,
                        //left: -35 + (width / 7),
                      ),
                      SizedBox(
                        child: Image.file(File(imagePath), height: 250,
                            width: width as double, fit: BoxFit.cover),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () async {
                            //await Picture.saveImage(imagePath);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Image saved successfully at " + imagePath),
                            ));
                          },
                          style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                          child: Row
                            (
                              children: [
                                const Icon(Icons.save),
                                SizedBox(width: width / 10),
                                const Text('SAVE IMAGE'),
                              ]
                          ),
                        ),
                        width: width as double,
                        margin: const EdgeInsets.only(left: 10, top: 20, right: 10, bottom: 10),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                              ObjectRecognition(imagePath: imagePath, context: context);
                          },
                          style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                          child: Row
                            (
                              children: [
                                const Icon(Icons.arrow_forward),
                                SizedBox(width: width / 14),
                                const Text('START DETECTION'),
                              ]
                          ),
                        ),
                        width: width as double,
                        margin: const EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                      ),
                    ]
                )
            )
        )
    );
  }
}