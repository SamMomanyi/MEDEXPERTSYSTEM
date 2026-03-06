;;; ============================================================
;;; FILE: knowledge_base.clp
;;; Medical Expert System — Knowledge Base (IF-THEN Rules)
;;; Load this SECOND, after templates.clp
;;;
;;; Rule naming convention:  dx-<disease>-<rule_number>
;;; Salience levels:
;;;   100 = startup/control rules
;;;    50 = symptom gathering
;;;    10 = diagnosis rules (default)
;;;     0 = output rules
;;; ============================================================


;;; ============================================================
;;; SECTION A: PHASE-CONTROL RULES
;;; These rules advance the system through its execution phases.
;;; ============================================================

;;; Move from startup to patient-gathering phase
(defrule phase-start
  "Fires once at startup to begin the consultation."
  (declare (salience 100))
  ?p <- (phase (current startup))
  =>
  (retract ?p)
  (assert (phase (current gather-patient)))
  (printout t crlf
    "============================================================" crlf
    "   MEDICAL EXPERT SYSTEM — Primary Diagnosis Support        " crlf
    "   Low-Resource Clinic Edition                              " crlf
    "============================================================" crlf
    crlf
    "DISCLAIMER: This system supports clinical decision-making." crlf
    "It does NOT replace the judgement of a qualified clinician." crlf
    crlf)
)

;;; After patient info is collected, move to symptom gathering
;;; (This rule waits for a patient fact to exist)
(defrule phase-patient-to-symptoms
  "Transitions to symptom gathering once patient data is recorded."
  (declare (salience 90))
  ?p <- (phase (current gather-patient))
  (patient)                             ; patient fact must exist
  =>
  (retract ?p)
  (assert (phase (current gather-symptoms)))
  (printout t crlf "--- SYMPTOM ASSESSMENT ---" crlf
    "Answer each question with Y (yes) or N (no)." crlf crlf)
)

;;; After all symptoms gathered, move to diagnosis
(defrule phase-symptoms-to-diagnose
  "Transitions to diagnosis phase once all symptoms have been asked."
  (declare (salience 40))
  ?p <- (phase (current gather-symptoms))
  ;; All 20 key symptoms must have been asked
  (symptom-asked (name fever))
  (symptom-asked (name high-fever))
  (symptom-asked (name chills))
  (symptom-asked (name sweating))
  (symptom-asked (name headache))
  (symptom-asked (name severe-headache))
  (symptom-asked (name muscle-pain))
  (symptom-asked (name joint-pain))
  (symptom-asked (name fatigue))
  (symptom-asked (name nausea))
  (symptom-asked (name vomiting))
  (symptom-asked (name diarrhea))
  (symptom-asked (name abdominal-pain))
  (symptom-asked (name constipation))
  (symptom-asked (name rash))
  (symptom-asked (name cough))
  (symptom-asked (name chest-pain))
  (symptom-asked (name difficulty-breathing))
  (symptom-asked (name painful-urination))
  (symptom-asked (name neck-stiffness))
  =>
  (retract ?p)
  (assert (phase (current diagnose)))
  (printout t crlf "--- RUNNING INFERENCE ENGINE ---" crlf crlf)
)

;;; After diagnosis rules fire, move to output
(defrule phase-diagnose-to-output
  "Transitions to output phase once the diagnosis phase completes."
  (declare (salience -5))
  ?p <- (phase (current diagnose))
  =>
  (retract ?p)
  (assert (phase (current output)))
)


;;; ============================================================
;;; SECTION B: SYMPTOM-GATHERING RULES
;;; One rule per symptom. Each rule asks the clinician and
;;; asserts a symptom fact + marks the symptom as asked.
;;; Salience 50 so these fire before diagnosis rules.
;;; ============================================================

(defrule ask-fever
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name fever)))
  =>
  (assert (symptom-asked (name fever)))
  (printout t "Does the patient have FEVER (temperature >= 37.5 C)? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name fever) (present yes)))
    else (assert (symptom (name fever) (present no))))
)

(defrule ask-high-fever
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name high-fever)))
  =>
  (assert (symptom-asked (name high-fever)))
  (printout t "Is the fever HIGH (temperature >= 39 C)? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name high-fever) (present yes)))
    else (assert (symptom (name high-fever) (present no))))
)

