open Definitions

module type PIOCHE = sig
  type 'a t
  val of_list: 'a list -> 'a t 
  val pioche : 'a t -> 'a option 
  val defausse : 'a -> 'a t -> unit 
end



module Pile : PIOCHE = struct (* LIFO *)

  type 'a t = {mutable front : 'a option ;  mutable content : 'a list}

  let of_list l =
    (* let l2 = List.rev l in *)
    match l with
     | [] -> {front = None; content = []}
     | hd::tl -> {front = Some(hd); content = tl}

  let pioche p = 
    match p.front with
      | None -> None
      | Some(x) -> 
        if p.content = [] then begin
          p.front <- None;
          Some(x);
        end
        else begin
          p.front <- Some(List.hd p.content);
          p.content <- List.tl p.content;
          Some(x);
        end

  let defausse x p =
    match p.front with 
      | None ->
        p.front <- Some(x);
      | Some(y) ->
        p.content <- y::p.content;
        p.front <- Some(x);

end



module File : PIOCHE = struct (* FIFO *)
  
  type 'a t = {mutable head : 'a list ;  mutable last : 'a option}

  let of_list l =
    (* let l2 = List.rev l in *)
    match l with
     | [] -> {head = []; last = None}
     | hd::tl -> {head = tl; last = Some(hd)}

  let pioche p = 
    match p.last with
      | None -> None
      | Some(x) ->
        if p.head = [] then begin
          p.last <- None;
          Some(x);
        end
        else begin 
          p.last <- Some(List.hd p.head);
          p.head <- List.tl p.head;
          Some(x);
        end

  let defausse x p =
    match p.last with 
      | None ->
        p.last <- Some(x);
      | _ ->
        p.head <- p.head @ [x];

end




module Algo(P:PIOCHE) = struct
  
  let run entree = 
    let n = entree.n in
    let conf = {rang_appel_de = Array.make n 0; fiance_de = Array.make n None} in
    let pioche = P.of_list (List.init n (fun(h) -> h)) in
    let current_homme = ref (P.pioche pioche) in
    while (!current_homme) != None do
      let femme_suivante = entree.liste_appel_de.(Option.get !current_homme).(conf.rang_appel_de.(Option.get !current_homme)) in
      if conf.fiance_de.(femme_suivante) = None then begin
        conf.fiance_de.(femme_suivante) <- !current_homme;
        current_homme := P.pioche pioche;
      end
      else begin
        if entree.prefere.(femme_suivante) (Option.get conf.fiance_de.(femme_suivante)) (Option.get !current_homme) then begin
          conf.rang_appel_de.(Option.get !current_homme) <- (conf.rang_appel_de.(Option.get !current_homme))+1;
          P.defausse (Option.get !current_homme) pioche;
        end
        else begin
          conf.rang_appel_de.(Option.get (conf.fiance_de.(femme_suivante))) <- (conf.rang_appel_de.(Option.get(conf.fiance_de.(femme_suivante)))) + 1;
          P.defausse (Option.get (conf.fiance_de.(femme_suivante))) pioche;
          conf.fiance_de.(femme_suivante) <- !current_homme;
        end;
        current_homme := P.pioche pioche;
      end
    done;
    (List.init n (fun (h) -> (h, entree.liste_appel_de.(h).(conf.rang_appel_de.(h)))))
end
