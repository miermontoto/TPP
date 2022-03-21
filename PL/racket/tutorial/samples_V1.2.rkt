#lang racket
(require racket/string mzlib/string mzlib/compat)

(provide ejemplos)
(provide comentarios)

;;; Estructura de un ejemplo: '(expr-str string boolean1 [boolean2])
;;;
;;; expr-str: la expresión resultante como string (solución). Si el ejemplo
;;;           es guiado se proporciona al usuario en el enunciado.
;;; string  : para un ejemplo no guiado el enunciado de éste. En ejemplos
;;;           guiados, si comienza por "  ;;" es una explicación del
;;;           resultado. En caso contrario, y si no es la cadena vacía,
;;;           es parte del enunciado del problema.
;;; boolean1: indica si el ejemplo es guiado.
;;; boolean2: opcional y de valor por defecto #f. Únicamente es necesario
;;;           en ejemplos guiados, a #t, para indicar que el ejemplo
;;;           provocará un error (p.e. por haber un símbolo indefinido)

(define samples
  (vector-immutable
   '("2" "  ;; retorna 2 (entero), un átomo numérico se evalua a si mismo" #t)                                    ;  0
   '("3.5" "  ;; retorna 3.5 (real), un átomo numérico se evalua a si mismo" #t)                                  ;  1
   '("+" "  ;; retorna #<procedure:+>, indica que el átomo + es una función (la suma)" #t)                        ;  2
   '("a" "  ;; error, el átomo a no está definido" #t #t)                                                         ;  3
   '("(+ 0 1 2)" "  ;; retorna 3 (la suma del resto de elementos)" #t)                                            ;  4
   '("()"  "  ;; retorna (), la lista vacía. Única S-expresión que es lista y átomo simultáneamente" #t)          ;  5 
   '("(list? ())" "  ;; retorna #t (cierto). Es una lista." #t)                                                   ;  6
   '("(atom? ())" "  ;; retorna #t (cierto). Es un átomo." #t)                                                    ;  7
   '("(pair? ())" "  ;; retorna #f (falso). Como () es un átomo, es indivisible, no es un par de car y cdr" #t)   ;  8
   '("(a (b c))" "  ;; error, el primer elemento no es una función (no está definido)" #t #t)                     ;  9
   '("((+ 1 2) 3 4)" "  ;; error, el primer elemento no retorna una función (retorna 3)" #t #t)                   ; 10
   '("(quote a)" "  ;; retorna el dato atómico a" #t)                                                             ; 11
   '("(quote (a (b c)))" "  ;; retorna el dato lista (a (b c))" #t)                                               ; 12
   '("'a" "  ;; retorna el átomo a" #t)                                                                           ; 13
   '("'(a (b c))" "  ;; retorna el dato lista (a (b c))" #t)                                                      ; 14
   '("'(+ 0 1 2)" "  ;; retorna el dato lista (+ 0 1 2), en lugar de 3 (no se evalúa)" #t)                        ; 15
   '("'(zero? 0)" "  ;; retorna la lista (zero? 0), en lugar de #t (no se evalúa)" #t)                            ; 16
   '("'atom?" "  ;; retorna el átomo atom?, en lugar de #<procedure:atom?> (no se evalúa)>" #t)                   ; 17
   '("'2"  "  ;; retorna 2" #t)                                                                                   ; 18
   '("'#f" "  ;; retorna #f" #t)                                                                                  ; 19
   '("(cons 'a '(b c))" "  ;; retorna la lista (a b c), (car '(a b c)) = a y (cdr '(a b c)) = (b c)" #t)          ; 20
   '("(car '(a b c))" "  ;; retorna a" #t)                                                                        ; 21
   '("(cdr '(a b c))" "  ;; retorna (b c)" #t)                                                                    ; 22
   '("(cons '(a b) '((c) d e))" "  ;; retorna ((a b) (c) d e)" #t)                                                ; 23
   '("(car '((a b) (c) d e))" "  ;; retorna (a b)" #t)                                                            ; 24
   '("(cdr '((a b) (c) d e))" "  ;; retorna ((c) d e)" #t)                                                        ; 25
   '("(cons 'a 'b)" "  ;; retorna (a . b), s-expresión válida de car='a' y cdr='b', pero que no es una lista" #t) ; 26
   '("(car '(a . b))" "  ;; retorna el átomo a" #t)                                                               ; 27
   '("(cdr '(a . b))" "  ;; retorna el átomo b" #t)                                                               ; 28
   '("(atom? '(a . b))" "  ;; retorna #f, no es un átomo" #t)                                                     ; 29
   '("(pair? '(a . b))" "  ;; retorna #t, (a . b) es una s-expresión válida (contruida con un par: car y cdr)" #t); 30
   '("(list? '(a . b))" "  ;; retorna #f, no es una lista" #t)                                                    ; 31
   '("(list? (cons '(a) '(b c)))" "  ;; retorna #t" #t)                                                           ; 32
   '("(pair? (cons '(a) '(b c)))" "  ;; retorna #t" #t)                                                           ; 33
   '("(car (cons '(a) '(b c)))" "  ;; retorna (a), el primer argumento del cons" #t)                              ; 34
   '("(cdr (cons '(a) '(b c)))" "  ;; retorna (b c), el segundo argumento del cons" #t)                           ; 35
   '("(car (car (cdr '(b (a c) d))))" ", para obtener el átomo a" #t)                                             ; 36
   '("(caadr '(b (a c) d))" ", para obtener el átomo a" #t)                                                       ; 37
   '("(cons 'b (cons (cons 'a (cons 'c ())) (cons 'd ())))" "" #t)                                                ; 38
   '("(cadar '((d c) (a) b))"
     "Obtener el átomo 'c' de la lista '((d c) (a) b)'
                    Usar sólo la función cXr apropiada (X secuencia de hasta 4 caracteres 'a' o 'd')" #f)         ; 39
   '("(cons (cons 'd (cons 'c ())) (cons (cons 'a ()) (cons 'b ())))"
     "Construir la lista '((d c) (a) b)' a partir de sus átomos" #f)                                              ; 40
   '("(cons (cons 'b (cons 'a ())) (cons (cons 'c (cons 'd ())) ()))"
     "Construir la lista '((b a) (c d))' a partir de sus átomos" #f)                                              ; 41
   '("(cadadr '((b a) (c d)))"
     "Obtener el átomo 'd' de la lista '((a b) (c d))'
                    Usar sólo la función cXr apropiada (X secuencia de hasta 4 caracteres 'a' o 'd')" #f)         ; 42
   '("(cons (cons (cons 'd ()) (cons 'a ())) (cons (cons 'b ()) (cons 'c ())))"
     "Construir la lista '(((d) a) (b) c)' a partir de sus átomos" #f)                                            ; 43
   '("(caaar '(((d) a) (b) c))"
     "Obtener el átomo 'd' de la lista '(((d) a) (b) c))'
                    Usar sólo la función cXr apropiada (X secuencia de hasta 4 caracteres 'a' o 'd')" #f)         ; 44
   '("(cons (cons 'a (cons 'b ())) (cons (cons (cons 'd ()) ()) (cons (cons 'c ()) ())))"
     "Construir la lista '((a b) ((d)) (c))' a partir de sus átomos" #f)                                          ; 45
   '("(caaadr '((a b) ((d)) (c)))"
     "Obtener el átomo 'd' de la lista '((a b) ((d)) (c))'
                    Usar sólo la función cXr apropiada (X secuencia de hasta 4 caracteres 'a' o 'd')" #f)         ; 46
   )
)


