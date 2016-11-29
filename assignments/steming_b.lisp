(load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")
#|

  Stemning B
  "ókyrrð, óvæntar breytingar, ljós litur"

  Skali: f major
  Hjóðfæri: Music Box (banki 0 - patch 10)
  Steming: horfa á dögg dropa af laufum ofaní tjörn eftir rigningu og sólin hefur brotist út

  Skipun til að búa til midi skrá
  (load "/home/kristjanhall/Programming/lisp/CUBEZ/examples/steming_b.lisp")

|# 

(setq cords (make-instance 'CORDS))
(setq scorelength 160)

(setq rythm (CUBEZ.markov
    '(24 48 96 192)
    '((0.50 0.50 0.0  0.0 )
      (0.40 0.35 0.15 0.10)
      (0.35 0.40 0.20 0.05)
      (0.40 0.40 0.15 0.05))
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
    :p 0.5
    :minscale 0.80
    :maxscale 0.95) 
  :velocity velocity
  :channel 1
  :fileName "steming_b.midi")