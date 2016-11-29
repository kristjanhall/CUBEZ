#|
MATRIX

various methods for generating matrixes and utilizing matrixes to
select elements from other lists
|#

(defclass MATRIX () (
  (matrixa :initform nil :accessor matrixa :initarg :matrixa)))


(defgeneric matrix.set (MATRIX &key matrix)
  (:documentation ""))
(defmethod matrix.set ((self MATRIX) &key matrix)
  (setf (slot-value self 'matrixa) matrix))


(defgeneric matrix.get (MATRIX)
  (:documentation ""))
(defmethod matrix.get ((self MATRIX))
  (slot-value self 'matrixa))



; matrix.markov - generate a list of randomly selected elements
(defgeneric matrix.markov (&key matrix row len)
  (:documentation ""))
(defmethod matrix.markov (&key matrix row len)
  (let ((lst) (last row))
    (dotimes (i len)
      (progn
        (setf last (matrix.findNext :row (nth last matrix)))
        (push last lst)))
    (reverse lst)))


; matrix.findNext - find next state based on probabilities in the selected matrix row
(defun matrix.findNext (&key row)
  (let (
    (dice (random 1.0))
    (strip (reverse (maplist #'(lambda (x) (apply '+ x)) (reverse row)))))
    (loop while (> dice (first strip)) do (pop strip))
    ;(while (> dice (first strip))
    ;  (pop strip))
    (- (length row) (length strip))))


; matrix.rndRow - make an array of random n random values with sum of sum
; len: number of elements in the resulting array
; sum: the sum of all the elements in the resulting array
(defun matrix.rndRow (&key len sum)
  (let ((total 0.0) (lst) (Q (/ (* sum 1.0) (- len 1))))
    (dotimes (i len)
      (if (eq i (- len 1))
        (if (< total sum) (push (- sum total) lst) (push 0.0 lst))
        (progn
          (let ((val (random Q)))
            (loop while (> (+ total val) sum) do
              (setf val (random Q)))
            (push val lst)
            (setf total (+ total val))))))
      (reverse lst)))


; matrix.rndMatrix - make an array of arrays
; rows: number of rows in the matrix
; cols: number of cols in the matrix (number of elements in the row array)
; rowsum: the sum of all the elements in each row
(defun matrix.rndMatrix (&key rows cols rowsum)
  (let ((matrix))
    (dotimes (i rows)
      (push (matrix.rndRow :len cols :sum rowsum) matrix))
    (reverse matrix)))


; matrix.selectFromLst - pick elements from some list based on a random
;                        generated matrix
; lst: list of elements to pick from
; count: number of elements in the resulting array
(defun matrix.selectFromLst (&key lst count start)
  ;(let ((newLst) (selection (markov-matrix (matrix.rndMatrix :rows (length lst) :cols (length lst) :rowsum 1.0) (random (length lst)) count)))
  (let (
    (newLst)
    (selection (matrix.markov
      :matrix (matrix.rndMatrix :rows (length lst) :cols (length lst) :rowsum 1.0)
      :row (if (eq nil start) (random (length lst)) start)
      :len count)
    ))

    (loop for index in selection do
      (push (nth index lst) newLst))
    (reverse newLst)))
;test=>
;(matrix.selectFromLst :lst '(24 48 96) :count 12)

(defun matrix.eval (&key len lst matrix)
  (let (
    (newLst)
    (selection (matrix.markov
      :matrix matrix
      :row (- (length matrix) 1)
      :len len)
    ))

    (loop for index in selection do
      (push (nth index lst) newLst))
    (reverse newLst)))

;test =>
;(defvar testMatrix (make-instance 'MATRIX))
;(matrix.set testMatrix :matrix (matrix.selectFromLst :lst '(24 48 96 48 24 48 96) :start 3 :count 12))
;(matrix.get testMatrix)

(defun matrix.a ()
    (list
      '(0.3 0.1 0.2 0.4)
      '(0.1 0.2 0.4 0.3)
      '(0.2 0.4 0.3 0.1)
      '(0.4 0.3 0.1 0.2)))

(defun matrix.b ()
    (list
      '(0.3 0.1 0.2 0.4)
      '(0.1 0.2 0.4 0.3)
      '(0.2 0.4 0.3 0.1)
      '(0.4 0.3 0.2 0.1)))

(defun matrix.blues ()
  (list
    '(0.3 0.1 0.2 0.4)
    '(0.1 0.2 0.4 0.3)
    '(0.2 0.4 0.3 0.1)
    '(0.4 0.3 0.2 0.1))
)