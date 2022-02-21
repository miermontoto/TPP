(require  mzlib/compat)

;;;-----------------------------------------------------------------------
;;; Número de argumentos de funciones
;;;-----------------------------------------------------------------------

;;; Funciones con tres argumentos
(displayln "lambda(x y z):")

((lambda (x y z)
   (writeln x)
   (writeln y)
   z) 'a 'b '(c d))

;;; Función con dos argumentos y resto z opcional
;;; z es la lista de resto de argumentos
(displayln "lambda(x y . z):")

((lambda (x y . z)
   (writeln x)
   (writeln y)
   z) 'a 'b '(c d) '(e) 'f)

;;; Función con argumentos opcionales, z es la lista
;;; de argumentos (obsérvese que la sintaxis de los
;;; parámetros cambia, en lugar de (. z) es directamente z)
(display "lambda z: ")

((lambda z z) 'a 'b '(c d) '(e) 'f)

;;;-----------------------------------------------------------------------
;;; Uso de funciones con argumentos variables y letrec para
;;; comprobar que éstos son adecuados. Ejemplo my-append
;;;-----------------------------------------------------------------------
;;;

; 1. Base       : my-append((), l2) = l2
; 2. Recurrencia: l1 no es () => l1 = cons(car(l1), cdr(l1))
;      Hipótesis: se conoce H = my-append(cdr(l1), l2)
;      Tesis    : my-append(l1) = cons(car(l1), H)

(define (my-append . resto)
  (letrec ([f (lambda (l1 l2)          ;; letrec porque f es recursiva
                (if [null? l1]
                    l2
                    (cons (car l1) (f (cdr l1) l2))))])
    (cond ([not (= (length resto) 2)]
           (error "my-append(l1,l2): requiere dos argumentos"))
          ([not (list? (car resto))]
           (error "my-append(l1,l2): el primer argumento debe ser una lista"))
          ([not (list? (cadr resto))]
           (error "my-append(l1,l2): el segundo argumento debe ser una lista"))
          (else
           (f (car resto) (cadr resto))))))


; o directamente definiendo una función lambda

(define my-append2                 
  (lambda resto                    
    (letrec ([f (lambda (l1 l2)    
                  (if [null? l1]
                      l2
                      (cons (car l1) (f (cdr l1) l2))))])
      (cond ([not (= (length resto) 2)]
             (error "my-append2(l1,l2): requiere dos argumentos"))
            ([not (list? (car resto))]
             (error "my-append2(l1,l2): el primer argumento debe ser una lista"))
            ([not (list? (cadr resto))]
             (error "my-append2(l1,l2): el segundo argumento debe ser una lista"))
            (else
             (f (car resto) (cadr resto)))))))


;;; Definición de funciones _and y _or para cualquier número de argumentos
;;; Se podrán utilizar en funciones de orden superior y es necesario
;;; redefinirlas porque en Scheme and y or son macros en lugar de funciones

(define _or
  (lambda x
    (letrec ([f (lambda(y)
                  (cond [(null? y) #f]
                        [(car y)]                 ; [(car y) #t] si sólo se retorna #t o #f
                        [else (f (cdr y))]))])
      (f x))))

(displayln "_or: ")
(_or #f #f 'a)  ;=> a
(_or #f #f)     ;=> #f

; Define la función _and

(define _and
  (lambda x
    (letrec ([f (lambda(y)
                  (cond [(null? y) #t]
                        [(not (car y)) #f]
                        [(null? (cdr y))          ; se ha de prescindir de esta condición si
                         (car y)]                 ; sólo se retorna #t o #f
                        [else
                         (f (cdr y))]))])
      (f x))))

(displayln "_and: ")
(_and #t 'a 0 ())         ;=> ()
(_and #t 'a #f '(a b c))  ;=> #f

;-------------------------------------------------------------------------------
;
; EJEMPLO DE USO DE LA FUNCIÓN MAP.
;
; La función Extrae de la sesión anterior
;; Extrae(Datos, Filtro, Formato) => (...)
;;
;; Funcion de orden superior que recibe:
;; datos                     : los datos a examinar
;; Filtro(Persona)  => #t/#f  : función de filtrado que se aplica a cada persona
;; Formato(Persona) => (...) : función que retorna la información relevante
;;                             ,o de interes, de una persona
;;
;;
;; La función Extrae devuelve la lista de los elementos de Datos que cumplan Filtro
;; y formateados via Formato. En general, tanto la función Filtro como la función
;; Formato serán funciones lambda, pero en los casos en que convenga, también se
;; podrán utilizar funciones de acceso ya definidas.

; Define la función Extrae mediante FOS
; PISTA:
;    PRIMERO filtra los datos
;    SEGUNDO formatea cada uno de los datos filtrados

(displayln "Extrae:")




(define numeros
  '((n1 (3 7 3))(n2 (3 4 9 0 1))(n3 (3 0 3 4)) (n4 (7))))

; Obtener todos los números con más de 3 dígitos. Filtrado con
; filter, sin formato (se obtiene toda la información)
(filter (lambda(x) (> (length (cadr x)) 3)) numeros)

; Obtener los nombres de todos los números con más de 3 dígitos
;(display "nombres: ")
;(Extrae numeros (lambda(x) (> (length (cadr x)) 3)) car)

; o bien
(map car (filter (lambda(x) (> (length (cadr x)) 3)) numeros))

;---------------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; union(A, B) = A U B 
; Retorna la unión de dos conjuntos
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; En la segunda sesión se pedía obtener esta función de
; forma recursiva, siendo una posible solución la siguiente:
;
; 1. Base       : el resultado de la funcíón para la lista vacía (conjunto);
;                 union((), B) = B  ;;; o bien union({}, B) = B
; 2. Recurrencia: A no es la lista/conjunto vacío; es decir,
;                 A = cons(car(A), cdr(A))
;      Hipótesis: se conoce union(cdr(A), B) = H
;      Tesis    : union(A, B) = si member(car(A), H)
;                               entonces H
;                               si_no cons(car(A), H)
;
; En Racket:
;
;(define (union A B)
;  (cond [(null? A) B]
;	[(member (car A) B)
;         (union (cdr A) B)]
;	[else (cons (car A)
;                    (union (cdr A) B))]))
;

; Proporcionar una nueva versión de la función union(A, B) comprobando
; previamente que su número de argumentos es el esparado y que éstos
; son válidos. En caso de no ser así, se proporcionará el mensaje
; de error correspondiente.
;
; Nota: deberá darse una única definición de función



;(display "union: ")
;(union '(c a x) 3)       ;=> error
;(union '(c a x))         ;=> error
;(union '(c a x) '(a (a))) ;=> (c x a (a))

; Dado que la validación de argumentos siempre se realiza de la misma
; forma, resulta más conveniente centrase en el uso de las FOS. Así, en
; adelante, las funciones solicitadas siempre se definirán bajo el
; supuesto de que los argumentos de las funciones se proporcionan
; correctamente, salvo que expresamente se indique lo contrario.

;------------------------------------------------------------------------;
; Salvo que en la especificación se indique otra cosa, utiliza Funciones
; de Orden Superior (FOS)  para definir las funciones que se solicitan a
; continuación, supuesto que sus argumentos se proporcionan correctamente
; (por tanto, se ignorará la validación de éstos).
;------------------------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; union(A,B) = A U B
; Retorna la unión los conjuntos A y B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;



;(display "union: ")
;(union '(c a x) '(a (a))) ;=> (c x a (a))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; subset?(A,B) = ¿A esta contenido en B?
; Retorna cierto si el conjunto A es subconjunto del B
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;



;(displayln "subset:")
;(subset? '(c b) '(a x b d c y))    ;=> #t
;(subset? '(c b) '(a x b d (c) y))  ;=> #f

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; subset2?(A,B) = ¿A esta contenido en B?
; Retorna cierto si el conjunto A es subconjunto del B
;
; NOTA: sin utilizar filter. Combinar map y apply
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;



;(displayln "subset2?:")
;(subset2? '(c b) '(a x b d c y))    ;=> #t
;(subset2? '(c b) '(a x b d (c) y))  ;=> #f

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Redefine la nueva función union(A, B) dada aquí
; (mediante FOS) para validar los argumentos que
; recibe. Si éstos fueran erróneos, deberá retornarse
; el mensaje de error correspondiente.
;
; Nota: deberá darse una única definición de función
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;


;(display "union: ")
;(union '(c a x) 3)       ;=> error
;(union '(c a x))         ;=> error
;(union '(c a x) '(a (a))) ;=> (c x a (a))

;;;------------------------------------------------------------------------
;;; EJERCICIOS COMPLEMENTARIOS
;;-------------------------------------------------------------------------

;;------------------------------------------------------------------------------------
;; Se proporciona la función enteros(x, y) que dados dos enteros a y b
;; retorna la lista de enteros consecutivos (a a+1 a+2 ... b-2 b-1); es
;; decir, los enteros del rango [a, b) . Esta lista será vacía si a>=b.
;;
;; Utilizar FOS y, si se requiere, la función enteros(x, y) para definir
;; las siguientes funciones:
;;
;; sucAritm0(r, n): retorna la lista (0 r 2*r ... (n-1)*r); es decir, la
;; lista de los n primeros términos de la sucesión aritmética cuyo primer
;; elemento es 0 y de razón r.
;;
;; suc-aritmetica(a, r, n): retorna la lista (a a+r a+2*r ... a+(n-1)*r);
;; es decir, la lista de los n primeros términos de la sucesión aritmética
;; cuyo primer elemento es a y de razón r.
;;
;; suma-aritmetica(a, r, n): que retorna la suma de los n primeros términos
;; de la sucesión aritmética cuyo primer elemento es a y de razón r.
;;
;; pares(a, b: retorna la lista de números pares en el rango [a, b] de
;; enteros
;;
;; multiplos(a, b, n): retorna la lista de todos los múltiplos del entero
;; n que pertenecen al rango [a, b] de enteros. Si n=0 retorna la lista d
;; enteros del rango dado.
;;------------------------------------------------------------------------------------

(define (enteros x y)
  (if (>= x y)
      ()
      (cons x (enteros (+ x 1) y))))

(display "enteros: ")
(enteros -5 10) ;=> (-5 -4 -3 -2 -1 0 1 2 3 4 5 6 7 8 9)
(enteros 1 6)   ;=> (1 2 3 4 5)

;;;;;;;;;;;;;;;;;;;;;




;(display "sucAritm0: ")
;(sucAritm0 3 5)  ;=> (0 3 6 9 12)

;;;;;;;;;;;;;;;;;;;;;




;(display "suc-aritmetica: ")
;(suc-aritmetica -7 3 5)   ;=> (-7 -4 -1 2 5)

;;;;;;;;;;;;;;;;;;;;;




;(display "suma-aritmetica: ")
;(suma-aritmetica -7 3 5)   ;=> -5

;;;;;;;;;;;;;;;;;;;;;




;(display "pares: ")
;(pares -7 9)   ;=> (-6 -4 -2 0 2 4 6 8)

;;;;;;;;;;;;;;;;;;;;;




;(displayln "multiplos: ")
;(multiplos -7 9 2)    ;=> (-6 -4 -2 0 2 4 6 8)
;(multiplos -30 30 7)  ;=> (-28 -21 -14 -7 0 7 14 21 28)
;multiplos 1 10 0)  ;=> (1 2 3 4 5 6 7 8 9 10)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; cambia-si(l1, l2, f-cond)
; Define la función recursiva cambia-si que cambia los valores de la lista
; l1 dada como primer parámetro por el elemento de la lista dada como segundo
; parámetro (l2) de la misma posición, pero sólo si se cumple la condición
; f-cond sobre esos valores.
;
; Compruébense las condiciones que han de cumplir los argumentos de la función,
; entre otras, que ambas listas han de tener el mismo tamaño.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

; 1. Base       : cambia-si((), (), f-cond) = ()
; 2. Recurrencia: l1 no es () => l1 = cons(car(l1), cdr(l1))
;      Hipótesis: se conoce cambia-si(cdr(l1), cdr(l2), f-cond) = H
;          Tesis: cambia-si(l1, l2, f-cond) = si f-cond(car(l1), car(l2))
;                                             entonces cons(car(l2), H)
;                                             si_no cons(car(l1), H)
;




;(display "cambia-si: ")
;(cambia-si '(1 2 4 8 16 32 64 128) '(2 3 4 5 6 7 8 9) <) ; => (2 3 4 8 16 32 64 128)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Redefine la función previa utilizando FOS y nombra la nueva función
; como FOS-cambia-si
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


 

;(display "FOS-cambia-si: ");
;(FOS-cambia-si '(1 2 4 8 16 32 64 128) '(2 3 4 5 6 7 8 9) <) ; => (2 3 4 8 16 32 64 128)
   
