#| scales/notes related methods |#

;; various scales - we use this to initalise the class slots
(defun scales.moll       () (list 0 2 3 5 7 8 10))
(defun scales.dur        () (list 0 2 4 5 7 9 11))
(defun scales.kumoi      () (list 0 2 3 7 9))
(defun scales.wholetone  () (list 0 2 4 6 8 10))
(defun scales.augmented  () (list 0 4 8))
(defun scales.dminor     () (notes.getNoteValueList :notes (list "D" "E" "F" "G" "A" "BB" "C")))
(defun scales.fmajor     () (notes.getNoteValueList :notes (list "G" "A" "B" "C" "D" "E" "F#")))
(defun scales.chromatic  () (notes.getNoteValueList :notes (list "C" "C#" "D" "D#" "E" "F" "F#" "G" "G#" "A" "A#" "B" "C")))
(defun scales.blues      () (notes.getNoteValueList :notes (list "C" "D#" "F" "F#" "G" "A#")))
(defun scales.hirajoshi  () (notes.getNoteValueList :notes (list "C" "D" "EB" "G" "AB")))
(defun scales.slendro    () (notes.getNoteValueList :notes (list "D" "E" "F#" "A" "B")))
(defun scales.lonian     () (notes.getNoteValueList :notes (list "C" "D" "E" "F" "G" "A" "B")))
(defun scales.aeolian    () (notes.getNoteValueList :notes (list "A" "B" "C" "D" "E" "F" "G")))
(defun scales.mixolydian () (notes.getNoteValueList :notes (list "G" "A" "B" "C" "D" "E" "F")))

(defclass SCALES () (
  (tries :initform 0 :accessor tries :initarg :tries)
  (moll :initform (scales.moll) :accessor moll :initarg :moll)
  (dur :initform (scales.dur) :accessor dur :initarg :dur)
  (kumoi :initform (scales.kumoi) :accessor kumoi :initarg :kumoi)
  (wholetone :initform (scales.wholetone) :accessor wholetone :initarg :wholetone)
  (dminor :initform (scales.dminor) :accessor dminor :initarg :dminor)
  (fmajor :initform (scales.fmajor) :accessor fmajor :initarg :fmajor)
  (augmented :initform (scales.augmented) :accessor augmented :initarg :augmented)
  (chromatic :initform (scales.chromatic) :accessor chromatic :initarg :chromatic)
  (blues :initform (scales.blues) :accessor blues :initarg :blues)
  (hirajoshi :initform (scales.hirajoshi) :accessor hirajoshi :initarg :hirajoshi)
  (slendro :initform (scales.slendro) :accessor slendro :initarg :slendro)
  (lonian :initform (scales.lonian) :accessor lonian :initarg :lonian)
  (aeolian :initform (scales.aeolian) :accessor aeolian :initarg :aeolian)
  (mixolydian :initform (scales.mixolydian) :accessor mixolydian :initarg :mixolydian)))

(defgeneric scales.get (SCALES name octive)
  (:documentation "fetch a scale and optionaly raise it to some octive"))

(defmethod scales.get ((self SCALES) name octive)
  (if (neq nil octive)
    (notes.raise :notes (slot-value self name) :octive octive)
    (slot-value self name)))

(defgeneric scales.inscale (SCALES note scale)
  (:documentation "Check if some note belongs to some scale"))
(defmethod scales.belongsto ((self SCALES) note scale)
  (find (math.modN 12 note) (slot-value self scale)))