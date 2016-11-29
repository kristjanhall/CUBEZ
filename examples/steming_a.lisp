(load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")
#|

  Stemning A
  "kyrrð, litlar breytingar, dökkur litur"


  Skipun til að búa til midi skrá
  (load "/home/kristjanhall/Programming/lisp/CUBEZ/examples/steming_a.lisp")

|# 

(setq cords (make-instance 'CORDS))
(setq scorelength 160)

(setq rythm (CUBEZ.rythm
    :len scorelength
    :theme '(24 48 96 192)
    :matrix '(
      (0.0  1.00 0.0  0.0 )
      (0.0  0.45 0.55 0.0 )
      (0.0  0.30 0.50 0.20)
      (0.0  0.20 0.70 0.10))
    :start 96))

(setq velocity (CUBEZ.rythm
    :len scorelength
    :theme '(55 65 70 74)
    :matrix '(
      (0.30 0.40 0.20 0.10)
      (0.20 0.50 0.20 0.10)
      (0.20 0.60 0.10 0.10)
      (0.15 0.50 0.30 0.05))
    :start 55))

(CUBEZ.compose
  :pitch (CUBEZ.pitch
    :len scorelength
    :theme (cords.geta cords '("C2" "G2" "D2" "D2#" "C2"))
    :settings (CUBEZ.settings
      :scale (scales.dminor)
      :minval 36
      :maxval 48
      :notintervals (append (interval.D) (interval.E)))
    :weights (CUBEZ.weights
      :space 5
      :order 30
      :placement 5
      :symmetry 60)
    :validators (list (validator.notinlastN 4)))
  :rythm rythm
  :duration (CUBEZ.duration
    :rythm rythm
    :p 0.3
    :minscale 0.85
    :maxscale 0.9) 
  :velocity velocity
  :channel 1
  :fileName "steming_a2.midi")