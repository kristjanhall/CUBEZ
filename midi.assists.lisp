(defvar midiPath (concatenate 'string CUBEPath "midis"))

; midi.writeMIDI - write a midi file to the filesystem
; song: a SONG instance
(defun midi.writeMIDI (&key score filePath fileName overwrite)
  (setq pitch-list (score.readList score 'pitch))
  (setq duration-list (score.readList score 'duration))
  (setq velocity-list (score.readList score 'velocity))
  (setq attack-list (score.readList score 'attack))
  (setq channels-list (score.readList score 'channels))

  (if (eq nil filePath) (setf filePath midiPath))

  ; if the file exists we maybe want to overwrite it
  (let ((_file_ (files.makeFilePath :path filePath :name fileName)))
    (if (files.doesFileExists :filePath _file_)
      (if (eq overwrite 1)
        (progn
          (files.deleteFile :filePath _file_)
          (PW-midi-file-SAVE3 fileName filePath))
        (print "File exists - set overwrite flag to replace or change filename"))
      (PW-midi-file-SAVE3 fileName filePath))))


(defun files.makeFilePath (&key path name)
  (let ((lastChar (subseq path (- (length path) 1))))
    (if (string= lastChar "/")
      (concatenate 'string path name)
      (concatenate 'string path "/" name))))


(defun files.doesFileExists (&key filePath)
    (if (neq (probe-file filePath) nil) T nil))

(defun files.deleteFile (&key filePath)
  (if (files.doesFileExists :filePath filePath)
    (delete-file filePath)
    nil))