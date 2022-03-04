(define (int->unary n) 
    (if (eq? n 1) 
        '(s . z) 
        (cons 's (int->unary (- n 1)))))

(define (unary->int n) 
    (if (equal? n 'z) 
        0
        (+ 1 (unary->int (cdr n)))))

(define (unary-add n1 n2) 
    (if (equal? n1 'z) 
        n2
        (cons 's (unary-add (cdr n1) n2))))

(define (unary-add-tr n1 n2) 
    (if (equal? n1 'z) 
        n2
        (unary-add-tr (cdr n1) (cons (car n1) n2))))
(define (unary-mul n1 n2) 
    (if (equal? n1 'z) 
        'z
        (unary-add n2 (unary-mul (cdr n1) n2))))

;TODO
(define (contains-empty-lists-only? ls) 
    (if (and (not (equal? ls '()))) 
        'z
        (unary-add n2 (unary-mul (cdr n1) n2))))