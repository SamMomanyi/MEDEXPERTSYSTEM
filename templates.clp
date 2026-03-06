;;; ============================================================
;;; FILE: templates.clp
;;; Medical Expert System — Template (Data Structure) Definitions
;;; Load this FIRST before any other file.
;;; ============================================================

;;; --- PATIENT template ---
;;; Stores information about the current patient being assessed.
(deftemplate patient
  (slot name    (type STRING)  (default "Unknown"))
  (slot age     (type INTEGER) (default 0))
  (slot sex     (type SYMBOL)  (allowed-symbols male female other) (default male))
)

;;; --- SYMPTOM template ---
;;; Each symptom the user is asked about will be stored as a fact
;;; using this template. 'present' is set to yes or no based on
;;; the clinician's answer.
(deftemplate symptom
  (slot name    (type SYMBOL))          ; e.g. fever, chills, rash
  (slot present (type SYMBOL)
                (allowed-symbols yes no unknown)
                (default unknown))
)

;;; --- DIAGNOSIS template ---
;;; Created by the inference engine when a set of rules fire.
;;; Holds the suggested disease and supporting clinical information.
(deftemplate diagnosis
  (slot disease      (type STRING))     ; Disease name
  (slot confidence   (type INTEGER)     ; Confidence score 0-100
                     (default 0))
  (slot urgency      (type SYMBOL)
                     (allowed-symbols critical high medium low)
                     (default low))
  (slot matched-rule (type STRING)      ; Which rule description fired
                     (default ""))
  (slot treatment    (type STRING)      ; Recommended first-line treatment
                     (default ""))
  (slot referral     (type STRING)      ; Criteria for referral
                     (default ""))
  (slot lab-tests    (type STRING)      ; Recommended tests
                     (default ""))
)

;;; --- PHASE template ---
;;; Controls which phase of execution the system is in.
;;; Phases:  startup -> gather-patient -> gather-symptoms -> diagnose -> output -> done
(deftemplate phase
  (slot current (type SYMBOL)
                (allowed-symbols startup
                                 gather-patient
                                 gather-symptoms
                                 diagnose
                                 output
                                 done)
                (default startup))
)

;;; --- SYMPTOM-ASKED template ---
;;; Tracks which symptoms have already been asked, to avoid repeating questions.
(deftemplate symptom-asked
  (slot name (type SYMBOL))
)

;;; ============================================================
;;; Initial facts — loaded when (reset) is called
;;; ============================================================
(deffacts initial-state
  "Starting facts for the Medical Expert System"
  (phase (current startup))
)
