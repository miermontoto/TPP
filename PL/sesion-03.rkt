;; PROGRAMACION FUNCIONAL
;; FUNCIONES DE ORDEN SUPERIOR - expresiones lambda, filtros

;;
;; El símbolo Datos proporciona datos de personas con el formato
;; que se indica:
;;
;;   (( Nombre Apellido1 Apellido2 Edad Sexo (estudios) Trabaja) ...)
;;
;; Sexo: V o M
;; Estudios: lista de estudios de esa persona
;; Trabaja: #t o #f
;;

(define Datos '(
                (LUIS GARCIA PEREZ 26 V (INFORMATICA MEDICINA) #t)
                (MARIA LUZ DIVINA 23 M (INFORMATICA) #t)
                (ADOLFO MONTES PELADOS 24 V (INFORMATICA) #f)
                (ANA GARCIA GONZALEZ 22 M () #f)
                (JOSE PEREZ MONTES 36 V () #t)
                (JOSHUA IGLESIAS GARCIA 12 V () #f)
                (MARUJA FERNANDEZ GARCIA 9 M () #f)
                (GUILLERMO PUERTAS VENTANAS 2 V (ECONOMIA) #f)
                ))

(define una-persona (cadr Datos))
(display "Ejemplo: ")
(writeln una-persona)

;; Además se proporcionan las siguientes funciones para acceder a la
;; información:

(define (get-nombre p)
  (car p))

(display "get-nombre: ")
(get-nombre una-persona)  ;=> MARIA

(define (get-apellidos p)
  (list (cadr p) (caddr p)))

(display "get-apellidos: ")
(get-apellidos una-persona)  ;=> (LUZ DIVINA)

(define (get-nombre-completo p)
  (cons (get-nombre p) (get-apellidos p)))

(display "get-nombre-completo: ")
(get-nombre-completo una-persona) ; => (MARIA LUZ DIVINA)

(define (get-edad p)
  (cadddr p))

(display "get-edad: ")
(get-edad una-persona)  ;=> 23

(define (get-genero p)
  (car (cddddr p)))

(display "get-genero: ")
(get-genero una-persona) ; => M

(define (get-estudios p)
  (cadr (cddddr p)))

(display "get-estudios: ")
(get-estudios una-persona)  ;=> (INFORMATICA)

(define (trabaja? p)
  (caddr (cddddr p)))

(display "trabaja? ")
(trabaja? una-persona)  ;=> #t

;;----------------------------------------------------------------------
;; 1 - Aplicando la función Extrae
;;----------------------------------------------------------------------
;; Extrae(Datos, Filtro, Formato) => (...)
;;
;; Funcion de orden superior que recibe:
;; Datos                     : los datos a examinar
;; Filtro(Persona)  => #t/#f : función de filtrado que se aplica a cada persona
;; Formato(Persona) => (...) : función que retorna la información relevante
;;                             ,o de interes, de una persona
;;
;;
;; La función Extrae devuelve la lista de los elementos de Datos que cumplan Filtro
;; y formateados via Formato. En general, tanto la función Filtro como la función
;; Formato serán funciones lambda, pero en los casos en que convenga, también se
;; podrán utilizar las funciones de acceso ya definidas.


;; Definición recursiva de Extrae
;  1. Base       : Extrae((), Filtro, Formato) = ()
;  2. Recurrencia: Datos no es () => Datos = cons(car(Datos), cdr(Datos))
;       Hipótesis: se conoce Extrae(cdr(Datos), Filtro, Formato) = H
;       Tesis    : Extrae(Datos) = si Filtro(car(Datos))
;                                  entonces cons(Formato(car(Datos)), H)
;                                  sino H

(define (Extrae Datos Filtro Formato)
  (cond
    ([null? Datos] Datos)
    ([Filtro (car Datos)] (cons (Formato (car Datos))
                                (Extrae (cdr Datos) Filtro Formato)))
    (else (Extrae (cdr Datos) Filtro Formato))))

;; Utiliza la función Extrae con funciones lambda para Filtro y Formato o , si procede, las
;; funciones de acceso predefinidas, para obtener de Datos la siguiente información:

;a) Los nombres de los adultos

(Extrae Datos (lambda (p) (>= (get-edad p) 18)) get-nombre)
;=> (LUIS MARIA ADOLFO ANA JOSE)

;; Recalcar que la función Extrae realiza dos procesamientos sobre los datos: Filtra y Formatea
;; los datos filtrados. Obsérvese que utilizar la función predefinida filter con la misma función
;; de filtrado, filtra exactamente los mismos datos, pero proporciona toda la información conocida
;; relativa a éstos:

(filter (lambda (p) (>= (get-edad p) 18)) Datos)
;=> ((LUIS GARCIA PEREZ 26 V (INFORMATICA MEDICINA) #t)
;    (MARIA LUZ DIVINA 23 M (INFORMATICA) #t)
;    (ADOLFO MONTES PELADOS 24 V (INFORMATICA) #f)
;    (ANA GARCIA GONZALEZ 22 M () #f)
;    (JOSE PEREZ MONTES 36 V () #t))

;; y, así, para obtener lo que interesa de los datos filtrados (en este caso, los nombres), se
;; requeriría un procesamiento posterior de éstos (el formateo).

;b) La lista de nombres completos de todos



;c) Los nombres de todas las mujeres que trabajan



;d) Los nombres completos de todos los que han estudiado INFORMATICA



;e) Los pares (género edad) de todas las personas sin estudios



;f) La edad de todos los INFORMATICOS



;g) La lista de nombres completos de todas las personas sin trabajo




;; ----------------------------------------------------------
;: 2 - FUNCION gen-filtro
;;-----------------------------------------------------------
;; gen-filtro::(A -> B) x (C x B -> BOOL) x C -> (A -> BOOL)
;; gen-filtro(EXTRACTOR OPERADOR VALOR) => lambda(Persona)
;;
;; Esta funcion de orden superior devuelve una funcion lambda(p) a aplicar 
;; como filtro en Extrae.
;; Para ello se parametriza con:
;; EXTRACTOR: Funcion que extraera los datos de la persona a comprobar
;; OPERADOR : Comparador de Valor y la salida de EXTRACTOR
;; VALOR : valor cte con el que comparar

;; Ej: filtro de personas con estudios de informatica
;;     
;; (gen-filtro 
;;    (lambda(p) (get-estudios p))  ; EXTRACTOR: accede al campo estudios
;;       member                    ; OPERADOR: funcion combina VALOR y salida de EXTRACTOR (operador valor (extractor x))
;;      'INFORMATICA)             ;; VALOR: a utilizar en la llamada a OPERADOR
;; => 
;; lambda(P) que aplicada a una persona extrae la lista de estudios y comprueba
;;           si contiene el atomo INFORMATICA
;;
;; > (define informaticos 
;;       (gen-filtro (lambda(p) (get-estudios p)) member 'INFORMATICA))
;;    )
;; > (Extrae Datos informaticos get-nombre) 
;;   (LUIS MARIA ADOLFO)

;; ¿podrías definir los filtros de los ejemplos anteriores con esta función?
;;

(define (gen-filtro EXTRACTOR OPERADOR VALOR)
  (lambda(p) (OPERADOR VALOR (EXTRACTOR p)))) ; La novedad es que la función devuelve otra función

(define informaticos
  (gen-filtro (lambda (p) (get-estudios p)) member 'INFORMATICA))

(Extrae Datos informaticos get-nombre)

;a) Los nombres de los adultos




;b) La lista de nombres completos de todos




;c) Los nombres de todas las mujeres que trabajan




;d) Los nombres completos de todos los que han estudiado INFORMATICA




;e) Los pares (género edad) de todas las personas sin estudios




;f) La edad de todos los INFORMATICOS




;g) La lista de nombres completos de todas las personas sin trabajo







;;;----------------------------------------------------------------------------------------
;;; EJERCICIOS COMPLEMENTARIOS
;;;----------------------------------------------------------------------------------------
;;;

(define numeros
  '((n1 (3 7 3))(n2 (3 4 9 0 1))(n3 (3 0 3 4)) (n4 (7))))

;; Definido el símbolo numeros como se indica, una lista de números
;; dados por la lista de sus dígitos y que tienen un nombre asociado,
;; utiliza la función filter para obtener los números que se solicitan.

;a) Obtener todos los números con más de 3 dígitos
;   ((n2 (3 4 9 0 1)) (n3 (3 0 3 4)))



;b) Obtener todos los números que tengan un siete
;   ((n1 (3 7 3)) (n4 (7)))



;c) Obtener todos los números que tengan como primer dígito un 3
;   ((n1 (3 7 3)) (n2 (3 4 9 0 1)) (n3 (3 0 3 4)))



;d) Obtener todos los números cuya suma de dígitos sea menor que 12
;   ((n3 (3 0 3 4)) (n4 (7)))




