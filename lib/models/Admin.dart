
class Admin {

  late int id_admin;
  late String nom_admin;
  late String password;
  late String email;

  composantMap() {
    var mapping = Map<String, dynamic>();
    mapping['id_admin'] = id_admin;
    mapping['nom_admin'] = nom_admin;
    mapping['password'] = password;
    mapping['email'] = email;


    return mapping;
  }

  Admin.fromMap(Map<String, dynamic> map) {
    id_admin = map['id_admin'];
    nom_admin = map['nom_admin'];
    email = map['email'];
    password = map['password'];
  }



}
