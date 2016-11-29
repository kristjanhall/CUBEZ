(load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")
#|

  Stemning C
  "fegurð - frjálst val"

  skali: aeolian
  hljóðfæri: Space Voice (banki 0 - patch 91)
  Stemning: hugleiðsla, róa hugann, sofna


  Skipun til að búa til midi skrá
  (load "/home/kristjanhall/Programming/lisp/CUBEZ/examples/steming_c.lisp")

|# 

(setq scales (make-instance 'SCALES))
(setq scorelength 160)

(setq rythm (CUBEZ.markov
    '(24 48 96 192)
    '((0.0  0.0  1.00 0.0 )
      (0.0  0.30 0.50 0.20)
      (0.0  0.30 0.40 0.30)
      (0.0  0.20 0.60 0.20))
    scorelength
    96))

(CUBEZ.compose
  :pitch (CUBEZ.pitch
    :len scorelength
    :theme (scales.get scales 'kumoi 3)
    :settings (CUBEZ.settings
      :scale (scales.aeolian)
      :minval 30
      :maxval 53)
    :weights (CUBEZ.weights
      :space 10
      :order 10
      :placement 20
      :symmetry 60)
    :validators (list (validator.notinlastN 4)))
  :rythm rythm
  :duration (CUBEZ.duration
    :rythm rythm
    :p 0.4
    :minscale 0.85
    :maxscale 1) 
  :velocity 80
  :channel 1
  :fileName "steming_c.midi")