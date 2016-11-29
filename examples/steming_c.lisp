(load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")
#|

  Stemning B
  "fegurð - frjálst val"


  Skipun til að búa til midi skrá
  (load "/home/kristjanhall/Programming/lisp/CUBEZ/examples/steming_c.lisp")

|# 

(setq cords (make-instance 'CORDS))
(setq scorelength 160)

(setq rythm (CUBEZ.markov
    '(24 48 96 192)
    '((0.50 0.50 0.0  0.0 )
      (0.40 0.40 0.20 0.00)
      (0.40 0.50 0.10 0.00)
      (1.00 0.00 0.00 0.00))
    scorelength
    24))

(CUBEZ.compose
  :pitch (CUBEZ.pitch
    :len scorelength
    :theme (cords.geta cords '("C3" "D3#" "F3" "F3#" "G3" "A3#"))
    :settings (CUBEZ.settings
      :scale (scales.blues)
      :minval 42
      :maxval 66
      :tries 8
      :notintervals (append (interval.E)))
    :weights (CUBEZ.weights
      :space 5
      :order 30
      :placement 30
      :symmetry 35)
    :validators (list (validator.notinlastN 4)))
  :rythm rythm
  :duration rythm
  ;:duration (CUBEZ.duration
  ;  :rythm rythm
  ;  :p 0.4
  ;  :minscale 0.85
  ;  :maxscale 1) 
  :velocity 80
  :channel 1
  :fileName "steming_c.midi")