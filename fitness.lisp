#|
The fitness class contains methods for evaluating the fitness of
some specimen based on some origin

USAGE:
(defvar test (make-instance 'FITNESS))
(fitness.prop test :spaces 10 :places 20 :order 30 :symmetry 40)

(fitness.eval :origin '() :specimen '()) -> int
(fitness.evals :origin '() :specimens '('())) -> '() ; fittest speciment

|#

(defclass FITNESS () (
  (spaces :initform 0 :accessor spaces :initarg :spaces)
  (places :initform 0 :accessor places :initarg :places)
  (order :initform 0 :accessor order :initarg :order)
  (symmetry :initform 0 :accessor symmetry :initarg :symmetry)

  (specimen :initform 0 :accessor specimen :initarg :specimen)
  (origin :initform 0 :accessor origin :initarg :origin)

  (distances :initform 0 :accessor distances :initarg :distances)
  (origin-spaces :initform 0 :accessor origin-spaces :initarg :origin-spaces)
  (specimen-spaces :initform 0 :accessor specimen-spaces :initarg :specimen-spaces)
  
  (origin-places :initform 0 :accessor origin-places :initarg :origin-places)
  (specimen-places :initform 0 :accessor specimen-places :initarg :specimen-places)

  (origin-vectors :initform 0 :accessor origin-vectors :initarg :origin-vectors)
  (specimen-vectors :initform 0 :accessor specimen-vectors :initarg :specimen-vectors)))



(defmethod fitness.getProp ((self FITNESS) &key slot)
  (slot-value self slot))


;; fitness.prop -> nil
;; initalize the fitness object
(defgeneric fitness.prop (FITNESS &key spaces places order symmetry origin specimen)
  (:documentation "Populate the class instance with data"))

(defmethod fitness.prop ((self FITNESS) &key spaces places order symmetry origin specimen)
  (if (neq nil spaces) (setf (slot-value self 'spaces) spaces) nil)
  (if (neq nil places) (setf (slot-value self 'places) places) nil)
  (if (neq nil order) (setf (slot-value self 'order) order) nil)
  (if (neq nil symmetry) (setf (slot-value self 'symmetry) symmetry) nil)

  ; do some preprocessing to simplify stuff in eval functions
  (if (neq nil origin)
    (progn
      (setf (slot-value self 'origin-spaces) origin)
      (setf (slot-value self 'origin-vectors) (utils.lists.vectors origin))
      (setf (slot-value self 'origin-spaces) (utils.lists.distances origin))))
  (if (neq nil specimen)
    (progn
      (setf (slot-value self 'specimen-spaces) specimen)
      (setf (slot-value self 'specimen-vectors) (utils.lists.vectors specimen))
      (setf (slot-value self 'specimen-spaces) (utils.lists.distances specimen))))
  (if (and (neq nil origin) (neq nil specimen))
    (setf (slot-value self 'distances) (mapcar #'(lambda (x) (* (if (eq 12 x) 12 (math.modN 12 x)) (* 1/12 1.0))) (utils.lists.lstSums origin specimen)))))



;; fitness.eval.spaces -> int
;; evaluate space fitness of stored speciments and orginal
(defgeneric fitness.eval.spaces (FITNESS)
  (:documentation ""))
(defmethod fitness.eval.spaces ((self FITNESS))
  (let (
    (spaces (slot-value self 'spaces))
    (origin-spaces (slot-value self 'origin-spaces))
    (specimen-spaces (slot-value self 'specimen-spaces))
    (score 0)
    (multi 0))
    
    (setf score (utils.lists.similar specimen-spaces origin-spaces))
    (setf multi (* (/ (+ (length origin-spaces) 1) (length origin-spaces)) 1.0))
    (* (* score multi) spaces)))


;; fitness.eval.places -> int
;; evaluate space placement fitness of stored speciments and orginal
(defgeneric fitness.eval.places (FITNESS)
  (:documentation ""))
(defmethod fitness.eval.places ((self FITNESS))
  (let (
    (places (slot-value self 'places))
    (origin-spaces (slot-value self 'origin-spaces))
    (specimen-spaces (slot-value self 'specimen-spaces))
    (score 0)
    (multi 0))
    
    (setf score (utils.lists.similar specimen-spaces origin-spaces))
    (setf multi (* (/ (+ (length origin-spaces) 1) (length origin-spaces)) 1.0))
    (* (* score multi) places)))


;; fitness.eval.order -> int
;; evaluate order fitness of stored speciments and orginal
(defgeneric fitness.eval.order (FITNESS)
  (:documentation ""))
(defmethod fitness.eval.order ((self FITNESS))
  (let (
    (order  (slot-value self 'order))
    (origin-vectors (slot-value self 'origin-vectors))
    (specimen-vectors (slot-value self 'specimen-vectors))
    (score 0)
    (multi 0))
    
    (setf score (utils.lists.similar specimen-vectors origin-vectors))
    (setf multi (* (/ (+ (length origin-vectors) 1) (length origin-vectors)) 1.0))
    (* (* score multi) order)))


;; fitness.eval.symmetry -> int
;; evaluate symmetry fitness of stored speciments and orginal
(defgeneric fitness.eval.symmetry (FITNESS)
  (:documentation ""))
(defmethod fitness.eval.symmetry ((self FITNESS))
  (let (
    (symmetry (slot-value self 'symmetry))
    (distances (slot-value self 'distances))
    (score))

    (setf score (* (reduce '+ distances) symmetry))
    score))



;; fitness.eval -> int
;; evaluate the fitness of some speciments vs orginal
;; NOTE: the origin and specimen is stored in the object so that all
;;       class methods have access to them
(defgeneric fitness.eval (FITNESS &key origin specimen)
  (:documentation "Evalute the fitness of the specimen"))

(defmethod fitness.eval ((self FITNESS) &key origin specimen)
  ; if the two objects are not of equal length then alert the
  ; user and return
  (if
    (neq (length origin) (length specimen))
    (progn
      (print "Lists must be of same length for fitness evaluation")
      (return-from fitness.eval)))

  ; store origin and specimen, do this through prop method as we
  ; do some pre-processing on these objects there
  (fitness.prop self :origin origin :specimen specimen)

  (let ((scores))
    (push (fitness.eval.spaces self) scores)
    (push (fitness.eval.places self) scores)
    (push (fitness.eval.order self) scores)
    (push (fitness.eval.symmetry self) scores)
    (apply '+ scores)))

; (fitness.eval test :origin '(62 64 65 72) :specimen '(60 58 62 68))