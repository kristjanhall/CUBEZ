

(defclass SETTINGS () (
  (tries :initform 0 :accessor tries :initarg :tries)
  (minval :initform 0 :accessor minval :initarg :minval)
  (maxval :initform 0 :accessor maxval :initarg :maxval)
  (notes :initform 0 :accessor notes :initarg :notes)
  (notintervals :initform 0 :accessor notintervals :initarg :notintervals)))


(defgeneric settings.prop (SETTING &key minval maxval notes notintervals)
  (:documentation "Populate the settings object"))

(defmethod settings.prop ((self SETTINGS) &key tries minval maxval notes notintervals)
  (if (neq nil tries) (setf (slot-value self 'tries) tries) nil)
  (if (neq nil minval) (setf (slot-value self 'minval) minval) nil)
  (if (neq nil maxval) (setf (slot-value self 'maxval) maxval) nil)
  (if (neq nil notes) (setf (slot-value self 'notes) notes) nil)
  (if (neq nil notintervals) (setf (slot-value self 'notintervals) notintervals) nil))



(defgeneric settings.get (SETTINGS thing)
  (:documentation "Get some slot value"))

(defmethod settings.get ((self SETTINGS) thing)
  (slot-value self thing))