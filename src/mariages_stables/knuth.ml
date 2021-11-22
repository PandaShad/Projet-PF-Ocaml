open Definitions

let algo ?(affiche_config=false) entree =
    let n = entree.n in
    let k = ref 0 in
    let conf_depart = {rang_appel_de = Array.make n 0 ; fiance_de = Array.make n None} in
    while !k < n do
      let current_homme = ref (Some(!k)) in
      while !current_homme != None do
        let meilleur_choix_restant = entree.liste_appel_de.(Option.get !current_homme).(conf_depart.rang_appel_de.(Option.get !current_homme)) in                         (*!k = Homme/Indice du tableau rang_appel_de et !femme = Femme/indice du tab fiance_de*)
        match conf_depart.fiance_de.(meilleur_choix_restant) with
          | None -> 
            let aux = conf_depart.fiance_de.(meilleur_choix_restant) in
            conf_depart.fiance_de.(meilleur_choix_restant) <- !current_homme;
            current_homme := aux;
          | Some(h) -> 
            if entree.prefere.(meilleur_choix_restant) (Option.get !current_homme) h then 
                let aux = conf_depart.fiance_de.(meilleur_choix_restant) in
                conf_depart.fiance_de.(meilleur_choix_restant) <- !current_homme;
                current_homme := aux;
            else current_homme := !current_homme;
        if !current_homme != None then conf_depart.rang_appel_de.(Option.get !current_homme) <- conf_depart.rang_appel_de.(Option.get !current_homme) + 1;
        if affiche_config then print_configuration conf_depart;
      done;
    if affiche_config then print_configuration conf_depart;
    k := !k + 1;
    done;
  (List.init n (fun (h) -> (h, entree.liste_appel_de.(h).(conf_depart.rang_appel_de.(h)))));;