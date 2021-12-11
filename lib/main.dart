import 'package:flutter/material.dart';
import 'package:object_recognition/DisplayURL.dart';
import 'package:object_recognition/Image.dart';

void main(){
  runApp(MaterialApp(
    title: 'Navigation Basics',
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key:key);
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
        ),

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
                height: 200,
                width: width / 2,
                //top: -50,
                //left: -35 + (width / 7),
              ),
              Container(
              child: ElevatedButton(
                onPressed: () async {
                  Picture(context).captureImage();
                },
                style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                child: Row
                  (
                  children: [
                    const Icon(Icons.camera),
                    SizedBox(width: width / 14),
                Text('CAPTURE IMAGE'),
                ]
              ),
              ),
                width: width as double,
                margin: const EdgeInsets.all(10),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Picture(context).selectImageFromGallery();
                  },
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  child: Row
                    (
                      children: [
                        const Icon(Icons.filter),
                        SizedBox(width: width / 14),
                        const Text('BROWSE IMAGE'),
                      ]
                  ),
                ),
                width: width as double,
                margin: const EdgeInsets.all(10),
              ),
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => DisplayURL(),
                        )
                    );
                  },
                  style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                  child: Row
                    (
                      children: [
                        const Icon(Icons.insert_link),
                        SizedBox(width: width / 14),
                        const Text('UPLOAD IMAGE'),
                      ]
                  ),
                ),
                width: width as double,
                margin: const EdgeInsets.all(10),
              ),
        ]
          )
      )
      )
    );
  }

}