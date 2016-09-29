(* 1. Function is_older *)
fun is_older (date1 : int*int*int, date2 : int*int*int) =
    if #1 date1 < #1 date2
    then true
    else if #1 date1 > #1 date2
    then false 
    else
        if #2 date1 < #2 date2
        then true
        else if #2 date1 > #2 date2
        then false
        else
            if #3 date1 < #3 date2
            then true
            else false

(* 2. Function number_in_month *)
fun number_in_month (ld : (int*int*int) list, m : int) =
    if null ld
    then 0
    else
        if (#2 (hd ld)) = m
        then 1 + number_in_month(tl(ld), m)
        else number_in_month(tl(ld), m)

(* 3. Function number_in_months *)
fun number_in_months (ld: (int*int*int) list, lm : int list) =
    if null lm
    then 0
    else number_in_month(ld, hd(lm)) + number_in_months(ld, tl(lm))

(* 4. Function dates_in_month *)
fun dates_in_month (ld : (int*int*int) list, m : int) =
    if null ld
    then []
    else
        if (#2 (hd ld)) = m
        then hd(ld) :: dates_in_month(tl ld, m)
        else dates_in_month(tl ld, m)

(* 5. Function dates_in_months *)
fun dates_in_months (ld : (int*int*int) list, lm : int list) =
    if null lm
    then []
    else dates_in_month(ld, hd lm) @ dates_in_months(ld, tl lm)

(* 6. Function get_nth *)
fun get_nth (ls : string list, n : int) =
    if n = 1
    then hd ls
    else get_nth(tl ls, n-1)

(* 7. Function date_to_string *)
fun date_to_string (date : int*int*int) =
    let
        val m = get_nth(["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"], (#2 date))
        val d = Int.toString(#3 date)
        val y = Int.toString(#1 date)
    in
        m ^ " " ^ d ^ ", " ^ y
    end

(* 8. Function number_before_reaching_sum *)
fun number_before_reaching_sum (s : int, ln : int list) =
    if s <= hd ln
    then 0
    else 1 + number_before_reaching_sum(s - hd ln, tl ln)

(* 9. Function what_month *)
fun what_month (d : int) =
    1 + number_before_reaching_sum(d, [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31])

(* 10. Function month_range *)
fun month_range (d1 : int, d2 : int) =
    if d1 > d2
    then []
    else what_month(d1) :: month_range(d1 + 1, d2)

(* 11. Function oldest *)
fun oldest (ld : (int*int*int) list) =
    if null ld
    then NONE
    else
        let
            fun oldest_nonempty (ld : (int*int*int) list) =
                if null (tl ld)
                then hd ld
                else
                    let
                        val tl_ans = oldest_nonempty(tl ld)
                    in
                        if is_older(hd(ld), tl_ans)
                        then hd ld
                        else tl_ans
                    end
        in
            SOME (oldest_nonempty ld)
        end

