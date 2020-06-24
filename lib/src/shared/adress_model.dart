import 'package:fryo/src/helper_database.dart';

class adressmodel {
  int id;
  String adressname;
  double adresscode;
  String adresslane;
  String adresscity;

  adressmodel(this.id, this.adressname, this.adresscode, this.adresslane,
      this.adresscity,);

  factory adressmodel.toObject(Map<String, dynamic> data) {
    return adressmodel(
        data[HelperDatabase.adressid],
        data[HelperDatabase.adressname],
        data[HelperDatabase.adresscode],
        data[HelperDatabase.adresslane],
        data[HelperDatabase.adresscity]);
  }
}
