(define (genera-iva tipo) (lambda(base) (* base (+ 1 tipo))))

(define iva-reducido (genera-iva .1))
(define iva-normal (genera-iva .21))

(define (test-normal x) (+ x (* x .21)))

(require srfi/1)

(define promedio (lambda x ((/ (apply + x) (length x)))))

(define promedio-min (lambda (a . L) (/ (apply + a L) (+ 1 (length L)))))

;;; Distancia Euclídea
(define (diff2 x y) (expt (- x y) 2)) ; Cuadrado de la resta de dos números.
(define (dist a b) (sqrt (apply + (map diff2 a b)))) ; Dist. Euclídea