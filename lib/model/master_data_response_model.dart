/// users : {"emailId":"admin@gmail.com","password":"admin","userName":"Admin"}

class MasterDataResponseModel {
  MasterDataResponseModel({
      Users? users,}){
    _users = users;
}

  MasterDataResponseModel.fromJson(dynamic json) {
    _users = json['users'] != null ? Users.fromJson(json['users']) : null;
  }
  Users? _users;
MasterDataResponseModel copyWith({  Users? users,
}) => MasterDataResponseModel(  users: users ?? _users,
);
  Users? get users => _users;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_users != null) {
      map['users'] = _users?.toJson();
    }
    return map;
  }

}

/// emailId : "admin@gmail.com"
/// password : "admin"
/// userName : "Admin"

class Users {
  Users({
      String? emailId, 
      String? password, 
      String? userName,}){
    _emailId = emailId;
    _password = password;
    _userName = userName;
}

  Users.fromJson(dynamic json) {
    _emailId = json['emailId'];
    _password = json['password'];
    _userName = json['userName'];
  }
  String? _emailId;
  String? _password;
  String? _userName;
Users copyWith({  String? emailId,
  String? password,
  String? userName,
}) => Users(  emailId: emailId ?? _emailId,
  password: password ?? _password,
  userName: userName ?? _userName,
);
  String? get emailId => _emailId;
  String? get password => _password;
  String? get userName => _userName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['emailId'] = _emailId;
    map['password'] = _password;
    map['userName'] = _userName;
    return map;
  }

}