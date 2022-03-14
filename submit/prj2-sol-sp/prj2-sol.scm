#!/usr/bin/env racket

#lang racket
(require rackunit)
(require racket/trace)
(define (int->unary n) 
    (if (eq? n 1) 
        '(s . z) 
        (cons 's (int->unary (- n 1)))))

(check-equal? (int->unary 0) 'z)
(check-equal? (int->unary 1) '(s . z))
(check-equal? (int->unary 2) '(s s . z))
(check-equal? (int->unary 5) '(s s s s s . z))


(define (unary->int n) 
    (if (equal? n 'z) 
        0
        (+ 1 (unary->int (cdr n)))))

(check-equal? (unary->int 'z) 0)
(check-equal? (unary->int '(s . z)) 1)
(check-equal? (unary->int  '(s  s . z)) 2)
(check-equal? (unary->int '(s s s s s . z)) 5)

(define (unary-add n1 n2) 
    (if (equal? n1 'z) 
        n2
        (cons 's (unary-add (cdr n1) n2))))
(check-equal? (unary-add 'z '(s . z)) '(s . z))
(check-equal? (unary-add '(s . z) 'z) '(s . z))
(check-equal? (unary-add '(s  s . z) '(s . z)) '(s s s . z))
(check-equal? (unary-add (int->unary 5) (int->unary 9)) (int->unary 14))

(define (unary-add-tr n1 n2) 
    (if (equal? n1 'z) 
        n2
        (unary-add-tr (cdr n1) (cons (car n1) n2))))
(check-equal? (unary-add-tr 'z '(s . z)) '(s . z))
(check-equal? (unary-add-tr '(s . z) 'z) '(s . z))
(check-equal? (unary-add-tr '(s  s . z) '(s . z)) '(s s s . z))
(check-equal? (unary-add-tr (int->unary 5) (int->unary 9)) (int->unary 14))

(define (unary-mul n1 n2) 
    (if (equal? n1 'z) 
        'z
        (unary-add n2 (unary-mul (cdr n1) n2))))
(check-equal? (unary-mul 'z '(s . z)) 'z)
(check-equal? (unary-mul '(s s . z) 'z) 'z)
(check-equal? (unary-mul '(s . z) '(s . z)) '(s . z))
(check-equal? (unary-mul '(s s . z) '(s . z)) '(s s . z))
(check-equal? (unary-mul '(s s . z) '(s s  s . z))
	      '(s s s s s s . z))
(check-equal? (unary-mul (int->unary 5) (int->unary 9)) (int->unary 45))

;TODO
(define (contains-empty-lists-only? ls) 
    (cond [(and (not (equal? ls '())) (equal? '() (car ls)))
        (and #t (contains-empty-lists-only? (cdr ls)))]
        [(and (not (equal? ls '() )))
        #f]
        [else #t]
      ))


(define (split-firsts ls)
  (letrec ([greats
    (lambda (acc1 acc2 l) 
      (cond [(and (pair? l) (pair? (car l)))
        (greats (cons (caar l) acc1 ) (cons (cdr (car l)) acc2 ) (cdr l))]
        [(and (pair? l) (not (pair? (car 1))))
        (greats (cons '() acc1 ) (cons '() acc2 ) (cdr l))]
        [else (cons (reverse acc1) (list (reverse acc2)))]
      )
    )])
    (greats '() '() ls))
  )

(define (list-tuples l1) 
    (if (not (pair? (cdr l1)))
        (cdr l1)
        (let [(x (split-firsts l1))](append (car x) (list-tuples (cdr x))))))

