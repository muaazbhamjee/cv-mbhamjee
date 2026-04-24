#!/usr/bin/env bash
# NRF Rating Application 2027 — Issue Creation Script
# Run from inside the cv-mbhamjee repo directory:
#   bash create_issues.sh
#
# Prerequisites: gh auth status should show 'project' in scopes.
# Labels and milestones must already exist (you've done this).

REPO="muaazbhamjee/cv-mbhamjee"

echo "==> Creating issues for $REPO"
echo ""

create_issue() {
  local title="$1"
  local body="$2"
  local labels="$3"
  local milestone="$4"
  local num
  num=$(gh issue create \
    --title "$title" \
    --body "$body" \
    --label "$labels" \
    --milestone "$milestone" \
    --repo "$REPO" \
    --json number --jq '.number')
  echo "  #$num — $title"
}

# ── M0: Planning & kickoff ────────────────────────────────────────────────────
echo "── M0: Planning & kickoff ──────────────────────────────────────────────"

create_issue \
  "[ADMIN] Set up GitHub Project Kanban board for NRF 2027 application" \
  "## Goal
Configure project #3 at https://github.com/users/muaazbhamjee/projects/3

## Done when
- [ ] Five status columns configured: 📥 Backlog | 🔜 This Session | 🔄 In Progress | 🔍 Needs Review | ✅ Done
- [ ] Sprint text field added
- [ ] NRF Section text field added
- [ ] All issues added to board
- [ ] First triage done (This Session vs Backlog)" \
  "area:admin,priority:critical" \
  "M0: Planning & kickoff"

create_issue \
  "[ADMIN] Confirm UP internal NRF deadline for 2027 call" \
  "## Goal
The 2026 UP guide gives 15 Jan 2026 as the internal deadline.
Confirm the equivalent date for the 2027 call.

## Contacts
- Ms. Nyiko Shingange: nyiko.shingange@up.ac.za / 012 420 5846
- Mr. Abe Mathopa: abe.mathopa@up.ac.za / 012 420 2158

## Done when
- [ ] Deadline confirmed in writing
- [ ] Date added as note to M6 milestone" \
  "area:admin,priority:critical" \
  "M0: Planning & kickoff"

create_issue \
  "[ADMIN] Commit annotated application draft and setup scripts to repo" \
  "## Goal
All NRF working files live in nrf-2027/ for version control.

## Done when
- [ ] nrf-2027/NRF_Application_2027_Annotated.docx committed
- [ ] nrf-2027/create_issues.md committed
- [ ] nrf-2027/create_issues.sh committed
- [ ] git push confirmed" \
  "area:admin,priority:normal" \
  "M0: Planning & kickoff"

create_issue \
  "[ADMIN] Log into NRF Connect and audit current CV state" \
  "## Steps
- [ ] Log in at nrfconnect.nrf.ac.za
- [ ] Sync ORCID (click Sync now)
- [ ] Check Publications — note what is present vs. missing
- [ ] Check Supervision — note which students are captured
- [ ] Check Career History — verify IBM/UJ/UP timeline is correct
- [ ] Capture findings as a comment on this issue" \
  "area:cv-nrf,priority:critical" \
  "M0: Planning & kickoff"

# ── M1: External actions initiated ───────────────────────────────────────────
echo "── M1: External actions initiated ─────────────────────────────────────"

create_issue \
  "[EXTERNAL] Request bibliometrics report from UP librarian Lathola Mchunu" \
  "## Contact
Lathola Mchunu: lathola.mchunu@up.ac.za

## Request content
1. Scopus and WoS citation counts for each Best Output DOI
2. Confirmed Scopus h-index and WoS h-index with draw date

## DOIs
- 10.1016/j.compfluid.2024.106242 (Computers & Fluids 2024)
- 10.1016/j.bspc.2025.110018 (BSPC 2026)
- 10.1016/j.solener.2019.11.058 (Solar Energy 2020)
- 10.1016/j.enbuild.2012.10.041 (Energy and Buildings 2013)
- 10.3390/mca27060088 (MCA 2022)

## Done when
- [ ] Email sent
- [ ] Report received
- [ ] Citation counts entered into annotated application draft" \
  "area:external,priority:critical" \
  "M1: External actions initiated"

create_issue \
  "[EXTERNAL] Request formal ATLAS contribution letter from Prof. S.H. Connell" \
  "## Goal