(define comments (make-vector (vector-length samples) null))

(vector-set!
 comments 0
 ";;; Se van a manejar datos simbólicos: S-expresiones, que son átomos
;;; (indivisibles) o pares de S-expresiones (el car y el cdr). Por el
;;;; momento, de ésto últimos nos centraremos en el subconjunto de las
;;; listas (pares de S-expresiones cuyo cdr es otra lista).

;;; Los átomos son símbolos. Ejemplos: 2, 3.5, +, , *, car, cdr, atom?,
;;; pair?, #t, #f. La evaluación de un átomo correspondiente a un valor
;;; (números, booleanos) es el propio valor. En cualquier otro caso, un
;;; átomo sólo se evalúa si está definido, por ejemplo, como función (+,
;;; -, car, cdr, pair?, etc.) y si no está definido se produce un error.")

(vector-set!
 comments 4
 ";;; Las listas son secuencias de S-expresiones encerradas entre paréntesis,
;;; incluida la lista vacía: (). Como se está restringiendo el uso de pares
;;; de S-expresiones a listas, los elementos de éstas podrán ser átomos u
;;; otras listas. Ejemplos: (), (a), (2 b (3)), etc.
;;; Si se evalua una lista, el intérprete asume que el primer elemento de
;;; ésta es una función que se aplica al resto de elementos (sus argumentos).
;;; Si el primer elemento de la lista no es una función (o una lista que
;;; se evalue a una función) se produce un error.")
  
(vector-set!
 comments 11
 ";;; La información (datos) que maneja un programa son también S-expresiones
;;; y para indicar al intérprete que una S-expresión es un dato y, por
;;; tanto que no se ha de evaluar, se utiliza la función: quote. La función
;;; require un argumento y retorna éste (el dato).")
  
(vector-set!
 comments 13
 ";;; Como proporcionar datos (S-expresiones) a los programas va a ser algo
;;; habitual (los programas manipulan información o datos), existe una
;;; forma abreviada equivalente de utilizar la función quote: anteponer un
;;; apostrofe (') a los datos (S-expresiones).")
  
(vector-set!
 comments 20
 ";;; La función 'cons' permite construir una S-expresión dadas dos
;;; S-expresiones. La primera es el 'car' del nuevo par y la segunda el
;;; 'cdr'. De momento, esta última está limitada a ser una lista, por
;;; lo que se construye otra lista.

;;; El 'car' de una lista no vacía, es su primer elemento y el 'cdr' de
;;; una lista no vacía es una copia de la misma sin su primer elemento
;;; (el car).")
  
(vector-set!
 comments 26
 ";;; Si ahora se invoca la función 'cons' con un segundo argumento que no
;;; sea una lista, por ejemplo con un átomo que no sea la lista vacía, se
;;; obtendrá una S-expresión (un par de 'car' y 'cdr') que no es una lista.")
  
(vector-set!
 comments 32
 ";;; En adelante, en las clases prácticas (no así en las de teoría) sólo
;;; se trabajará con el subconjunto de S-expresiones constituido por átomos
;;; y listas, dejando al margen los pares que no sean listas.

;;; En el intérprete los pares que no son listas se representan entre
;;; paréntesis y se utiliza el caracter '.' para separar el 'car' y el 'cdr'.
;;; Como este tipo de S-expresiones no se van a utilizar en las clases
;;; prácticas, los ejercicios que se desarrollen nunca tendrán como resultado
;;; una S-expresión con puntos. Si así fuere, será porque la solución dada
;;; es errónea.")
  
(vector-set!
 comments 36
 ";;; Las funciones 'car' y 'cdr' permiten, mediante composición, acceder a
;;; cualquier átomo o sublista de una lista, con independencia del nivel en
;;; el que se encuentren.")
  
(vector-set!
 comments 37
 ";;; Para facilitar la composición de las funciones 'car' y 'cdr' y que las
;;; S-expresiones resultantes sean más cortas, existen funciones predefinidas
;;; que realizan todas las composiciones posibles de hasta 4 'car' o 'cdr'.
;;; Estas funciones se nombran como 'cXr', donde X puede tener hasta 4
;;; letras 'a' o 'd' según la función que se componga 'car' o 'cdr',
;;; respectivamente. Ejemplos:
;;; '(cadr x)' equivale a '(car (cdr x))'
;;; '(caar x)' equivale a '(car (car x))'
;;; '(caadar x)' equivale a '(car (car (cdr (car x))))'")
  
(vector-set!
 comments 38
 ";;; Cualquier lista se puede obtener a partir de sus átomos individuales
;;; utilizando, exclusivamente, la función 'cons'. En el siguiente ejemplo
;;; se verá como obtener la lista: '(b (a c) d). Aquí se presenta la solución
;;; por pasos (evaluación de izquierda a derecha):
;;; Inicial: (cons 'b (cons (cons 'a (cons 'c ())) (cons 'd ())))
;;; Paso 1 : (cons 'b (cons (cons 'a (cons 'c ())) '(d))))
;;; Paso 2 : (cons 'b (cons (cons 'a '(c)) '(d))))
;;; Paso 3 : (cons 'b (cons '(a c) '(d)))
;;; Paso 4 : (cons 'b '((a c) d))
;;; Paso 5 : (b (a c) d)")

(vector-set!
 comments 39
 ";;; En los ejemplos restantes el tutorial no proporciona la expresión a
;;; evaluar, en su lugar se presenta un ejercicio simple que se soluciona
;;; mediante una expresión que se ha de proporcionar. Tienes tres intentos
;;; para dar la expresión correcta, trás tres intentos fallidos el tutorial
;;; te facilitará la solución.")

(define ejemplos samples)
(define comentarios comments)
