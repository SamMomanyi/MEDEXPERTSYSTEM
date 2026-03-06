;;; ============================================================
;;; FILE: functions.clp
;;; Medical Expert System — Helper Functions and Output Rules
;;; Load this THIRD, after knowledge_base.clp
;;; ============================================================


;;; ============================================================
;;; SECTION A: HELPER FUNCTIONS (deffunction)
;;; ============================================================

;;; Prints a divider line
(deffunction print-divider ()
  (printout t "------------------------------------------------------------" crlf)
)

;;; Prints a double divider line
(deffunction print-double-divider ()
  (printout t "============================================================" crlf)
)

;;; Prints a confidence bar using ASCII characters
;;; Example: confidence 85 -> [#########.]  85%
(deffunction print-confidence-bar (?score)
  (bind ?filled  (div ?score 10))
  (bind ?empty   (- 10 ?filled))
  (printout t "  Confidence: [")
  (loop-for-count (?i 1 ?filled)  (printout t "#"))
  (loop-for-count (?i 1 ?empty)   (printout t "."))
  (printout t "] " ?score "%" crlf)
)

;;; Prints the urgency level with a text label
(deffunction print-urgency (?level)
  (printout t "  Urgency:    ")
  (if (eq ?level critical)
    then (printout t "*** CRITICAL — EMERGENCY — Do not delay! ***" crlf)
  )
  (if (eq ?level high)
    then (printout t "HIGH — Urgent clinical attention required" crlf)
  )
  (if (eq ?level medium)
    then (printout t "MEDIUM — Monitor closely; treat and observe" crlf)
  )
  (if (eq ?level low)
    then (printout t "LOW — Routine care; supportive management" crlf)
  )
)


;;; ============================================================
;;; SECTION B: PATIENT INPUT RULE
;;; Fires during the gather-patient phase to collect patient info.
;;; ============================================================

(defrule collect-patient-info
  "Asks for patient name, age, and sex then asserts a patient fact."
  (declare (salience 95))
  (phase (current gather-patient))
  (not (patient))                       ; only fire if no patient yet
  =>
  (printout t "--- PATIENT INFORMATION ---" crlf)

  (printout t "Patient name: ")
  (bind ?name (readline))

  (printout t "Patient age (years): ")
  (bind ?age (read))

  (printout t "Patient sex [male/female/other]: ")
  (bind ?sex (read))

  (assert (patient
    (name (str-cat ?name))
    (age  ?age)
    (sex  ?sex)
  ))

  (printout t crlf "Patient recorded: " ?name " | Age: " ?age " | Sex: " ?sex crlf)
)


;;; ============================================================
;;; SECTION C: OUTPUT RULES
;;; These rules fire during the 'output' phase to print results.
;;; They use the diagnosis facts asserted by the knowledge base.
;;; ============================================================

;;; --- Print the results header ---
(defrule output-header
  "Prints the results section header."
  (declare (salience 20))
  (phase (current output))
  (patient (name ?n) (age ?a) (sex ?s))
  =>
  (print-double-divider)
  (printout t "   DIAGNOSIS RESULTS" crlf)
  (print-double-divider)
  (printout t "   Patient : " ?n crlf)
  (printout t "   Age     : " ?a " years | Sex: " ?s crlf)
  (print-double-divider)
  (printout t crlf)
)

;;; --- Print a CRITICAL urgency diagnosis ---
(defrule output-diagnosis-critical
  "Prints diagnoses with CRITICAL urgency first, with emergency banner."
  (declare (salience 15))
  (phase (current output))
  (diagnosis
    (disease      ?d)
    (confidence   ?c)
    (urgency      critical)
    (matched-rule ?r)
    (treatment    ?t)
    (referral     ?ref)
    (lab-tests    ?l)
  )
  =>
  (printout t "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" crlf)
  (printout t "!!!  EMERGENCY DIAGNOSIS ALERT                         !!!" crlf)
  (printout t "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" crlf)
  (printout t "  Disease   : " ?d crlf)
  (print-confidence-bar ?c)
  (print-urgency critical)
  (printout t "  Rule Fired: " ?r crlf)
  (print-divider)
  (printout t "  TREATMENT : " ?t crlf)
  (print-divider)
  (printout t "  REFERRAL  : " ?ref crlf)
  (print-divider)
  (printout t "  LAB TESTS : " ?l crlf)
  (printout t "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!" crlf)
  (printout t crlf)
)

;;; --- Print a HIGH urgency diagnosis ---
(defrule output-diagnosis-high
  "Prints diagnoses with HIGH urgency."
  (declare (salience 14))
  (phase (current output))
  (diagnosis
    (disease      ?d)
    (confidence   ?c)
    (urgency      high)
    (matched-rule ?r)
    (treatment    ?t)
    (referral     ?ref)
    (lab-tests    ?l)
  )
  =>
  (print-double-divider)
  (printout t "  Disease   : " ?d crlf)
  (print-confidence-bar ?c)
  (print-urgency high)
  (printout t "  Rule Fired: " ?r crlf)
  (print-divider)
  (printout t "  TREATMENT : " ?t crlf)
  (print-divider)
  (printout t "  REFERRAL  : " ?ref crlf)
  (print-divider)
  (printout t "  LAB TESTS : " ?l crlf)
  (printout t crlf)
)

;;; --- Print a MEDIUM urgency diagnosis ---
(defrule output-diagnosis-medium
  "Prints diagnoses with MEDIUM urgency."
  (declare (salience 13))
  (phase (current output))
  (diagnosis
    (disease      ?d)
    (confidence   ?c)
    (urgency      medium)
    (matched-rule ?r)
    (treatment    ?t)
    (referral     ?ref)
    (lab-tests    ?l)
  )
  =>
  (print-double-divider)
  (printout t "  Disease   : " ?d crlf)
  (print-confidence-bar ?c)
  (print-urgency medium)
  (printout t "  Rule Fired: " ?r crlf)
  (print-divider)
  (printout t "  TREATMENT : " ?t crlf)
  (print-divider)
  (printout t "  REFERRAL  : " ?ref crlf)
  (print-divider)
  (printout t "  LAB TESTS : " ?l crlf)
  (printout t crlf)
)

;;; --- Print a LOW urgency diagnosis ---
(defrule output-diagnosis-low
  "Prints diagnoses with LOW urgency."
  (declare (salience 12))
  (phase (current output))
  (diagnosis
    (disease      ?d)
    (confidence   ?c)
    (urgency      low)
    (matched-rule ?r)
    (treatment    ?t)
    (referral     ?ref)
    (lab-tests    ?l)
  )
  =>
  (print-double-divider)
  (printout t "  Disease   : " ?d crlf)
  (print-confidence-bar ?c)
  (print-urgency low)
  (printout t "  Rule Fired: " ?r crlf)
  (print-divider)
  (printout t "  TREATMENT : " ?t crlf)
  (print-divider)
  (printout t "  REFERRAL  : " ?ref crlf)
  (print-divider)
  (printout t "  LAB TESTS : " ?l crlf)
  (printout t crlf)
)

;;; --- No diagnoses found message ---
(defrule output-no-diagnoses
  "Fires if no diagnosis facts exist after the diagnose phase."
  (declare (salience 10))
  (phase (current output))
  (not (diagnosis))
  =>
  (print-double-divider)
  (printout t "  No matching diagnoses found." crlf)
  (printout t "  Recommendation: Expand symptom recording or refer to a" crlf)
  (printout t "  higher-level facility for further investigation." crlf)
  (print-double-divider)
  (printout t crlf)
)

;;; --- Print footer ---
(defrule output-footer
  "Prints the footer and disclaimer after all diagnoses are shown."
  (declare (salience 5))
  (phase (current output))
  =>
  (print-double-divider)
  (printout t "  DISCLAIMER: Results are suggestions only." crlf)
  (printout t "  Clinical judgement of the attending healthcare worker" crlf)
  (printout t "  must always take precedence." crlf)
  (print-double-divider)
  (printout t crlf)
  (printout t "  Consultation complete. Type (reset) then (run) to start" crlf)
  (printout t "  a new consultation, or (exit) to quit CLIPS." crlf crlf)
)
