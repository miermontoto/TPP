(define (loop-samples samples comments index . optional)
  (displayln "\nsample> Entrando al intérprete de ejemplos...")
  (displayln "sample> Puedes finalizar su ejecución mediante la expresión: (exit)")
  (newline)
  (letrec ([size (- (vector-length samples) 1)]      ; ejemplos entre [0, size]
           [secure-read                              ; (read) seguro
            (lambda (prompt)
              (with-handlers ([exn:fail?
                               (lambda (exn)
                                 (displayln (exn-message exn))
                                 (newline)
                                 (secure-read prompt))])
                (display prompt)                      ; muestra el enunciado del ejemplo y
                (read)))]                             ; pide la entrada al usuario
           [secure-read-from-string                   ; (read-from-string str) seguro
            (lambda (str n)                           ; permite detectar errores sintácticos en la solución
              (with-handlers ([exn:fail?              ; dada para el ejemplo
                               (lambda (exn)
                                 (displayln (exn-message exn))
                                 (newline)
                                 (display "Error en la solución del ejemplo ")
                                 (displayln n)
                                 null)])
                (read-from-string str)))]             ; convierte la cadena con la solución en una expresión
           [numSample->str
            (lambda (n)
              (let ([str (number->string n)])
                (if (< n 10)
                    (string-append "0" str)
                    str)))]
           [failed-attempts                           ; número máximo de intentos fallidos para
            (cond [(null? optional) 3]                ; presentar la solución de ejemplos no guiados
                  [(integer? (car optional))
                   (max 3 (car optional))]
                  [else 3])]
           [retry
            (lambda (n try-number response)
              (cond ([= try-number failed-attempts]   ; se ha alcanzado el máximo de intentos fallidos
                     (displayln (string-append        ; presentar la solución
                                 "\nRespuesta correcta: "
                                 response))
                     (newline)
                     (loop n n 1))                      ; no avanzar al siguiente ejemplo y reiniciar intentos
                    (else
                     (newline)
                     (loop n n (add1 try-number)))))]   ; no avanzar al siguiente ejemplo, siguiente intento
               
           [loop
            (lambda (n previous try-number)
              (let* ([sample (vector-ref samples n)]  ; ejemplo n
                     [guided-sample? (caddr sample)]  ; ¿ejemplo guiado?
                     [sample-with-error?              ; ¿ejemplo guiado con error?
                      (and (= (length sample) 4)
                           (cadddr sample))]   
                     [comment-result?                 ; ¿comentario asociado al resultado?
                      (and (not (zero? (string-length (cadr sample))))
                           (string=?
                            (substring (cadr sample) 0 4)
                            "  ;;"))]
                     [expr-user                       ; expresión que introduce el usuario
                      ((lambda (str)
                         (let ([comment (if (not (= n previous))
                                            (vector-ref comments n)    ; comentario asociado al ejemplo n (y siguientes, normalmente)
                                            ())]   
                               [prompt-sample                          ; prompt del enunciado (o parte del enunciado)
                                (cond ((not guided-sample?)
                                       (string-append
                                        "\n---------> Ejemplo: "
                                        (cadr sample)))                ; enunciado para ejemplos no guiados
                                      ((or (zero? (string-length (cadr sample)))
                                           comment-result?)
                                       (string-append
                                        "---------> Evalúa: "
                                        (car sample)))                 ; muestra la solución para ejemplos guiados
                                      (else
                                       (string-append
                                        "---------> Evalúa: "
                                        (car sample)                   ; muestra la solución para ejemplos guiados y
                                        (cadr sample))))])             ; y alguna parte adicional del enunciado
                           (if [not (null? comment)]                   
                               (displayln (string-append               ; si lo hay, mostrar el comentario
                                           comment "\n;;; "
                                           (make-string 70 #\-) "\n"))
                               "")
                           (secure-read (string-append
                                         prompt-sample "\nsample-" (numSample->str n) "> "))))
                       (car sample))]
                     [OK-response? (equal?                             ; ¿respuesta dada correcta?
                                    expr-user                          
                                    (secure-read-from-string
                                     (car sample) n))]
                     [OK? (or (not guided-sample?)                     ; ¿respuesta correcta en ejemplo guiado?
                              OK-response?                             ; respuesta dada correcta
                              (equal? expr-user '(exit)))])            ; orden de salida
                (cond [(not OK?)                                       ; sólo para ejemplos guiados
                       (displayln "Escribe la expresión correctamente")
                       (newline)
                       (loop n n (add1 try-number))]
                      [(equal? expr-user '(exit))                      ; orden de salida del intérprete
                       (displayln "\nSaliendo del intérprete...\n")]
                      [else (let ([result
                                   (with-handlers ([exn:fail?
                                                    (lambda (exn)
                                                      (display (exn-message exn))
                                                      (display ".\n")
                                                      '¡Error!)])
                                     (eval expr-user))])              ; evaluación de la expresión dada por el usuario
                              (cond ([and (eq? result '¡Error!)       ; ejemplo no guiado y la respuesta del usuario
                                          (not guided-sample?)]       ; provoca un error
                                     ;(loop n (add1 try-number)))             ; no avanzar al siguiente ejemplo
                                     (retry n try-number
                                            (car sample)))            ; reintentar
                                    ([and (not guided-sample?)        ; ejemplo no guiado con respuesta
                                          (not OK-response?)]         ; de usuario incorrecta (sin error)
                                     (write result)                   ; poner la solución incorrecta del usuario
                                     (displayln "   ;; Respuesta Incorrecta")
                                     (retry n try-number              ; reintentar
                                            (car sample)))
                                    (else
                                     (write result)
                                     (display "  ")
                                     (displayln
                                      (if (and guided-sample? comment-result?)
                                          (cadr sample)               ; muestra el comentario del resultado
                                          ""))
                                     (newline)
                                     (if (= n size)
                                         (write '¡Terminaste!)        ; no hay más ejemplos, salir
                                         (loop (+ n 1) n 1)))))])))])     ; ir al siguiente
    (cond [(or (not (integer? index)) (< index 0) (> index size))
           (display "El argumento debe ser un entero del rango: [0, ")
           (write size)
           (displayln "]")]
          [else (loop index (- index 1) 1)])))

;(define tutorial loop-samples)
;(define (tutorial sample-numer)
;  (loop-samples ejemplos comentarios 0))