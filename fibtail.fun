fun fib_tail_aux( n ; a ; b ) =
    if n > 0
    then fib_tail_aux( n - 1 ; b ; a + b )
    else a,

fun fib_tail(x) =
    fib_tail_aux( x ; 0 ; 1 )