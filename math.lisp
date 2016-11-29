; int int -> int
; return them N modulus of num
(defun math.modN (N num) (mod num N))


; int int -> int
; returns a random int in some range
(defun math.rndrng (minval maxval) (+ minval (random (+ 1 (- maxval minval)))))