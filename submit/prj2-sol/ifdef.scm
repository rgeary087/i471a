#!/usr/bin/env racket
#lang racket

(require json)
(require racket/cmdline)

(require "gram.scm")
;;; Parser


;;grammar
(define IFDEF-GRAM
  '((start . ( (source EOF) ))
    (source . ( (TEXT source) (ifdef source) () ))
    (ifdef . ( (def SYM source elif else ENDIF) ))
    (def . ( (IFDEF) (IFNDEF) ))
    (elif . ( (ELIF SYM source elif) () ))
    (else . ( (ELSE source) () ))))
	    
;;; Lexer

(define DEF-RE #px"^\\s*\\#(ifdef|ifndef|elif|else|endif)\\b")
(define SYM-RE #px"^\\s+([_a-zA-Z]\\w*)")
(define SYM-DEFS '( "ifdef" "ifndef" "elif" ))

(define (read-stdin)
  (port->string (current-input-port))
)

(define (push-text text toks)
  (if (> (string-length text) 0)
      (cons (list 'TEXT text) toks)
      toks))

(define (scan-lines lines (toks '()) (text ""))
  (if (eq? (length lines) 0)
      (reverse (push-text text toks))
      (let* ([line (car lines)]
	     [rest (cdr lines)]
	     [m-def (regexp-match DEF-RE line)])
	(if (not m-def)
	    (scan-lines rest toks (string-append text line "\n"))
	    (let*
		([toks1 (push-text text toks)]
		 [def (cadr m-def)]
		 [def-len (string-length (car m-def))]
		 [toks2 (cons (list (string->symbol (string-upcase def))
				    (string-append "#" def))
			      toks1)])
	      (if (member def SYM-DEFS)
		  (let ([m-sym (regexp-match SYM-RE (substring line def-len))])
		    (if m-sym
			(scan-lines rest (cons (list 'SYM (cadr m-sym)) toks2))
			(scan-lines rest toks2)))
		  (scan-lines rest toks2)))))))


(define (scan text)
  (scan-lines (string-split (regexp-replace #rx"\n$" text "") "\n")))

(define (scan-stdin)
  (scan (read-stdin)))

;;; main program

(define (usage)
  (display "usage: ifdef.scm parse|scan")
  (newline))
  

;;used to delimit end of input to parser
(define EOF-TOK (list 'EOF "<EOF>"))

(define (main)
  (let* ([args (vector->list (current-command-line-arguments))])
	 (if (eq? (length args) 0)
	     (usage)
	     (cond
	      [(equal? (car args) "scan")
	       (let ([toks (scan-stdin)]
                     ;mapper to convert sym token-kind to string for json
		     [map-tok (lambda (tok) (cons (symbol->string (car tok))
						  (cdr tok)))])
		 (write-json (map map-tok toks)))]
	      [(equal? (car args) "parse")
	       (begin
		 (display (parse IFDEF-GRAM
				 (append (scan-stdin) (list EOF-TOK))))
		 (newline))]
	      (else (usage))))))



(main)
