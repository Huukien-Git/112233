;;; ==========================================================================
;;; CHUONG TRINH AUTOLISP: VE LUOI TRUC TOA DO ABC VA 123 (CAD GRID SYSTEM)
;;; Lenh su dung: LT hoac VELUOI hoac VELUOITRUC
;;; Tac gia: AI Assistant for AutoCAD
;;; ==========================================================================

(vl-load-com)

;; Ham khoi tao va kiem tra Layer / Linetype
(defun Init-Grid-Layers ()
  ;; Kiem tra va load kieu duong CENTER
  (if (not (tblsearch "LTYPE" "CENTER"))
    (vl-catch-all-apply
      '(lambda () (vla-load (vla-get-Linetypes (vla-get-ActiveDocument (vlax-get-acad-object))) "CENTER" "acad.lin"))
    )
  )

  ;; Tao Layer TRUC (Mau 1 - Do, Net CENTER)
  (if (not (tblsearch "LAYER" "TRUC"))
    (command "_.layer" "_m" "TRUC" "_c" "1" "" "_l" "CENTER" "" "")
    (command "_.layer" "_s" "TRUC" "")
  )

  ;; Tao Layer BONG_BONG (Mau 2 - Vang, Net Continuous)
  (if (not (tblsearch "LAYER" "BONG_BONG"))
    (command "_.layer" "_m" "BONG_BONG" "_c" "2" "" "_l" "Continuous" "" "")
  )

  ;; Tao Layer TEXT_TRUC (Mau 3 - Xanh la, Net Continuous)
  (if (not (tblsearch "LAYER" "TEXT_TRUC"))
    (command "_.layer" "_m" "TEXT_TRUC" "_c" "3" "" "_l" "Continuous" "" "")
  )

  ;; Tao Layer DIM (Mau 4 - Xanh lo Cyan, Net Continuous)
  (if (not (tblsearch "LAYER" "DIM"))
    (command "_.layer" "_m" "DIM" "_c" "4" "" "_l" "Continuous" "" "")
  )
)

;; Ham ve Text can giua (Middle Center)
(defun Draw-MC-Text (pt h txt lay /)
  (entmake (list
    '(0 . "TEXT")
    (cons 8 lay)
    (cons 10 pt)
    (cons 11 pt)
    (cons 40 h)
    (cons 1 txt)
    '(72 . 1) ; Center
    '(73 . 2) ; Middle
  ))
)

;; Ham ve vong tron bong bong dau truc
(defun Draw-Bubble (center ptRad lay)
  (entmake (list
    '(0 . "CIRCLE")
    (cons 8 lay)
    (cons 10 center)
    (cons 40 ptRad)
  ))
)

;; Ham ve duong thang
(defun Draw-Line (p1 p2 lay /)
  (entmake (list
    '(0 . "LINE")
    (cons 8 lay)
    (cons 10 p1)
    (cons 11 p2)
  ))
)

;; Ham xu ly loi va khoi phuc he thong
(defun *MyGridError* (msg)
  (if old-osmode (setvar "OSMODE" old-osmode))
  (if old-cmdecho (setvar "CMDECHO" old-cmdecho))
  (if old-clayer (setvar "CLAYER" old-clayer))
  (if old-cecolor (setvar "CECOLOR" old-cecolor))
  (vla-EndUndoMark (vla-get-ActiveDocument (vlax-get-acad-object)))
  (princ "\nDa dung lenh ve luoi truc.")
  (princ)
)

;; ==========================================================================
;; LENH CHINH: LT / VELUOI / VELUOITRUC
;; ==========================================================================
(defun c:LT () (c:VELUOI))
(defun c:VELUOITRUC () (c:VELUOI))

