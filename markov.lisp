#|
A markov chain class

Initiate the class with some matrix and a selection attribute, then use the
instance by calling markov.start method with an "entry" element, this will
return a list of selected attribute indexes.

To get a list of selected attributes use markov.translate

The same instance can be called multiple times if we want to generate more than
one result for the same instance matrix + attributes

(defvar M (make-instance 'MARKOV))

(markov.prop M
  :attribs '("the" "fox" "jumped" "dog")
  :matrix '(
    (0   0.6 0   0.4) ; the
    (0.4 0   0.6 0  ) ; fox
    (0.6 0.2 0   0.2) ; jumped
    (0   0   1   0  ) ; dog
  )
  :len 5)

(markov.start M "the") ; => (0 3 2 0 1) <- these are selected indexes
(markov.translate M) ;   => ("the" "dog" "jumped" "the" "fox") <- these are the acctual attributes

(markov.start M "the") ; => (0 1 2 1 2)
(markov.translate M) ;   => ("the" "fox" "jumped" "fox" "jumped")

|#

(defclass MARKOV () (
  (attribs :initform nil :accessor attribs :initarg :attribs)
  (matrix :initform nil :accessor matrix :initarg :matrix)
  (selection :initform '() :accessor selection :initarg :selection)
  (len :initform 0 :accessor len :initarg :len)))


(defgeneric markov.prop (MARKOV &key matrix attribs len)
  (:documentation "Propogate the class instance"))
(defmethod markov.prop ((self MARKOV) &key matrix attribs len)
  (if (neq nil matrix) (setf (slot-value self 'matrix) matrix) nil)
  (if (neq nil attribs) (setf (slot-value self 'attribs) attribs) nil)
  (if (neq nil len) (setf (slot-value self 'len) len) nil))


(defgeneric markov.next (MARKOV index)
  (:documentation "Start evaluating results, start from element el"))
(defmethod markov.next ((self MARKOV) index)
  (let (
    (selection (slot-value self 'selection))    ; get the current selection
    (len (slot-value self 'len))                ; get the desired length
    (row (nth index (slot-value self 'matrix))) ; get the matrix row
    (counter 0) (sum 0))
    
    ; add the selected index to the selection array and store it
    (push index selection)
    (setf (slot-value self 'selection) selection)

    ; find the next index to push to selection, or quit
    (if (< (length selection) len)
      (let ((dice (random 1.0)))
        (loop while (< sum dice) do
          (progn
            (setf sum (+ sum (nth counter row)))
            (incf counter)))
        (markov.next self (decf counter))))))


(defgeneric markov.start (MARKOV el)
  (:documentation "Start evaluating results, start from element el"))
(defmethod markov.start ((self MARKOV) el)
  (let (
    (index (position el (slot-value self 'attribs) :test #'equal)))

    (setf (slot-value self 'selection) nil)
    (markov.next self index)
    (setf (slot-value self 'selection) (reverse (slot-value self 'selection)))
    (slot-value self 'selection)))


(defgeneric markov.translate (MARKOV)
  (:documentation "Return a list with the selected elements"))
(defmethod markov.translate ((self MARKOV))
  (let (
    (selection (slot-value self 'selection))
    (attribs (slot-value self 'attribs)))
    (mapcar #'(lambda (x) (nth x attribs)) selection))) 


(defgeneric markov.eval (MARKOV el)
  (:documentation "Does the same as running start and translate"))
(defmethod markov.eval ((self MARKOV) el)
  (markov.start self el)
  (markov.translate self))