fun fat_tail_aux( x ; p ) =
    if x == 0
    then 1 else if x == 1
                then p
                else x * fat_tail_aux( x - 1 ; p ),

fun fat_tail(x) =
    fat_tail_aux( x ; 1 )