(defrule ask-chills
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name chills)))
  =>
  (assert (symptom-asked (name chills)))
  (printout t "Does the patient have CHILLS or RIGORS (shivering)? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name chills) (present yes)))
    else (assert (symptom (name chills) (present no))))
)

(defrule ask-sweating
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name sweating)))
  =>
  (assert (symptom-asked (name sweating)))
  (printout t "Does the patient have PROFUSE SWEATING? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name sweating) (present yes)))
    else (assert (symptom (name sweating) (present no))))
)

(defrule ask-headache
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name headache)))
  =>
  (assert (symptom-asked (name headache)))
  (printout t "Does the patient have a HEADACHE? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name headache) (present yes)))
    else (assert (symptom (name headache) (present no))))
)

(defrule ask-severe-headache
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name severe-headache)))
  =>
  (assert (symptom-asked (name severe-headache)))
  (printout t "Is the headache SEVERE (worst of life)? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name severe-headache) (present yes)))
    else (assert (symptom (name severe-headache) (present no))))
)

(defrule ask-muscle-pain
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name muscle-pain)))
  =>
  (assert (symptom-asked (name muscle-pain)))
  (printout t "Does the patient have MUSCLE or BODY ACHES? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name muscle-pain) (present yes)))
    else (assert (symptom (name muscle-pain) (present no))))
)

(defrule ask-joint-pain
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name joint-pain)))
  =>
  (assert (symptom-asked (name joint-pain)))
  (printout t "Does the patient have JOINT PAIN? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name joint-pain) (present yes)))
    else (assert (symptom (name joint-pain) (present no))))
)

(defrule ask-fatigue
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name fatigue)))
  =>
  (assert (symptom-asked (name fatigue)))
  (printout t "Does the patient have FATIGUE or WEAKNESS? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name fatigue) (present yes)))
    else (assert (symptom (name fatigue) (present no))))
)

(defrule ask-nausea
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name nausea)))
  =>
  (assert (symptom-asked (name nausea)))
  (printout t "Does the patient have NAUSEA? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name nausea) (present yes)))
    else (assert (symptom (name nausea) (present no))))
)

(defrule ask-vomiting
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name vomiting)))
  =>
  (assert (symptom-asked (name vomiting)))
  (printout t "Does the patient have VOMITING? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name vomiting) (present yes)))
    else (assert (symptom (name vomiting) (present no))))
)

(defrule ask-diarrhea
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name diarrhea)))
  =>
  (assert (symptom-asked (name diarrhea)))
  (printout t "Does the patient have DIARRHOEA? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name diarrhea) (present yes)))
    else (assert (symptom (name diarrhea) (present no))))
)

(defrule ask-abdominal-pain
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name abdominal-pain)))
  =>
  (assert (symptom-asked (name abdominal-pain)))
  (printout t "Does the patient have ABDOMINAL PAIN? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name abdominal-pain) (present yes)))
    else (assert (symptom (name abdominal-pain) (present no))))
)

(defrule ask-constipation
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name constipation)))
  =>
  (assert (symptom-asked (name constipation)))
  (printout t "Does the patient have CONSTIPATION? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name constipation) (present yes)))
    else (assert (symptom (name constipation) (present no))))
)

(defrule ask-rash
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name rash)))
  =>
  (assert (symptom-asked (name rash)))
  (printout t "Does the patient have a SKIN RASH? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name rash) (present yes)))
    else (assert (symptom (name rash) (present no))))
)

(defrule ask-cough
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name cough)))
  =>
  (assert (symptom-asked (name cough)))
  (printout t "Does the patient have a COUGH (productive / with phlegm)? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name cough) (present yes)))
    else (assert (symptom (name cough) (present no))))
)

(defrule ask-chest-pain
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name chest-pain)))
  =>
  (assert (symptom-asked (name chest-pain)))
  (printout t "Does the patient have CHEST PAIN? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name chest-pain) (present yes)))
    else (assert (symptom (name chest-pain) (present no))))
)

