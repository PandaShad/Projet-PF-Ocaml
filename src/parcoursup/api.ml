(********************************* NOTION DE SESSION *********************************)

type formation = {
  name : string;
  mutable places_restantes : int;
  mutable preference : string array;
  mutable rang_appel : int;
  mutable commision : (candidat1:string -> candidat2:string -> bool) option;
}

type voeux = {
  voeux_name : string;
  mutable rang_repondeur : int option;
}

type candidat = { 
  name : string;
  mutable voeux : voeux array;
  mutable propositions : voeux array
}

type session = {
  mutable candidats : candidat array;
  mutable formations : formation array;
}

let nouvelle_session () = {candidats = [||] ; formations = [||]}

(*********************** QUELQUES FONCTIONS UTILITAIRES *********************)

let get_formation session nom_formation =
  let rec iter i = match session.formations.(i).name with
    | s when s = nom_formation -> session.formations.(i)
    | _ -> iter (i+1)
  in
  iter 0;;

let get_candidat session nom_candidat =
  let rec iter i = match session.candidats.(i).name with
    | s when s = nom_candidat -> session.candidats.(i)
    | _ -> iter (i+1)
  in
  iter 0;;

let get_voeux session nom_candidat nom_formation =
  let candidat = get_candidat session nom_candidat in
  let rec iter i = match candidat.voeux.(i).voeux_name with 
    | v when (String.equal v nom_formation) -> candidat.voeux.(i)
    | _ -> iter (i+1)
  in
  iter 0;;

let rec quick l cmp = 
  match l with
  | [] -> []
  | [x] -> [x]
  | hd :: tl -> 
    (match List.partition (fun x -> cmp ~candidat1:x ~candidat2:hd) tl with
      | l1, l2 -> (quick l1 cmp) @ [hd] @ (quick l2 cmp))

(*********************** FONCTIONS DE LA PHASE DE CONFIGURATION *********************)

let ajoute_candidat session ~nom_candidat =
  session.candidats <- Array.append session.candidats [|{name = nom_candidat ; voeux = [||] ; propositions = [||]}|]

let ajoute_formation session ~nom_formation ~capacite =
  session.formations <- Array.append session.formations [|{name = nom_formation ; places_restantes = capacite ; preference = [||] ; rang_appel = 0; commision = None}|]

let ajoute_voeu session ~rang_repondeur ~nom_candidat ~nom_formation = (* AJOUTER UNE METHODE POUR TRIER LE TABLEAUX DE VOEUX PAR RANG *)
  (* let formation = get_formation session nom_formation in *)
  let formation_not_in = ref true in
  for i = 0 to ((Array.length session.candidats)-1) do
    if session.candidats.(i).name = nom_candidat then begin
      match (Array.length session.candidats.(i).voeux) with
        | 0 -> session.candidats.(i).voeux <- Array.append session.candidats.(i).voeux [|{voeux_name = nom_formation ; rang_repondeur = rang_repondeur}|];
        | _ ->
            for y = 0 to ((Array.length session.candidats.(i).voeux) - 1) do
              if session.candidats.(i).voeux.(y).voeux_name = nom_formation then begin
                session.candidats.(i).voeux.(y).rang_repondeur <- rang_repondeur;
                formation_not_in := false;
              end
              else begin
                if (y = ((Array.length session.candidats.(i).voeux) -1)) && (!formation_not_in) then session.candidats.(i).voeux <- Array.append session.candidats.(i).voeux [|{voeux_name = nom_formation ; rang_repondeur = rang_repondeur}|];
              end
            done;
    end
  done

