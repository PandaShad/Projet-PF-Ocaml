# Partie 1 - Mariages Stables
## Knuth :
Implémentation réussis de l'algorithme de Knuth, on suppose ici que les hommes proposent et que les femmes disposent, afin de tester sur un exemple donné dans le fichier test/marriages_stables/exemple.ml il suffit d'éxécuter la commande suivante ( en supposant que dune est bien installer ):
```bash
dune runtest test/marriages_stables/knuth
```
Voici les données utilisé pour ce test, elles sont modifiables à souhait. Veuillez à toujours donné n nombre de femmes/hommes dans la liste d'appel de chacun ainsi que dans la liste de preference.
```bash
{
    n = 4;
    liste_appel_de = [|
      [|c;b;d;a|];
      [|b;a;c;d|];
      [|b;d;a;c|];
      [|c;a;d;b|];
    |];
    prefere = prefere_of [|
      [|a;b;d;c|];
      [|c;a;d;b|];
      [|c;b;d;a|];
      [|b;a;c;d|]
    |]
  }
```
## Gale-Shapley

Implémentation réussis de l'algorithme de Gale-Shapley, on suppose ici aussi que les hommes proposent et que les femmes disposent, afin de tester sur un exemple donné dans le fichier test/marriages_stables/exemple.ml il suffit d'exécuter la commande suivante ( en supposant que dune est bien installer ):
```bash
dune runtest test/marriages_stables/gale_shapley
```

## Algo-Abstrait

Implémentation réussis de l'algorithme Abstrait, c’est un algorithme qui prend en paramètre une structure de données ( soit une file, soit une pile ).
On peut se convaincre que l’algorithme de Knuth correspond à cet algorithme dans lequel la pioche est une pile, tandis que l’algorithme de Gale-Shapley correspond au cas où la pioche est une file.

Chaque structure de données à été implémenté sous forme de modules, tout d'abord on a un module PIOCHE dont hérite les deux autres modules Pile et File.
```bash
dune runtest test/marriages_stables/algo_abstrait
```
# Partie 2 - Parcoursup
Le fonctionnement de chaque fonction est décrit dans le fichier src/parcoursup/api.mli

Le but de cette implémentation est de simuler le comportement d'une session parcoursup jour après jour ( sans traiter les cas particuliers tels que les élèves boursiers par exemple ). On se doit de respecter un certain ordre d'exécution tout d'abord : 

- On définit ce qu'est une session
- On exécute les fonctions de la phase de configuration ( tels quel ajoute_candidat )
- On réunit les commissions en appelant la fonction reunit_commisions
- On appelle nouveau_jour qui s'occupe d'actualiser la session en fonction des propositions effectuées
- On peut consulter l'état de la session avec les fonctions consulte_propositions et consulte_voeux_en_attente
- Un candidat peut renoncer à n'importe qu'elle proposition reçue lors de la phase d'appel
- On appelle nouveau_jour autant de jour que l'on veut simuler

Nous avons décider d'utiliser des Array mutable comme structure de données pour la plupart des données stockées dans sessions, une session consiste en un tableau de candidat et de formation où
- Candidat est un type définit avec : 
 ```bash 
type candidat = { 
  name : string;
  mutable voeux : voeux array;
  mutable propositions : voeux array
}
```
- Formation est un type définit avec : 
 ```bash 
type formation = {
  name : string;
  mutable places_restantes : int;
  mutable preference : string array;
  mutable rang_appel : int;
  mutable commision : (candidat1:string -> candidat2:string -> bool) option;
}
```
- Voeux est un type définit avec : 
 ```bash 
type voeux = {
  voeux_name : string;
  mutable rang_repondeur : int option;
}
```
- Et enfin session :
 ```bash 
type session = {
  mutable candidats : candidat array;
  mutable formations : formation array;
}
```
Ainsi que quelques définitions de plusieurs fonctions utilitaires :
- get_formation pour obtenir une formation à partir d'une string
- get_candidat pour obtenir un candidat à partir d'une string
- get_voeux pour obtenir un voeux à partir d'une string représentant le nom d'un candidat et d'une autre strinf pour le nom de la formation concernée
- quick : implémentation d'un quicksort en Ocaml prenant en paramètre la liste a triée et la fonction de comparaison

## Issues
La fonction nouveau_jour est très bordélique, il y a surement une bien meilleure implémentation possible en terme de complexité et de taille. De plus le fait d'avoir choisis des Arrays comme structure de données nous empêche d'utiliser filter pour retirer un élement et nous oblige à réaliser cette ligne barbare :
```bash
Array.of_list (List.filter (fun v -> not(String.equal v.voeux_name voeux_qui_propose.voeux_name)) (Array.to_list candidat.voeux));
```
Aussi il aurait était préférable d'utiliser des Hashtbl plutot que des Arrays, mais malheureusement nous n'avons pas eu le temps de modifier tout parcoursup pour le rendre compatible avec les Hashtbl, peut être pour une future update avant le partiel :)



## Tests
Les tests persos se trouvent dans le dossier test_perso, nos 5 tests passent sans problèmes, mais il est possible que certains tests ne fonctionnent pas. En effet je pense que sous certaines conditions le rang d'appel est augmenté de 1 de trop et donc la personne en position 0 pourrait se retrouver en position -1 et donc ne jamais recevoir de propositions qu'importe le nombre d'appel à nouveau_jour !



## Conclusion
Petit manque de temps pour transformer tout les Array en Hashtb, grosse prise de tête sur nouveau_jour, et beaucoup d'optimisation possible de partout, mais au final ce fut un projet enrichissant  et très interressant. Ocaml est un language particulier mais puissant et je suis curieux d'en connaitre les limites, il y a de forte chances que l'on revienne sur se projet ou d'en commencer un autre en Ocaml, sur github il existe un space invader en Ocaml et j'avoue que le challenge me plait