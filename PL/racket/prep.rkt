(filter number? (apply append datos))

(map list 
(map (curry car) datos)
(map (curry apply max) datos))

(define (foto-de la-sede consumos)
  (filter (lambda(x) (eq? la-sede (sede x))) consumos))

(define (foto-de-curry la-sede consumos)
  (filter (compose (curry eq? la-sede) sede) consumos))

(define (sedes las-copias)
  (letrec ([solo-sedes (map sede las-copias)]
          [make-set (lambda(l)
                      (cond [(null? l) l]
                            [(member (car l) (cdr l)) (make-set (cdr l))]
                            [else (cons (car l) (make-set (cdr l)))]))])
    (make-set solo-sedes)))

(define (copias-totales las-copias)
  (list (apply + (map bn las-copias))
        (apply + (map color las-copias))))

(define (totales-por-sede la-sede las-copias)
  (let ([copias-de (foto-de la-sede las-copias)])
    (copias-totales copias-de)))

