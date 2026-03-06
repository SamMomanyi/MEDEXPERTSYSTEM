;;; ============================================================
;;; FILE: main.clp
;;; Medical Expert System — Main Entry Point
;;;
;;; HOW TO RUN:
;;; 1. Open CLIPS (download from https://www.clipsrules.net)
;;; 2. In the CLIPS prompt, load files IN THIS ORDER:
;;;
;;;    CLIPS> (load "templates.clp")
;;;    CLIPS> (load "knowledge_base.clp")
;;;    CLIPS> (load "functions.clp")
;;;    CLIPS> (load "main.clp")
;;;
;;; 3. Start the system:
;;;    CLIPS> (reset)
;;;    CLIPS> (run)
;;;
;;; 4. For a new patient consultation:
;;;    CLIPS> (reset)
;;;    CLIPS> (run)
;;;
;;; All four files must be in the SAME folder.
;;; ============================================================


;;; ============================================================
;;; BATCH LOADER
;;; If you load ONLY this file, it will automatically load the
;;; other three files first (they must be in the same directory).
;;; ============================================================

;;; Uncomment the lines below if you want main.clp to auto-load
;;; the other files when you load it:
;;;
;;; (load "templates.clp")
;;; (load "knowledge_base.clp")
;;; (load "functions.clp")


;;; ============================================================
;;; SYSTEM INFORMATION
;;; ============================================================

;;; System metadata stored as a global variable
(defglobal
  ?*system-name*    = "Medical Expert System v1.0"
  ?*system-purpose* = "Primary Diagnosis Support for Low-Resource Clinics"
  ?*knowledge-base* = "8 diseases | 16 IF-THEN rules | 20 symptoms"
  ?*built-for*      = "Expert Systems Assignment — CAT 1"
)


;;; ============================================================
;;; QUICK-START RULE
;;; Prints instructions when the system first loads.
;;; ============================================================

(defrule system-loaded
  "Fires once when main.clp is loaded to confirm the system is ready."
  (declare (salience 200))
  (initial-fact)
  =>
  (printout t crlf
    "============================================================" crlf
    "  " ?*system-name* crlf
    "  " ?*system-purpose* crlf
    "  " ?*knowledge-base* crlf
    "============================================================" crlf
    crlf
    "  System loaded successfully." crlf
    crlf
    "  To start a consultation, type:" crlf
    "    CLIPS> (reset)" crlf
    "    CLIPS> (run)" crlf
    crlf
    "  To view all loaded rules, type:" crlf
    "    CLIPS> (rules)" crlf
    crlf
    "  To view the fact list at any time, type:" crlf
    "    CLIPS> (facts)" crlf
    crlf
    "============================================================" crlf
    crlf)
)
