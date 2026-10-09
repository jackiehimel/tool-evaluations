# Customer-shaped task — Sleepy Hollow MVP vertical slice

**Target scenario:** Harmony Hills University (fictional institution) — Student Success / Retention  
**Primary user:** Lauren Dukes, Retention & Student Support Coach  
**Target student:** Jordan Ellis (BSN Program, Year 2)  
**Task definition:** Standardized customer-shaped benchmark task for testing turnkey prototype generation. Paste the description block below verbatim into the tool under test.

---

> Build a working vertical-slice prototype for Sleepy Hollow (a governed relationship-progress platform for student retention).
> 
> Prove the core product grammar:
> `Signal → Condition → Opportunity Card → Recommendation / Why Drawer → AI Draft Review Modal → Pending Outcome`.
> 
> ### Requirements:
> 1. **Data Models & Seed Data:**
>    - Institution: Harmony Hills University.
>    - Advisor: Lauren Dukes (Retention & Student Support Coach).
>    - Student: Jordan Ellis (Bachelor of Science in Nursing, College of Health Sciences).
>    - Simulated Signals:
>      - Missed 2 of the last 3 live class sessions in Anatomy & Physiology.
>      - 2 assignments overdue (Lab 3 & Quiz 4).
>      - Current grade in Anatomy & Physiology dropped below the BSN progression threshold (B-).
>    - Opportunity:
>      - Type: "Academic Risk Emerging"
>      - Priority: "High / Act This Week"
>      - Headline: "Jordan's attendance dipped, two assignments are late, and grade is below BSN progression threshold."
> 
> 2. **Advisor Command Center UI:**
>    - Header showing institution ("Harmony Hills University") and logged-in user ("Lauren Dukes").
>    - Opportunity stream displaying Jordan Ellis's card with proof chips (`2 Missed Sessions`, `2 Overdue`, `Grade below B-`).
> 
> 3. **Explainability ("Why?") Drawer:**
>    - Clicking "Why" explains the contributing signals and cites the governing rule:
>      *"BSN Program Rule: Anatomy & Physiology requires B- minimum for clinical placement."*
> 
> 4. **AI Draft Review Modal:**
>    - Pre-filled supportive outreach email to Jordan Ellis.
>    - **Safety/Review Gate:** The "Send" button MUST be disabled until the advisor checks a confirmation box: *"I have reviewed this draft for tone and accuracy"*.
>    - Clicking "Send" marks the card as `"Pending Outcome"` (watching for assignment submission or call scheduled within 3 business days) and shows a confirmation toast.

---

## Acceptance criteria
- Application builds and runs cleanly via a single start command.
- Seed data for Jordan Ellis loads automatically.
- Advisor Command Center displays the opportunity card with all proof chips.
- "Why?" drawer clearly presents signal evidence and rule provenance.
- Human review gate prevents sending until explicitly confirmed.
- Sending transitions the opportunity to "Pending Outcome".
- Zero unmeasured time estimates. All actions logged with timestamps.
