#|--------------------------------------------------------------------------------------------------------------
NAME: Ran Tao
SID: 11488080

CptS355 - Assignment 3 (Scheme)
Spring 2017
Scheme Functions
--------------------------------------------------------------------------------------------------------------|#


;;;hw3 q1 - (deepSum L)
#|--------------------------------------------------------------------------------------------------------------
The function deepSum takes a single argument, L, a list, and returns the sum of elements (atoms) contained in L
and the sublists in L. You can assume that list L contains either integers or sublists containing integers. 
--------------------------------------------------------------------------------------------------------------|#
(define (deepSum L)(cond
                     ((null? L) 0)
                     ((null? (car L)) 0)
                     ((pair? (car L))(+ (deepSum(car L)) (deepSum (cdr L))))
                     (else (+ (car L) (deepSum (cdr L))))
                     ))

(display "(1. (deepSum '(1 (2 3 4) (5) 6 7 (8 9 10) 11)) returns 66) => ")
(deepSum '(1 (2 3 4) (5) 6 7 (8 9 10) 11))

(display "(1. (deepSum '( () )) returns 0) => ")
(deepSum '(()))

;;;hw3 q2 - (numbersToSum sum L)
#|--------------------------------------------------------------------------------------------------------------
The function numbersToSum that takes an int (called sum)(which you can assume is positive), and
an int list L (which you can assume contains positive numbers) and returns a list. The
returned list should include the first n elements from the input list such that the first n elements of the
list add to less than sum, but the first (n + 1) elements of the list add to sum or more.
Assume the entire list sums to more than the passed in sum value. 
--------------------------------------------------------------------------------------------------------------|#
(define (numbersToSum num L)(cond
                              ((null? L) '())
                              ((eq? num 0) '())                              
                              (( > num (car L))(cons (car L)(numbersToSum (- num (car L)) (cdr L))))
                              (else '())
                              ))

(display "(2. (numbersToSum 100 '(10 20 30 40)) returns (10 20 30)) => ")
(numbersToSum 100 '(10 20 30 40))
(display "(2. (numbersToSum 30 '(5 4 6 10 4 2 1 5)) returns (5 4 6 10 4)) => ")
(numbersToSum 30 '(5 4 6 10 4 2 1 5))

;;;hw3 q3 - (isSorted L)
#|--------------------------------------------------------------------------------------------------------------
The function isSorted takes a list (which contains positive numbers) and returns true if the elements
in the list are in ascending order. isSorted will return false otherwise. (Hint: use length function
to check the length of a list) 
--------------------------------------------------------------------------------------------------------------|#
(define (isSorted L)(cond
                      ((null? L) #t)
                      ((eq? (length L) 1) #t)
                      ((> (car (cdr L)) (car L))(isSorted (cdr L)))
                      (else #f)
                      ))
(display "(3. (isSorted '(1 4 5 6 10)) returns #t) => ")
(isSorted '(1 4 5 6 10))
(display "(3. (isSorted '(1 3 6 5 10)) returns #f) => ")
(isSorted '(1 3 6 5 10))
(display "(3. (isSorted '(1)) returns #t) => ")
(isSorted '(1))

;;;hw3 q4 - (mergeUnique2 L1 L2)
#|--------------------------------------------------------------------------------------------------------------
The function mergeUnique2 takes two lists of integers, L1 and L2, each already in ascending order,
and returns a merged list that is also in ascending order and that doesn’t include any duplicates. The
resulting list should be the union of the elements of the two lists. Duplicates should be eliminated
during the merge. You may assume that input lists, L1 and L2, don’t contain any duplicates. 
--------------------------------------------------------------------------------------------------------------|#
(define (mergeUnique2 L1 L2)(cond
                              ((null? L1) L2)
                              ((null? L2) L1)                             
                              ((< (car L1)(car L2))(cons (car L1) (mergeUnique2 (cdr l1) l2)))
                              ((> (car L1)(car L2))(cons (car L2) (mergeUnique2 (cdr L2) L1)))
                              (else (cons (car L1) (mergeUnique2 (cdr L1) (cdr L2))))
                              ))

(display "(4. (mergeUnique2 '(4 6 7) '(3 5 7)) returns (3 4 5 6 7 )) => ")
(mergeUnique2 '(4 6 7) '(3 5 7))
(display "(4. (mergeUnique2 '(1 5 7) '(2 5 7)) returns (1 2 5 7)) => ")
(mergeUnique2 '(1 5 7) '(2 5 7)) 
(display "(4. (mergeUnique2 '() '(3 5 7)) returns (3 5 7)) => ")
(mergeUnique2 '() '(3 5 7))

;hw3 (fold f base L)
;It traverses the list from right to left and applies the combining function. 
(define (fold f base L) (cond
                           ((null? L) base)
                           (else (f (car L) (fold f base (cdr L))))
                           ))

(define (foldl f base L) (cond
                           ((null? L) base)
                           (else (foldl f (f base (car L)) (cdr L)))
                           ))

;;;hw3 q5 - (mergeUniqueN Ln)
#|--------------------------------------------------------------------------------------------------------------
a) Using mergeUnique2 function defined above and the fold function, define mergeUniqueN which
takes a list of lists, each already in ascending order, and returns a new list containing all of the elements
in ascending order. (You may assume that the sublists in Ln don’t contain any duplicate values.)
--------------------------------------------------------------------------------------------------------------|#
(define (mergeUniqueN Ln)(fold mergeUnique2 '() Ln))

(display "(5. (mergeUniqueN '()) returns ()) => ")
(mergeUniqueN '())
(display "(5. (mergeUniqueN '((2 4 6) (1 4 5 6))) returns (1 2 4 5 6)) => ")
(mergeUniqueN '((2 4 6) (1 4 5 6)))
(display "(5. (mergeUniqueN '((2 4 6 10) (1 3 6) (8 9))) returns (1 2 3 4 6 8 9 10)) => ")
(mergeUniqueN '((2 4 6 10) (1 3 6) (8 9)))
#|--------------------------------------------------------------------------------------------------------------
b) In a comment, discuss the question of how many cons operations your function uses to produce its
result, in terms of the sizes of the input lists. Explain your answer. For this problem, I suggest looking
first at how many cons operations are used by mergeUnique2 for lists of length len1 and len2. If
mergeUniqueN is used for a list with a single sublisy, what is the answer? For 2 sublists? For n
sublists?
----------------------------------------------------------------------------------------------------------------
Ansewr: b) 1 sublist => cons will be length of sublist - 1
           2 sublists => cons will be sum of length of two sublists - 1
           so, n sublists => cons will be sum of length of n sublists - 1
--------------------------------------------------------------------------------------------------------------|#


;hw3 q6 - mymap
(define (mymap f L) (cond
                      ((null? L) '())
                      (else ( cons (f (car L)) (mymap f (cdr L))))
                      ))
;hw3 q6 - recursion
(define (matrixMapRe f M)(cond
                         ((null? M) '())
                         (else (cons (mymap f (car M)) (matrixMapRe f (cdr M))))
                         ))
;;;hw3 q6 - (matrixMap f M) non-recursion
#|--------------------------------------------------------------------------------------------------------------
A matrix M can be represented in Scheme as a list of lists, for example M='((1 2) (3 4))
Without using recursion, write a function matrixMap, which takes a function f and a matrix M as
arguments and returns a matrix consisting of f applied to the elements of M.
--------------------------------------------------------------------------------------------------------------|#
(define (matrixMap f M)(list (map f (car M))(map f (car (cdr M)))))

(display "(6. (matrixMap (lambda (x) (* x x)) '((1 2) (3 4)) ) returns ((1 4) (9 16))) => ")
(matrixMap (lambda (x) (* x x)) '((1 2) (3 4)))
(display "(6. (matrixMap (lambda (x) (+ 1 x)) '((0 1 2) (3 4 5)) ) returns ((1 2 3) (4 5 6))) => ")
(matrixMap (lambda (x) (+ 1 x)) '((0 1 2) (3 4 5)))

;hw3 q7 - mulit-functions
;determine a number is odd or not
(define (isOdd x)(cond
                   ((odd? x) x)
                   (else #f)
                   ))

;Filter function takes a “predicate “ function and a list, and returns
;a list consisting the elements of the original list for which the
;predicate function returns true for. 
(define (filter pred L) (cond
                          ((null? L) '())
                          ((pred (car L)) (cons (car L) (filter pred (cdr L))))
                          (else (filter pred (cdr L)))
                          ))

;add a list number up
(define (addup L) (cond
                    ((null? L) 0)
                    (else (+ (car L) (addup (cdr L))))
                    ))

;;count the length of a list
(define (mylength L) (cond
                       ((null? L) 0)
                       (else (+ 1 (mylength (cdr L))))
                       ))
;;;hw3 q7 (aveOdd L)
#|--------------------------------------------------------------------------------------------------------------
Without using recursion, write a function avgOdd which takes a list L and returns the average of
the odd values in L
--------------------------------------------------------------------------------------------------------------|#
(define (avgOdd L)(/ (addup(filter isOdd L)) (mylength(filter isOdd L))))

(display "(7. (avgOdd '(1 2 3 4 5)) returns 3) => ")
(avgOdd '(1 2 3 4 5))
(display "(7. (avgOdd '(1 3 5)) returns 3) => ")
(avgOdd '(1 3 5))
(display "(7. (avgOdd '(1 2 4 6)) returns 1) => ")
(avgOdd '(1 2 4 6))

;;;hw3 q8 (unzip L)
#|--------------------------------------------------------------------------------------------------------------
In class we defined a function named zip that takes two lists as its arguments and produces a list of
pairs as its output. For this problem, define the inverse of zip without using recursion, namely unzip,
that takes a list of two-element lists as input and produces a list of two lists as output. (Hint: Call the
map function twice to get the first and second values from pairs)
What should (unzip '()) be?
--------------------------------------------------------------------------------------------------------------|#
(define (unzip L)(cond
                  ((null? L) '(() ()))
                  (else (apply map list L))
                  ))

(display "(8. (unzip '()) returns (() ())) => ")
(unzip '())
(display "(8. (unzip '((1 2) (3 4) (5 6))) returns ((1 3 5) (2 4 6))) => ")
(unzip '((1 2) (3 4) (5 6)))
(display "(8. (unzip '((1 “a”) (5 “b”) (8 “c”))) returns ((1 5 8) (“a” “b” “c”))) => ")
(unzip '((1 “a”) (5 “b”) (8 “c”)))


;;;hw3 testFunction
#|--------------------------------------------------------------------------------------------------------------|#
(define (testFunctions)
  (cond
          ((eqv? #f (= (deepSum '(1 (2 3 4) (5) 6 7 (8 9 10) 11)) 66)) (display "deepSum failed"))
          ((eqv? #f (= (deepSum '( () ))                           0)) (display "deepSum failed"))
          
          ((eqv? #f (equal? (numbersToSum 100 '(10 20 30 40))     '(10 20 30)))   (display "numbersToSum failed"))
          ((eqv? #f (equal? (numbersToSum 30 '(5 4 6 10 4 2 1 5)) '(5 4 6 10 4))) (display "numbersToSum failed"))
          
          ((eqv? #f (eqv? (isSorted '(1 4 5 6 10)) #t)) (display "isSorted failed"))
          ((eqv? #f (eqv? (isSorted '(1 3 6 5 10)) #f)) (display "isSorted failed"))
          ((eqv? #f (eqv? (isSorted '(1))          #t)) (display "isSorted failed"))
          
          ((eqv? #f (equal? (mergeUnique2 '(4 6 7) '(3 5 7)) '(3 4 5 6 7))) (display "mergeUnique2 failed"))
          ((eqv? #f (equal? (mergeUnique2 '(1 5 7) '(2 5 7)) '(1 2 5 7)))   (display "mergeUnique2 failed"))
          ((eqv? #f (equal? (mergeUnique2 '() '(3 5 7))      '(3 5 7)))     (display "mergeUnique2 failed"))
          
          ((eqv? #f (equal? (mergeUniqueN '())                         '()))                (display "mergeUniqueN failed"))
          ((eqv? #f (equal? (mergeUniqueN '((2 4 6) (1 4 5 6)))        '(1 2 4 5 6)))        (display "mergeUniqueN failed"))
          ((eqv? #f (equal? (mergeUniqueN '((2 4 6 10) (1 3 6) (8 9))) '(1 2 3 4 6 8 9 10))) (display "mergeUniqueN failed"))
          
          ((eqv? #f (equal? (matrixMap (lambda (x) (* x x)) '((1 2) (3 4)) )     '((1 4) (9 16)) ))    (display "matrixMap failed"))
          ((eqv? #f (equal? (matrixMap (lambda (x) (+ 1 x)) '((0 1 2) (3 4 5)) ) '((1 2 3) (4 5 6)) )) (display "matrixMap failed"))

          ((eqv? #f (= (avgOdd '(1 2 3 4 5)) 3)) (display "avgOdd failed"))
          ((eqv? #f (= (avgOdd '(1 3 5))     3)) (display "avgOdd failed"))
          ((eqv? #f (= (avgOdd '(1 2 4 6))   1)) (display "avgOdd failed"))

          ((eqv? #f (equal? (unzip '())                        '(()())))                  (display "unzip failed"))
          ((eqv? #f (equal? (unzip '((1 2) (3 4) (5 6)))       '((1 3 5) (2 4 6))))       (display "unzip failed"))
          ((eqv? #f (equal? (unzip '((1 “a”) (5 “b”) (8 “c”))) '((1 5 8) (“a” “b” “c”)))) (display "unzip failed"))
          
          (else (display "All functions passed tests!"))))

(testFunctions)