(defun notes.getNote (&key note)
  (let ((snote) (notes '(0 1 2 3 4 5 6 7 8 9 10 11)))
    (cond
      ((string= note "C") (setf snote (nth 0 notes)))
      ((string= note '"C#") (setf snote (nth 1 notes)))
      ((string= note '"D") (setf snote (nth 2 notes)))
      ((string= note '"D#") (setf snote (nth 3 notes)))
      ((string= note '"E") (setf snote (nth 4 notes)))
      ((string= note '"F") (setf snote (nth 5 notes)))
      ((string= note '"F#") (setf snote (nth 6 notes)))
      ((string= note '"G") (setf snote (nth 7 notes)))
      ((string= note '"G#") (setf snote (nth 8 notes)))
      ((string= note '"A") (setf snote (nth 9 notes)))
      ((string= note '"A#") (setf snote (nth 10 notes)))
      ((string= note '"B") (setf snote (nth 11 notes)))
      ((string= note '"DB") (setf snote (nth 1 notes)))
      ((string= note '"EB") (setf snote (nth 3 notes)))
      ((string= note '"GB") (setf snote (nth 6 notes)))
      ((string= note '"AB") (setf snote (nth 8 notes)))
      ((string= note '"BB") (setf snote (nth 10 notes))))
      snote))

(defun notes.make (&key note octive)
  (let ((octa (* 12 octive)))
    (if (< octa 121)
      (if (numberp note)
        (+ note octa)
        (+ (notes.getNote :note note) octa)))))


(defun notes.isNote (innote &key note)
  (let ((check (- innote (notes.getNote :note note))))
    (if (eq (math.modN 12 check) 0) T nil)))

(defun notes.getNoteValueList (&key notes)
  (let ((noteList))
    (loop for q in notes do
      (push (notes.getNote :note q) noteList))
    (reverse noteList)))

(defun notes.raise (&key notes octive)
  (let ((nnotes))
    (loop for q in notes do
      (push (notes.make :note q :octive octive) nnotes))
  (reverse nnotes)))

;(notes.getNoteValueList :notes '("C" "C#" "B"))