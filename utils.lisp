
; list.removeNth - remote the nth element from a list
; lst: list to work in
; n: the element number to remove
; returns a new list
(defun utils.lists.removeNth (lst n)
  (declare
    (type (integer 0) n)
    (type list lst))
  (if (or (zerop n) (null lst))
    (cdr lst)
    (cons (car lst) (utils.lists.removeNth (cdr lst) (1- n)))))


; list.removeFirstRef - remove the first instance of some element in a list
; lst: the list to work on
; element: the element to remove
; returns a new list
(defun utils.lists.removeFirstRef (lst element)
  (let ((pos (position element lst)))
    (if (neq nil pos)
      (utils.lists.removeNth lst pos)
      lst)))


; '(int) -> '(int)
; return a list of 0's and 1's where 0 stands for decremental distance
; and 1 stands for incremental distance between elements in a list
(defun utils.lists.vectors (lst)
  (let ((dirs) (i 1))
    (loop while (< i (length lst)) do
      (if
        (< (- (nth (- i 1) lst) (nth i lst)) 0)
        (push 1 dirs)
        (push 0 dirs))
      (incf i))
    dirs))


; '(int) -> '(int)
; takes in a list of ints and returns a list with the absolute distances between
; each element
(defun utils.lists.distances (lst)
  (let ((distances) (i 1))
    (loop while (< i (length lst)) do
      (progn
        (push (abs (- (nth (- i 1) lst) (nth i lst))) distances)
        (incf i)))
    distances))


; '(int) -> '(int)
; takes in a list of ints and returns a list with the distances between each
; element
(defun utils.lists.distancesi (lst)
  (let ((distances) (i 1))
    (loop while (< i (length lst)) do
      (progn
        (push (- (nth (- i 1) lst) (nth i lst)) distances)
        (incf i)))
    distances))


; find the absolute distance between two lists of equal size
; i.e. |lstA_i - lstB_i|
(defun utils.lists.lstDistances (lstA lstB)
  (mapcar #'(lambda (x y) (abs (- x y))) lstA lstB))


; find the stepwise sum of two lists
; i.e. |lstA_i + lstB_i|
(defun utils.lists.lstSums (lstA lstB)
  (mapcar #'(lambda (x y) (abs (+ x y))) lstA lstB))
; (utils.lists.lstSums '(42 48 56 60) '(48 46 44 58))


; wrapper around mapcar (for some unknown reason)
(defun utils.lists.map (lst fn)
  (mapcar fn lst))
; (utils.lists.map '(13 14 16 18) #'(lambda (x) (math.modN 12 x)))
; (utils.lists.map (utils.lists.lstSums '(64 69 65 72) '(64 69 65 72)) #'(lambda (x) (math.modN 12 x)))


; '(int) '(int) -> int
; returns the number of elements two lists have in common, order of
; appearance is not important
(defun utils.lists.similar (lstA lstB)
  (let (
    (similarity 0)
    (matchList lstB))
    (loop for el in lstA do
      (if
        (find el lstB)
        (progn
          (incf similarity)
          (setf matchList (utils.lists.removeFirstRef matchList el)))))
    similarity))
; (utils.lists.similar '(1 2 3 4) '(1 2 3 5))


; '(int) '(int) -> int
; returns the number of elements two lists have in common, order of
; appearance is important
(defun utils.lists.similari (lstA lstB)
  (let ((similarity 0))
    (dotimes (i (length lstA))
      (if
        (eq (nth i lstA) (nth i lstB))
        (incf similarity)))
    similarity))
;(utils.lists.similari '(1 2 3 4) '(1 2 3 5))


; '('(int)) -> int
; lsts is a list of lists
; returns the total length of all lists in a list
(defun utils.lists.sumlengths (lsts)
  (let ((lengths 0))
    (loop for lst in lsts do
        (setf lengths (+ lengths (length lst))))
    lengths))
;(utils.lists.sumlengths '((1 2 3) (1 2) (1 2 3 4)))


; int int -> '(int)
; generate a list of numbers from "start" to "end"
(defun utils.lists.range (start end)
  (let ((lst))
    (loop for i from start to end do (push i lst))
    (reverse lst)))

(defun utils.lists.lift (lst by)
  (print (mapcar #'(lambda (x) (+ x by)) lst))
  (mapcar #'(lambda (x) (+ x by)) lst))
; (utils.lists.lift '(1 2 3 4) 10)


(defun utils.dice (p)
  (if (> (random 10.0) (* p 10.0)) T nil))


(defun utils.lists.scalep (lst p minscale maxscale)
  (let ((scaledlst))
    (loop for item in lst do
      (if (neq nil (utils.dice p))
        (push (round (* item (/ (math.rndrng (* minscale 10) (* maxscale 10)) 10))) scaledlst)
        (push item scaledlst)))
    (reverse scaledlst)))
; (utils.lists.scalep '(10 30 40 50) 0.4 0.8 1)


; n '(any) -> '(any)
; returns the first n elements of a list
(defun firstN (n lst) (loop :repeat n :for x :in lst :collect x))

(defun maxn (lst) (reduce 'max lst))
(defun maxi (lst) (position (maxn lst) lst))
