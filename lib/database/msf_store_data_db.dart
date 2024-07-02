
import 'package:msf/config/constant.dart';
import 'package:msf/database/msf_db.dart';
import 'package:msf/model/MasterDataModel.dart';
import 'package:msf/model/master_data_response_model.dart';

class SetDatabase{
  static  DatabaseHelper? _databaseHelper = new DatabaseHelper();

  static checkDatabaseStatus(MasterDataResponseModel data) async {

    /* var arrAvatarsData = data[Constant.ARR_AVATARS];
    var arrDesignationData = data[Constant.ARR_DESIGNATION];
    var arrTitlesData = data[Constant.ARR_TITLES];

*/
    setDataInTable(DatabaseHelper.MSF_USERS_TABLE, data.users);
  }

  /*check db table status and insert data in table*/

  static setDataInTable(String tableName, var dataArr) async {
    int dataRowCount = 0;
    int? deleteRowCount = -1;
    deleteRowCount = await _databaseHelper?.clearTable(tableName);
    if(deleteRowCount!=-1){
      setDataInUsersTable(dataArr,tableName);

    }


  }

  /*Set data in city table*/

  static Future<int?> setDataInUsersTable(var dataArr,String tableName) async {
    int distanceDataArrLength = dataArr.length;
    int? pId = -1;
    if (distanceDataArrLength > 0)
      for (int i = 0; i < distanceDataArrLength; i++) {
        String id = dataArr[i][Constant.EMAIL_ID];
        String password="";
        if(tableName==DatabaseHelper.MSF_USERS_TABLE){
          password =dataArr[i][Constant.PASSWORD];
        }else
          password = dataArr[i][Constant.PASSWORD];
        MasterDataModel gameModel =   MasterDataModel(i,id, password);
        pId = await _databaseHelper?.insertDataInTableRecord(
            tableName, gameModel.toMap());
      }
  }
}