(defrule ask-difficulty-breathing
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name difficulty-breathing)))
  =>
  (assert (symptom-asked (name difficulty-breathing)))
  (printout t "Does the patient have DIFFICULTY BREATHING (shortness of breath)? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name difficulty-breathing) (present yes)))
    else (assert (symptom (name difficulty-breathing) (present no))))
)

(defrule ask-painful-urination
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name painful-urination)))
  =>
  (assert (symptom-asked (name painful-urination)))
  (printout t "Does the patient have PAINFUL or BURNING URINATION? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name painful-urination) (present yes)))
    else (assert (symptom (name painful-urination) (present no))))
)

(defrule ask-neck-stiffness
  (declare (salience 50))
  (phase (current gather-symptoms))
  (not (symptom-asked (name neck-stiffness)))
  =>
  (assert (symptom-asked (name neck-stiffness)))
  (printout t "Does the patient have NECK STIFFNESS? [Y/N]: ")
  (bind ?ans (lowcase (read)))
  (if (eq ?ans y)
    then (assert (symptom (name neck-stiffness) (present yes)))
    else (assert (symptom (name neck-stiffness) (present no))))
)


;;; ============================================================
;;; SECTION C: DIAGNOSTIC RULES
;;;
;;; These rules fire during the 'diagnose' phase.
;;; Each rule matches a specific symptom pattern and asserts a
;;; diagnosis fact with a confidence score and clinical guidance.
;;;
;;; RULE FORMAT:
;;;   IF (phase diagnose) AND (symptom X present yes) AND ...
;;;   THEN assert (diagnosis ...)
;;;
;;; Multiple rules can fire for the same disease (different patterns).
;;; The output section handles ranking by confidence.
;;; ============================================================

;;; ── MALARIA ──────────────────────────────────────────────────

(defrule dx-malaria-R1
  "R1: Classic malaria triad — fever, chills, sweating."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name fever)    (present yes))
  (symptom (name chills)   (present yes))
  (symptom (name sweating) (present yes))
  =>
  (assert (diagnosis
    (disease    "Malaria")
    (confidence 85)
    (urgency    high)
    (matched-rule "R1: Fever + Chills + Sweating (classic malaria triad)")
    (treatment  "Order Malaria RDT. If positive, administer ACT (Artemether-Lumefantrine). Ensure adequate oral hydration.")
    (referral   "Refer immediately if RDT is negative but strong clinical suspicion remains, or if signs of cerebral malaria appear (altered consciousness, seizures).")
    (lab-tests  "Malaria RDT | Blood smear (thick and thin) | Full Blood Count (FBC)")
  ))
  (printout t "  [Rule R1 fired] -> Malaria suggested (85%)" crlf)
)

(defrule dx-malaria-R2
  "R2: Fever with headache and muscle pain — common P. falciparum presentation."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name fever)       (present yes))
  (symptom (name headache)    (present yes))
  (symptom (name muscle-pain) (present yes))
  =>
  (assert (diagnosis
    (disease    "Malaria")
    (confidence 70)
    (urgency    high)
    (matched-rule "R2: Fever + Headache + Muscle Pain")
    (treatment  "Order Malaria RDT. If positive, administer ACT (Artemether-Lumefantrine). Ensure adequate oral hydration.")
    (referral   "Refer if RDT negative with strong suspicion or if patient deteriorates.")
    (lab-tests  "Malaria RDT | Blood smear (thick and thin) | Full Blood Count (FBC)")
  ))
  (printout t "  [Rule R2 fired] -> Malaria suggested (70%)" crlf)
)

(defrule dx-malaria-R3
  "R3: High fever with nausea and fatigue."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name high-fever) (present yes))
  (symptom (name nausea)     (present yes))
  (symptom (name fatigue)    (present yes))
  =>
  (assert (diagnosis
    (disease    "Malaria")
    (confidence 65)
    (urgency    high)
    (matched-rule "R3: High Fever + Nausea + Fatigue")
    (treatment  "Order Malaria RDT. If positive, administer ACT (Artemether-Lumefantrine).")
    (referral   "Refer if RDT negative with strong clinical suspicion.")
    (lab-tests  "Malaria RDT | Blood smear | FBC")
  ))
  (printout t "  [Rule R3 fired] -> Malaria suggested (65%)" crlf)
)


;;; ── TYPHOID FEVER ────────────────────────────────────────────