(defun c:VELUOI ( / ptBase x1 x2 y1 y2 typeGrid
                    listX listY listLabelX listLabelY
                    ext bubbleR bubbleDist textH
                    minX maxX minY maxY
                    pt1 pt2 ptTop ptBot ptLeft ptRight
                    dimY1 dimY2 dimX1 dimX2
                    acadDoc)
  
  ;; Luu bien he thong
  (setq old-error *error*)
  (setq *error* *MyGridError*)
  (setq old-osmode (getvar "OSMODE"))
  (setq old-cmdecho (getvar "CMDECHO"))
  (setq old-clayer (getvar "CLAYER"))
  (setq old-cecolor (getvar "CECOLOR"))

  (setvar "CMDECHO" 0)
  (setq acadDoc (vla-get-ActiveDocument (vlax-get-acad-object)))
  (vla-StartUndoMark acadDoc)

  (princ "\n--- CHUONG TRINH VE LUOI TRUC ABC & 123 (TY LE 1:100) ---")

  ;; Diem goc dat luoi truc
  (setq ptBase (getpoint "\nChon diem goc dat he luoi truc <0,0,0>: "))
  (if (null ptBase) (setq ptBase '(0.0 0.0 0.0)))

  ;; Chon kieu danh so
  (initget "1 2")
  (setq typeGrid (getkword "\nChon kieu truc [1: Dung 1-2-3 / Ngang A-B-C | 2: Dung A-B-C / Ngang 1-2-3] <1>: "))
  (if (or (null typeGrid) (= typeGrid "")) (setq typeGrid "1"))

  ;; Nhap khoang cach cac nhip X
  (setq x1 (getreal "\nKhoang cach nhip X1 (Trang 1-2 hoac A-B) <4000>: "))
  (if (null x1) (setq x1 4000.0))

  (setq x2 (getreal "\nKhoang cach nhip X2 (Trang 2-3 hoac B-C) <4500>: "))
  (if (null x2) (setq x2 4500.0))

  ;; Nhap khoang cach cac nhip Y
  (setq y1 (getreal "\nKhoang cach nhip Y1 (Trang A-B hoac 1-2) <4000>: "))
  (if (null y1) (setq y1 4000.0))

  (setq y2 (getreal "\nKhoang cach nhip Y2 (Trang B-C hoac 2-3) <4000>: "))
  (if (null y2) (setq y2 4000.0))

  ;; Khoi tao Layer
  (Init-Grid-Layers)
  (setvar "OSMODE" 0) ; Tat bat diem de ve chinh xac tuyet doi

  ;; Thiet lap thong so ty le
  (setq ext 1200.0)      ; Do vuon qua truc ngoai cung
  (setq bubbleR 450.0)   ; Ban kinh vong tron bong bong
  (setq bubbleDist (+ ext bubbleR))
  (setq textH 400.0)     ; Chieu cao chu ten truc

  ;; Toa do tuyet doi theo diem goc ptBase
  (setq minX (car ptBase))
  (setq minY (cadr ptBase))
  (setq listX (list minX (+ minX x1) (+ minX x1 x2)))
  (setq listY (list minY (+ minY y1) (+ minY y1 y2)))

  (setq maxX (+ minX x1 x2))
  (setq maxY (+ minY y1 y2))

  ;; Thiet lap nhan truc theo tuy chon
  (if (= typeGrid "1")
    (progn
      (setq listLabelX (list "1" "2" "3"))
      (setq listLabelY (list "A" "B" "C"))
    )
    (progn
      (setq listLabelX (list "A" "B" "C"))
      (setq listLabelY (list "1" "2" "3"))
    )
  )

  ;; 1. VE CAC TRUC DOC (VERTICAL GRIDS)
  (setq i 0)
  (while (< i 3)
    (setq curX (nth i listX))
    (setq curLbl (nth i listLabelX))

    (setq pt1 (list curX (- minY ext) 0.0))
    (setq pt2 (list curX (+ maxY ext) 0.0))
    ;; Duong truc
    (Draw-Line pt1 pt2 "TRUC")

    ;; Bong bong duoi
    (setq ptBot (list curX (- minY bubbleDist) 0.0))
    (Draw-Bubble ptBot bubbleR "BONG_BONG")
    (Draw-MC-Text ptBot textH curLbl "TEXT_TRUC")

    ;; Bong bong tren
    (setq ptTop (list curX (+ maxY bubbleDist) 0.0))
    (Draw-Bubble ptTop bubbleR "BONG_BONG")
    (Draw-MC-Text ptTop textH curLbl "TEXT_TRUC")

    (setq i (1+ i))
  )

  ;; 2. VE CAC TRUC NGANG (HORIZONTAL GRIDS)
  (setq j 0)
  (while (< j 3)
    (setq curY (nth j listY))
    (setq curLbl (nth j listLabelY))

    (setq pt1 (list (- minX ext) curY 0.0))
    (setq pt2 (list (+ maxX ext) curY 0.0))
    ;; Duong truc
    (Draw-Line pt1 pt2 "TRUC")

    ;; Bong bong trai
    (setq ptLeft (list (- minX bubbleDist) curY 0.0))
    (Draw-Bubble ptLeft bubbleR "BONG_BONG")
    (Draw-MC-Text ptLeft textH curLbl "TEXT_TRUC")

    ;; Bong bong phai
    (setq ptRight (list (+ maxX bubbleDist) curY 0.0))
    (Draw-Bubble ptRight bubbleR "BONG_BONG")
    (Draw-MC-Text ptRight textH curLbl "TEXT_TRUC")

    (setq j (1+ j))
  )

  ;; 3. VE KICH THUOC (DIMENSIONS NATIVE AUTOCAD)
  (setvar "CLAYER" "DIM")

  ;; Dim phuong X: Nhip 1-2, Nhip 2-3
  (setq dimY1 (- minY 700.0))
  (command "_.dimlinear" 
           (list (nth 0 listX) minY 0.0) 
           (list (nth 1 listX) minY 0.0) 
           (list (/ (+ (nth 0 listX) (nth 1 listX)) 2.0) dimY1 0.0))
  
  (command "_.dimlinear" 
           (list (nth 1 listX) minY 0.0) 
           (list (nth 2 listX) minY 0.0) 
           (list (/ (+ (nth 1 listX) (nth 2 listX)) 2.0) dimY1 0.0))

  ;; Dim Tong phuong X
  (setq dimY2 (- minY bubbleDist bubbleR 600.0))
  (command "_.dimlinear" 
           (list minX minY 0.0) 
           (list maxX minY 0.0) 
           (list (/ (+ minX maxX) 2.0) dimY2 0.0))

  ;; Dim phuong Y: Nhip A-B, Nhip B-C
  (setq dimX1 (- minX 700.0))
  (command "_.dimlinear" 
           (list minX (nth 0 listY) 0.0) 
           (list minX (nth 1 listY) 0.0) 
           (list dimX1 (/ (+ (nth 0 listY) (nth 1 listY)) 2.0) 0.0))

  (command "_.dimlinear" 
           (list minX (nth 1 listY) 0.0) 
           (list minX (nth 2 listY) 0.0) 
           (list dimX1 (/ (+ (nth 1 listY) (nth 2 listY)) 2.0) 0.0))

  ;; Dim Tong phuong Y
  (setq dimX2 (- minX bubbleDist bubbleR 600.0))
  (command "_.dimlinear" 
           (list minX minY 0.0) 
           (list minX maxY 0.0) 
           (list dimX2 (/ (+ minY maxY) 2.0) 0.0))

  ;; 4. TIEU DE BAN VE
  (setq midX (/ (+ minX maxX) 2.0))
  (setq titleY (- dimY2 1200.0))
  (Draw-MC-Text (list midX titleY 0.0) 450.0 "MAT BANG HE TRUC TOA DO" "TEXT_TRUC")
  (Draw-Line (list (- midX 2200.0) (- titleY 350.0) 0.0) (list (+ midX 2200.0) (- titleY 350.0) 0.0) "TEXT_TRUC")
  (Draw-MC-Text (list midX (- titleY 650.0) 0.0) 250.0 "TY LE: 1/100" "DIM")

  ;; Zoom all de xem toan bo ban ve
  (command "_.zoom" "_e")

  ;; Khoi phuc bien he thong
  (setvar "OSMODE" old-osmode)
  (setvar "CMDECHO" old-cmdecho)
  (setvar "CLAYER" old-clayer)
  (setvar "CECOLOR" old-cecolor)
  (setq *error* old-error)
  (vla-EndUndoMark acadDoc)

  (princ "\n>> Da ve xong luoi truc CAD thanh cong! <<\n")
  (princ)
)

(princ "\n=======================================================")
(princ "\n DA LOAD THANH CONG LISP VE LUOI TRUC CAD!")
(princ "\n Go lenh: LT hoac VELUOI de bat dau ve.")
(princ "\n=======================================================\n")
(princ)
