(load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")
#|

  Karakter B
  "Hraður, síbreytilegur, ójafnvægi, óreglulegur"


  Skipun til að búa til midi skrá
  (load "/home/kristjanhall/Programming/lisp/CUBEZ/examples/karakter_b.lisp")

|# 


(setq scorelength 160)

(setq rythm (CUBEZ.rythm
    :len scorelength
    :theme '(24 48 96 192)
    :matrix '(
      (0.8  0.2  0.0  0.0)
      (0.75 0.25 0.0  0.0)
      (0.0  0.0  0.0  0.0)
      (0.0  0.0  0.0  0.0))
    :start 24))

(CUBEZ.compose
  :pitch (CUBEZ.pitch
    :len scorelength
    :theme '(47 67 48 67)
    :settings (CUBEZ.settings
      :scale (scales.moll)
      :minval 47
      :maxval 72
      :notintervals (interval.B))
    :weights (CUBEZ.weights
      :space 30
      :order 30
      :placement 30
      :symmetry 10)
    :validators (list (validator.notinlastN 1) (validator.minfromlast 2)))
  :rythm rythm
  :duration rythm 
  :velocity 80
  :channel 2
  :fileName "karakter_b.midi")