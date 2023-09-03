import 'package:color_blast/Model/client.dart';
import 'package:color_blast/Model/professionnel.dart';
import 'package:color_blast/Model/user_pro.dart';

class DataManager{

   Client? client;
   UserPro? pro;
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