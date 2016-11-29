#|

  To utilize the candy wrapper methods

  1 - create a settings thing
  2 - create pitch, attack, duration, velocity and channel lists
  3 - call CUBEZ.compose
  4 - enjoy (or not) 

  or

  1 - make a rythm list
  2 - compose a score with all the stuff in one definition like below

  run this command (with correct path) to generate your midi file
  (load "/home/kristjanhall/Programming/lisp/CUBEZ/examples/002.lisp")

|#

; load all CUBEZ libraries 
(load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")

; store the length in a variable to make it easier to change the length
(setq scorelength 154)

; we need the rythm in a variable for now since we need to use it
; both for rythm/attack and duration
(setq rythm (CUBEZ.rythm
    :len scorelength
    :theme '(24 48 96 192)
    :matrix '(
      (0.8  0.2  0.0  0.0)
      (0.75 0.15 0.05 0.0)
      (0.0  1.0  0.0  0.0)
      (0.0  0.0  0.0  0.0))
    :start 24))

; make a score and save it to the filesystem
(CUBEZ.compose
  :pitch (CUBEZ.pitch
    :len scorelength
    :theme '(60 67 64)
    :settings (CUBEZ.settings
      :scale (scales.kumoi)
      :notintervals (interval.a)
      :minval 50
      :maxval 70
      :tries 4)
    :weights (CUBEZ.weights
      :space 10
      :order 20
      :placement 30
      :symmetry 40)
    :validators (list (validator.notinlastN 1)))
  :rythm rythm
  :duration rythm
  ;:duration (CUBEZ.duration
  ;  :rythm rythm
  ;  :p 0.4
  ;  :minscale 0.85
  ;  :maxscale 0.9)  ; with 40% probability an element in the rythm list wil be scaled by 0.85...0.90
  :velocity 78      ; if there is no variation in the velocity it's enough to just put a number here, but we could also put a list
  :channel 2        ; same here, we can use a number or put in our own list 
  :filePath "/home/kristjanhall/Programming/lisp/CUBEZ/midis"
  :fileName "002.midi")