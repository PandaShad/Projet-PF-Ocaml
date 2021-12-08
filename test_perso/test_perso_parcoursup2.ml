open Test_perso_parcoursup_utils

let session = nouvelle_session ()

let () = 
    ajoute_candidat session ~nom_candidat:"Maxime";
    ajoute_candidat session ~nom_candidat:"Ghouti";
    ajoute_candidat session ~nom_candidat:"Rami";

    ajoute_formation session ~nom_formation:"Université Côte d'Azur" ~capacite:2;
    ajoute_formation session ~nom_formation:"Université de Toulon" ~capacite:1;

    ajoute_voeu session 
        ~rang_repondeur: None 
        ~nom_candidat:"Maxime" 
        ~nom_formation:"Université Côte d'Azur";
    ajoute_voeu session 
        ~rang_repondeur: (Some 1) 
        ~nom_candidat:"Maxime" 
        ~nom_formation:"Université de Toulon";
    ajoute_voeu session 
        ~rang_repondeur:(Some 2) 
        ~nom_candidat:"Ghouti" 
        ~nom_formation:"Université Côte d'Azur";
    ajoute_voeu session 
        ~rang_repondeur: (Some 1) 
        ~nom_candidat:"Ghouti" 
        ~nom_formation:"Université de Toulon";
    ajoute_voeu session 
        ~rang_repondeur:(Some 1) 
        ~nom_candidat:"Rami" 
        ~nom_formation:"Université Côte d'Azur";
    ajoute_voeu session 
        ~rang_repondeur: (Some 1) 
        ~nom_candidat:"Rami" 
        ~nom_formation:"Université de Toulon";
        
    ajoute_commission session 
        ~nom_formation:"Université Côte d'Azur" 
        ["Ghouti";"Maxime";"Rami"]; 

    ajoute_commission session 
        ~nom_formation:"Université de Toulon" 
        ["Ghouti";"Maxime";"Rami"]; 

    reunit_commissions session;

    nouveau_jour session;
    affiche_voeux_en_attente session "Maxime";
    affiche_propositions_en_attente session "Maxime";
    affiche_voeux_en_attente session "Ghouti";
    affiche_propositions_en_attente session "Ghouti";
    affiche_voeux_en_attente session "Rami";
    affiche_propositions_en_attente session "Rami";
    (* renonce session 
        ~nom_candidat:"Maxime" 
        ~nom_formation:"Université Côte d'Azur"; *)
    renonce session 
        ~nom_candidat:"Ghouti" 
        ~nom_formation:"Université de Toulon";

    nouveau_jour session;
    affiche_voeux_en_attente session "Maxime";
    affiche_propositions_en_attente session "Maxime";
    affiche_voeux_en_attente session "Ghouti";
    affiche_propositions_en_attente session "Ghouti";
    affiche_voeux_en_attente session "Rami";
    affiche_propositions_en_attente session "Rami";