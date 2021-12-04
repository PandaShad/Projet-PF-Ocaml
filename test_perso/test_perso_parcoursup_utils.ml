open Parcoursup.Api

let nouvelle_session () = 
  Format.printf "nouvelle session\n";
  nouvelle_session ()

let ajoute_candidat session ~nom_candidat = 
  Format.printf "ajoute candidat %s\n" nom_candidat;
  ajoute_candidat session ~nom_candidat

let ajoute_formation session ~nom_formation ~capacite = 
  Format.printf "ajoute formation %s (%d places)\n" 
    nom_formation
    capacite;
  ajoute_formation session ~nom_formation ~capacite

let string_of_rang = function
| None -> ""
| Some r -> Format.sprintf " (rang=%d)" r

let ajoute_voeu session ~rang_repondeur ~nom_candidat ~nom_formation =
  Format.printf "ajoute voeu de %s pour %s%s\n"
    nom_candidat
    nom_formation
    (string_of_rang rang_repondeur);
  ajoute_voeu session ~rang_repondeur ~nom_candidat ~nom_formation

let reunit_commissions session =
  Format.printf "réunit commissions\n";
  reunit_commissions session

let nouveau_jour session = 
  Format.printf "nouveau jour\n";
  nouveau_jour session

let renonce session ~nom_candidat ~nom_formation =
  Format.printf "%s renonce à %s\n" 
    nom_candidat 
    nom_formation;
  renonce session ~nom_candidat ~nom_formation

let affiche_propositions_en_attente session candidat =
  consulte_propositions session ~nom_candidat:candidat |>
  String.concat ", " |>
  Format.printf "Propositions en attente de %s : {%s}\n" candidat

let affiche_voeux_en_attente session candidat =
    consulte_voeux_en_attente session ~nom_candidat:candidat |>
    List.map (fun (formation,rang) -> Format.sprintf "%s(%d)" formation rang) |>
    String.concat ", " |>
    Format.printf "Voeux en attente de %s : {%s}\n" candidat
   
let commission l ~candidat1 ~candidat2 =
  let rec aux = function
  | [] -> false
  | x::_ when x=candidat1 -> true
  | x::_ when x=candidat2 -> false
  | _::tl -> aux tl in
  aux l

let string_of_list l = 
  l |> String.concat "; " |> Format.sprintf "[%s]"

let ajoute_commission session ~nom_formation l =
  Format.printf "commission de classement de %s : %s\n"
    nom_formation
    (string_of_list l);
  ajoute_commission session ~nom_formation ~fonction_comparaison:(commission l)