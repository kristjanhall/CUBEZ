(load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")
#|

  Karakter A
  "Hægur, litlar breytingar, jafnvægi, reglulegur"


  Skipun til að búa til midi skrá
  (load "/home/kristjanhall/Programming/lisp/CUBEZ/examples/karakter_a.lisp")

|# 


(setq scorelength 160)

(setq rythm (CUBEZ.rythm
    :len scorelength
    :theme '(24 48 96 192)
    :matrix '(
      (0.00 1.00 0.0  0.0)
      (0.0  0.75 0.25 0.0)
      (0.0  0.70 0.20 1.0)
      (0.0  0.90 0.10 0.0))
    :start 48))

(CUBEZ.compose
  :pitch (CUBEZ.pitch
    :len scorelength
    :theme '(57 65 67 65)
    :settings (CUBEZ.settings
      :scale (scales.mixolydian)
      :notintervals (interval.b)
      :minval 60
      :maxval 72)
    :weights (CUBEZ.weights
      :space 20
      :order 40
      :placement 30
      :symmetry 10))
  :rythm rythm
  :duration (CUBEZ.duration
    :rythm rythm
    :p 0.5
    :minscale 0.85
    :maxscale 0.9) 
  :velocity 80
  :channel 2
  :fileName "karakter_a.midi")