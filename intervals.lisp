#| interval related methods |#

;; various intervales
(defun interval.A () (list 0 12))
(defun interval.B () (list 1 2 10 11))
(defun interval.C () (list 3 4 8 9))
(defun interval.D () (list 5 6 7))
(defun interval.E () (list 1 4 5))


;; find a interval group by checking the space between
;; two notes
(defun interval.find (&key note.a note.b)
  (cond
    ((find (math.modN 11 (abs (- note.b note.a))) (interval.A)) (interval.A))
    ((find (math.modN 11 (abs (- note.b note.a))) (interval.B)) (interval.B))
    ((find (math.modN 11 (abs (- note.b note.a))) (interval.C)) (interval.C))
    ((find (math.modN 11 (abs (- note.b note.a))) (interval.D)) (interval.D))
    ((find (math.modN 11 (abs (- note.b note.a))) (interval.E)) (interval.E))))
;; find a interval group by checking the space between
;; two notes
(defun interval.findName (&key note.a note.b)
  (cond
    ((find (math.modN 11 (abs (- note.b note.a))) (interval.A)) 'interval.A)
    ((find (math.modN 11 (abs (- note.b note.a))) (interval.B)) 'interval.B)
    ((find (math.modN 11 (abs (- note.b note.a))) (interval.C)) 'interval.C)
    ((find (math.modN 11 (abs (- note.b note.a))) (interval.D)) 'interval.D)
    ((find (math.modN 11 (abs (- note.b note.a))) (interval.E)) 'interval.E)))