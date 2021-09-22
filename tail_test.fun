fun test( a ; b ) =
    if a == 0
    then b
    else test( 0 ; a + 1 )