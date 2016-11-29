#|
MIDI

methods for generating midi files
supplied by Kjartan Ólafsson <kjartano@hi.is>

|#

(defvar pitch-list '( 60 60 60 60))
(defvar duration-list '( 60 60 60 60))
(defvar velocity-list '( 60 60 60 60))
(defvar attack-list '( 60 60 60 60))
(defvar CHANNELS-LIST '( 0 0 0 0))
(defvar *time-sign* nil)
(defvar *numb* 4)
(defvar *mesure* 4)
(defvar AMPLITUDE-LIST nil)
(defvar PITCH-ENVELOPE-LIST nil)
(defvar look-midi nil)

(defun time-list2 (lst) (reverse (maplist #'(lambda  (el) (apply #'+  el)) (reverse lst))))
(defun set-time-sign (num mes) (setf *numb* num) (setf *mesure* mes))
(defun time-list (lst) (cond((< 0 (length lst)) (let (( ll (if (= (car lst) 0) lst(cons 0 lst)))) (reverse (maplist #'(lambda  (el) (apply #'+  el)) (reverse ll)))))))

(defmacro while (test &body body)
  (let ((testlab (gensym))
    (toplab (gensym)))
    `(tagbody
    (go ,testlab)
    ,toplab
    (progn ,@body)
    ,testlab
    (when ,test (go ,toplab)))))

(defun No-parenth (lst) (let ((result1)) (while lst (cond (( numberp (car lst)) (push  (pop lst)result1)) ((listp (car lst))  (mapcar #'(lambda (ll) (push   ll result1)) (pop lst))))) (reverse result1)))
(defun round2 (x) (if (numberp x) (if (minusp x) (* (truncate (+  (abs x) 0.5)) -1) (truncate (+ x 0.5))) x))

(defun variable-length-midi-time (ticks)
  (let ((high-byte1 0) (high-byte2 0) (high-byte3 0) (mod-ticks (mod ticks #x80)))
    (cond
      ((> ticks #x1FFFFF)
        (setq high-byte3 (+ #x80 (truncate (/ ticks #x200000))))
        (setq high-byte2 (+ #x80 mod-ticks))
        (setq high-byte1 (+ #x80 mod-ticks))
        (setq ticks mod-ticks)
        (list high-byte3 high-byte2 high-byte1 ticks))
      ((> ticks #x3FFF)
        (setq high-byte2 (+ #x80 (truncate (/ ticks #x4000))))
        (setq high-byte1 (+ #x80 mod-ticks))
        (setq ticks mod-ticks)
        (list high-byte2 high-byte1 ticks))
      ((> ticks #x7F)
        (setq high-byte1 (+ #x80 (truncate (/ ticks #x80))))
        (setq ticks mod-ticks)
        (list high-byte1 ticks))
      (t (list ticks)))))

(defun covert-length-to-4-byte-list (len)
  (let ((byte1 0) (byte2 0) (byte3 0) (byte4 0))
    (cond
      ((> len #xFFFFFF)
        (setq byte4 (truncate (/ len #x1000000)))
        (setq byte3 (mod len #x1000000))
        (setq byte3 (mod len #x10000))
        (setq byte2 (mod len #x10000))
        (setq byte1 (mod len #x100)))
      ((> len #xFFFF)
        (setq byte3 (truncate (/ len #x10000)))
        (setq byte2 (mod len #x10000))
        (setq byte1 (mod len #x100)))
      ((> len #xFF)
        (setq byte2 (truncate (/ len #x100)))
        (setq byte1 (mod len #x100)))
      (t  (setq byte1 len)))
    (list byte4 byte3 byte2 byte1)))

(defun  make-variable-length-midi-delta-times  (midi-list)
  (let ((res)(time-now 0))
    (WHILE midi-list
      (push (append (variable-length-midi-time (- (caar midi-list) time-now)) (cdar midi-list)) res)
      (setq time-now (caar midi-list))
      (pop midi-list))
    (no-parenth (nreverse res))))

(defun two-incr-lists (notes  amp pitch)
  (let (
    (out-list)
    (new-amp (mapcar #'(lambda (l1) (list (nth 0 l1)(+ 176 (nth 1 l1)) (nth 2 l1)(nth 3 l1)))(copy-list amp)))
    (new-pitch (mapcar #'(lambda (l1) (list (nth 0 l1)(+ 224 (nth 1 l1)) (nth 2 l1)(nth 3 l1)))(copy-list pitch))))

    (while (or  new-amp notes   new-pitch)
    ;(if   (eq (length notes)0)(progn(print-EVE (length new-amp))(print-EVE (length new-pitch))))
    (cond ((and (not (equal nil notes))
      (or(eq  nil new-amp)
        (<= (car (car notes))(car(car new-amp))))
      (or(eq  nil new-pitch)
        (<= (car (car notes))(car(car new-pitch)))))
      (push (pop notes)out-list))
      ((and (not (equal nil new-amp))
        (or(eq  nil notes)
        (> (car (car notes))(car(car new-amp))))
        (or(eq  nil new-pitch)
        (> (car(car new-pitch))(car(car new-amp)))))
        (push (pop new-amp) out-list))
      (t (if (not (equal nil new-pitch))(push (pop new-pitch)out-list)))
    ))
    (reverse out-list)))

(defun  make-midi-file-list  (attacks pitches durs vels chans)
  (setq chans (mapcar #'(lambda (l1)(+ 1 l1))   (copy-list chans)))
  (let ((t-time)(note)(midi-list))
  (while attacks
    (setq t-time (pop attacks))
    (setq note (pop pitches))
    (push (list
      t-time
      (+ #x8f (car chans))
      note
      (pop vels))
      midi-list)
    (push (list
      (+ t-time (car durs))
      (+ #x8f (car chans))
      note
      0)
      midi-list)
    (pop durs)
    (pop chans))

  (if
    (or (not (equal nil AMPLITUDE-LIST))(not (equal nil PITCH-ENVELOPE-LIST)))
    (setq  midi-list (two-incr-lists(sort
      (nreverse midi-list) #'< :key #'(lambda (a) (car a)))
      AMPLITUDE-LIST PITCH-ENVELOPE-LIST))
    (setq  midi-list (sort  (nreverse midi-list) #'< :key #'(lambda (a) (car a)))))

  (setq look-midi   midi-list)
  (make-variable-length-midi-delta-times midi-list)))

(defun make-midi-file-0 (attacks pitches durs vels chans )
  (let ((data (make-midi-file-list attacks pitches durs vels chans))
    (track-info
      '(#x00 #xff #x58 #x04 #x04  #x02 #x24 #x08
      #x00 #xff #x51 #x03 #x07 #xa1 #x20))
    (track-end '(#x00 #xff #x2f #x00)))

    (append
      (no-parenth(list
        #x4D #x54 #x68 #x64 #x00 #x00
        #x00 #x06 #x00 #x00 #x00 #x01
        #x00 #x60 #x4D #x54 #x72 #x6B))
      (covert-length-to-4-byte-list (+ (length track-info)(length data)(length track-end)))
      track-info
      data
      track-end)))

(defun set-mac-file-type (_path mac-file-type) (declare (ignore _path mac-file-type)) t)

(defun PW-midi-file-SAVE3  ( name1 path )
  (let (
    (new-att (time-list(append (list 0)  (cdr  (mapcar #'(lambda (l1 )(round2 (* 2 l1 )))  attack-list) ))))
    (new-dur   (append (rest (mapcar #'(lambda (l1 )(round2 (* 2 l1 )))    duration-list)) (list 0))))
  (print new-att)
  (print (length new-att))
  (print new-dur)
  (print (length new-dur))
  (PW-midi-file-SAVE1  (make-midi-file-0
    new-att pitch-list new-dur velocity-list channels-list)  name1 path )))

(defun PW-midi-file-SAVE1  (midi-data-list  name1 path  )
  (let* ((new-file))
    (setq *PRINT-BASE* 2)
    (setq new-file (ccl::create-file (make-pathname :directory path :name name1)))
    (WITH-OPEN-FILE
      (out new-file :direction :output :IF-EXISTS :overwrite
      :element-type '(unsigned-byte  8))
      (WHILE midi-data-list (write-byte (pop midi-data-list) out)))
    (setq *PRINT-BASE* 10)))

(defun position-obj-char (obj lst)
  (let ((pos) (count 0) (lst1 (copy-list lst)) (el 0) (test) (max1 0))
  (WHILE lst1 (setq el (pop lst1))
    (cond (
      (stringp el)
      (setq test (CCL::STRING-LESSP  el obj))
      (if (and(not (equal nil test))(<=  max1 test))
        (progn (setq max1 test) (setq pos count)))))
    (incf count))
  pos))
