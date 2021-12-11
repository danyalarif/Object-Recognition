import 'dart:io';
import 'package:flutter/material.dart';
import 'BoxWidget.dart';
import 'RecognitionUtils.dart';
import 'main.dart';

class Results extends StatelessWidget {
  List<RecognitionUtils>? results = [];
  String imagePath;
  Results({Key? key, required this.imagePath, required this.results, required BuildContext context}) : super(key: key);
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
                      Stack(
                        children:
                            [
                      boundingBoxes(results!),
                      Container(
                        child: Image.file(File(imagePath), height: 300,
                            width: 300),
                        margin: EdgeInsets.only(top: 30),
                      ),
                              ]
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => MyApp(),
                                )
                            );
                          },
                          style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                          child: Row
                            (
                              children: [
                                const Icon(Icons.insert_link),
                                SizedBox(width: width / 14),
                                const Text('MAIN MENU'),
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
  Widget boundingBoxes(List<RecognitionUtils> results) {
    if (results.isEmpty) {
      return Container(
        child: Text("No object recognized!"),
      );
    }
    return Container(
      child: BoxWidget(result: results.elementAt(0)),
    );
  }
}