Letter confirming: UP Institutional Representative and Team Leader title, ITk monitoring contributions, AQT supervision.

## Contact
Prof. Simon H. Connell: shconnell@uj.ac.za | +27 82 945 7508

## Done when
- [ ] Email sent (request 2-week turnaround)
- [ ] Letter received
- [ ] Letter uploaded as attachment in NRF Connect
- [ ] Reference to letter added in Outputs 1 and 2 contribution statements" \
  "area:external,priority:critical" \
  "M1: External actions initiated"

create_issue \
  "[EXTERNAL] Confirm NITheCS Fellowship application status" \
  "## Options
- Pending: insert 'He has applied for a NITheCS Fellowship to support quantum computing research at UP.'
- Awarded: insert 'He holds a NITheCS Fellowship, supporting quantum computing and SciML research at UP.'
- Not applied: remove placeholder entirely.

## Done when
- [ ] Status confirmed
- [ ] Section A placeholder updated
- [ ] Section H placeholder updated" \
  "area:external,priority:high" \
  "M1: External actions initiated"

create_issue \
  "[EXTERNAL] Check InspireHEP citation counts for ATLAS Best-5 outputs" \
  "## Papers to check at https://inspirehep.net
1. Nature 2024 — DOI 10.1038/s41586-024-07824-z
2. Physics Reports 2025 — DOI 10.1016/j.physrep.2024.09.004

## Done when
- [ ] Citation count and date recorded for each
- [ ] Counts added to Output 1 and Output 2 motivation paragraphs" \
  "area:application,priority:high" \
  "M1: External actions initiated"

create_issue \
  "[EXTERNAL] Identify and confirm 6-8 reviewer names for Section I" \
  "## Required profiles
1. Prof. in Multiphase CFD / LBM — international
2. Prof. in Computational Biofluid Mechanics — international
3. Prof. in Experimental HEP — NOT an ATLAS co-author
4. Prof. in Mechanical/Thermal Engineering — SA (UCT, Stellenbosch, or Wits)
5. Prof. in Physics — SA, active in SA-CERN, NOT an ATLAS co-author
6. Prof./Senior Researcher at CSIR or SAMRC — computational science
7. (Optional) LBM specialist — Europe or North America
8. (Optional) Computational biomechanics — check Ngoepe (UCT) for conflict

## For each candidate
- [ ] Name, email, current institution confirmed
- [ ] NOT a co-author in last 5 years (ATLAS papers count)
- [ ] NOT from UP Mechanical & Aeronautical Engineering
- [ ] Associate Professor level or above
- [ ] Max one reviewer per institution" \
  "area:external,priority:critical" \
  "M4: Reviewers confirmed"

# ── M2: NRF Connect CV complete ───────────────────────────────────────────────
echo "── M2: NRF Connect CV complete ─────────────────────────────────────────"

create_issue \
  "[CV-NRF] Correct career history in NRF Connect (IBM / UJ SRA / UP timeline)" \
  "## Correct timeline
- Hatch Africa (CFD Analyst): 2008–2009
- UJ (Lecturer to Senior Lecturer): Jan 2015 – Jan 2023
- IBM Research Africa (Staff Research Scientist): Feb 2023 – Dec 2024
- UJ (Visiting SRA, adjunct, concurrent with IBM): Jul 2023 – Dec 2024
- UP (Associate Professor): Jan 2025 – present

## Done when
- [ ] All entries corrected in NRF Connect Career History
- [ ] Screenshot saved for records" \
  "area:cv-nrf,priority:critical" \
  "M2: NRF Connect CV complete"

create_issue \
  "[CV-NRF] Enter all review-period journal publications (2019–2026) in NRF Connect" \
  "## Papers to enter
- Makhanya & Bhamjee et al. (2026) BSPC — DOI 10.1016/j.bspc.2025.110018
- Ralijaona, Igumbor, Bhamjee et al. (2024) Computers & Fluids — DOI 10.1016/j.compfluid.2024.106242
- Mokoena, Bhamjee et al. (2023) R&D Journal SAIMechE vol.39
- Makhanya, Connell, Bhamjee et al. (2023) MCA vol.28(3) — DOI 10.3390/mca28030064
- Bhamjee, Connell, Nel (2022) MCA vol.27(6) — DOI 10.3390/mca27060088
- Potgieter, Bhamjee, Kruger (2021) R&D Journal SAIMechE vol.37
- Potgieter, Bester, Bhamjee (2020) Solar Energy — DOI 10.1016/j.solener.2019.11.058

