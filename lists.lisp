#|
Various list methods, list.make is a list function that can be used to make
any other list

|#



; make a list of len length where each element is in minval..maxval range
; optionaly takes in a list of validators
(defun lists.make (&key len minval maxval validators collected)
  (let ((lst))
    (loop while (< (length lst) len) do
      (let ((pass nil))
        (loop while (not pass) do
          (let ((next (math.rndrng minval maxval)))
            (if
              (validator.every validators next collected)
              (progn
                (push next lst)
                (setf pass T)))))))
    lst))

; example usage
; (lists.make :len 10 :minval 10 :maxval 30)
; (lists.make :len 10 :minval 10 :maxval 30 :validators (list (validator.notinlastN 10)))
; (lists.make :len 10 :minval 10 :maxval 30 :validators (list (validator.notinlist '(10 15 19 25 28)) (validator.notinlastN 2)))


; make a list with n repeated elements followed by one different element, repeated m times
; return list length = (n * m + (m))
(defun lists.repnm (n m &key maxval minval)
  (let ((lst))
    (dotimes (j m)
      (progn
        (let ((repA (math.rndrng minval maxval)))
          (dotimes (i n) (push repA lst))
          (setf lst (append (lists.make :len 1 :minval minval :maxval maxval :validators (list (validator.notinlist (firstN n lst)))) lst)))))
    (reverse lst)))
; (lists.repnm 3 3 :minval 10 :maxval 20)