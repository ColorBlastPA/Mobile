class DataManager{
   String data1 = "";
   String data2 = "";
   String data3 = "";


  static final DataManager _instance = DataManager._internal();

  factory DataManager(){
    return _instance;
  }

  DataManager._internal();

}