## For each
- [ ] DOI auto-import where available
- [ ] Verify author order, volume, pages
- [ ] Confirm Scopus Q1 classification
- [ ] Mark own contribution percentage" \
  "area:cv-nrf,priority:critical" \
  "M2: NRF Connect CV complete"

create_issue \
  "[CV-NRF] Enter pre-2019 best outputs (Section E) in NRF Connect — target 8-10" \
  "## To enter
1. Bhamjee, Nurick, Madyira (2013) Energy and Buildings vol.57 — already listed
2. ATLAS Collaboration (2018) Phys. Lett. B vol.787 pp.68-88 (WZ resonance search)
3-6. 3-4 representative ATLAS pre-2019 papers — confirm selection with Prof. Connell
7. Hydrocyclone papers from 2017-2018 if in peer-reviewed journals
8. UJ NRF Thuthuka outputs from 2017-2019

## Done when
- [ ] 8-10 entries selected in NRF Connect Section E" \
  "area:cv-nrf,priority:high" \
  "M2: NRF Connect CV complete"

create_issue \
  "[CV-NRF] Enter all postgraduate supervision records in NRF Connect" \
  "## MEng completions (graduated)
- T. Jooma Abbajee (2026, UJ, co-sup)
- K.M. Makhanya (2025, UJ, co-sup)
- T.F. Mokoena (2022, UJ, main sup)
- T. Ramokoka (2022, UJ, main sup)
- T.B. Molale (2021, UJ, co-sup)
- A. Potgieter (2020, UJ, Cum Laude, main sup)
- D.M. Chirnside (2019, UJ, main sup)
- S.A.T. Tina (2017, UJ, Cum Laude, co-sup)
- M.S.W. Potgieter (2016, UJ, Cum Laude, co-sup)

## Ongoing at UP
- A.Y. Akinbowale, M. Ramokali, M. Takoutchouang, M.S.W. Potgieter, A. Essop (all PhD)
- T. Jooma Abbajee, M.P. Connell (PhD, UJ, co-sup)
- M. Maila, B. Kazembe, M.Y. Rasool (MEng)

## For each student
- [ ] Citizenship, study level, degree, thesis title, dates, role, status entered" \
  "area:cv-nrf,priority:high" \
  "M2: NRF Connect CV complete"

create_issue \
  "[CV-NRF] Enter grants, patents, and keynotes in NRF Connect" \
  "## Grants
- 2025 UP RDP: R50,000
- 2022 UJ URC Equipment: R284,517
- 2021 UJ GES COVID-19: R80,000
- 2020-2021 ESRF: EUR 8,750
- 2017-2019 NRF Thuthuka Post-PhD: R602,000

## Patents
- ZA2023/09448 (granted 30 Jul 2024)
- US18/200,050 (pending)

## Keynotes (under Keynote and Plenary Addresses — NOT Other conference outputs)
- CHPC 2017 — Keynote: Modelling of Multiphase Flow in Process Equipment
- CHPC 2025 — Invited talk: Entangled Worlds

## Done when
- [ ] All grants, patents, and keynotes entered in correct NRF Connect sections" \
  "area:cv-nrf,priority:high" \
  "M2: NRF Connect CV complete"

create_issue \
  "[CV-UP] Update UP CV with corrected timeline and new outputs" \
  "## Changes required
- [ ] Employment dates corrected: IBM Feb 2023-Dec 2024; UJ SRA Jul 2023-Dec 2024; UP Jan 2025-present
- [ ] Add SAIP 2025 papers (Abbajee/RC and Cassim/Greenhouse)
- [ ] Add IEEE IGARSS 2025 paper
- [ ] Add CERG-FLUX Lab founding (2026) under Research Lab Leadership
- [ ] Add MKM411 SciML notebooks and PINN heat transfer under Other Scholarly Contributions
- [ ] Update h-indices: GS 63, Scopus 31, WoS 27 (April 2026)
- [ ] Confirm Kruger2026 LOC membership is listed" \
  "area:cv-up,priority:high" \
  "M2: NRF Connect CV complete"

# ── M3: Narrative sections drafted ───────────────────────────────────────────
echo "── M3: Narrative sections drafted ──────────────────────────────────────"

create_issue \
  "[APP-A] Finalise Section A — Career Profile Narrative" \
  "## Checklist