(defrule dx-typhoid-R4
  "R4: Stepwise fever, headache, abdominal pain, constipation — classic typhoid."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name fever)         (present yes))
  (symptom (name headache)      (present yes))
  (symptom (name abdominal-pain)(present yes))
  (symptom (name constipation)  (present yes))
  =>
  (assert (diagnosis
    (disease    "Typhoid Fever")
    (confidence 88)
    (urgency    high)
    (matched-rule "R4: Fever + Headache + Abdominal Pain + Constipation (classic enteric fever)")
    (treatment  "Oral rehydration. Prescribe Ciprofloxacin or Azithromycin per local antibiogram. Monitor for complications.")
    (referral   "Refer for IV antibiotics if patient cannot tolerate oral medication, shows intestinal perforation signs, or deteriorates after 3 days.")
    (lab-tests  "Widal Test | Blood Culture (gold standard) | Full Blood Count | Stool Culture")
  ))
  (printout t "  [Rule R4 fired] -> Typhoid Fever suggested (88%)" crlf)
)

(defrule dx-typhoid-R5
  "R5: Fever with abdominal pain and diarrhoea — enteric fever variant."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name fever)         (present yes))
  (symptom (name abdominal-pain)(present yes))
  (symptom (name diarrhea)      (present yes))
  =>
  (assert (diagnosis
    (disease    "Typhoid Fever")
    (confidence 70)
    (urgency    high)
    (matched-rule "R5: Fever + Abdominal Pain + Diarrhoea")
    (treatment  "Oral rehydration and antibiotics as per antibiogram.")
    (referral   "Refer if unable to tolerate oral fluids or if systemic signs worsen.")
    (lab-tests  "Widal Test | Blood Culture | Full Blood Count")
  ))
  (printout t "  [Rule R5 fired] -> Typhoid Fever suggested (70%)" crlf)
)


;;; ── DENGUE FEVER ─────────────────────────────────────────────

(defrule dx-dengue-R6
  "R6: Dengue triad — sudden fever, rash, severe joint pain."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name fever)      (present yes))
  (symptom (name rash)       (present yes))
  (symptom (name joint-pain) (present yes))
  =>
  (assert (diagnosis
    (disease    "Dengue Fever")
    (confidence 87)
    (urgency    high)
    (matched-rule "R6: Fever + Rash + Joint Pain (dengue triad)")
    (treatment  "Supportive care ONLY: rest, fluids, Paracetamol. AVOID Aspirin and NSAIDs — bleeding risk.")
    (referral   "Refer urgently if platelet count dropping, bleeding signs present, or haemodynamic instability.")
    (lab-tests  "NS1 Antigen Test | Dengue IgM/IgG | Full Blood Count | Platelet Count")
  ))
  (printout t "  [Rule R6 fired] -> Dengue Fever suggested (87%)" crlf)
)

(defrule dx-dengue-R7
  "R7: Fever with muscle pain, headache — breakbone fever pattern."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name fever)       (present yes))
  (symptom (name muscle-pain) (present yes))
  (symptom (name headache)    (present yes))
  (symptom (name nausea)      (present yes))
  =>
  (assert (diagnosis
    (disease    "Dengue Fever")
    (confidence 75)
    (urgency    high)
    (matched-rule "R7: Fever + Muscle Pain + Headache + Nausea")
    (treatment  "Supportive care: rest, oral fluids, Paracetamol. AVOID Aspirin and NSAIDs.")
    (referral   "Refer if bleeding signs, falling platelet count, or haemodynamic instability.")
    (lab-tests  "NS1 Antigen | Dengue IgM/IgG | FBC | Platelet Count")
  ))
  (printout t "  [Rule R7 fired] -> Dengue Fever suggested (75%)" crlf)
)


;;; ── PNEUMONIA ────────────────────────────────────────────────

