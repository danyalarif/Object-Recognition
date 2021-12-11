import 'package:mongo_dart/mongo_dart.dart';
import 'dart:developer';
class DBTools {
  static Future<Db> getConnection() async{
    var db = await Db.create(getConnectionString());
    try {
      await db.open();
    }catch (e)
    {
      log(e.toString());
    }
    return db;
  }
  static String getConnectionString(){
    return "mongodb+srv://danyal:admin810@cluster0.f3ray.mongodb.net:27017/ImageToAR?retryWrites=true&w=majority";
  }
}