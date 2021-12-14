class Famille {

  late int id_famille;
  late String nom_famille;



  familleMap() {
    var mapping = Map<String, dynamic>();
    mapping['id_famille'] = id_famille;
    mapping['nom_famille'] = nom_famille;

    return mapping;
  }


}