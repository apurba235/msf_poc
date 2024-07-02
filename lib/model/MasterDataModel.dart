


import 'package:msf/config/constant.dart';

class MasterDataModel {
  late int _ColId;
  late String _emailid;
  late String _password;


  MasterDataModel(this._ColId, this._emailid, this._password);

  int get ColId => _ColId;
  String get emailid => _emailid;
  String get password => _password;



  set id(String value) {
    _emailid=value;
  }

  set name(String value) {
    _password=value;
  }


  /*Conver game onject into a map object*/
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (ColId != null) {
      map[Constant.COL_ID] = ColId;
    }
    map[Constant.EMAIL_ID] = emailid;
    map[Constant.PASSWORD] = password;

    return map;
  }
/*Conver game onject into a map object*/
  Map<String, dynamic> toMapUpdate() {
    var map = Map<String, dynamic>();
    if (ColId != null) {
      map[Constant.COL_ID] = ColId;
    }


    return map;
  }

  /*Extract a game object from Map object*/
  MasterDataModel.fromMapObject(Map<String, dynamic> map) {
    _emailid = map[Constant.EMAIL_ID];
    _password = map[Constant.PASSWORD];
  }


}
