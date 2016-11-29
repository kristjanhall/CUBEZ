(load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")
#|

  Stemning B
  "ókyrrð, óvæntar breytingar, ljós litur"


  Skipun til að búa til midi skrá
  (load "/home/kristjanhall/Programming/lisp/CUBEZ/examples/steming_b.lisp")

|# 

(setq cords (make-instance 'CORDS))
(setq scorelength 160)

(setq rythm (CUBEZ.markov
    '(24 48 96 192)
    '((0.50 0.50 0.0  0.0 )
      (0.30 0.30 0.30 0.10)
      (0.30 0.30 0.30 0.10)
      (0.40 0.30 0.20 0.10))
    scorelength
    24))

(setq velocity (CUBEZ.rythm
    :len scorelength
    :theme '(55 65 75)
    :matrix '(
      (0.30 0.40 0.30)
      (0.20 0.50 0.30)
      (0.10 0.70 0.20))
    :start 65))

(CUBEZ.compose
  :pitch (CUBEZ.pitch
    :len scorelength
    :theme (cords.geta cords '("G4" "C4" "D4" "F4#" "D4"))
    :settings (CUBEZ.settings
      :scale (scales.fmajor)
      :minval 52
      :maxval 81
      :notintervals (append (interval.A) (interval.E)))
    :weights (CUBEZ.weights
      :space 5
      :order 30
      :placement 5
      :symmetry 60)
    :validators (list (validator.notinlastN 8)))
  :rythm rythm
  :duration (CUBEZ.duration
    :rythm rythm
    :p 0.3
    :minscale 0.85
    :maxscale 0.9) 
  :velocity velocity
  :channel 1
  :fileName "steming_b.midi")