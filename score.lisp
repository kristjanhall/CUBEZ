#|
SCORE


|#


(defclass SCORE () (
    (attack :initform nil :accessor attack-lst :initarg :attack)
    (pitch :initform nil :accessor pitch-lst :initarg :pitch)
    (duration :initform nil :accessor duration-lst :initarg :duration)
    (channels :initform nil :accessor channels-lst :initarg :channels)
    (velocity :initform nil :accessor velocity-lst :initarg :velocity)))


; generic interface and method for writing all the score to the class slots
(defgeneric score.prop (SCORE &key attack pitch duration channels velocity)
    (:documentation "Write stuff to the slots"))
(defmethod score.prop ((self SCORE) &key attack pitch duration channels velocity)
    (setf (slot-value self 'attack) attack)
    (setf (slot-value self 'pitch) pitch)
    (setf (slot-value self 'duration) duration)
    (setf (slot-value self 'channels) channels)
    (setf (slot-value self 'velocity) velocity))


; generic interface and method for appending to all the score in the class slots
(defgeneric score.appendLists (SCORE attack pitch duration channels velocity)
    (:documentation "Write stuff to the slots"))
(defmethod score.appendLists ((self SCORE) attack pitch duration channels velocity)
    (setf (slot-value self 'attack) (nconc attack (slot-value self 'attack)))
    (setf (slot-value self 'pitch) (nconc pitch (slot-value self 'pitch)))
    (setf (slot-value self 'duration) (nconc duration (slot-value self 'duration)))
    (setf (slot-value self 'channels) (nconc channels (slot-value self 'channels)))
    (setf (slot-value self 'velocity) (nconc velocity (slot-value self 'velocity))))


; generic interface and method for reversing all the score in the class slots
(defgeneric score.reverseLists (SCORE)
    (:documentation "Reverse all the song"))
(defmethod score.reverseLists ((self SCORE))
    (setf (slot-value self 'attack) (reverse (slot-value self 'attack)))
    (setf (slot-value self 'pitch) (reverse (slot-value self 'pitch)))
    (setf (slot-value self 'duration) (reverse (slot-value self 'duration)))
    (setf (slot-value self 'channels) (reverse (slot-value self 'channels)))
    (setf (slot-value self 'velocity) (reverse (slot-value self 'velocity))))


; generic interface and method for reversing a specific list in the class slots
(defgeneric score.reverseList (SCORE listname)
    (:documentation "Reverse a selected list"))
(defmethod score.reverseList ((self SCORE) listname)
    (setf (slot-value self 'attack) (reverse (slot-value self listname))))


; generic interface and method for appending to all the score in the class slots
(defgeneric score.clearLists (SCORE)
    (:documentation "Clear all the song"))
(defmethod score.clearLists ((self SCORE))
    (setf (slot-value self 'attack) '())
    (setf (slot-value self 'pitch) '())
    (setf (slot-value self 'duration) '())
    (setf (slot-value self 'channels) '())
    (setf (slot-value self 'velocity) '()))


; generic interface and method for writing some list to one given slot in the class
(defgeneric score.writeList (SCORE listname lst)
  (:documentation "Write some list to some slot"))
(defmethod score.writeList ((self SCORE) listname lst) (
  setf (slot-value self listname) lst))


; generic interface and method for writing some list to one given slot in the class
(defgeneric score.appendList (SCORE listname lst)
  (:documentation "Write some list to some slot"))
(defmethod score.appendList ((self SCORE) listname lst) (
  setf (slot-value self listname) (nconc lst (slot-value self listname))))


; generic interface and method for reading some specific list from the class slots
(defgeneric score.readList (SCORE lst)
  (:documentation "Read from a slot for given lst name"))
(defmethod score.readList ((self SCORE) lst) ( slot-value self lst ))