; Scheme no tiene currificación de forma nativa
; Función curry del módulo "racket/function"

(require mzlib/compat racket/function)

;
;

(define ll-numeros '((1 3 -10) (5 -8 0 17 21) (8 3)))

; Dada la lista ll-numeros, cuyos elementos son a su vez sublistas
; de números enteros, obtener una nueva lista de listas que contengan
; únicamente los valores pares de las sublistas originales

(display "filtrado de pares: ")

(map (lambda(l)
       (filter even? l)) ll-numeros)

; Utilizando currificado para filtrar los valores

(display "filtrado de pares (curry): ")

(map (curry filter even?) ll-numeros)

; curry retorna una función lambda
; (curry filter even?) <=> (lambda(l) (filter even? l))


; Observaciones sobre funciones lambda de un argumento:
; ----------------------------------------------------
; (lambda(x) (f x)) <=> (f x);  no tiene objeto alguno la definición lambda
;
; Ejemplo
;(define f (lambda(l) (length l)); la definición lambda no tiene utilidad
;
; De querer utilizar f como alias  de la función length sería suficiente
; (y mejor) con hacer:
;
; (define f length)
; (f '(1 2 3 4)) ;=> 4
;
; Por supuesto esto es extensible a funciones de dos o más argumentos
; (lambda(x y) (f x y)) <=> (f x y)


; Currificación:
; -------------
; Tiene utilidad para funciones de 2 o más argumentos. 
;
; Para una función de 2 argumentos, f(x, y), conocido el valor del primer
; argumento (x = a), la función de un argumento que se evalúa a f(a, y) es
; la función lambda que retornaría curry(f, a). Es decir,
; curry(f, a) = y -> f(a, y)
;
; curry(filter, even?) =>  y -> filter(even?, y)

(define suma-v1 (curry + 5))

; Retorna la función lambda: x -> 5 + x. Obsérvese que el orden es
; importante, aunque para la suma resulte irrelevante porque es
; asociativa. En general, curry(f, a) = x -> f(a, x) que no es lo
; mismo que x -> f(x, a), salvo que f sea asociativa.
;
; En Racket, la siguiente definición de suma-v2 sería equivalente a
; suma-v1 (ignorando que esta última admite un número de argumentos
; variables por la función +):

(define suma-v2
  (lambda(x)
    (+ 5 x)))

(display "suma-v1(4): ")
(suma-v1 4)
(display "suma-v2(4): ")
(suma-v2 4)

; Para que suma-v1 y suma-v2 fueran totalmente equivalentes, la
; función lambda también debería admitir un número de argumentos
; variable:

(define suma-v2
  (lambda x
    (+  5 (apply + x))))

(display "suma-v1(4, -3, 7.25): ")
(suma-v1 4 -3 7.25)
(display "suma-v2(4, -3, 7.25): ")
(suma-v2 4 -3 7.25)

; curry(f, a) = x -> f(a, x)
;
; Funciones lambda de la forma x -> f(a, g(x)) no se corresponden
; directamente con la currificación de f, pero pueden obtenerse
; utilizando ésta en la función predefinida compose:
; compose(curry(f, a), g)
;
; Ejemplos:
(define datos '((a (16 -3 4 0)) (b (5 8 0 11 2)) (c (8 19 9 -15))))

; Obtener las sumas de las listas numéricas de datos
(display "sumas: ")
(map (lambda(x)
       (apply + (cadr x))) datos)

; (map (curry apply +) datos) esto no vale

(display "sumas (compose): ")
(map (compose (curry apply +) cadr) datos)

; Obtener la lista de números correspondiente a un símbolo dado

(display "números de n2: ")
(cadar (filter (compose (curry eq? 'a) car) datos))

; aunque en este caso se puede currificar member directamente
(display "números de n2: ")
(cadar (filter (curry member 'a) datos))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utiliza FOS para definir la función binary-and(n1, n2) que
;; retorna el and de dos números binarios representados por
;; listas de ceros y unos.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (binary-and n1 n2)
 ; (map [lambda(x y) (* x y)] n1 n2)) ;; penaliza
  (map * n1 n2))



; (lambda(x) (length x)) => length

(display "binary-and: ")
(binary-and '(1 1 0 0 1 0 1 0) '(0 1 0 1 1 0 1 1))  ; => (0 1 0 0 1 0 1 0)

;;-------------------------------------------------------------------------
;; Utilizar FOS para definir la función maxLength(l1, l2, l3, ...) que
;; retorna la mayor longitud de las listas que recibe como argumentos. 
;;-------------------------------------------------------------------------




;(display "maxLength: ")
;(maxLength '(a (b c)) '(1 2 3 4) '((a b) (c d) e (f) g)) ;=> 5

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define mediante FOS la función de parámetros variables
;               filtrar-for(f, l1, l2, ...)
;; que retorna la lista: (filter(f, l1) filter(f,l2) ...)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;





;(displayln "filter:")
;(filter-for atom? '(1 (2) 3) '(9 (2 3)) '(0 1 6))      ; => ((1 3) (9) (0 1 6))
;(filter-for number? '(a (b) 3) '(d (2 e)) '(a 1 (b)))  ; => ((3) () (1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; A continuación se define el símbolo Datos cuya evaluación proporciona
;; información organizada mediante campos clave (nombre, estudios, etc.)
;; de varias personas.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Utiliza FOS en la definición de las funciones que se indican posteriormente
;

(define
 Datos
 '(((nombre LUIS) (sexo V) (apellidos GARCIA PEREZ) (estudios (INFORMATICA MEDICINA)) (edad 26) (en_activo #t))
  ((en_activo #t) (sexo M) (nombre MARIA) (apellidos LUZ DIVINA) (edad 23) (estudios (INFORMATICA)))
  ((nombre ADOLFO) (sexo V) (estudios (INFORMATICA)) (apellidos MONTES PELADOS) (edad 24) (en_activo #f))
  ((nombre ANA) (apellidos GARCIA GONZALEZ) (edad 22) (sexo M) (estudios ()) (en_activo #t))
  ((sexo V) (estudios ()) (nombre JOSE) (en_activo #f) (apellidos PEREZ MONTES) (edad 36) )
  ((edad 12) (nombre JOSHUA) (apellidos IGLESIAS GARCIA) (sexo V) (estudios ()) (en_activo #t))
  ((nombre MARUJA) (edad 9) (sexo M) (estudios ()) (apellidos FERNANDEZ GARCIA) (en_activo #f))
  ((apellidos PUERTAS VENTANAS) (nombre GUILLERMO) (en_activo #f) (edad 2) (sexo V) (estudios (ECONOMIA)))))

;; Definir la función info(key, p) que retorna una lista con el valor asociado
;; a la clave key para una persona p dada.




;(display "info: ")
;(info 'apellidos (cadr Datos))  ; => (LUZ DIVINA)

;; Define la funcion buscar(key datos) que retorna la lista con la información de
;; clave dada para todas las personas de datos




;(display "buscar: ")
;(buscar 'nombre Datos)  ; => ((LUIS) (MARIA) (ADOLFO) (ANA) (JOSE LUIS) (JOSHUA) (MARUJA) (GUILLERMO))

;; Define la función buscar+(l-keys, datos) que retorna la lista con la información
;; correspondiente a las claves dadas en la lista l-keys para todas las personas de
;; datos
;;
;; Sugerencia: previamente define una función que haga lo solicitado para una persona dada y,
;; posteriormente, define la función buscar+(l-keys, datos) aplicando la primera a todas las
;; personas de datos




;(displayln "buscar+:")
;(buscar+ '(nombre apellidos) Datos) ;=> ((LUIS GARCIA PEREZ) (MARIA LUZ DIVINA) (ADOLFO MONTES PELADOS)...)
;(buscar+ '(nombre sexo edad) Datos) ;=> ((LUIS V 26) (MARIA M 23) (ADOLFO V 24) (ANA M 22) (JOSE V 36)...)

;;;------------------------------------------------------------------------
;;; EJERCICIOS COMPLEMENTARIOS
;;;------------------------------------------------------------------------

;; Define la función presentar(datos, orden_claves), ésta al ser evaluada recibirá
;; como primer argumento la información de Datos y como segundo una lista que contiene
;; todas las claves de la información y establece el orden en que éstas se deben mostrar.
;;
;; Para ordenar las claves utiliza la función predefinida sort(l, f), que ordena los
;; elementos de la lista l según la función de ordenación f




;(displayln "presentar:")
;(presentar Datos '(apellidos nombre edad sexo estudios en_activo))

;; Utilizar FOS y la función presentar para obtener la información de
;; las personas tal y cómo se indica, prescindiendo de la clave, pero
;; mostrando cada campo en la misma posición de la lista de información:

; ((LUIS GARCIA PEREZ 26 V (INFORMATICA MEDICINA) #t)
;  (MARIA LUZ DIVINA 23 M (INFORMATICA) #t)
;  (ADOLFO MONTES PELADOS 24 V (INFORMATICA) #f)
;  (ANA GARCIA GONZALEZ 22 M () #t)
;  (JOSE PEREZ MONTES 36 V () #f)
;  (JOSHUA IGLESIAS GARCIA 12 V () #t)
;  (MARUJA FERNANDEZ GARCIA 9 M () #f)
;  (GUILLERMO PUERTAS VENTANAS 2 V (ECONOMÍA) #f))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Define mediante FOS la función change-all(l, u, v) que retorna
;; la lista resultante de cambiar cada elemento u de l por v.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




;(display "change-all: ")
;(change-all '((a) b 2 (a 3) (a) a) '(a) 0)  ; => (0 b 2 (a 3) 0 a)

;;
;; Versión currificada
;; -------------------
;; Define la función choose(u, v, z) retorna v si u es igual a z y
;; z en caso contrario. Utiliza esta función para proporcionar una
;; versión currificada de la función change-all






;(display "change-all: ")
;(change-all '((a) b 2 (a 3) (a) a) '(a) 0)  ; => (0 b 2 (a 3) 0 a)

;;-------------------------------------------------------------------------
;; Definir la runción recursiva fill(x, l). Da una lista l, esta
;; función retorna una lista de todas las posibles sublistas que se
;; pueden obtener al incorporar x en cada una de las distintas posiciones
;; de l
;;
;; fill(x, ()) = ( (x) )
;; fill(x, (a b)) = ( (x a b) (a x b) (a b x) )
;;-------------------------------------------------------------------------



;(display "fill: ")
;(fill 'x '(a (b c) d)) ; => ((x a (b c) d) (a x (b c) d) (a (b c) x d) (a (b c) d x))


;; Dar una versión currificada de la función fill


;(display "fill (curry): ")
;(fill 'x '(a (b c) d)) ; => ((x a (b c) d) (a x (b c) d) (a (b c) x d) (a (b c) d x))

;;-------------------------------------------------------------------------
;; Definir el símbolo my-curry como una función lambda para que se
;; comporte igual que la currificación de una función f(x, y) de dos
;; argumentos.
;;
;; Si la definición previa te resulta demasiado compleja, puedes probar la
;; alternativa de definir dos funciones g(f) y h(f, x) que retornen las
;; funciones lambda equivalentes a curry(f) y curry(f, x), respectivamente.
;;-------------------------------------------------------------------------


