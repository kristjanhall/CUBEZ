#|

The printers job is to take some theme and generate a proposal for new
elements for the theme.

For this the printer takes in
- theme
- settings object (class)
- fitness object (class)

The printer then also utilizes various utility functions to generate
the proposed new score

|#

(defclass PRINTER () (
  (theme :initform 0 :accessor theme :initarg :theme)
  (settings :initform 0 :accessor settings :initarg :settings)
  (fitness :initform 0 :accessor fitness :initarg :fitness)
  (futures :initform 0 :accessor futures :initarg :futures)))


(defgeneric printer.prop (PRINTER &key theme settings fitness)
  (:documentation ""))

(defmethod printer.prop ((self PRINTER) &key theme settings fitness)
  (if (neq nil theme) (setf (slot-value self 'theme) theme) nil)
  (if (neq nil settings) (setf (slot-value self 'settings) settings) nil)
  (if (neq nil fitness) (setf (slot-value self 'fitness) fitness) nil))


(defgeneric printer.eval.fitness (PRINTER)
  (:documentation "select the best continum based on scoring from the passed in fitness class"))

(defmethod printer.eval.fitness ((self PRINTER))
  (let (
    (scores)
    (theme (slot-value self 'theme))
    (futures (slot-value self 'futures))
    (fitness (slot-value self 'fitness)))

    (loop for lst in futures do
      (let ((score (fitness.eval fitness :origin theme :specimen (cdr lst))))
        (push score scores)))
    (maxi (reverse scores))))
    ;(maxi (mapcar #'(lambda (lst) (reduce '+ lst)) (reverse scores)))))


(defgeneric printer.print (PRINTER &key len validators)
  (:documentation "generate a list of len length based on selected theme"))

(defmethod printer.print ((self PRINTER) &key len validators)
  (let (
    (tries) (themelength) (lst)
    (theme (slot-value self 'theme))
    (settings (slot-value self 'settings))
    (maxval) (minval) (notes) (notintervals))
    
    (setf maxval (settings.get settings 'maxval))
    (setf minval (settings.get settings 'minval))
    (setf notes (settings.get settings 'notes))
    (setf notintervals (settings.get settings 'notintervals))
    (setf tries (settings.get settings 'tries))
    (setf lst theme)
    (setf themelength (length theme))
    (setf (slot-value self 'theme) theme)

    (loop while (< (length lst) len) do
      (let ((futures))
        (dotimes (i tries)
          (push (append (last lst themelength) (lists.make
            :len 1
            :minval minval
            :maxval maxval
            :collected lst
            :validators (append validators (list (validator.validnote notes) (validator.validinterval notintervals))))) futures))

        (setf (slot-value self 'futures) futures)
        (setf lst (append lst (last (nth (printer.eval.fitness self) futures))))))
    lst))
