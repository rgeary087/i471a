(define (quadratic-roots2 a b c f) (if (= a 0) (error 1) (let ([disc (f (- (* b b) (* 4 (*
a c))))]) (list (quad-func b a disc) (quad-func b a (- disc))))))

(define (guess a b) (if (> (/ (abs (- (* a a) b)) b) .0001) (guess (/ (+ a ( / b a)) 2) b)
a))

(define (my-sqrt b) (guess 1.0 b))

(define (quad-func b a d) (/ (+ (- b) d) (* 2 a)))

(define (discriminant a b c) (sqrt (- (* b b) (* 4 (* a c)))))

(define (cmp-gt ls1 ls2)
   (if (null? ls1)
       '()
       (cons (> (car ls1) (car ls2))
             (cmp-gt (cdr ls1) (cdr ls2)))))
             
(define (ls-prod list1 list2) (if (null? list1) '()
	(cons (* ( car list1) (car list2)) (ls-prod (cdr list1) (cdr list2)))))

(define (ls-f list1 list2 f) (if (null? list1) '()
	(cons (f ( car list1) (car list2)) (ls-f (cdr list1) (cdr list2) f))))
	
(define (greater-than list1 num) (if (null? list1) '()
	(cons (> (car list1) num) (greater-than (cdr list1) num))))
