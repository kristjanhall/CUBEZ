
(defclass CORDS () (
  (cords
    :initform (append
      '("A0" "B0" "C1" "D1" "E1" "F1" "G1" "A1" "B1" "C2" "D2" "E2" "F2" "G2" "A2" "B2" "C3" "D3" "E3" "F3" "G3" "A3" "B3" "C4" "D4" "E4" "F4" "G4" "A4" "B4" "C5" "D5" "E5" "F5" "G5" "A5" "B5" "C6" "D6" "E6" "F6" "G6" "A6" "B6" "C7" "D7" "E7" "F7" "G7" "A7" "B7" "C8")
      '("A0#" "C1#" "D1#" "F1#" "G1#" "A1#" "C2#" "D2#" "F2#" "G2#" "A2#" "C3#" "D3#" "F3#" "G3#" "A3#" "C4#" "D4#" "F4#" "G4#" "A4#" "C5#" "D5#" "F5#" "G5#" "A5#" "C6#" "D6#" "F6#" "G6#" "A6#" "C7#" "D7#" "F7#" "G7#" "A7#"))
    :accessor cords :initarg :cords)
  (nums
    :initform (append
      '(21 23 24 26 28 29 31 33 35 36 38 40 41 43 45 47 48 50 52 53 55 57 59 60 62 64 65 67 69 71 72 74 76 77 79 81 83 84 86 88 89 91 93 95 96 98 100 101 103 105 107 108)
      '(22 25 27 30 32 34 37 39 42 44 46 49 51 54 56 58 61 63 66 68 70 73 75 78 80 82 85 87 90 92 94 97 99 102 104 106))
    :accessor nums :initarg :nums)))

(defgeneric cords.get (CORDS cord)
  (:documentation "get some cord"))
(defmethod cords.get ((self CORDS) cord)
  (let (
    (cords (slot-value self 'cords))
    (nums (slot-value self 'nums)))
    (nth (position (string-upcase cord) cords :test #'equal) nums)))

(defgeneric cords.geta (CORDS cordsarray)
  (:documentation "get an array of cords"))
(defmethod cords.geta ((self CORDS) cordsarray)
  (let ((lst))
    (loop for cord in cordsarray do
      (push (cords.get self cord) lst))
    (reverse lst)))

; (defvar C (make-instance 'CORDS))
; (cords.get C "A5")
; (cords.geta C '("C3" "D3" "D3#" "E4" "G4" "A4"))

#|
    ("C3" "D3" "D3#" "E4" "G4" "A4")
C3  (0.1 0.5 0.0 0.4 0.0 0.0)
D3  (0.2 0.1 0.1 0.3 0.3 0.0)
D3# (0.0 0.3 0.0 0.3 0.0 0.4)
E4  (0.2 0.0 0.1 0.4 0.2 0.1)
G4  (0.5 0.1 0.0 0.0 0.1 0.2)
A4  (0.2 0.0 0.1 0.3 0.4 0.0)
|#