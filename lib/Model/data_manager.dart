import 'package:color_blast/Model/client.dart';
import 'package:color_blast/Model/professionnel.dart';

class DataManager{

   Client? client;
   List<Professionnel?>? professionnel;
   List<Professionnel?>? favoris;

  static final DataManager _instance = DataManager._internal();

  factory DataManager(){
    return _instance;
  }

  DataManager._internal();

   void reset() {
     client = null;
     professionnel = null;
     favoris = null;
   }

}