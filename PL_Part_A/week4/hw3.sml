(* Coursera Programming Languages, Homework 3, Provided Code *)
exception NoAnswer

datatype pattern = Wildcard
                 | Variable of string
                 | UnitP
                 | ConstP of int
                 | TupleP of pattern list
                 | ConstructorP of string * pattern

datatype valu = Const of int
              | Unit
              | Tuple of valu list
              | Constructor of string * valu

fun g f1 f2 p =
  let
    val r = g f1 f2
  in
    case p of
      Wildcard          => f1 ()
    | Variable x        => f2 x
    | TupleP ps         => List.foldl (fn (p,i) => (r p) + i) 0 ps (* recursively call g for each pattern p in pattern list ps  *)
    | ConstructorP(_,p) => r p (* recursively call g for pattern p *)
    | _                 => 0
  end

(**** for the challenge problem only ****)
datatype typ = Anything
             | UnitT
             | IntT
             | TupleT of typ list
             | Datatype of string

(**** you can put all your code here ****)
(* 1. only_capitals *)
fun only_capitals lst =
  List.filter (fn s => Char.isUpper(String.sub(s, 0))) lst

(* 2. longest_string1 *)
fun longest_string1 lst =
  List.foldl (fn (s1, s2) => if (String.size s1) > (String.size s2) then s1 else s2) "" lst

(* 3. longest_string2 *)
fun longest_string2 lst =
  List.foldl (fn (s1, s2) => if (String.size s1) >= (String.size s2) then s1 else s2) "" lst

(* 4a. longest_string3; 4b. longest_string4 *)
fun longest_string_helper f lst =
  case lst of
    [] => ""
  | s::[] => s
  | s1::(s2::lst') => if f (String.size(s1), String.size(s2))
                      then longest_string_helper f (s1::lst')
                      else longest_string_helper f (s2::lst')
val longest_string3 = longest_string_helper (fn (x1, x2) => x1 >= x2)
val longest_string4 = longest_string_helper (fn (x1, x2) => x1 > x2)

(* 5. longest_capitalized *)
fun longest_capitalized lst =
  let
    val f = longest_string1 o only_capitals
  in
    f lst
  end

(* 6. rev_string *)
fun rev_string s =
  let
    val f = List.rev o String.explode
  in
    String.implode (f s)
  end

(* 7. first_answer *)
fun first_answer f lst =
  case lst of
    [] => raise NoAnswer
  | x::xs => case (f x) of
               NONE => first_answer f xs
             | SOME v => v

(* 8. all_answers *)
fun all_answers f lst =
  let fun helper f acc lst =
        case lst of
          [] => if acc = [] then NONE else SOME acc
        | x::xs => case (f x) of 
                     NONE => helper f acc xs
                   | SOME v => helper f (acc @ v) xs
  in
    if lst = [] then SOME [] else helper f [] lst
  end

(* 9a. count_wildcards; 9b. count_wild_and_variable_lengths; 9c. count_some_var *)
fun count_wildcards p =
  g (fn x => 1) (fn x => 0) p

fun count_wild_and_variable_lengths p =
  g (fn x => 1) (fn x => String.size(x)) p

fun count_some_var (s, p) =
  g (fn x => 0) (fn x => if s = x then 1 else 0) p

(* 10. check_pat *)
fun check_pat p =
  let
    fun extract p =
      case p of
        Variable x => [x]
      | TupleP ps => List.foldl (fn (p, acc) => (extract p) @ acc ) [] ps
      | ConstructorP (_, p) => extract p
      | _ => []
    fun duplicate lst = (* time complexity: n^2 *)
      case lst of
        [] => false
      | x::ys => List.exists (fn y => x = y) ys orelse duplicate ys
  in
    not(duplicate(extract(p)))
  end

(* 11. match *)
fun match(v, p) =
  case p of
    Wildcard => SOME []
  | Variable x => SOME [(x, v)]
  | UnitP => if v = Unit then SOME [] else NONE
  | ConstP i => if v = Const(i) then SOME [] else NONE
  | TupleP ps => (case v of
                    Tuple(vs) => if List.length(vs) = List.length(ps)
                                 then all_answers match (ListPair.zip(vs, ps))
                                 else NONE
                  | _ => NONE)
  | ConstructorP (s1, p) => (case v of
                              Constructor(s2, v2) => if s1 = s2 then match(v2, p) else NONE
                            | _ => NONE)

(* 12. first_match *)
fun first_match v ps =
  SOME(first_answer (fn p => match (v, p)) ps)
  handle NoAnswer => NONE

