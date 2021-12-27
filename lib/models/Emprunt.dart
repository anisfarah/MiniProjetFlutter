
class Emprunt {

  late int id_emprunt;
  late String membre;
  late String composant;
  late int qte_emprunt;

  empruntMap() {
    var mapping = Map<String, dynamic>();
    mapping['id_emprunt'] = id_emprunt;
    mapping['membre'] = membre;
    mapping['composant'] = composant;
    mapping['qte_emprunt'] = qte_emprunt;

    return mapping;
  }




}
