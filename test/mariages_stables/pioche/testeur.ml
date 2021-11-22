open Mariages_stables
open Algo_abstrait

let string_of_opt = function
| None -> "None"
| Some i -> Format.sprintf "Some %d" i

module Testeur(P:PIOCHE) = struct
  
  let run () = 

    Random.init 100;

    let p = [|P.of_list []; P.of_list [0;1]|] in

    Format.printf "let p0 = of_list []\nlet p1 = of_list [0;1]\n";

    for _=0 to 30 do
      let n = Random.int 2 in
      let x = Random.int 10 in
      if Random.bool () then
        Format.printf "pioche p%d;;\n- : int option = %s\n" n (string_of_opt (P.pioche p.(n)))
      else begin
        Format.printf "defausse %d p%d;;\n" x n;
        P.defausse x p.(n)
      end
    done

end