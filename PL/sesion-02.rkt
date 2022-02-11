;;; *************
;;; * SESIÓN-02 *
;;; *************


(require mzlib/compat)         ; Importa una biblioteca. En particular, nos
                               ; permite utilizar la función atom? que, en
                               ; otro caso, no estaría disponible


;;; Definición de funciones, sintaxis:
;;;
;;; (define (f param1 param2 ...) Sexp)
;;;
;;; Nombre de la función: f
;;; Parámetros de la función: param1 param2 ...    (pueden ser 0)
;;; Cuerpo de la definición: cualquier S-expresión Sexp evaluable
;;; Resultado de la llamada: la evaluación de la S-expresión que resulta
;;; de sustituir los parámetros de la función en la S-expresión Sexp por
;;; argumentos de la llamada.
;;;
;;; Ejemplos:

;(define (saluda) '¡Hola_Mundo!) ; definición
;(saluda)                        ; invocación (o llamada)

;(define (suma a b) (+ a b))     ; definición
;(suma 3 -10)                    ; invocación


;;; Definición de funciones recursivas sobre listas
;;; -----------------------------------------------
;;;
;;; En el análisis por casos se utilizará la notación funcional estándar:
;;; <nombre_función>(arg0, arg1, ...). Por ejemplo, para f(l):
;;;
;;; 1. Base       : el resultado de la función la lista vacía;
;;;                 f(()) = lo que corresponda según problema a resolver
;;; 2. Recurrencia: l no es la lista vacía; es decir, l=cons(car(l), cdr(l))
;;;      Hipótesis: se supone conocido f(cdr(l))=H
;;;          Tesis: obtener f(l) a partir de la hipótesis H en combinación
;;;                 con el elemento car(l) de la lista l que no forma parte
;;;                 del argumento de la hipótesis
;;;                 f(l) = combinar adecuadamente car(l) y H
;;;

;;;------------------------------------------------------------------------
;;; Ejemplo: Definir la función my-length(l), que retorna el número de
;;; elementos de la lista dada.
;
; 1. Base       : el resultado de la función para la lista vacía;
;                 my-length(()) = 0
; 2. Recurrencia: l no es la lista vacía; es decir, l = cons(car(l), cdr(l))
;      Hipótesis: se conoce my-length(cdr(l)) = H
;      Tesis    : my-lenhth(l) = H + 1
;
; En Racket:

;(define (my-length l)
;  (if [null? l]
;      0
;      (+ (my-length (cdr l)) 1)))

;(displayln "my-length:")
;(my-length '(a (b c) d))           ; => 3
;(my-length '((a b c) d (e (f g)))) ; => 3

;;;------------------------------------------------------------------------
;;; CONSTRUIR LAS SIGUIENTES FUNCIONES RECURSIVAS
;;;------------------------------------------------------------------------
;;; En todos los casos es imprescindible realizar el análisis por casos.
;;; Estableciendo la base y la recurrencia de la misma forma que se ha
;;; hecho en el ejemplo previo.
;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Función my-reverse(l) que retorna una lista con los mismos elementos
; que la proporcionada, pero en orden inverso.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 1. Base: x es la lista vacía. my-reverse(x) es conocida --> '()'
;
; 2. Recurrencia: x no es vacía, x = cons(car(x), cdr(x))
;;;              Hipótesis: se conoce my-reverse(cdr(x)) = H
;;;              Tesis: my-reverse(x) = append(H, list(car(x)))

(define (my-reverse x)
  (if (null? x)
      x
      (append (my-reverse (cdr x)) (list (car x)))))


(displayln "my-reverse:")
(my-reverse '((b (a)) c d))   ; => (d c (b (a)))
(my-reverse '(a (b c) d (e))) ; => ((e) d (b c) a)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Supuesto que los elementos de una lista representan un conjunto
; (recuérdese que un conjunto no hay orden y tampoco repeticiones)
; definir la función adjoin(x, A) que retorna un nuevo conjunto
; A + {x}
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 1. Base: A es la lista vacía: adjoin(x, A) = {x}
; 2. Recurrencia: A no es la lista vacía.
;;;    Hipótesis: Se conoce adjoin(x, cdr(A)) = H
;;;        Tesis: adjoin(x, A) = si x = car(A) entonces H, si no cons(car(A), H)

(define (adjoin x A)
  (cond [(null? A) (list x)]
        [(equal? x (car A))
              (adjoin x (cdr A))]
        [else (cons (car A) (adjoin x (cdr A)))]))

(displayln "adjoin:")
(adjoin '(a) '((b c) (d))) ; => ((b c) (d) (a))
(adjoin 0 '(5 0 7 10)) ; => (5 7 10 0)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Definir la función union(A,B) = A U B que retorna el conjunto
; unión de los dos dados.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 1. Base: A es vacío --> union(A,B) = B
; 2. Recurrencia: A no es vacío.
;;;    Hipótesis: Se conoce union(cdr(A), B) = H1
;;;        Tesis: union(A, B) = adjoin(car(A), H1)

(define (union A B)
  (if (null? A) B
      (adjoin (car A) (union (cdr A) B))))


(displayln "union:")
(union '((1) (2) (3)) '((2) (5))) ; => ((1) (3) (2) (5))
(union '(a f c b) '(z a b c))     ; => (f z a b c)

;;; Definición de funciones recursivas sobre S-expresiones
;;; ------------------------------------------------------
;;;
;;; En prácticas sólo se trabajará con átomos y el subconjunto de
;;; S-expresiones que son listas (listas anidadas o multinivel) y en
;;; el análisis por casos se utilizará la notación funcional estándar:
;;; <nombre_función>(arg0, arg1, ...). Por ejemplo, para f(Sexp):
;;;
;;; 1. Base       : el resultado de la función la función para un átomo;
;;;                 f(átomo) = lo que corresponda según problema a resolver
;;;                 Deberá analizarse el caso particular f(()), ya que la
;;;                 lista vacía también es un átomo.
;;; 2. Recurrencia: Sexp no es un átomo; es decir, Sexp=cons(car(Sexp), cdr(Sexp))
;;;      Hipótesis: se conocen f(car(Sexp))= H1 y f(cdr(Sexp)) = H2
;;;          Tesis: obtener f(Sexp) combinando ambas hipótesis, H1 y H2
;;;                 f(Sexp) = combinar adecuadamente H1 y H2
;;;

;;;------------------------------------------------------------------------
;;; Ejemplo: Definir la función atoms(Sexp), que retorna el número de
;;; átomos de la S-expresión dada.
;
; 1. Base       : el resultado de la función para un átomo;
;                 atoms(átomo) = 1; excepto si el átomo es la lista vacía
;                 atoms(()) = 0.
; 2. Recurrencia: Sexp no es un átomo; es decir, Sexp=cons(car(Sexp),cdr(Sexp))
;      Hipótesis: se conocen atoms(car(Sexp)) = H1 y atoms(cdr(Sexp)) = H2
;      Tesis    : atoms(Sexp) = H1 + H2
;
; En Racket:

;(define (atoms Sexp)
;  (cond [(null? Sexp) 0]
;        [(atom? Sexp) 1]
;        [else (+ (atoms (car Sexp))
;                 (atoms (cdr Sexp)))]))

;(displayln "atoms:")
;(atoms '((b (c) a) d))         ; => 4
;(atoms '((a b c) d (e (f g)))) ; => 7

;;;------------------------------------------------------------------------
;;; CONSTRUIR LAS SIGUIENTES FUNCIONES RECURSIVAS
;;;------------------------------------------------------------------------
;;; En todos los casos es imprescindible realizar el análisis por casos.
;;; Estableciendo la base y la recurrencia de la misma forma que se ha
;;; hecho en el ejemplo previo.
;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Definir la función ocurrencias(x, Sexp) que retorna el número de
; ocurrencias del átomo x en la S-expresión dada Sexp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 1. Base: Sexp es un átomo : si es igual a x, 1, si no, 0.
; 2. Recurrencia: Sexp no es un átomo.
;;;    Hipótesis: se conoce  H1 = ocurrencias(x, cdr(Sexp)) y H2 = ocurrencias(x, car(Sexp))
;;;        Tesis: ocurrencias(x, Sexp) = H1 + H2
(define (ocurrencias x Sexp)
  (if (atom? Sexp) (if (eq? x Sexp) 1 0)
      (+ (ocurrencias x (car Sexp)) (ocurrencias x (cdr Sexp)))))


(displayln "ocurrencias:")
(ocurrencias 'a '((a b (a)) (a) c))  ; => 3
(ocurrencias 1 '((1 2 (1)) 1 (0 1))) ; => 4

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Definir la función erase(x, Sexp) que retorna una S-expresión
; copia de Sexp, pero que no contiene ninguna ocurrencia de x
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 1. Base: Sexp es la lista vacía => ()
; 2. Recurrencia: Sexp no es la lista vacía.
;      Hipótesis: Se conoce H1 = erase(x, car(Sexp)) y H2 = erase(x, cdr(Sexp))
;          Tesis: cons(H1, H2)
(define (erase x Sexp)
  (cond [(equal? x Sexp) ()]
        [(or (null? Sexp) (atom? Sexp)) Sexp]
        [else (cons (erase x (car Sexp)) (erase x (cdr Sexp)))]))


(displayln "erase:")
(erase '(f) '((a (b c) (f)) (d a (e)) f)) ; => ((a (b c)) (d a (e)) f)
(erase 'f '((a (b c) ()) (d a (e)) f))    ; => ((a (b c)) (d a (e)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Definir la función ocurrencias2(x, Sexp) que retorna el número de
; ocurrencias de la S-expresión x en la S-expresión Sexp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 1. Base: Sexp es igual a x => 1. De lo contrario, si Sexp es átomo o la lista vacía, entonces 0.
; 2. Recurrencia: Sexp no es átomo, ni la lista vacía, ni igual a x.
;      Hipótesis: Se conoce H1 = ocurrencias2(x, cdr(Sexp)) y H2 = ocurrencias2(x, car(Sexp)).
;          Tesis: ocurrencias2(x, Sexp) = H1 + H2;

(define (ocurrencias2 x Sexp)
  (cond [(equal? x Sexp) 1]
        [(null? Sexp) 0]
        [(atom? Sexp) 0]
        [else (+ (ocurrencias2 x (car Sexp)) (ocurrencias2 x (cdr Sexp)))]))

(displayln "ocurrencias2:")
(ocurrencias2 'a '((a b (a)) (a) c))                 ; => 3
(ocurrencias2 '(a) '((a b (a)) (a) c))               ; => 2
(ocurrencias2 '(0 1) '((1 2 ((0 1))) ((0) 1) (0 1))) ; => 2

;;;------------------------------------------------------------------------
;;; EJERCICIOS COMPLEMENTARIOS
;;;------------------------------------------------------------------------
;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Definir la función cons-atoms(sexp) que retorna la S-expresión
; que permite obtener sexp a partir de sus átomos.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 1. Base: sexp es un átomo.
; 2. Recurrencia: sexp no es un átomo.
;;;    Hipótesis: Se conoce cons-atoms(car(sexp)) = H1 y cons-atoms(cdr(sexp)) = H2
;;;        Tesis: cons-atoms(sexp) = '(cons H1 H2)

(define (cons-atoms sexp)
  (cond [(null? sexp) sexp]
        [(atom? sexp) (list 'quote sexp)]
        [else (list 'cons (cons-atoms (car sexp)) (cons-atoms (cdr sexp)))]))



(displayln "cons-atoms:")
(cons-atoms '(a b)) ;=> (cons 'a (cons 'b ()))
(cons-atoms '(a (b) ((c) d))) ;=> (cons 'a (cons (cons 'b ()) (cons (cons (cons 'c ()) (cons 'd ())) ())))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Definir la función (A,B) que retorna el conjunto intersección
; de los dos proporcionados.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;


;(displayln "intersection:")
;(intersection '((1) (2) (3)) '((2) (5))) ; => ((2))
;(intersection '(a f c b) '(z a b c))     ; => (a c b)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; existe?(x, Sexp) retorna cierto si la S-expresión x está
; contenida en la S-expresión Sexp 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 1. Base: x es igual a Sexp => #t. De lo contrario, si Sexp es átomo o la lista vacía, #f.
; 2. Recurrencia: No se cumple ningún caso base.
;      Hipótesis: Se conoce existe?(x, cdr(Sexp)) = H1 y existe?(x, car(Sexp))
;          Tesis: H1 OR H2
(define (existe? x Sexp)
  (cond [(equal? x Sexp) #t]
        [(null? Sexp) #f]
        [(atom? Sexp) #f]
        [else (or (existe? x (car Sexp)) (existe? x (cdr Sexp)))]))


(displayln "existe?")
(existe?  'a '((a b (a)) (e) c))     ;=> #t
(existe? '(a)  '((a b (a)) (e) c))   ;=> #t
(existe? '((a))  '((a b (a)) (e) c)) ;=> #f