(defrule dx-pneumonia-R8
  "R8: Classic pneumonia — fever, productive cough, chest pain, dyspnoea."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name fever)               (present yes))
  (symptom (name cough)               (present yes))
  (symptom (name chest-pain)          (present yes))
  (symptom (name difficulty-breathing)(present yes))
  =>
  (assert (diagnosis
    (disease    "Pneumonia")
    (confidence 91)
    (urgency    high)
    (matched-rule "R8: Fever + Productive Cough + Chest Pain + Difficulty Breathing")
    (treatment  "Prescribe Amoxicillin (first line) or Azithromycin. Ensure oxygenation. Encourage oral fluids.")
    (referral   "Refer for oxygen therapy or IV antibiotics if O2 saturation below 94% or condition worsens.")
    (lab-tests  "Chest X-Ray | Sputum Culture and Sensitivity | Full Blood Count | CRP")
  ))
  (printout t "  [Rule R8 fired] -> Pneumonia suggested (91%)" crlf)
)

(defrule dx-pneumonia-R9
  "R9: Fever with cough and difficulty breathing."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name fever)               (present yes))
  (symptom (name cough)               (present yes))
  (symptom (name difficulty-breathing)(present yes))
  =>
  (assert (diagnosis
    (disease    "Pneumonia")
    (confidence 75)
    (urgency    high)
    (matched-rule "R9: Fever + Cough + Difficulty Breathing")
    (treatment  "Prescribe appropriate antibiotic. Monitor oxygen saturation. Encourage fluids.")
    (referral   "Refer if O2 saturation below 94% or patient unable to manage at home.")
    (lab-tests  "Chest X-Ray | Full Blood Count | CRP")
  ))
  (printout t "  [Rule R9 fired] -> Pneumonia suggested (75%)" crlf)
)


;;; ── URINARY TRACT INFECTION (UTI) ────────────────────────────

(defrule dx-uti-R10
  "R10: Classic UTI triad — dysuria, frequency, suprapubic pain."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name painful-urination)(present yes))
  (symptom (name abdominal-pain)   (present yes))
  =>
  (assert (diagnosis
    (disease    "Urinary Tract Infection (UTI)")
    (confidence 88)
    (urgency    medium)
    (matched-rule "R10: Painful Urination + Lower Abdominal/Suprapubic Pain")
    (treatment  "Prescribe Nitrofurantoin or Trimethoprim for 5-7 days. Encourage increased fluid intake.")
    (referral   "Refer if fever present (pyelonephritis suspected), or if patient is pregnant, elderly, or immunocompromised.")
    (lab-tests  "Urine Dipstick | Midstream Urine (MSU) Culture and Sensitivity | Urine Microscopy")
  ))
  (printout t "  [Rule R10 fired] -> UTI suggested (88%)" crlf)
)

(defrule dx-uti-R11
  "R11: Dysuria with fever — possible pyelonephritis."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name painful-urination)(present yes))
  (symptom (name fever)            (present yes))
  =>
  (assert (diagnosis
    (disease    "Urinary Tract Infection (UTI) / Pyelonephritis")
    (confidence 80)
    (urgency    high)
    (matched-rule "R11: Painful Urination + Fever (ascending infection suspected)")
    (treatment  "Antibiotics: Ciprofloxacin or Co-amoxiclav. Consider IV route if systemic signs present.")
    (referral   "Refer for IV antibiotics and further imaging if pyelonephritis confirmed or suspected.")
    (lab-tests  "Urine MSU Culture | Urine Dipstick | FBC | Renal Function Tests | Renal Ultrasound")
  ))
  (printout t "  [Rule R11 fired] -> UTI/Pyelonephritis suggested (80%)" crlf)
)


;;; ── GASTROENTERITIS ──────────────────────────────────────────

(defrule dx-gastro-R12
  "R12: Acute gastroenteritis — nausea, vomiting, diarrhoea, cramps."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name nausea)        (present yes))
  (symptom (name vomiting)      (present yes))
  (symptom (name diarrhea)      (present yes))
  (symptom (name abdominal-pain)(present yes))
  =>
  (assert (diagnosis
    (disease    "Acute Gastroenteritis")
    (confidence 90)
    (urgency    medium)
    (matched-rule "R12: Nausea + Vomiting + Diarrhoea + Abdominal Pain")
    (treatment  "Oral Rehydration Solution (ORS). Zinc supplementation for children under 5. Antibiotics only if bacterial cause confirmed.")
    (referral   "Refer if severe dehydration, unable to retain fluids, or bloody diarrhoea is present.")
    (lab-tests  "Stool Microscopy Culture and Sensitivity | FBC | Electrolytes (U and E)")
  ))
  (printout t "  [Rule R12 fired] -> Acute Gastroenteritis suggested (90%)" crlf)
)

