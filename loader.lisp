#|
This file only exists to make sure that we do not load
the CUBE lib files multiple times when running methods
that load the CUBE.lisp file - see example files

|#


(if (boundp 'loadedFiles)
  nil
  (progn
    (defvar loadedFiles '())
    (defun loader.load ()
      (loop for file in filesToLoad do
        (let ((filePath (concatenate 'string CUBEPath file)))
          (if (find filePath loadedFiles :test #'equal)
            nil
            (progn
              (load filePath)
              (push filePath loadedFiles))))))

    ; call (loader.reload "lib/some.lisp") to reload that file
    (defun loader.reload (filename)
      (let ((file (concatenate 'string CUBEPath filename)))
        (if (find file loadedFiles :test #'equal)
          (let ((N (position file loadedFiles :test #'equal)))
            (setf loadedFiles (append (subseq loadedFiles 0 N) (subseq loadedFiles (+ N 1) (length loadedFiles)))))
          nil)
        (loader.load)))))