let ajoute_commission session ~nom_formation ~fonction_comparaison = (* TRIE SEULEMENT LES CANDIDATS AYANT LA FORMATION DANS LEUR VOEUX AU LIEU DE TRIER TOUT LES CANDIDATS *)
  let formation = get_formation session nom_formation in
  formation.commision <- Some(fonction_comparaison)


  (* let candidats_possible = ref [||] in *)
  (* for i = 0 to n-1 do
    for y = 0 to (Array.length session.candidats.(i).voeux)-1 do
      if session.candidats.(i).voeux.(y).voeux_name = nom_formation then candidats_possible := Array.append !candidats_possible [|session.candidats.(i).name|]
    done;
  done;
  (* let res = (Array.init n (fun(s) -> session.candidats.(s).name)) in *)
  (* Array.sort fonction_comparaison !candidats_possible; *)
  let candidats_possible_list = Array.to_list !candidats_possible in
  let rec aux l = match l with
    | [] -> []
    | c1 :: c2 :: tl when fonction_comparaison ~candidat1:c1 ~candidat2:c2 = true -> c1 :: aux (c2::tl)
    | c1 :: c2 :: tl when fonction_comparaison ~candidat1:c1 ~candidat2:c2 = false -> c2 :: aux (c1::tl)
    | c :: tl -> c :: aux(tl)
  in  *)
  (* formation.preference <- Array.of_list(aux candidats_possible_list) *)

    (* for i= 0 to ((Array.length session.candidats)-1) do
    match Array.length formation.preference with
      | 0 -> formation.preference <- Array.append formation.preference [|session.candidats.(i).name|]
      | _ -> 
        for y = 0 to ((Array.length formation.preference)-1) do
          if (fonction_comparaison session.candidats.(i).name formation.preference.(y)) *)

(************************** FONCTION REUNIT COMMISSIONS **********************)

let reunit_commissions session =
  let n = Array.length session.formations in
  for i = 0 to (n-1) do
    let candidats_possible = ref [] in
    for y = 0 to (Array.length session.candidats)-1 do
      for k = 0 to (Array.length session.candidats.(y).voeux)-1 do
        if session.candidats.(y).voeux.(k).voeux_name = session.formations.(i).name then candidats_possible := !candidats_possible @ [session.candidats.(y).name]
      done;
    done;
    let fonction_comparaison = Option.get(session.formations.(i).commision) in
    let res = quick !candidats_possible fonction_comparaison;
    in session.formations.(i).preference <- Array.of_list res;
      (* let rec aux l = 
        match l with
          | [] -> []
          | [x] -> [x]
          | x :: y :: tl when fonction_comparaison ~candidat1:x ~candidat2:y ->
            x :: aux(y::tl)
          | x :: y :: tl when not(fonction_comparaison ~candidat1:x ~candidat2:y) -> 
            y :: aux(x::tl)
          | _ :: tl ->
            aux tl  
      in aux !candidats_possible; *)
    (* in session.formations.(i).preference <- Array.of_list res *)
  done


