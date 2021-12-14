
    class MembreClub {

  late int id_membre;
  late String nom_membre;
  late String prenom_membre;
  late String numtel1;
  late String numtel2;

  MembreClubMap() {
    var mapping = Map<String, dynamic>();
    mapping['id_membre'] = id_membre;
    mapping['nom_membre'] = nom_membre;
    mapping['prenom_membre'] = prenom_membre;
    mapping['numtel1'] = numtel1;
    mapping['numtel2'] = numtel2;

    return mapping;
  }



    }