- [ ] Opening sentence names UP Institutional Representative and Team Leader role explicitly
- [ ] IBM dates: Feb 2023-Dec 2024
- [ ] UJ SRA role (Jul 2023-Dec 2024) mentioned as concurrent/adjunct
- [ ] NITheCS Fellowship sentence inserted (from NITheCS status issue)
- [ ] ESRF international grant mentioned
- [ ] IUTAM Vice-Presidency named as peer recognition
- [ ] CHPC keynote (2017) and invited talk (2025) mentioned
- [ ] Character count verified <= 5,500
- [ ] No bullet points — pure narrative prose
- [ ] Text copied into NRF Connect" \
  "area:application,priority:high" \
  "M3: Narrative sections drafted"

create_issue \
  "[APP-C] Decide Best-5 Output 5 — keep Solar Energy (2020) or substitute" \
  "## Decision required
Current Output 5 = Solar Energy (2020), where you are 3rd author.

## Option A: Keep Solar Energy (2020)
- Pro: Q1, IF 5.742, establishes sustainability from start of review window
- Con: 3rd author; weak independence signal

## Option B: Replace with MCA 2022 (Cyclonic Flow — Bhamjee M. first author)
- Pro: first author on core LBM topic; stronger independence
- Con: lower journal prestige (MDPI vs Elsevier)

## Option C: Replace with Mokoena et al. (2023) R&D Journal SAIMechE (BEATS detector)
- Pro: connects CFD expertise to ATLAS
- Con: still not first author

## Steps
- [ ] Check Scopus citation count for Solar Energy 2020 (from librarian report)
- [ ] Confirm author order for MCA 2022 paper
- [ ] Make decision — record as comment on this issue
- [ ] Update annotated application draft accordingly" \
  "area:strategy,priority:high" \
  "M3: Narrative sections drafted"

create_issue \
  "[APP-C] Add citation counts to all Best-5 output motivation paragraphs" \
  "## Format
'X citations (Scopus, April 2026)' or 'X citations (InspireHEP, April 2026)'

## Outputs needing counts
- [ ] Output 1 (Nature 2024): InspireHEP count
- [ ] Output 2 (Physics Reports 2025): InspireHEP count
- [ ] Output 3 (Computers & Fluids 2024): Scopus from librarian
- [ ] Output 4 (BSPC 2026): Scopus — may be low; frame around recency
- [ ] Output 5 (Solar Energy 2020 or substitute): Scopus from librarian" \
  "area:application,priority:high" \
  "M3: Narrative sections drafted"

create_issue \
  "[APP-C] Strengthen ATLAS contribution statements for Outputs 1 and 2" \
  "## For both outputs
- [ ] Name formal title: 'as UP Institutional Representative and Team Leader'
- [ ] State specific work: ITk environmental monitoring, AQT supervision
- [ ] Add reference to formal ATLAS contribution letter attachment
- [ ] State InspireHEP citation count

## Done when
- [ ] Both contribution statements revised and entered in NRF Connect" \
  "area:application,priority:critical" \
  "M3: Narrative sections drafted"

create_issue \
  "[APP-C] Clarify first-author vs lead-researcher for Output 3 (Computers & Fluids)" \
  "## Issue
Ralijaona M. is first author but you claim lead researcher and corresponding author (~70%).

## Text to add
'First authorship was assigned to Ralijaona M. as the executing postgraduate candidate; corresponding authorship and intellectual leadership — including conceptualisation of the coupled CFD-UVGI-evaporation framework — remained with the applicant.'

## Done when
- [ ] Clarifying sentence added to Output 3 contribution statement
- [ ] Scopus citation count added
- [ ] Revised text entered in NRF Connect" \
  "area:application,priority:high" \
  "M3: Narrative sections drafted"

create_issue \
  "[APP-D] Populate Section D — Best student supervision outputs (target 4-5 entries)" \
  "## Currently: 2 entries. Target: 4-5.

## Add
1. Abbajee T.J. et al. (2025). Reservoir Computing. SAIP 2025, pp.1026-1031. [Co-sup, UJ]
2. Ramokoka T. & Bhamjee M. (2021). VP shunt modelling. SACAM2020. [Main sup]
3. Makhanya K.M. et al. (2023). CFD for lung acoustics. MCA vol.28(3). [Principal sup — conference version]
4. Connell M.P., Bhamjee M. et al. (2022). ATLAS ITk Environmental Monitoring. SAIP 2022. [ATLAS AQT sup]

