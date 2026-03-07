# MedExpertSystem

**A rule-based Medical Expert System for primary diagnosis in low-resource clinics.**
Built in CLIPS 6.30 (C Language Integrated Production System) as part of an Expert Systems university assignment.

---

## What It Does

The system assists healthcare workers by asking 20 yes/no symptom questions and applying
IF-THEN medical rules to suggest possible diagnoses — complete with confidence scores,
urgency levels, treatment recommendations, referral criteria, and lab tests to order.

- **8 diseases** covered (Malaria, Typhoid, Dengue, Pneumonia, UTI, Gastroenteritis, Meningitis, URTI)
- **16 IF-THEN diagnostic rules** in the knowledge base
- **20 clinical symptoms** assessed per consultation
- **4 urgency levels**: CRITICAL / HIGH / MEDIUM / LOW
- Works **100% offline** — no internet required
- Runs on any **low-cost Linux/Windows/Mac** machine with CLIPS installed

---

## Project Structure

```
MedExpertSystem/
├── templates.clp       — Data structures (deftemplate definitions) — load 1st
├── knowledge_base.clp  — All IF-THEN rules (symptom asking + diagnosis) — load 2nd
├── functions.clp       — Output helpers and display rules — load 3rd
├── main.clp            — System metadata and startup rule — load 4th
└── README.md           — This file
```

---

## Requirements

- **CLIPS 6.30** installed
- Linux (Pop!_OS / Ubuntu): `sudo apt install clips`
- Windows/Mac: download from https://www.clipsrules.net

---

## How to Run

**1. Navigate to the project folder:**
```bash
cd ~/ClipsProjects/MedExpertSystem
```

**2. Launch CLIPS:**
```bash
clips
```

**3. Load the files in order at the CLIPS prompt:**
```
CLIPS> (load "templates.clp")
CLIPS> (load "knowledge_base.clp")
CLIPS> (load "functions.clp")
CLIPS> (load "main.clp")
```

**4. Start a consultation:**
```
CLIPS> (reset)
CLIPS> (run)
```

**5. Follow the prompts** — enter patient name/age/sex, then answer 20 Y/N symptom questions.

**6. New patient (no need to reload files):**
```
CLIPS> (reset)
CLIPS> (run)
```

**7. Quit:**
```
CLIPS> (exit)
```

---

## Example Output

```
--- RUNNING INFERENCE ENGINE ---

  [Rule R6 fired] -> Dengue Fever suggested (87%)
  [Rule R2 fired] -> Malaria suggested (70%)

============================================================
  Disease   : Dengue Fever
  Confidence: [########..] 87%
  Urgency:    HIGH — Urgent clinical attention required
  Rule Fired: R6: Fever + Rash + Joint Pain (dengue triad)
------------------------------------------------------------
  TREATMENT : Supportive ONLY: rest, fluids, Paracetamol.
              AVOID Aspirin and NSAIDs (bleeding risk).
------------------------------------------------------------
  REFERRAL  : Refer urgently if platelet count dropping,
              bleeding signs present, or haemodynamic instability.
------------------------------------------------------------
  LAB TESTS : NS1 Antigen Test | Dengue IgM/IgG | FBC | Platelet Count
```

---

## Diseases and Rules

| Rule | Disease            | Key Symptoms                               | Confidence | Urgency  |
|------|--------------------|--------------------------------------------|------------|----------|
| R1   | Malaria            | Fever + Chills + Sweating                  | 85%        | HIGH     |
| R2   | Malaria            | Fever + Headache + Muscle Pain             | 70%        | HIGH     |
| R3   | Malaria            | High Fever + Nausea + Fatigue              | 65%        | HIGH     |
| R4   | Typhoid Fever      | Fever + Headache + Abdominal Pain + Constipation | 88%  | HIGH     |
| R5   | Typhoid Fever      | Fever + Abdominal Pain + Diarrhoea         | 70%        | HIGH     |
| R6   | Dengue Fever       | Fever + Rash + Joint Pain                  | 87%        | HIGH     |
| R7   | Dengue Fever       | Fever + Muscle Pain + Headache + Nausea    | 75%        | HIGH     |
| R8   | Pneumonia          | Fever + Cough + Chest Pain + Dyspnoea      | 91%        | HIGH     |
| R9   | Pneumonia          | Fever + Cough + Difficulty Breathing       | 75%        | HIGH     |
| R10  | UTI                | Painful Urination + Abdominal Pain         | 88%        | MEDIUM   |
| R11  | UTI/Pyelonephritis | Painful Urination + Fever                  | 80%        | HIGH     |
| R12  | Gastroenteritis    | Nausea + Vomiting + Diarrhoea + Abd. Pain  | 90%        | MEDIUM   |
| R13  | Gastroenteritis    | Vomiting + Diarrhoea + Fever               | 75%        | MEDIUM   |
| R14  | Meningitis         | Fever + Severe Headache + Neck Stiffness   | 94%        | CRITICAL |
| R15  | Meningitis         | Fever + Neck Stiffness + Vomiting          | 88%        | CRITICAL |
| R16  | URTI / Cold        | Cough + Fatigue + Fever + Headache         | 72%        | LOW      |

---

## Architecture

```
Execution Flow:
startup → gather-patient → gather-symptoms → diagnose → output → done

Salience Hierarchy:
  200  system-loaded (startup banner)
  100  phase-start
   95  collect-patient-info
   50  ask-symptom rules (x20)
   40  phase-symptoms-to-diagnose
   10  dx-disease-RN diagnostic rules (x16)
    5  output-footer
   -5  phase-diagnose-to-output
```

---

## Disclaimer

This system is a decision **support** tool only.
It does not replace the clinical judgement of a qualified healthcare professional.
All diagnoses are suggestions based on encoded rules and must be verified by a clinician.

---



