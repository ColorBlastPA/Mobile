import 'package:color_blast/Model/client.dart';
import 'package:color_blast/Model/professionnel.dart';

class DataManager{

   Client? client;
   Professionnel? pro;
   List<Professionnel?>? professionnel;
   List<Professionnel?>? favoris;
   bool? workspaceClient;

  static final DataManager _instance = DataManager._internal();

  factory DataManager(){
    return _instance;
  }

  DataManager._internal();

   void reset() {
     workspaceClient = null;
     pro = null;
     client = null;
     professionnel = null;
     favoris = null;
   }

}