## Decision
- [ ] Confirm whether Mokoena/BEATS paper (R&D Journal 2023) goes here
- [ ] Confirm whether BSPC 2026 stays in Best-5 or moves here

## Done when
- [ ] Minimum 4 entries with full references and role annotations
- [ ] No repeat of Section C outputs" \
  "area:application,priority:high" \
  "M3: Narrative sections drafted"

create_issue \
  "[APP-E] Populate Section E — pre-2019 outputs (target 8-10 entries)" \
  "## To add
- Physics Letters B (2018) WZ resonance search paper
- 3-4 representative ATLAS pre-2019 papers (confirm with Prof. Connell)
- Earlier hydrocyclone papers if in peer-reviewed journals
- DHET-accredited outputs from Thuthuka period (2017-2019)

## Done when
- [ ] 8-10 entries selected in NRF Connect Section E" \
  "area:application,priority:normal" \
  "M3: Narrative sections drafted"

create_issue \
  "[APP-F] Revise Section F — Completed Research narrative" \
  "## Updates
- [ ] Explicitly name UP Institutional Representative and Team Leader in ATLAS paragraph
- [ ] Move IEEE IGARSS 2025 and SAIP 2025 references here (published, not forthcoming)
- [ ] Add Reservoir Computing paper (SAIP 2025, Abbajee et al.)
- [ ] Add CHPC 2025 invited talk reference
- [ ] Character count check <= 11,000

## Done when
- [ ] All updates made and entered in NRF Connect Section F" \
  "area:application,priority:high" \
  "M3: Narrative sections drafted"

create_issue \
  "[APP-G] Finalise Section G — Self-Assessment" \
  "## Changes
- [ ] Update h-indices: GS 63, Scopus 31, WoS 27 (April 2026)
- [ ] Explain h-index spread (ATLAS inflation of GS counts)
- [ ] Insert citation counts for Outputs 3, 4, 5 (from librarian report)
- [ ] Replace 'I believe my research constitutes...' with 'My research constitutes...'
- [ ] Add IUTAM Vice-Presidency and CHPC keynote as peer recognition evidence
- [ ] Reference formal ATLAS letter for Outputs 1 and 2
- [ ] Character count check <= 5,500

## Done when
- [ ] All updates made and entered in NRF Connect Section G" \
  "area:application,priority:critical" \
  "M3: Narrative sections drafted"

create_issue \
  "[APP-H] Finalise Section H — Ongoing and Planned Future Research" \
  "## Changes
- [ ] REMOVE: IEEE IGARSS 2025 and SAIP 2025 (published — move to Section F)
- [ ] ADD: Physics of Fluids LBM-DEM manuscript status and target quarter
- [ ] ADD: ADSC 2026 abstract — Teaching Machines to Respect Physics
- [ ] ADD: NITheCS Fellowship sentence (once confirmed)
- [ ] ADD: Quantum postdoc recruitment status (once confirmed)
- [ ] ADD: DSI QuTI funding application status
- [ ] Make Programme 3 (quantum) concrete with specific actions
- [ ] Character count check <= 5,500

## Done when
- [ ] All changes made and entered in NRF Connect Section H" \
  "area:application,priority:high" \
  "M3: Narrative sections drafted"

create_issue \
  "[APP-H] Confirm Physics of Fluids LBM-DEM manuscript timeline" \
  "## Questions
- [ ] Current state: drafting / results complete / under internal review?
- [ ] Realistic submission quarter?
- [ ] Can it be noted as 'under review' if submitted before NRF call closes?

## Done when
- [ ] Timeline confirmed and Section H updated with correct status and quarter" \
  "area:strategy,priority:high" \
  "M3: Narrative sections drafted"

# ── M4: Reviewers confirmed ───────────────────────────────────────────────────
echo "── M4: Reviewers confirmed ─────────────────────────────────────────────"

create_issue \
  "[APP-I] Enter all reviewer details in NRF Connect Section I" \
  "## Goal
Minimum 6, maximum 10 reviewers. Aim for 8. At least 3 international.

## Critical checks
- [ ] Not a co-author in last 5 years (ATLAS papers count for HEP nominees)
- [ ] Not from UP Mechanical & Aeronautical Engineering
- [ ] Associate Professor level or above
- [ ] Max one reviewer per institution

