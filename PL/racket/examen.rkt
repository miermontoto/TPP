(require mzlib/compat racket/function)

;-------------
; Ejercicio 1
;-------------

(define (take n l)
  (cond [(zero? n) ()]
        [else
         (cons (car l)
               (take (- n 1) (cdr l)))]))

(display "take(3, (a (b) ((c) d) (e (f)) g)) => ")
(take 3 '(a (b) ((c) d) (e (f)) g))
;(display "\n")


(define (take-list v . resto)
  (map (curry take v) resto))


(display "take-list(2, (a (b)), ((e) f (g)), (1 2 3 4):")
(take-list 2 '(a (b)) '((e) f (g)) '(1 2 3 4))

;-------------
; Ejercicio 2
;-------------

(define datos
  '((3.5 -4 18 36 15 -2.3)
    (-18 -3.25 0 -4.7 24 1.2 0 -3)
    (4 2.3 17 8 2 3.4 5.2 23 17)
    (-3 15 7.2 2 19 2.5 3 -4.2 5.1)
    (0 2.5 23 9 7.3 18)
    (1.3 4 2 1.7 24 2.45 0.25 -35.7)))

;(displayln "datos:")
;datos
;(display "\n")

;(displayln "Ejemplo de expresión FOS: map(car, datos)")
;(display "Primeros elementos de las sublistas de datos => ")
;(map car datos)
(display "\n")

; Apartado 2.1
(display "2.1: ")
(filter (curry member 0) datos)


; Apartado 2.2
(display "2.2: ")
(map (curry apply min) datos)


; Apartado 2.3
(display "2.3: ")
(filter (curry (compose (compose not negative?) apply) min) datos)


; Apartado 2.4
(display "2.4: ")
(map (curry filter (curry integer?)) datos)

; Apartado 2.5
(display "2.5: ")
(let ([minLength (apply min (map length datos))])
  (take-list minLength datos))

(displayln "")

;-------------
; Ejercicio 3
;-------------

(define datos-con-nombre
  ([lambda(ll)
     (letrec [(f (lambda(x)
                   (if (null? x)
                       x
                       (cons (cons (string->symbol
                                    (string-append
                                     "lnum-"
                                     (number->string
                                      (- (length ll) (length x)))))
                                   (car x))
                             (f (cdr x))))))]
       (f ll))] datos))

;(displayln "datos-con-nombre:")
;datos-con-nombre
;(display "\n")


; 1. Base: ll es la lista vacía => ()
; 2. Recurrencia: ll NO es la lista vacía: ll = cons(car(ll), cdr(ll))
;      Hipótesis: se conoce sumas-positivas(cdr(ll)) = H
;          Tesis:  si positive?(suma(cdar(ll))):
;                      sumas-positivas(ll) = cons(caar(ll)), H)
;                  si no:
;                      sumas-positivas(ll) = H
;
; Como explicado en la entrega del examen, para realizar la suma
; se puede utilizar cualquier método, aunque no sea recurrente.
; En este caso se utiliza una FOS.
;
; donde cdar(ll) es la lista que contiene los valores de la sublista lnum-n
; y caar(ll) es el nombre de la sublista lnum-n.
(define (sumas-positivas ll)
  (if (null? ll) ll
      (let ([H (sumas-positivas (cdr ll))] [suma (curry apply +)])
        (if (positive? (suma (cdar ll))) (cons (caar ll) H) H))))


(display "sumas-positivas(datos-con-nombre): ")
(sumas-positivas datos-con-nombre)
(displayln "")

;-------------
; Ejercicio 4
;-------------


(define (take n l)
  (letrec ([t (lambda(n l)
            (if (zero? n) ()
                (cons (car l) (t (- n 1) (cdr l)))))])
  (if (not (number? n)) (displayln "El parámetro n debe de ser un número.")
      (if (not (integer? n)) (displayln "El parámetro n debe de ser un número natural.")
          (if (not (list? l)) (displayln "El parámetro l debe de ser una lista.")
              (if (> n (length l)) (displayln "El parámetro n debe de ser mayor que la longitud de la lista l.")
                  (if (negative? n) (displayln "El parámetro n debe de ser un número natural.")
                      (t n l))))))))



(displayln "take(n, l) con comprobación argumentos:") ; se han añadido comprobaciones adicionales.
(take '(1 2 3 4) 3)
;(take 3.4 '(a (b c) d (e) f))
;(take -2.7 '(a (b c) d (e) f))
(take 6 '(a (b c) d (e) f))
;(take pi '(a (b c) d (e) f))
;(take -1 '(a (b c) d (e) f))
;(take 1 ())
;(take 2 4)
(take 3 '(a (b c) d (e) f))
;(take 0 ())

