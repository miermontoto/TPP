;;; ************
;;; * TUTORIAL *
;;; ************

(require "samples_V1.2.rkt")   ; ejemplos del tutorial (actualmente 47)

(require mzlib/compat)         ; Importa una biblioteca. En particular, nos
                               ; permite utilizar la función atom? que, en
                               ; otro caso, no estaría disponible

;;; S-expresiones:
;;;         Constructor (cons)
;;;         Observadores
;;;                   primer elemento de la lista (car)
;;;                   resto de elementos de la lista (cdr)

(load "loop-samples.rkt")
(define (tutorial num-ejemplo)
  (loop-samples ejemplos comentarios num-ejemplo))

; Bucle de ejemplos numerados comenzando en el primero (ejemplo 0):
(tutorial 0)
; se puede salir en cualquier momento mediante: (exit)
;
; Se puede comenzar (o continuar) en cualquier ejemplo indicando su
; número: (tutorial n)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;  ¿CÓMO USAR EL TUTORIAL?  ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Lee con atención el texto que se presenta inicialmente, ya que el
;;; ejemplo de expresión (o expresiones) que se evaluarán a continuación
;;; pretenden aclarar la información que éste proporciona.
;;;
;;; Las expresiones que se han de evaluar, las proporciona el propio
;;; tutorial, excepto para los últimos ejemplos. Se indican como:
;;;
;;; ---------> Evalúa: <expresión_a_evaluar>
;;;
;;; Debes entonces proporcionar esta <expresión_a_evaluar> en la caja de
;;; entrada que aparece en la línea siguiente y pulsar <RETURN> para que
;;; la expresión se evalúe mediante el intérprete de racket. El resultado
;;; de la evaluación se muestra en la siguiente línea, habitualmente
;;; acompañado de un pequeño comentario sobre el resultado obtenido y
;;; que está separado de éste por los caracteres ';;'.
;;;
;;; Con el fin de aclarar algunas cuestiones o ver que ocurre cuando se
;;; proporciona al intérprete una expresión errónea, unos pocos ejemplos
;;; solicitan introducir expresiones incorrectas para el intérprete y,
;;; por tanto, el resultado de su evaluación será un error retornado por
;;; éste. Desde el punto de vista del tutorial la expresión tecleada es
;;; válida pero la marca como '¡Error!' y se comenta éste.
;;; 
;;; Ten en cuenta que en este tutorial se ven las cuestiones más
;;; básicas sobre la expresiones de racket y sobre cómo el intérprete
;;; evalua éstas (algo que va a ser habitual en todas las prácticas de
;;; programación funcional). Por tanto, no debe quedar duda alguna del
;;; texto que se muestra para los ejemplos, de cómo se proporciona una
;;; expresión y tipos de éstas, o de los resultados obtenidos en la
;;; evaluación o sobre los comentarios de estas evaluaciones.
;;;
;;; Si te queda alguna duda, solicita ayuda a tu profesor de prácticas
;;; para que te las resuelva.
;;;
;;; Errores en la expresiones a evaluar
;;; -----------------------------------
;;; La mayor parte de las expresiones que se evaluarán llevan paréntesis
;;; y para que éstas se puedan interpretar es necesario que los
;;; paréntesis estén equilibrados (igual número de paréntesis izquierdos
;;; y paréntesis derechos), de forma que al tratar de evaluar una
;;; expresión se puede producir alguno de los siguientes errores:
;;;
;;;     1. La expresión tecleada no es la que solicita el tutorial. En
;;;        este caso, el tutorial informa de ello y vuelve a solicitar
;;;        la expresión que espera.
;;;
;;;     2. En la expresión tecleada hay paréntesis derechos de más. En
;;;        este caso, el tutorial trasladada el error del intérprete
;;;        'read: unexpected `)`' y vuelve a solicitar la expresión que
;;;        espera.
;;;
;;;     3. En la expresión tecleada hay paréntesis izquierdos de más. En
;;;        este caso, volverá a aparecer la caja de entrada tras pulsar
;;;        <RETURN> hasta que se tecleen los suficientes paréntesis
;;;        derechos como para equilibrar la expresión, o bien haya un
;;;        exceso de éstos, en cuyo caso se pasará al caso 2. Lo que
;;;        ocurra después dependerá de que la expresión dada finalmente
;;;        sea la que espera el tutorial o no.
;;;
;;; En resumen, el intérprete sólo puede evaluar expresiones con
;;; paréntesis equilibrados y si lo que falta son paréntesis derechos
;;; queda a la espera de que se pongan éstos e ignora las pulsaciones
;;; sobre la tecla <RETURN> a efectos de evaluación (obviamente, cada
;;; pulsación de ésta conlleva pasar a la línea siguiente).
;;;
