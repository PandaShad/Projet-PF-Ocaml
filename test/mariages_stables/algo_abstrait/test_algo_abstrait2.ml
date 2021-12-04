open Mariages_stables.Definitions
open Mariages_stables.Algo_abstrait
open Mariages_stables_exemple.Exemple

let () = Random.init 100

module Pioche_aleatoire : PIOCHE = struct
  type 'a t = ('a * bool) array
  let of_list l = 
    let arr = Array.of_list l in
    Array.sort compare arr;
    Array.map (fun x -> (x, true)) arr

  let pioche p =
    let deb = Random.int (Array.length p) in
    let rec essaie i inclus =
      if i=deb && not inclus then None
      else if snd p.(i) then begin
        p.(i) <- (fst p.(i), false) ;
        Format.printf "pioche %s\n" (string_of_homme i);
        Some (fst p.(i))
      end else essaie ((i+1) mod (Array.length p)) false 
    in essaie deb true
  let defausse x p = 
    for i=0 to Array.length p - 1 do
      if fst p.(i) = x then begin
        p.(i) <- (x, true);
        Format.printf "defausse %s\n" (string_of_homme i)
      end
    done
end

module M = Algo(Pioche_aleatoire)
module M2 = Algo(Pile)
module M3 = Algo(File)

let rend_verbeux f prefere_f h h' =
  Format.printf "demande à %s de choisir entre %s et %s\n" 
  (string_of_femme f) (string_of_homme (min h h')) (string_of_homme (max h h'));
  prefere_f h h'
let algo ?(affiche_config=false) entree = 
  ignore affiche_config;
  print_entree entree; 
  let e = { entree with prefere= Array.mapi rend_verbeux entree.prefere} in
  let sortie = M.run e in
  assert (sortie = M2.run entree);
  assert (sortie = M3.run entree);
  print_sortie sortie

let () = algo exemple_knuth