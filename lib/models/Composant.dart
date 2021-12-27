
class Composant {

   late int id_composant;
   late String nom_composant;
   late String ref_composant;
   late String famille;
   late int qte_dispo;
   late String date_acquisition;

   composantMap() {
     var mapping = Map<String, dynamic>();
     mapping['id_composant'] = id_composant;
     mapping['nom_composant'] = nom_composant;
     mapping['ref_composant'] = ref_composant;
     mapping['famille'] = famille;
     mapping['qte_dispo'] = qte_dispo;
     mapping['date_acquisition'] = date_acquisition;

     return mapping;
   }




}
