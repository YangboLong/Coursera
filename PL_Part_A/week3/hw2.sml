(* Dan Grossman, Coursera PL, HW2 Provided Code *)

(* if you use this function to compare two strings (returns true if the same
string), then you avoid several of the functions in problem 1 having
polymorphic types that may be confusing *)
fun same_string(s1 : string, s2 : string) =
  s1 = s2

(* put your solutions for problem 1 here *)
(* a. all_except_option *)
fun all_except_option(str, lst) =
  case lst of
    [] => NONE
  | head::lst' => if same_string(head, str)
                  then SOME(lst')
                  else let val opt = all_except_option(str, lst')
                       in case opt of
                            NONE => NONE
                          | SOME(xs) => SOME(head::xs)
                       end

(* b. get_substitutions1 *)
fun get_substitutions1(lst, str) =
  case lst of
    [] => []
  | x::xs => let val opt = all_except_option(str, x)
             in case opt of
                  NONE => get_substitutions1(xs, str)
                | SOME(y) => y @ get_substitutions1(xs, str)
             end

(* c. get_substitutions2 *)
fun get_substitutions2(lst, str) =
  let fun aux(lst, acc) =
    case lst of
      [] => acc
    | x::xs => let val opt = all_except_option(str, x)
               in case opt of
                    NONE => aux(xs, acc)
                  | SOME(y) => aux(xs, y @ acc)
               end
  in
    aux(lst, [])
  end

(* d. similar_names *)
fun similar_names(lst, {first = x, middle = y, last = z}) =
  let val xs = get_substitutions2(lst, x)
      fun aux(xs, acc) =
        case xs of
          [] => acc
        | x::xs' => aux(xs', acc @ [{first = x, middle = y, last = z}])
  in
    aux(xs, [{first = x, middle = y, last = z}])
  end

(* you may assume that Num is always used with values 2, 3, ..., 10
though it will not really come up *)
datatype suit = Clubs | Diamonds | Hearts | Spades
datatype rank = Jack | Queen | King | Ace | Num of int
type card = suit * rank

datatype color = Red | Black
datatype move = Discard of card | Draw

exception IllegalMove

(* put your solutions for problem 2 here *)
(* a. card_color *)
fun card_color(card) =
  case card of
    (Clubs, _) => Black
  | (Spades, _) => Black
  | (Diamonds, _) => Red
  | (Hearts, _) => Red 

(* b. card_value *)
fun card_value(card) =
  case card of
    (_, Num i) => i
  | (_, Ace) => 11
  | _ => 10

(* c. remove_card *)
fun remove_card(cs, c, ex) =
  case cs of
    [] => raise ex
  | c'::cs' => if c = c' then cs'
               else c'::remove_card(cs', c, ex)

(* d. all_same_color *)
fun all_same_color(cs) =
  case cs of
    [] => true
  | c::[] => true
  | c1::(c2::cs') => (card_color(c1) = card_color(c2) andalso all_same_color(c2::cs'))

(* e. sum_cards *)
fun sum_cards(cs) =
  let fun aux(cs, acc) =
        case cs of
          [] => acc
        | c::cs' => aux(cs', card_value(c) + acc)
  in
    aux(cs, 0)
  end

(* f. score *)
fun score(cs, goal) =
  let
    val sum = sum_cards(cs)
    val preliminary = if sum > goal then 3 * (sum - goal) else goal - sum;
  in
    if all_same_color(cs)
    then preliminary div 2
    else preliminary
  end

(* g. officiate *)
fun officiate(card_list, move_list, goal) =
  let
    fun mov(card_list, move_list, held_cards) =
      case move_list of
        [] => score(held_cards, goal)
      | m::ms => case m of
                   Discard c => let val held_cards = remove_card(held_cards, c, IllegalMove)
                                in mov(card_list, ms, held_cards)
                                end
                 | Draw => case card_list of
                             [] => score(held_cards, goal)
                           | c::cs => let val held_cards = c::held_cards
                                          val card_list = remove_card(card_list, c, IllegalMove)
                                      in if sum_cards(held_cards) > goal
                                         then score(held_cards, goal)
                                         else mov(card_list, ms, held_cards)
                                      end
  in
    mov(card_list, move_list, [])
  end