;------------------------------------------------------
; Define mediante FOS la función frecuency(x, l) que
; retorna el número de repeticiones de x en la lista l
;------------------------------------------------------
;



;(display "frecuency: ")
;(frecuency1 '(a) '(a b (a) a d (a))) ; => 2

;------------------------------------------------------
; Define la función recursiva filterec(f, L) que, dada
; una función booleana de un argumento y una lista L,
; retorna la lista con los elementos de L que cumplen f
;-------------------------------------------------------
;



;(display "filtered: ")
;(filterec list? '(1 (2) ((a)) 3))  ; => ((2) ((a)))

;------------------------------------------------------
; Define la función recursiva for-all(f, L) que retorna
; la lista resultante de aplicar la función f a cada uno
; de los elementos de la lista
;-------------------------------------------------------
;



;(display "for-all: ")
;(for-all cadr '((a b) ((a) c) (d (e)))) ;  => (b c (e))

;----------------------------------------------------------------------
; Utiliza las funciones dadas al principio, que extraen información
; del símbolo definido Datos, para definir la función persona?(p)
; que permite comprobar que la información dada para una persona
; es correcta (acorde con la forma en que se proporciona la información
; de las personas de Datos). Entre otras posibles condiciones: que es
; una lista de siete elementos o que los estudios realizados se
; proporcionan en una lista
;
; Comprueba todas las condiciones que creas relevantes. Como mínimo
; ha de verificarse una condición relevante por cada campo.
;----------------------------------------------------------------------
;




;(persona? '(MARIA LUZ DIVINA 23 M (INFORMATICA) #t))    ; => #t
;(persona? '(MARIA LUZ DIVINA 2 3 M (INFORMATICA) #t))   ; => #f
;(persona? '(MARIA (LUZ DIVINA) 23 M (INFORMATICA) #t))  ; => #f
;(persona? '(MARIA LUZ DIVINA 23 M INFORMATICA #t))      ; => #f
;(persona? '(MARIA LUZ DIVINA 23 H (INFORMATICA) #t))    ; => #f

