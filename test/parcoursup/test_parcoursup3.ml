open Test_parcoursup_utils
let session = nouvelle_session ()

let () = 
  ajoute_candidat session ~nom_candidat:"Adam";
  ajoute_candidat session ~nom_candidat:"Béatrice";
  ajoute_formation session ~nom_formation:"Université Côte d'Azur" ~capacite:1;
  ajoute_formation session ~nom_formation:"Université de Toulon" ~capacite:2;
  ajoute_voeu session 
    ~rang_repondeur:None
    ~nom_candidat:"Adam" 
    ~nom_formation:"Université Côte d'Azur";
    ajoute_voeu session 
    ~rang_repondeur:None
    ~nom_candidat:"Adam" 
    ~nom_formation:"Université de Toulon";
    ajoute_voeu session 
    ~rang_repondeur:(Some 1) 
    ~nom_candidat:"Béatrice" 
    ~nom_formation:"Université Côte d'Azur";
    ajoute_voeu session 
    ~rang_repondeur:(Some 2) 
    ~nom_candidat:"Béatrice" 
    ~nom_formation:"Université de Toulon";
  ajoute_commission session 
    ~nom_formation:"Université Côte d'Azur" 
    ["Adam";"Béatrice"]; 
    ajoute_commission session 
    ~nom_formation:"Université de Toulon" 
    ["Adam";"Béatrice"]; 
  reunit_commissions session;
  nouveau_jour session;
  affiche_voeux_en_attente session "Adam";
  affiche_propositions_en_attente session "Adam";
  affiche_voeux_en_attente session "Béatrice";
  affiche_propositions_en_attente session "Béatrice";
  renonce session 
    ~nom_candidat:"Adam" 
    ~nom_formation:"Université Côte d'Azur";
  affiche_voeux_en_attente session "Adam";
  affiche_propositions_en_attente session "Adam";
  affiche_voeux_en_attente session "Béatrice";
  affiche_propositions_en_attente session "Béatrice";
  nouveau_jour session;
  affiche_voeux_en_attente session "Adam";
  affiche_propositions_en_attente session "Adam";
  affiche_voeux_en_attente session "Béatrice";
  affiche_propositions_en_attente session "Béatrice"