(defrule dx-gastro-R13
  "R13: Febrile gastroenteritis — vomiting, diarrhoea, fever."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name vomiting) (present yes))
  (symptom (name diarrhea) (present yes))
  (symptom (name fever)    (present yes))
  =>
  (assert (diagnosis
    (disease    "Acute Gastroenteritis")
    (confidence 75)
    (urgency    medium)
    (matched-rule "R13: Vomiting + Diarrhoea + Fever (febrile gastroenteritis)")
    (treatment  "ORS. Consider antibiotics if Salmonella or Shigella suspected.")
    (referral   "Refer if unable to retain oral fluids or dehydration is severe.")
    (lab-tests  "Stool MCS | FBC | Electrolytes")
  ))
  (printout t "  [Rule R13 fired] -> Acute Gastroenteritis suggested (75%)" crlf)
)


;;; ── MENINGITIS ───────────────────────────────────────────────

(defrule dx-meningitis-R14
  "R14: CRITICAL — Meningeal triad: fever, severe headache, neck stiffness."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name fever)          (present yes))
  (symptom (name severe-headache)(present yes))
  (symptom (name neck-stiffness) (present yes))
  =>
  (assert (diagnosis
    (disease    "Meningitis")
    (confidence 94)
    (urgency    critical)
    (matched-rule "R14: Fever + Severe Headache + Neck Stiffness — EMERGENCY")
    (treatment  "EMERGENCY: Administer IV Ceftriaxone IMMEDIATELY. Add Dexamethasone if available. Secure IV access.")
    (referral   "IMMEDIATE HOSPITAL REFERRAL — this is a medical emergency. Do not delay.")
    (lab-tests  "Lumbar Puncture (CSF Analysis) | Blood Culture | CT Scan (before LP) | FBC | CRP/ESR")
  ))
  (printout t "  [Rule R14 fired] -> *** MENINGITIS EMERGENCY *** (94%)" crlf)
)

(defrule dx-meningitis-R15
  "R15: Fever + neck stiffness + vomiting."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name fever)         (present yes))
  (symptom (name neck-stiffness)(present yes))
  (symptom (name vomiting)      (present yes))
  =>
  (assert (diagnosis
    (disease    "Meningitis")
    (confidence 88)
    (urgency    critical)
    (matched-rule "R15: Fever + Neck Stiffness + Vomiting")
    (treatment  "EMERGENCY: IV Ceftriaxone immediately. Do not wait for LP results to start antibiotics.")
    (referral   "IMMEDIATE HOSPITAL REFERRAL — medical emergency.")
    (lab-tests  "Lumbar Puncture | Blood Culture | FBC | CRP")
  ))
  (printout t "  [Rule R15 fired] -> *** MENINGITIS EMERGENCY *** (88%)" crlf)
)


;;; ── COMMON COLD / UPPER RESPIRATORY TRACT INFECTION ─────────

(defrule dx-cold-R16
  "R16: Viral URTI — cough, fatigue, fever (mild)."
  (declare (salience 10))
  (phase (current diagnose))
  (symptom (name cough)   (present yes))
  (symptom (name fatigue) (present yes))
  (symptom (name fever)   (present yes))
  (symptom (name headache)(present yes))
  =>
  (assert (diagnosis
    (disease    "Upper Respiratory Tract Infection (Common Cold / Flu)")
    (confidence 72)
    (urgency    low)
    (matched-rule "R16: Cough + Fatigue + Fever + Headache (viral URTI)")
    (treatment  "Supportive: rest, adequate fluids, Paracetamol for fever/pain. Antibiotics NOT indicated for viral URTI.")
    (referral   "Refer if symptoms persist beyond 10 days, worsen significantly, or secondary bacterial infection is suspected.")
    (lab-tests  "Clinical diagnosis. No routine lab tests required. Consider throat swab if bacterial tonsillitis suspected.")
  ))
  (printout t "  [Rule R16 fired] -> URTI/Cold suggested (72%)" crlf)
)
