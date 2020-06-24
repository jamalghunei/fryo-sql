import 'package:fryo/src/helper_database.dart';

class UserModel {
  int id;
  String userName;
  String email;
  int type;

  UserModel(this.type, this.id, this.email, this.userName);

  factory UserModel.toObject(Map<String, dynamic> data) {
    return UserModel(
        data[HelperDatabase.typeUserColumn],
        data[HelperDatabase.idUserColumn],
        data[HelperDatabase.emailUserColumn],
        data[HelperDatabase.userNameColumn]);
  }
}
