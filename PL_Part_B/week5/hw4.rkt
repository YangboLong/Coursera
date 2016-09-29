#lang racket

(provide (all-defined-out)) ;; so we can put tests in a second file

;; put your code below
; Problem 1
(define (sequence low high stride)
  (if (> low high)
      null
      (cons low (sequence (+ low stride) high stride))))

; Problem 2
(define (string-append-map xs suffix)
  (map (lambda (x) (string-append x suffix)) xs))

; Problem 3
(define (list-nth-mod xs n)
  (cond [(< n 0) (error "list-nth-mod: negative number")]
        [(null? xs) (error "list-nth-mod: empty list")]
        [#t (let ([i (remainder n (length xs))])
              (car (list-tail xs i)))]))

; Problem 4
(define (stream-for-n-steps s n)
  (let ([pr (s)])
    (if (= n 0)
        null
        (cons (car pr) (stream-for-n-steps (cdr pr) (- n 1))))))

; Problem 5
(define funny-number-stream
  (letrec ([f (lambda (x)
                (if (= (remainder x 5) 0)
                    (cons (* x -1) (lambda () (f (+ x 1))))
                    (cons x (lambda () (f (+ x 1))))))])
    (lambda () (f 1))))

; Problem 6
(define dan-then-dog
  (letrec ([f (lambda (i)
                (if (= (remainder i 2) 0)
                    (cons "dan.jpg" (lambda () (f (+ i 1))))
                    (cons "dog.jpg" (lambda () (f (+ i 1))))))])
    (lambda () (f 0))))

; Problem 7
(define (stream-add-zero s)
  (letrec ([pr (s)]
           [th (lambda () (cons (cons 0 (car pr)) (stream-add-zero (cdr pr))))])
    (lambda () (th))))

; Problem 8
(define (cycle-lists xs ys)
  (letrec ([f (lambda (n)
                (cons (cons (list-nth-mod xs n) (list-nth-mod ys n)) (lambda () (f (+ n 1)))))])
    (lambda () (f 0))))

; Problem 9
(define (vector-assoc v vec)
  (letrec ([f (lambda (i)
                (if (= (vector-length vec) i)
                #f ; no pair was found in vector
                (let ([v1 (vector-ref vec i)])
                  (if (and (pair? v1) (equal? v (car v1)))
                      v1 ; found the pair, return it
                      (f (+ i 1))))))]) ; not found yet, check next element
    (f 0)))

; Problem 10
(define (cached-assoc xs n)
  (letrec ([vec (make-vector n #f)]
           [pos 0] ; next slot in cache vec
           [f (lambda (v)
                (let ([ans (vector-assoc v vec)]) ; check cache for the value v
                  (if ans
                      ans ; has answer in cache, return the pair
                      (let ([pr (assoc v xs)]) ; no answer in cache
                        (if pr
                            (begin ; value v is in list xs
                              (vector-set! vec pos pr) ; add the pair to cache
                              (if (= pos (- n 1)) ; modify cache index pos
                                  (set! pos 0)
                                  (set! pos (+ pos 1)))
                              pr)
                            #f)))))]) ; v is not in xs
    f))