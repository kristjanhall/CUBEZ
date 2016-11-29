#|
Validators are simple methods that take in some inital value, like a list of
valid values, and returns a function that can be evaluated for any other
value of valid type

eval methods (every and any) take in a list of validators and runs some value
through all of them

|#

;; true if and only of all validators return true
(defun validator.every (validators val &optional valB)
  (let ((pass T))
    ;(print val)
    ;(print valB)
    (loop for validator in validators do
      (setf pass (and pass (funcall validator val valB))))
    pass))


;; true if any validator returns true
(defun validator.any (validators val &optional valB)
  (let ((pass nil))
    (loop for validator in validators do
      (setf pass (or pass (funcall validator val valB))))
    pass))

; example
;(validator.every (list (validator.inlist '(1 3 5 7)) (validator.notinlist '(2 4 6 8))) 3)


;; validation methods
(defun validator.inlist (lst) (function (lambda (number &optional lstb) (find number lst))))
(defun validator.notinlist (lst) (function (lambda (number &optional lstb) (not (find number lst)))))
(defun validator.notlast () (function (lambda (number &optional lstb) (neq (car lstb) number))))
(defun validator.same (numa) (function (lambda (numb) (eq numa numb))))
(defun validator.notsameas (numa) (function (lambda (numb) (neq numa numb))))
(defun validator.lessthan (max) (function (lambda (value) (<= value max))))
(defun validator.morethan (min) (function (lambda (value) (>= value min))))

; true only if number is max N distance from the last element in the list
; note that we assume that the list is reversed here
(defun validator.minfromlast (N)
  (function
    (lambda (number lst)
      (progn
        (if (or 
            (eq nil lst)
            (> (abs (- (first lst) number)) (- N 1)))
          T nil)))))

; true only if number is max N distance from the last element in the list
; note that we assume that the list is reversed here
(defun validator.maxfromlast (N)
  (function
    (lambda (number lst)
      (progn
        (if (or 
            (eq nil lst)
            (< (abs (- (first lst) number)) (+ N 1)))
            ;(< (abs (- (nth 0 (last lst)) number)) (+ N 1)))
          T nil)))))

; true only of number is not in the last N elements in the list
; note that we assume that the list is reversed here
(defun validator.notinlastN (N)
  (function
    (lambda (number lst)
      ;(if (neq nil lst)
      ;  (print (last lst (min N (length lst))))
      ;  (print "lst is nil"))
      (if (neq nil lst)
        (not (find number (last lst (min N (length lst)))))
        T))))

; validates that some note is in some note list - note that this requires some mod 12 calculations
(defun validator.validnote (notes)
  (function
    (lambda (note &optional lst)
      ;(print (find (math.modN 12 note) (mapcar #'(lambda (x) (math.modN 12 x)) notes)))
      (find (math.modN 12 note) (mapcar #'(lambda (x) (math.modN 12 x)) notes)))))

(defun validator.validinterval (intervals)
  (function
    (lambda (interval &optional lst)
      (if (eq 0 intervals)
        T
        (not (find (math.modN 12 interval) (mapcar #'(lambda (x) (math.modN 12 x)) intervals)))))))