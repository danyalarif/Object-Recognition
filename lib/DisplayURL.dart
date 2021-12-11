import 'package:flutter/material.dart';
import 'package:object_recognition/Image.dart';

class DisplayURL extends StatefulWidget {
  @override
  _DisplayURLState createState() => _DisplayURLState();
}

class _DisplayURLState extends State<DisplayURL> {
  TextEditingController fieldText = TextEditingController();
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
                ),
              //style: Color(0xffF178B6),
            ),
            inputDecorationTheme: const InputDecorationTheme(
              hintStyle: TextStyle(color: Colors.grey),
            )
        ),
        home: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/Images/background.png"),
                    fit: BoxFit.cover)
            ),
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                backgroundColor: Colors.transparent,
                appBar: AppBar(backgroundColor: Colors.purple,
                  title: const Text('Object Recognition'),
                ),
                body: Column(
                  //alignment: Alignment.center,
                    children: [
                      SizedBox(
                        child: Image(
                            image: AssetImage("assets/Images/logo.png")),
                        height: 200,
                        width: width / 2,
                        //top: -50,
                        //left: -35 + (width / 7),
                      ),
                      Container(
                        child: TextField(
                          controller: fieldText,
                          onChanged: (value) {
                            setState(() {});
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: "Enter your URL",
                            //hintStyle: TextStyle(color: Colors.white),
                          ),
                        ),
                        width: width as double,
                        margin: const EdgeInsets.all(10),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            String txt = fieldText.text;
                            Picture(context).uploadImage(txt);
                          },
                          style: ElevatedButton.styleFrom(
                              shape: StadiumBorder()),
                          child: Row
                            (
                              children: [
                                const Icon(Icons.download),
                                SizedBox(width: width / 14),
                                const Text('DOWNLOAD'),
                              ]
                          ),
                        ),
                        width: width as double,
                        margin: const EdgeInsets.all(30),
                      ),
                    ]
                )
            )
        )
    );
  }
}


