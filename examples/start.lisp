; this file ->
; (load "/home/kristjanhall/Programming/lisp/CUBEZ/start.lisp")
(load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")

;; lets make a song!
(defvar _printer (make-instance 'PRINTER))
(defvar _fitness (make-instance 'FITNESS))
(defvar _settings (make-instance 'SETTINGS))
(defvar _scales (make-instance 'SCALES))
(defvar _cords (make-instance 'CORDS))
(defvar myScore (make-instance 'SONG))

(fitness.prop _fitness
	:spaces 20
	:places 25
	:order 25
	:symmetry 30)

(settings.prop _settings
	:tries 10
	:minval 40
	:maxval 67
	:notes (scales.blues))

(printer.prop _printer
	:theme (append (scales.get _scales 'blues 4))
	:settings _settings
	:fitness _fitness)


#|
(print (printer.print _printer :len 20))
(print (lists.make :len 20 :minval 24 :maxval 24))
(print (lists.make :len 20 :minval 24 :maxval 24))
(print (lists.make :len 20 :minval 2 :maxval 2))
(print (lists.make :len 20 :minval 75 :maxval 75))
|#

(defvar markov.attack (make-instance 'MARKOV))
(markov.prop markov.attack
  :attribs '(24 24 48 48)
  :matrix (matrix.a)
  :len 60)
(markov.start markov.attack 24)
(defvar attack (markov.translate markov.attack))

(defvar markov.pitch (make-instance 'MARKOV))
(markov.prop markov.pitch
  :attribs '("C3" "D3" "D3#" "E4" "G4" "A4")
  :matrix '(
		(0.1 0.5 0.0 0.4 0.0 0.0)
		(0.2 0.1 0.1 0.3 0.3 0.0)
		(0.0 0.3 0.0 0.3 0.0 0.4)
		(0.2 0.0 0.1 0.4 0.2 0.1)
		(0.5 0.1 0.0 0.0 0.1 0.2)
		(0.2 0.0 0.1 0.3 0.4 0.0))
  :len 60)
(markov.start markov.pitch "C3")
(defvar pitch (cords.geta _cords (markov.translate markov.pitch)))

(song.prop myScore
	;:pitch (printer.print _printer :len 60)
	:pitch pitch
	:attack attack
	:duration (utils.lists.scalep attack 0.6 0.7 1) ; maybe scale this list a litle bit
	:channels (lists.make :len 60 :minval 2 :maxval 2)
	:velocity (lists.make :len 60 :minval 75 :maxval 75))

(print (song.readList myScore 'pitch))
(print (song.readList myScore 'attack))
(print (song.readList myScore 'duration))

;(midi.writeMIDI :song myScore :filePath midiPath :fileName "new.midi" :overwrite 1)