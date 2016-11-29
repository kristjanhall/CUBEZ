#|
CUBE
a collection of lisp methods that can be utilzed to generate
a simple AI generated midi music

Author: kristján hall <krh44@hi.is>


This file loads all the other files in CUBE in order of
dependance or importance, to use CUBE keep all the
files listed below and this file in the same
folder and run this file

|#


; =========>> UPDATE THIS PATH <<=========
(defvar CUBEPath "/home/kristjanhall/Programming/lisp/CUBEZ/")
; =========>> UPDATE THIS PATH <<=========

; to load this file
; (load "/home/kristjanhall/Programming/lisp/CUBEZ/CUBEZ.lisp")

; only mess with this if you know what is happening here...

(defvar filesToLoad '(
	"utils.lisp"
	"lists.lisp"
	"math.lisp"
	"fitness.lisp"
	"validators.lisp"
	"settings.lisp"
	"printer.lisp"
	"intervals.lisp"
	"scales.lisp"
	"notes.lisp"
	"score.lisp"
	"cords.lisp"
	"markov.lisp"
	"matrix.lisp"
	"midi.lisp"
	"midi.assists.lisp"
	"maker.lisp"
))


; load the files
(load (concatenate 'string CUBEPath "loader.lisp"))
; note that the loader does not reload files multiple times
; even though this file is loaded multiple times, if we
; need to reload some file (updated code) then we need
; to call (loader.reload "lib/some.lis")
(loader.load)