(************************** FONCTIONS DE LA PHASE D'APPEL **********************)

(* let nouveau_jour session =
  for i = 0 to ((Array.length session.formations)-1) do
    let voeux_list = ref (Array.to_list session.candidats.(i).voeux) in
    let n = ref 0 in
    begin match (Array.length session.formations.(i).preference) with
      | x when x > session.formations.(i).places_restantes -> n := ((session.formations.(i).places_restantes)-1)
      | _ -> n := ((Array.length session.formations.(i).preference)-1)
    end;
    for y = session.formations.(i).rang_appel to !n do
      let candidat = get_candidat session session.formations.(i).preference.(session.formations.(i).rang_appel) in
      candidat.propositions <- candidat.propositions @ [session.formations.(i).name];
      voeux_list := List.filter (fun v -> not (String.equal v.voeux_name session.formations.(i).name)) !voeux_list;
      candidat.voeux <- Array.of_list !voeux_list;
      session.formations.(i).rang_appel <- session.formations.(i).rang_appel + 1;
      (* let preference_list = ref (Array.to_list session.formations.(i).preference) in 
      preference_list := List.filter (fun p -> not(String.equal p candidat.name)) !preference_list;
      session.formations.(i).preference <- Array.of_list !preference_list; *)
      session.formations.(i).places_restantes <- session.formations.(i).places_restantes - 1
    done;
  done;; *)

let renonce session ~nom_candidat ~nom_formation =
  (* let candidat = get_candidat session nom_candidat in *)
  let rec iter i = match session.candidats.(i).name with
    | s when s = nom_candidat ->
      let voeux_list = ref (Array.to_list session.candidats.(i).voeux) in
      voeux_list := List.filter (fun v -> not (String.equal v.voeux_name nom_formation)) !voeux_list;
      session.candidats.(i).voeux <- Array.of_list !voeux_list;
      let sting_list_proposition = ref [] in
      for y = 0 to ((Array.length session.candidats.(i).propositions)-1) do 
        sting_list_proposition :=  !sting_list_proposition @ [session.candidats.(i).propositions.(y).voeux_name]
      done;
      let formation = get_formation session nom_formation in
      if List.mem nom_formation !sting_list_proposition then begin
        session.candidats.(i).propositions <- Array.of_list(List.filter (fun p -> not(String.equal p.voeux_name nom_formation)) (Array.to_list(session.candidats.(i).propositions)));
        formation.places_restantes <- formation.places_restantes + 1;
      end;
    | _ -> iter (i+1)
  in iter 0

let nouveau_jour session =
  for i = 0 to ((Array.length session.formations)-1) do
    let formation = session.formations.(i) in
    while ((formation.places_restantes != 0) && (formation.rang_appel < Array.length formation.preference)) do
      let rang_appel = formation.rang_appel in
      let candidat = get_candidat session formation.preference.(rang_appel) in
      let string_voeux_list = ref [] in
      for j = 0 to ((Array.length candidat.voeux)-1) do 
        string_voeux_list := !string_voeux_list @ [candidat.voeux.(j).voeux_name]
      done;
      if (List.mem formation.name !string_voeux_list) then begin
        let voeux_qui_propose = get_voeux session candidat.name formation.name in
        candidat.propositions <- Array.append candidat.propositions [|voeux_qui_propose|];
        candidat.voeux <- Array.of_list (List.filter (fun v -> not(String.equal v.voeux_name voeux_qui_propose.voeux_name)) (Array.to_list candidat.voeux));
        if (Array.length candidat.voeux) >= 1 then begin 
          let rec renonce_voeux_de_plus_haut_rang k = match candidat.voeux.(k) with
            | v when v.rang_repondeur > voeux_qui_propose.rang_repondeur ->
              if (voeux_qui_propose.rang_repondeur != None) then begin
                let formation_renonce = get_formation session v.voeux_name in
                renonce session ~nom_candidat:candidat.name ~nom_formation:formation_renonce.name;
                formation_renonce.preference <- Array.of_list(List.filter (fun p -> not(String.equal p candidat.name)) (Array.to_list formation_renonce.preference));
              end;
              if (Array.length candidat.voeux > 1) then renonce_voeux_de_plus_haut_rang k
            | _ -> if(Array.length candidat.voeux) > (k+1) then renonce_voeux_de_plus_haut_rang (k+1)
          in renonce_voeux_de_plus_haut_rang 0
        end;
        if (Array.length candidat.propositions) > 1 then begin 
          let rec renonce_proposition_de_plus_haut_rang k = match candidat.propositions.(k) with
            | p when ((p.rang_repondeur > voeux_qui_propose.rang_repondeur) || ((p.rang_repondeur   = None) && voeux_qui_propose.rang_repondeur != None))->
              let formation_renonce = get_formation session p.voeux_name in
              renonce session ~nom_candidat:candidat.name ~nom_formation:formation_renonce.name;
              (* formation_renonce.preference <- Array.of_list(List.filter (fun p -> not(String.equal p candidat.name)) (Array.to_list formation_renonce.preference)); *)
              if (Array.length candidat.propositions > 1) then renonce_proposition_de_plus_haut_rang k
            | _ -> if(Array.length candidat.propositions) > (k+1) then renonce_proposition_de_plus_haut_rang (k+1)
            in renonce_proposition_de_plus_haut_rang 0
        end;
        formation.places_restantes <- formation.places_restantes - 1;
        formation.rang_appel <- formation.rang_appel + 1
      end;
    done;
  done

let consulte_propositions session ~nom_candidat =
  let candidat = get_candidat session nom_candidat in
  let string_propositions_list = ref [] in
  for j = 0 to ((Array.length candidat.propositions)-1) do 
    string_propositions_list := !string_propositions_list @ [candidat.propositions.(j).voeux_name]
  done;
  !string_propositions_list

let consulte_voeux_en_attente session ~nom_candidat =
  let candidat = get_candidat session nom_candidat in
  let voeux_list = ref (Array.to_list candidat.voeux) in
  voeux_list := List.filter (fun v -> not (Array.mem v candidat.propositions)) !voeux_list;
  let rec aux l = match l with
    | [] -> []
    | hd::tl -> 
      let formation = get_formation session hd.voeux_name in
      (* let rang_liste_complementaire = ref 0 in *)
      let rec aux2 i =
      match formation.preference.(i) with
        | s when String.equal s nom_candidat ->
          if i = formation.rang_appel then 0 
          else (i-formation.rang_appel)
        | _ -> aux2 (i+1)
      in
      (hd.voeux_name, aux2 0) :: aux tl
  in
  aux !voeux_list