## Done when
- [ ] 6-8 reviewers entered on NRF Connect with full name, email, institution, specialisation, association, reason
- [ ] Exclusion list completed if needed (max 3)" \
  "area:application,priority:critical" \
  "M4: Reviewers confirmed"

# ── M5: Ready for peer review ─────────────────────────────────────────────────
echo "── M5: Ready for peer review ───────────────────────────────────────────"

create_issue \
  "[STRATEGY] Identify 1-2 NRF-rated researchers to review draft before submission" \
  "## Goal
Share with C or B rated researchers in your field before final submission.
Target: share by end of October 2025 for 3 weeks of feedback.

## Steps
- [ ] Identify 2 candidates (not current co-authors)
- [ ] Confirm willingness to review
- [ ] Share annotated draft with questions: coherence, independence signals, gaps vs C1 criteria
- [ ] Incorporate feedback into final draft" \
  "area:strategy,priority:high" \
  "M5: Ready for peer review"

create_issue \
  "[APP] Upload PDF copies of all 5 Best Outputs to NRF Connect" \
  "## Papers
1. Nature (2024) — quantum entanglement with top quarks
2. Physics Reports (2025) — Higgs characterisation Run 2
3. Computers & Fluids (2024) — UVGI droplet infectiousness
4. BSPC (2026) — pulmonary acoustics
5. Solar Energy (2020) or substitute (pending Output 5 decision)

## Done when
- [ ] All 5 PDFs uploaded to NRF Connect Attachments
- [ ] Upload success verified (file size, no corruption)" \
  "area:cv-nrf,priority:critical" \
  "M5: Ready for peer review"

create_issue \
  "[APP] Upload ATLAS formal contribution letter as attachment in NRF Connect" \
  "## Steps
- [ ] Receive letter from Prof. Connell (see EXTERNAL issue)
- [ ] Convert to PDF
- [ ] Upload as ATLAS_Contribution_Letter_Connell.pdf to NRF Connect Attachments
- [ ] Add reference sentence to Output 1 contribution statement
- [ ] Add reference sentence to Output 2 contribution statement" \
  "area:application,priority:critical" \
  "M5: Ready for peer review"

# ── M6: Final submission ──────────────────────────────────────────────────────
echo "── M6: Final submission ────────────────────────────────────────────────"

create_issue \
  "[ADMIN] Final pre-submission checklist — NRF Connect" \
  "## CV section
- [ ] All review-period publications entered
- [ ] Pre-2019 best outputs selected (Section E)
- [ ] All supervision records complete
- [ ] Career history correct
- [ ] Grants, patents, keynotes entered
- [ ] h-indices up to date with draw dates

## Application sections
- [ ] A: Career Profile <= 5,500 chars
- [ ] B: Research Expertise — fields and panels correct
- [ ] C: Best-5 — all 5 complete, contribution statements specific, citation counts present
- [ ] D: Student supervision outputs — 4+ entries, no repeats from C
- [ ] E: Pre-2019 — 8-10 entries selected
- [ ] F: Completed research <= 11,000 chars
- [ ] G: Self-assessment <= 5,500 chars
- [ ] H: Future research <= 5,500 chars
- [ ] I: 6-8 reviewers entered with full details

## Attachments
- [ ] 5 Best Output PDFs uploaded
- [ ] ATLAS contribution letter uploaded

## Final steps
- [ ] Click Final Submit on NRF Connect
- [ ] Notify UP Research Office" \
  "area:admin,priority:critical" \
  "M6: Final submission"

# ── Add all issues to project board ──────────────────────────────────────────
echo ""
echo "==> All issues created."
echo ""
echo "==> Adding issues to project #3..."

PROJECT_ID=$(gh api graphql -f query='
  query {
    user(login: "muaazbhamjee") {
      projectV2(number: 3) { id }
    }
  }
' --jq '.data.user.projectV2.id')

echo "    Project node ID: $PROJECT_ID"

gh issue list \
  --repo "$REPO" \
  --state open \
  --limit 50 \
  --json number,id \
  --jq '.[].id' \
| while read ISSUE_ID; do
    gh api graphql -f query="
      mutation {
        addProjectV2ItemById(input: {
          projectId: \"$PROJECT_ID\"
          contentId: \"$ISSUE_ID\"
        }) { item { id } }
      }
    " > /dev/null && echo "    Added $ISSUE_ID"
  done

echo ""
echo "==> Done! Visit your board at:"
echo "    https://github.com/users/muaazbhamjee/projects/3"