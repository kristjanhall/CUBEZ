#|

Some candy wrappers for score generation...
mainly here as a direct answer to the principal methods described in the
final assignment instructions under "lýsing á föllum"

|#


; assist function, returns an evaluated list made by a markov chain
; based of attribs, martrix and len
(defun CUBEZ.markov (attribs matrix len start)
  (let ((markov.chain (make-instance 'MARKOV)))
    (markov.prop markov.chain
      :attribs attribs
      :matrix matrix
      :len len)
    (markov.eval markov.chain start)))


; writes a midi file to the filesystem
; * velocity can either be a number or a list of velocity values
; * channel can either be a number or a list of channel values
(defun CUBEZ.compose (&key pitch rythm duration velocity channel fileName filePath)
  (let (
    (_score (make-instance 'SCORE))
    (_velocity) (_channel))

    ; check if velocity and channel are just numbers
    (if (numberp velocity)
      (setf _velocity (lists.make :len (length pitch) :minval velocity :maxval velocity))
      (setf _velocity velocity))
    (if (numberp channel)
      (setf _channel (lists.make :len (length pitch) :minval channel :maxval channel))
      (setf _channel channel))

    (score.prop _score
      :pitch pitch
      :attack rythm
      :duration duration
      :channels _channel
      :velocity _velocity)
    ;(print (score.readList _score 'attack))
    (;print (score.readList _score 'duration))
    (midi.writeMIDI :score _score :filePath filePath :fileName fileName :overwrite 1)
    (print "============================")
    (print "File has been saved")
    (print "============================")))


; returns a fitness instance required by the pitch function
(defun CUBEZ.weights (&key space order placement symmetry)
  (let (
    (_fitness (make-instance 'FITNESS)))
    (fitness.prop _fitness
      :spaces space
      :places placement
      :order order
      :symmetry symmetry)
    _fitness))


; returns a list of note values, pitch, of length len
(defun CUBEZ.pitch (&key len theme settings weights validators)
  (let (
    (_printer (make-instance 'PRINTER)))

    (printer.prop _printer
      :theme theme
      :settings settings
      :fitness weights)

    (printer.print _printer
      :len len
      :validators validators)))


; returns a settings instance that is required by the pitch method
; * minval default = 47
; * maxval default = 72
; * tries default = 4
; minval, maxval and tries are only required if you want to overwrite the default values
(defun CUBEZ.settings (&key scale notintervals minval maxval tries)
  (let (
    (_settings (make-instance 'SETTINGS)))

    (settings.prop _settings
      :tries (or tries 4)
      :minval (or minval 47)
      :maxval (or maxval 72)
      :notes scale
      :notintervals notintervals)
    _settings))


; returns a list selected from given theme and matrix
(defun CUBEZ.rythm (&key len theme matrix start)
  (CUBEZ.markov theme matrix len start))
  #|
  (let (
    (markov.rythm (make-instance 'MARKOV)))

    (markov.prop markov.rythm
      :attribs theme
      :matrix matrix
      :len len)
    
    (markov.eval markov.rythm)))
  |#


; returns a list of either scaled rythm list or a list that is exactly
; like the rythm list
; * rythm -> required
; * p, minscale, maxscale -> optional
(defun CUBEZ.duration (&key rythm p minscale maxscale)
  (if (and (neq nil p) (neq nil minscale) (neq nil maxscale))
    (utils.lists.scalep rythm p minscale maxscale)
    (copy-list rythm)))


; returns a list of velocity values
; if theme and matrix is supplied the returned list will be generated with markov chains
; otherwise a list of velocity value is returned 
; * len -> required
; * velocity -> optional (required if no theme or matrix)
; * theme, matrix, start -> optional (required if velocity not given) 
(defun CUBEZ.velocity (&key len velocity theme matrix start)
  (if (and (neq nil theme) (neq nil matrix))
    ; if true
    (CUBEZ.markov theme matrix len start)
    ; if false
    (lists.make :len len :minval (math.modN 128 velocity) :maxval (math.modN 128 velocity))))


    #|
    (let ((markov.velocity (make-instance 'MARKOV)))
      (markov.prop markov.rythm
        :attribs theme
        :matrix matrix
        :len len)
      (markov.eval markov.velocity))
    |#


; returns a list of channel values
; * len -> required
(defun CUBEZ.channel (&key len channel)
  (lists.make :len len :minval (math.modN 16 channel) :maxval (math.modN 16 channel)))
