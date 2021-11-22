open Test_parcoursup_utils

let session = nouvelle_session ()

let () = 
  ajoute_candidat session ~nom_candidat:"Adam";
  ajoute_formation session ~nom_formation:"Université Côte d'Azur" ~capacite:1000;
  ajoute_voeu session 
    ~rang_repondeur:(Some 1) 
    ~nom_candidat:"Adam" 
    ~nom_formation:"Université Côte d'Azur";
  ajoute_commission session 
    ~nom_formation:"Université Côte d'Azur" 
    ["Adam"]; 
  reunit_commissions session;
  nouveau_jour session;
  affiche_voeux_en_attente session "Adam";
  affiche_propositions_en_attente session "Adam"