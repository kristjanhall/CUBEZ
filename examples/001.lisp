; this file ->
; (load "/home/kristjanhall/Programming/lisp/CUBEZ/examples/001.lisp")
(load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")

;; lets make a song!
(defvar _printer (make-instance 'PRINTER))
(defvar _fitness (make-instance 'FITNESS))
(defvar _settings (make-instance 'SETTINGS))
(defvar _scales (make-instance 'SCALES))
(defvar _cords (make-instance 'CORDS))
(defvar myScore (make-instance 'SONG))
(defvar markov.attack (make-instance 'MARKOV))
(defvar scorelength 140)

(fitness.prop _fitness
	:spaces 10
	:places 20
	:order 30
	:symmetry 40)

(settings.prop _settings
	:tries 4
	:minval 47
	:maxval 72
	:notes (scales.blues))

(printer.prop _printer
	;:theme (scales.get _scales 'blues 4)
	:theme '(48 53 55 58)
	:settings _settings
	:fitness _fitness)

(markov.prop markov.attack
  :attribs '(24 48 96 128)
  :matrix '(
    (0.6 0.4 0.0 0.0)
    (0.7 0.3 0.0 0.0)
    (0.9 0.1 0.0 0.0)
    (1.0 0.0 0.0 0.0))
  :len scorelength)
(defvar attack (markov.eval markov.attack 24)) ; start from 24

(song.prop myScore
	:pitch (printer.print _printer
    :len scorelength
    :validators (list (validator.notinlastN 4) (validator.maxfromlast 12)))
	:attack attack
	:duration (utils.lists.scalep attack 0.4 0.9 1) ; use scaled attack list
  ;:duration attack
	:channels (lists.make :len scorelength :minval 2 :maxval 2)
	:velocity (lists.make :len scorelength :minval 75 :maxval 75))

(print (song.readList myScore 'pitch))
(print (song.readList myScore 'attack))
(print (song.readList myScore 'duration))

(midi.writeMIDI :song myScore :filePath midiPath :fileName "001.midi" :overwrite 1)