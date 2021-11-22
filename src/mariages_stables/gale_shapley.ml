open Definitions

let algo ?(affiche_config=true) entree =
  let n = entree.n in 
  let conf = {rang_appel_de = Array.make n 0; fiance_de = Array.make n None} in
  let homme_non_marie = ref (List.init n (fun(i) -> i)) in
  let pretendants = Array.make n [||] in
  while List.length !homme_non_marie != 0 do
    for i = 0 to (List.length !homme_non_marie)-1 do
      let femme_suivante = ref entree.liste_appel_de.(i).(conf.rang_appel_de.(i)) in
      pretendants.(!femme_suivante) <- Array.append pretendants.(!femme_suivante) [|i|]
    done;
    for i = 0 to n-1 do
      let length = Array.length pretendants.(i) in
      for y = 0 to length-1 do
        if length != 0 then
          if conf.fiance_de.(i) = None then begin
            conf.fiance_de.(i) <- Some(pretendants.(i).(y));
            homme_non_marie := List.filter (fun h -> h != Option.get conf.fiance_de.(i)) !homme_non_marie;
          end
          else begin
            if entree.prefere.(i) pretendants.(i).(y) (Option.get conf.fiance_de.(i)) then begin
              conf.rang_appel_de.(Option.get conf.fiance_de.(i)) <-  (conf.rang_appel_de.(Option.get conf.fiance_de.(i))) + 1;
              homme_non_marie := !homme_non_marie @ [(Option.get conf.fiance_de.(i))];
              conf.fiance_de.(i) <- Some(pretendants.(i).(y));
              homme_non_marie := List.filter (fun h -> h != Option.get conf.fiance_de.(i)) !homme_non_marie;
            end
            else conf.rang_appel_de.(pretendants.(i).(y)) <- conf.rang_appel_de.(pretendants.(i).(y))+1
          end;
      done;
      pretendants.(i) <- [||];
    done;
    if affiche_config then print_configuration conf;
  done;
  (List.init n (fun (h) -> (h, entree.liste_appel_de.(h).(conf.rang_appel_de.(h)))));;