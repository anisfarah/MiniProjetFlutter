
class RetourComposant {

  late int id_retour;
  late String emprunt;
  late String date_retour;
  late String etat;

  RetourComposantMap() {
    var mapping = Map<String, dynamic>();
    mapping['id_retour'] = id_retour;
    mapping['emprunt'] = emprunt;
    mapping['date_retour'] = date_retour;
    mapping['etat'] = etat;

    return mapping;
  }




}
