# Trabalho de conclusão do curso de Compiladores 2021.1

Christiano Braga  
Instituto de Computação  
Universidade Federal Fluminense

- Data de entrega: 24/09/2021

## Objetivo

Estender a linguagem Fun e seu interpretador com suporte a definição
de uma função com um número indefinido de parâmetros e sua chamada.

## Etapas

 ### 1. Modifique a gramática de Fun para dar suporte a declaração de funções com vários paraâmetros.

   Foram modificados os módulos ```FUN-LEX``` ... dando suporte ao delimitador de parâmetros ```;``` 
```BNF
---|suporte à palavra reservada ; que delimita os parametros de função
     eq keywords = ('fun '`( '`) '= '`, '~ '+ '- '* '/ '>= '> '<= '< '== 'or 'and 'if 'then 'else ';) .
```
   e o ```FUN-GRM```
```BNF
inc LISPIDEXP .
...
---| definicao de função suporta uma lista de identificadores agora também
op fun_(_) =_ : Idn  List  Expr -> Expr [prec 50] .
---| chamada de função suporta uma lista de expressões agora também
op _(_) : Idn List -> Expr [prec 10] .```
```         
   Foi criado um novo fonte Maude ```lisp-id-exp.maude``` contendo as operações básicas de Listas de Expressões e Ids dando suporte à Gramática

 ### 2. Modifique o compilador de Fun para Π IR de forma que declarações e expressões apropriadas sejam geradas a partir do código Fun.

   Foi modificado o módulo ```FUN-TRAN2``` para que as declarações de funções e expressões (chamadas) envolvendo funções com múltiplos parâmetros tenham sentido e,
   gerem corretamente código Π IR que trate correspondentemente estes casos

```BNF
    ---| agora pode receber na declaração uma lista de ids que nada mais é do que FORMAIS
     eq compileExpr(fun I1 (argumentos) = E) = compileDec(fun I1 (argumentos) = E) .

    ---| agora na hora de chamar, pode receber uma lista de expressões que nada mais é do que ATUAIS
     eq compileExpr(I(argumentos)) = recapp(compileIdn(I), ẞ₂(argumentos)) .

    ---| agora na hora de compilar a declaração , pode receber uma lista de ids
     eq compileExpr((fun I1 (argumentos) = E1, E2)) =
        let(compileDec(fun I1 (argumentos) = E1), compileExpr(E2)) .

    ---| agora na hora de compilar a chamada, pode receber uma lista de expressões
     op compileDec : Expr -> Dec .
     eq compileDec(fun I1 (argumentos) = E) =
        rec(compileIdn(I1), lambda(ẞ₁(argumentos) , compileExpr(E))) .

    ---| OPERADORES ESZETT (ẞ) tratam as listas e as transformam em ou Formais ou Atuais seguido da compilação do restante do código
     op ẞ₁ : List ->  Formals .
     eq ẞ₁(argumentos) = if cdr(argumentos) == nil then compileIdn(car₁(argumentos))
                                                 else  compileIdn(car₁(argumentos)) ẞ₁(cdr(argumentos))
                           fi .
     op ẞ₂ : List -> Actuals .
     eq ẞ₂(argumentos) =  if cdr(argumentos) == nil then compileExpr(car₂(argumentos))
                                                       else  ẞ₂(cdr(argumentos)) compileExpr(car₂(argumentos))
                             fi .
    ---| OPERADORES ESZETT (ẞ)
```         


 ### 3. Teste sua estensão implementando versões que utilizem recursão de cauda (_tail recursion_) das funções ```fat``` e ```fib```. Modifique também o exemplo da função ```apply```.
   
   Foram criados alguns códigos testes ```apply2.fun``` que recebe uma função e uma variavel x como parâmetro e depois chama aplicando x, e ```teste_parametros.fun``` 
   que faz o teste de declaração e chamada de função com múltiplos parâmetros, além de se testar funções e expressões como eram antes das novas implementações, a seguir os outputs 


Apply modificado ```apply2.fun```

```BNF
fun fat(x) =
    if x == 0
    then 1
    else x * fat(x - 1),

fun apply( f ; x ) =
    f(x)
```


Função que testa uso de múltiplos parâmetros ```teste_parametros.fun```

```BNF
fun teste( x ; y ; z ; t ) =
    x + y * ( z - t )
```



Outputs

```BNF
E:\incoming\Biblioteca2\Livros\Ci�ncia da Computa��o\Compiladores\compiler_tools2\maudeFunTrabWinLinux>wsl ./maude.linux64 -no-banner -allow-files fun-io 
🎉 Fun Interpreter
Beta version, Sep. 2021
Fun > fload("fat.fun")
File fat.fun loaded!
Fun > run("fat(100)")
93326215443944152681699238856266700490715968264381621468592963895217599993229915608941463976156518286253697920827223758251185210916864000000000000000000000000
Fun > fload("teste_parametros.fun")
File teste_parametros.fun loaded!
Fun > run("teste( 1 ; 2 ; 3 ; 4 )")
-3
Fun > fload("apply2.fun")
File apply2.fun loaded!
Fun > run("apply( fat ; 10 )")
3628800
Fun > q
result Portal: <>
Bye.
```

   Por fim, foram implementadas versões com (_tail recursion_) das funções ```fat``` e ```fib``` são os fontes respectivamente  ```fattail.fun```  e ```fibtail.fun``` 
   que realiza o teste de chamada recursiva de funções com múltiplos parâmetros, a seguir os fontes e outputs destas funções 
   mostrando os mesmos resultados com as mesmas entradas para ambas as versões dos dois códigos , demonstrando assim
   que ambas as versões dos dois códigos , são equivalentes.


Fatorial versão (_tail recursion_) (```fattail.fun```)
```BNF
fun fat_tail_aux( x ; p ) =
    if x == 0
    then 1 else if x == 1
                then p
                else x * fat_tail_aux( x - 1 ; p ),

fun fat_tail(x) =
    fat_tail_aux( x ; 1 )
```

Fibonacci versão (_tail recursion_) (```fibtail.fun```)
```BNF
fun fib_tail_aux( n ; a ; b ) =
    if n > 0
    then fib_tail_aux( n - 1 ; b ; a + b )
    else a,

fun fib_tail(x) =
    fib_tail_aux( x ; 0 ; 1 )
```

Outputs:   
```BNF
E:\incoming\Biblioteca2\Livros\Ci�ncia da Computa��o\Compiladores\compiler_tools2\maudeFunTrabWinLinux>wsl ./maude.linux64 -no-banner -allow-files fun-io 
🎉 Fun Interpreter
Beta version, Sep. 2021
Fun > fload("fattail.fun")
File fattail.fun loaded!
Fun > run("fat_tail(0)")
1
Fun > run("fat_tail(1)")
1
Fun > run("fat_tail(10)")
3628800
Fun > fload("fat.fun")
File fat.fun loaded!
Fun > run("fat(0)")
1
Fun > run("fat(1)")
1
Fun > run("fat(10)")
3628800
Fun > fload("fib.fun")
File fib.fun loaded!
Fun > run("fib(0)")
0
Fun > run("fib(1)")
1
Fun > run("fib(2)")
1
Fun > run("fib(9)")
34
Fun > fload("fibtail.fun")
File fibtail.fun loaded!
Fun > run("fib_tail(0)")
0
Fun > run("fib_tail(1)")
1
Fun > run("fib_tail(2)")
1
Fun > run("fib_tail(9)")
34
Fun > q
result Portal: <>
Bye.
```