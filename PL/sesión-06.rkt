(require mzlib/compat racket/function)

;; Para todas las funciones que se soliciten, y siempre que sea posible, deberá utilizarse
;; la currificación


;;-----------------------------------------------------------------------------------------
;; Dar la definición recursiva de la función addLast(l, l1, l2, ...) que dada una lista l
;; y una secuencia de listas l1, l2, ..., retorne la lista de listas (l1' l2' ...). Siendo 
;; cada li' la concatenación de li con la lista l.
;;-----------------------------------------------------------------------------------------

; Dado que  l1, l2, ... es una secuencia de un número indeterminado de listas y a
; todas ellas hay que concatenarlas la lista l, la recurrencia se establecerá sobre la lista
; resto = (l1 l2 ...)

; 1. Base       : resto es la lista vacía addLast(l) = ()
; 2. Recurrencia: resto NO es la lista vacía => resto = cons(car(resto), cdr(resto))
;;;               car(resto) = l1, cdr(resto) = (l2 l3 ...)
;;;    Hipótesis: se conoce addLast(l, l2, l3, ...) = H = apply(addLast, cons(l, cdr(resto))
;;;        Tesis: addLast(l, l1, l2, l3, ...) = cons(append(l1, l), H)


(define (addLast l . resto)
  (if (null? resto) resto
      (cons (append (car resto) l) (apply addLast (cons l (cdr resto))))))

(display "addLast: ")
(addLast '((a) b) () '(c) '(1 (2 3))) ;=> (((a) b) (c (a) b) (1 (2 3) (a) b))

;;-----------------------------------------------------------------------------------------
;; Definir la función addLast-FOS(l, l1, l2, ...) equivalente a la función previa, pero
;; utilizando FOS
;;-----------------------------------------------------------------------------------------

(define (addLast-FOS l . resto)
  (map (lambda(x) (append x l)) resto))

(display "addLast-FOS: ")
(addLast-FOS '((a) b) () '(c) '(1 (2 3))) ;=> (((a) b) (c (a) b) (1 (2 3) (a) b))

;;-----------------------------------------------------------------------------------------
;; Definir mediante FOS la función addLast+(ll, l1, l2, ...) que dada una lista de listas
;; ll y una secuencia de listas l1, l2, ..., retorne la lista de listas (l1' l2' ...).
;; Siendo cada li' la concatenación de li con cada una de las listas de ll en el mismo
;; orden que aparecen en ésta
;;-----------------------------------------------------------------------------------------

(define (addLast+ ll . resto)
  (apply addLast-FOS (cons (apply append ll) resto)))


(display "addLast+: ")
(addLast+ '((a) ((b) c)) () '(d) '(1 (2 3))) ;=> ((a (b) c) (d a (b) c) (1 (2 3) a (b) c))

;;------------------------------------------------------------------------------------
; Utilizar FOS para definir las funciones que se solicitan posteriormente, dada la
; definición del símbolo Manos que contienen la información dela situación de una
; partida del juego del UNO en un momento dado.
;
; Todas las cartas de la baraja del UNO tienen asociado un valor numérico entre 0 y 9
; o un valor simbólico correspondiente a distintas acciones: roba2, reversa, pierde-turno,
; comodin-color y comodin-roba4. Además, todas las cartas son de un color: azul, rojo,
; verde o amarillo, a excepción de los comodínes que se puedan utilizar con cualquier
; color. Por tanto, cada carta se representará por la lista de dos elementos (valor color),
; exceptuando los comodínes que se representarán mediante una lista de un elemento (su valor).

(define Manos
  '((ana    ((4 rojo) (9 rojo) (9 verde) (comodin-color) (9 verde) (8 verde) (3 azul)))
    (rosa   ((0 amarillo) (1 amarillo) (3 rojo) (8 azul) (4 verde) (3 rojo) (9 azul)))
    (luis   ((comodin-color) (8 amarillo) (5 rojo) (7 amarillo) (5 verde) (4 amarillo)))
    (pedro  ((7 amarillo) (1 rojo) (4 verde) (9 rojo) (7 rojo) (6 amarillo) (4 rojo)))
    (maria  ((7 verde) (8 amarillo) (0 rojo) (comodin-roba4) (3 verde) (8 verde) (3 azul)))
    (carmen ((8 azul) (5 verde) (5 amarillo) (6 amarillo) (3 amarillo) (6 azul) (pierde-turno azul)))
    (blanca ((3 amarillo) (1 rojo) (5 amarillo) (4 amarillo) (2 azul) (9 azul) (7 azul)))
    (quique ((9 amarillo) (reversa rojo) (2 rojo) (6 verde) (8 rojo) (1 azul) (1 verde)))))


;;------------------------------------------------------------------------------------
;; Definir la función cartas-mano(nombre, manos) que dado el nombre de un jugador de las
;; las manos de una partida del UNO retorna las cartas de éste:
;; la lista (nombre-del-jugador (mano-del-jugador)).
;;------------------------------------------------------------------------------------

(define (cartas-mano p data)
  (apply append (cdar (filter (lambda(x) (eq? (car x) p)) data))))


(display "cartas-mano: ")
(cartas-mano 'maria Manos) ;=> (maria ((7 verde) (8 amarillo) (0 rojo) (comodin-roba4) (3 verde) (8 verde) (3 azul)))

;;------------------------------------------------------------------------------------
;; Definir la función comodin?(cartas-mano) que retorna cierto si las cartas de la mano
;; de un jugador tiene un comodín y falso en caso contrario.
;;
;; Obsérvese que existen dos tipos de comodínes: comodin-color y comodin-roba4
;;------------------------------------------------------------------------------------

(define (comodin? x)
  (not (eq? (length (filter (lambda(n) (or (member 'comodin-color n) (member 'comodin-roba4 n))) x)) 0)))


(displayln "comodin? (filter)")
(display "comodin?(cartas de luis): ")
(comodin? (cartas-mano 'luis Manos)) ;=> #t
(display "comodin?(cartas de maria): ")
(comodin? (cartas-mano 'maria Manos)) ;=> #t
(display "comodin?(cartas de quique): ")
(comodin? (cartas-mano 'quique Manos)) ;=> #f

;;------------------------------------------------------------------------------------
;; Definir la función valor-compatible(valor, cartas-mano) que retorna la lista
;; de cartas de una mano cuyo valor (numérico o simbólico) es jugable para el valor
;; dado.
;;
;; Se considerará que una carta será de valor compatible si tiene el mismo valor
;; o bien si es un comodín.
;;------------------------------------------------------------------------------------

(define (valor-compatible v c)
  (cons
   (filter (lambda(n) (member v n)) c)
   (filter (lambda(n) (or (member 'comodin-color n) (member 'comodin-roba4 n))) c)
   ))


(display "valor-compatible(9, cartas de ana): ")
(valor-compatible 9 (cartas-mano 'ana Manos)) ;=> ((9 rojo) (9 verde) (9 verde) (comodin-color))
(display "valor-compatible(8, cartas de maría): ")
(valor-compatible 8 (cartas-mano 'maria Manos)) ;=> ((8 amarillo) (8 verde) (comodin-roba4))

;;------------------------------------------------------------------------------------
;; Definir la función color-compatible(color, cartas-mano) que retorna la lista de
;; cartas de una mano que son jugables para el color dado.
;;
;; Se considerará que una carta será de color compatible si tiene el mismo color o bien
;; si es un comodín.
;;------------------------------------------------------------------------------------



(display "color-compatible: ")
;(color-compatible 'verde (cartas-mano 'maria Manos)) ;=> ((7 verde) (3 verde) (8 verde) (comodin-roba4))
(display "color-compatible: ")
;(color-compatible 'rojo (cartas-mano 'pedro Manos)) ;=> ((1 rojo) (9 rojo) (7 rojo) (4 rojo))

;;------------------------------------------------------------------------------------
;; Definir la función compatibles(carta, cartas-mano) que retorna la lista de cartas
;; de una mano que son compatibles para la carta dada (para su valor o color). El
;; argumento carta siempre será una lista de dos elementos (valor color), incluso si la
;; carta es un comodín porque será el color elegido para continuar el juego.
;;
;; Una carta de la mano será compatible con la carta dada si es de valor o color
;; compatible con ésta.
;;------------------------------------------------------------------------------------




(display "compatibles: ")
;(compatibles '(9 rojo)
;             (cartas-mano 'ana Manos)) ;=> ((4 rojo) (9 rojo) (9 verde) (comodin-color) (9 verde))
(display "compatibles: ")
;(compatibles '(comodin-color verde)
;             (cartas-mano 'maria Manos)) ;=> ((7 verde) (comodin-roba4) (3 verde) (8 verde))

;;------------------------------------------------------------------------------------
;; Definir la función jugadores-con-comodin(manos) que retorna la lista de nombres de
;; jugadores que tienen en su mano un comodín.
;;------------------------------------------------------------------------------------




(display "jugadores-con-comodin: ")
;(jugadores-con-comodin Manos) ;=> (ana luis maria)

;;------------------------------------------------------------------------------------
;; Definir la función jugadores-cartas-compatibles(carta, manos) que retorna las cartas
;; compatibles con la carta dada que cada jugador tiene en su mano.  El argumento
;; carta siempre será una lista de dos elementos (valor color), incluso si la carta es
;; un comodín porque será el color elegido para continuar el juego.
;;------------------------------------------------------------------------------------




(displayln "jugadores-cartas-compatibles:")
;(jugadores-cartas-compatibles '(0 rojo) Manos)
;=> ((ana ((4 rojo) (9 rojo) (comodin-color)))
;    (rosa ((0 amarillo) (3 rojo) (3 rojo)))
;    (luis ((comodin-color) (5 rojo)))
;    (pedro ((1 rojo) (9 rojo) (7 rojo) (4 rojo)))
;    (maria ((0 rojo) (comodin-roba4)))
;    (carmen ())
;    (blanca ((1 rojo)))
;    (quique ((reversa rojo) (2 rojo) (8 rojo))))

;(jugadores-cartas-compatibles '(comodin-color verde) Manos)
;=> ((ana ((9 verde) (comodin-color) (9 verde) (8 verde)))
;    (rosa ((4 verde)))
;    (luis ((comodin-color) (5 verde)))
;    (pedro ((4 verde)))
;    (maria ((7 verde) (comodin-roba4) (3 verde) (8 verde)))
;    (carmen ((5 verde)))
;    (blanca ())
;    (quique ((6 verde) (1 verde))))

;;------------------------------------------------------------------------------------
; Dada la definición del símbolo Vectores, que es una lista de vectores de dimensión
; variable donde cada vector tiene un nombre y a continuación sus coordenadas, obtener
; las funciones que se solicitan posteriormente.
;;------------------------------------------------------------------------------------

(define Vectores
  '(v1 (12 2.5 -8 24 33)
    v2 (1 -2 3 0 7 -2.3 0 21)
    v3 (-12 2.8 3.5)
    v4 (-1 2 -2.3 5)
    v5 (-12.5 -3 8 5 24 0 -3 12)
    v6 (3 0 18 15 9 12.5)))

;;------------------------------------------------------------------------------------
;; Definir la función recursiva suma(l-nombres, l-vectores) que retorna la suma de
;; las coordenadas de los vectores de la lista l-vectores cuyo nombre figure en la
;; lista l-nombres. 
;;
;; Nota: se procurará evitar cálculos repetitivos
;;------------------------------------------------------------------------------------





(display "\nsuma('(v2 v3 v1 v7) Vectores): ")
;(suma '(v2 v3 v1 v7) Vectores) ;=> 85.5

;;------------------------------------------------------------------------------------
;; Definir la función recursiva producto(x, l-nombres, l-vectores) que retorna la
;; lista de vectores resultante de multiplicar por el escalar x cada uno de los vectores
;; de l-vectores cuyo nombre figure en la lista l-nombres. Para ello se propociona
;; la función por-escalar(x, componentes-vector) que retorne las componentes del
;; vector que se obtiene al multiplicar el vector de componentes especificadas por el
;; escalar x.
;;
;; Nota: se procurará evitar cálculos repetitivos
;;------------------------------------------------------------------------------------

(define (por-escalar x componentes-vector)
  (map (curry * x) componentes-vector))




(displayln "\nproducto(0.5, (v1 v7 v3), Vectores):")
;(producto 0.5 '(v1 v7 v3) Vectores) ;=> (v1 (6.0 1.25 -4.0 12.0 16.5) v3 (-6.0 1.4 1.75))

;; En la solución que se proporciona para el ejemplo, producto(0.5, (v1 v7 v3), Vectores), los
;; vectores resultantes se nombran como v1 y v3, pero estos vectores no tienen las misma componentes
;; (no son los mismos vectores) que los v1 y v3 dados en la lista Vectores.
;;
;; Modifica la definición dada para la función producto(x, l-nombres, l-vectores) para que en
;; el resultados los vectores se nombren en la forma x*vi. Para ello deberán utilizarse las
;; siguientes funciones predefinidas:
;;    symbol->string(símbolo) que retorna la cadena correspondiente al símbolo dado
;;    number->string(número) que retorna la cadena correspondiente al número especificado
;;    string->symbol(cadena) que retorna el símbolo correspondiente a la cadena dada
;;    string-append(s1, s2, ...) que retorna la concatenación de las cadenas especificadas




;(producto 0.5 '(v1 v7 v3) Vectores) ;=> (0.5*v1 (6.0 1.25 -4.0 12.0 16.5) 0.5*v3 (-6.0 1.4 1.75))

;;------------------------------------------------------------------------------------
;; Utilizar FOS para proporcionar una expresión que permita obtener la suma de todas
;; las componentes de los vectores de Vectores
;;------------------------------------------------------------------------------------

(display "\nsuma de todas las componentes: ") ;=> 177.2



;;------------------------------------------------------------------------------------
;; Utilizar FOS para proporcionar una expresión que permita obtener una lista con el
;; nombre de cada vector y a continuación, en lugar de sus componentes, el número de
;; éstas.
;;------------------------------------------------------------------------------------

(display "\nnúmero de componentes: ") ;=> (v1 5 v2 8 v3 3 v4 4 v5 8 v6 6)


