# NRF Rating Application 2027 — GitHub Project Setup
# repo: https://github.com/muaazbhamjee/cv-mbhamjee
#
# Run the sections below IN ORDER from your terminal.
# Assumes: gh CLI installed and authenticated (`gh auth status` to verify).
# All commands target the repo muaazbhamjee/cv-mbhamjee.
#
# KANBAN COLUMNS  →  GitHub Project status field values:
#   📥 Backlog | 🔜 This Session | 🔄 In Progress | 🔍 Needs Review | ✅ Done
#
# LABEL COLOUR KEY used in this file:
#   area:application  #1F3864  (dark blue)   — narrative sections in NRF Connect
#   area:cv-nrf       #2E8540  (green)        — NRF Connect CV data entry
#   area:cv-up        #27AE60  (light green)  — UP CV / academic profile
#   area:external     #F39C12  (amber)        — actions requiring another person
#   area:strategy     #8E44AD  (purple)       — framing / decision issues
#   area:admin        #7F8C8D  (grey)         — logistics, deadlines, system setup
#   priority:critical #C0392B  (red)          — blocks submission if not done
#   priority:high     #E67E22  (orange)       — needed before peer review
#   priority:normal   #3498DB  (blue)         — standard work items
# ─────────────────────────────────────────────────────────────────────────────

# ══════════════════════════════════════════════════════════════════════════════
# STEP 1 — Create labels
# ══════════════════════════════════════════════════════════════════════════════

gh label create "area:application"  --color "1F3864" --description "NRF Connect narrative sections" --repo muaazbhamjee/cv-mbhamjee
gh label create "area:cv-nrf"       --color "2E8540" --description "NRF Connect CV data entry"      --repo muaazbhamjee/cv-mbhamjee
gh label create "area:cv-up"        --color "27AE60" --description "UP CV and academic profiles"    --repo muaazbhamjee/cv-mbhamjee
gh label create "area:external"     --color "F39C12" --description "Requires action from another person" --repo muaazbhamjee/cv-mbhamjee
gh label create "area:strategy"     --color "8E44AD" --description "Strategic framing or decision"  --repo muaazbhamjee/cv-mbhamjee
gh label create "area:admin"        --color "7F8C8D" --description "Logistics, deadlines, systems"  --repo muaazbhamjee/cv-mbhamjee
gh label create "priority:critical" --color "C0392B" --description "Blocks submission if not done"  --repo muaazbhamjee/cv-mbhamjee
gh label create "priority:high"     --color "E67E22" --description "Needed before peer review"      --repo muaazbhamjee/cv-mbhamjee
gh label create "priority:normal"   --color "3498DB" --description "Standard work item"             --repo muaazbhamjee/cv-mbhamjee


# ══════════════════════════════════════════════════════════════════════════════
# STEP 2 — Create milestones  (due dates = Friday session targets)
# ══════════════════════════════════════════════════════════════════════════════

gh api repos/muaazbhamjee/cv-mbhamjee/milestones \
  --method POST \
  --field title="M0: Planning & kickoff" \
  --field due_on="2025-04-25T23:59:00Z" \
  --field description="Week of 24 Apr — initial planning session, set up repo and project board"

gh api repos/muaazbhamjee/cv-mbhamjee/milestones \
  --method POST \
  --field title="M1: External actions initiated" \
  --field due_on="2025-05-02T23:59:00Z" \
  --field description="All emails sent, all requests lodged that have 2-3 week lead times"

gh api repos/muaazbhamjee/cv-mbhamjee/milestones \
  --method POST \
  --field title="M2: NRF Connect CV complete" \
  --field due_on="2025-06-06T23:59:00Z" \
  --field description="All publications, supervision, career history entered in NRF Connect"

gh api repos/muaazbhamjee/cv-mbhamjee/milestones \
  --method POST \
  --field title="M3: Narrative sections drafted" \
  --field due_on="2025-07-04T23:59:00Z" \
  --field description="Sections A, C, D, E, F, G, H fully drafted with citations filled"

gh api repos/muaazbhamjee/cv-mbhamjee/milestones \
  --method POST \
  --field title="M4: Reviewers confirmed" \
  --field due_on="2025-08-01T23:59:00Z" \
  --field description="All 6-8 reviewer names, emails, and conflict checks complete"

gh api repos/muaazbhamjee/cv-mbhamjee/milestones \
  --method POST \
  --field title="M5: Ready for peer review" \
  --field due_on="2025-10-31T23:59:00Z" \
  --field description="Complete draft shared with 1-2 NRF-rated researchers for feedback"

gh api repos/muaazbhamjee/cv-mbhamjee/milestones \
  --method POST \
  --field title="M6: Final submission" \
  --field due_on="2026-01-15T23:59:00Z" \
  --field description="UP internal deadline — final submit on NRF Connect"


# ══════════════════════════════════════════════════════════════════════════════
# STEP 3 — Create GitHub Project (Kanban board)
# ══════════════════════════════════════════════════════════════════════════════
# This uses the Projects v2 GraphQL API.
# First, get your user/org node ID:

gh api graphql -f query='{ viewer { id login } }'
# Copy the "id" value — you will need it for the next command.
# It looks like: U_kgDOBxxxxxxx

# Create the project (replace YOUR_USER_NODE_ID with the id from above):
gh api graphql -f query='
  mutation {
    createProjectV2(input: {
      ownerId: "YOUR_USER_NODE_ID"
      title: "NRF Rating Application 2027"
    }) {
      projectV2 { id number url }
    }
  }
'
# Copy the returned project "number" — you'll use it to add issues to the board.
# The project URL will be: https://github.com/users/muaazbhamjee/projects/NUMBER

# After creating the project, go to its URL and:
#   Settings → Fields → add a "Status" single-select field with these options:
#   📥 Backlog | 🔜 This Session | 🔄 In Progress | 🔍 Needs Review | ✅ Done
#   (GitHub creates "Todo / In Progress / Done" by default — rename or add options)

# Add a "Sprint" text field for the Friday session label (e.g. "Fri 2 May", "Fri 9 May")
# Add a "Section" text field for the NRF section reference (e.g. "A", "C-Output1", "D")


# ══════════════════════════════════════════════════════════════════════════════
# STEP 4 — Create all issues
# Format: gh issue create --title "..." --body "..." --label "..." --milestone "..." --repo muaazbhamjee/cv-mbhamjee
# ══════════════════════════════════════════════════════════════════════════════

# ── MILESTONE 0 — PLANNING & KICKOFF (this week) ─────────────────────────────

gh issue create \
  --title "[ADMIN] Set up GitHub Project Kanban board for NRF 2027 application" \
  --body "## Goal
Create a GitHub Projects v2 board with columns: 📥 Backlog | 🔜 This Session | 🔄 In Progress | 🔍 Needs Review | ✅ Done.

Add fields: Status, Sprint (Friday date), Section (NRF section ref).

Link all issues from this repo to the project.

## Done when
- [ ] Project board live at github.com/users/muaazbhamjee/projects/N
- [ ] All issues added to board
- [ ] Labels and milestones verified" \
  --label "area:admin,priority:critical" \
  --milestone "M0: Planning & kickoff" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[ADMIN] Confirm UP internal NRF deadline for 2027 call" \
  --body "## Goal
The UP guide (2026 call) gives 15 January 2026 as the institutional deadline.
For the 2027 call, contact the UP Research Office to confirm the equivalent date.

Contacts:
- Ms. Nyiko Shingange: nyiko.shingange@up.ac.za / 012 420 5846
- Mr. Abe Mathopa: abe.mathopa@up.ac.za / 012 420 2158

## Done when
- [ ] Confirmed 2027 call internal UP deadline in writing (email)
- [ ] Date noted in project description and pinned as a milestone" \
  --label "area:admin,priority:critical" \
  --milestone "M0: Planning & kickoff" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[ADMIN] Save annotated application draft to repo" \
  --body "## Goal
The annotated Word document (NRF_Application_2027_Annotated.docx) produced in the planning session should be committed to this repo for version control.

## Steps
- [ ] Create folder \`nrf-2027/\` in repo
- [ ] Add annotated docx
- [ ] Add this create_issues.md file
- [ ] Initial commit: 'chore: add NRF 2027 annotated draft and issue setup script'" \
  --label "area:admin,priority:normal" \
  --milestone "M0: Planning & kickoff" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[ADMIN] Log into NRF Connect and audit current CV state" \
  --body "## Goal
Before any data entry, understand what is already in NRF Connect and what is missing.

## Steps
- [ ] Log in at nrfconnect.nrf.ac.za
- [ ] Sync ORCID (click 'Sync now')
- [ ] Check Publications section — note which papers are present vs. missing
- [ ] Check Supervision section — note which students are captured
- [ ] Check Career History — note whether IBM/UJ/UP timeline is correct
- [ ] Note any system errors or missing relationships
- [ ] Capture findings as a comment on this issue" \
  --label "area:cv-nrf,priority:critical" \
  --milestone "M0: Planning & kickoff" \
  --repo muaazbhamjee/cv-mbhamjee


# ── MILESTONE 1 — EXTERNAL ACTIONS (initiate this week, responses in 2-3 weeks) ──

gh issue create \
  --title "[EXTERNAL] Request bibliometrics report from UP librarian Lathola Mchunu" \
  --body "## Goal
Obtain confirmed Scopus and WoS citation counts per paper, and h-index verification for the NRF application.

## Contact
Lathola Mchunu: lathola.mchunu@up.ac.za
UP Library subject librarian for Mechanical & Aeronautical Engineering.

## Request
Email requesting:
1. Scopus citation count for each of the 5 Best Outputs (DOIs listed below)
2. WoS citation count for same
3. Confirmed Scopus h-index and WoS h-index with draw date
4. Citation counts for pre-2019 papers (especially Energy and Buildings 2013)

## DOIs needed
- 10.1016/j.compfluid.2024.106242 (Computers & Fluids 2024)
- 10.1016/j.bspc.2025.110018 (BSPC 2026)
- 10.1016/j.solener.2019.11.058 (Solar Energy 2020)
- 10.1016/j.enbuild.2012.10.041 (Energy and Buildings 2013)

## Done when
- [ ] Email sent
- [ ] Report received
- [ ] Citation counts entered into annotated application draft
- [ ] h-index values confirmed and dated" \
  --label "area:external,priority:critical" \
  --milestone "M1: External actions initiated" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[EXTERNAL] Request ATLAS formal contribution letter from Prof. S.H. Connell" \
  --body "## Goal
Obtain a formal letter from the SA-ATLAS Institutional Board (or Prof. Simon Connell as SA-ATLAS PI) confirming:
1. Your formal title: UP Institutional Representative and Team Leader for the ATLAS Experiment at CERN
2. Your specific contributions: ITk detector environmental monitoring, AQT supervision of SA students
3. That these contributions qualify you as a co-author on the ATLAS collaboration papers listed

## Why this is critical
An Engineering panel reviewer will almost certainly discount Outputs 1 and 2 (Nature 2024, Physics Reports 2025) if the ~0.5% contribution is only self-asserted. A letter from an independent ATLAS authority makes the contribution verifiable.

## Contact
Prof. Simon H. Connell: shconnell@uj.ac.za | +27 82 945 7508

## Steps
- [ ] Draft email requesting letter (2-week turnaround)
- [ ] Send email
- [ ] Letter received
- [ ] Letter uploaded as attachment in NRF Connect application
- [ ] Reference to letter added in Outputs 1 and 2 contribution statements" \
  --label "area:external,priority:critical" \
  --milestone "M1: External actions initiated" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[EXTERNAL] Confirm NITheCS Fellowship application status" \
  --body "## Goal
Confirm current status of the NITheCS Fellowship application so the correct sentence can be inserted in Sections A and H of the NRF application.

## Options
- Applied and pending: 'He has applied for a NITheCS Fellowship to support quantum computing research at UP.'
- Awarded: 'He holds a NITheCS Fellowship, supporting quantum computing and SciML research at UP.'
- Not yet applied: remove placeholder entirely from application.

## Done when
- [ ] Status confirmed
- [ ] Correct sentence inserted in Section A (Career Profile) placeholder
- [ ] Correct sentence inserted in Section H (Future Research) placeholder" \
  --label "area:external,priority:high" \
  --milestone "M1: External actions initiated" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[EXTERNAL] Check InspireHEP citation counts for ATLAS Best-5 outputs" \
  --body "## Goal
InspireHEP (inspire-hep.net) is the authoritative citation database for HEP papers.
Physics and HEP reviewers will check InspireHEP, not Scopus, for ATLAS paper citation counts.

## Papers to check
1. Nature 2024 — DOI 10.1038/s41586-024-07824-z (quantum entanglement with top quarks)
2. Physics Reports 2025 — DOI 10.1016/j.physrep.2024.09.004 (Higgs characterisation Run 2)

## Steps
- [ ] Go to https://inspirehep.net and search each DOI
- [ ] Record citation count and date
- [ ] Add counts to Output 1 and Output 2 motivation paragraphs in annotated draft
- [ ] Note any high-profile citing papers (useful for self-assessment)" \
  --label "area:application,priority:high" \
  --milestone "M1: External actions initiated" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[EXTERNAL] Identify and confirm 6-8 reviewer names for Section I" \
  --body "## Goal
Section I requires actual names, emails, institutions, and conflict checks.
NRF Connect will not accept submission without populated reviewer fields.

## Required profiles (from annotated application draft)
1. Prof. in Multiphase CFD / LBM — international (TU Delft, TU Munich, Imperial, ETH)
2. Prof. in Computational Biofluid Mechanics / Respiratory Mechanics — international
3. Prof./Senior Researcher in Experimental HEP — NOT an ATLAS co-author
4. Prof. in Mechanical/Thermal Engineering — SA (UCT, Stellenbosch, or Wits)
5. Prof. in Physics — SA (UCT, UJ, or UKZN), active in SA-CERN but NOT an ATLAS co-author
6. Prof./Senior Researcher at CSIR or SAMRC — computational science background
7. (Optional) LBM specialist — Europe or North America
8. (Optional) Computational biomechanics — check Prof. Ngoepe (UCT) for co-author conflict

## For each candidate
- [ ] Confirm name, email, current institution
- [ ] Verify: NOT a co-author on any paper in last 5 years (ATLAS papers count)
- [ ] Verify: NOT from UP Mechanical & Aeronautical Engineering
- [ ] Verify: Associate Professor level or above
- [ ] Verify: maximum one reviewer per institution
- [ ] Draft 1-sentence nomination reason

## Done when
- [ ] 6 confirmed reviewers with full details
- [ ] All entered on NRF Connect Section I" \
  --label "area:external,priority:critical" \
  --milestone "M4: Reviewers confirmed" \
  --repo muaazbhamjee/cv-mbhamjee


# ── MILESTONE 2 — NRF CONNECT CV ─────────────────────────────────────────────

gh issue create \
  --title "[CV-NRF] Correct career history in NRF Connect (IBM / UJ SRA / UP timeline)" \
  --body "## Goal
Fix the employment timeline in NRF Connect CV to match the correct chronology.

## Correct timeline
- Hatch Africa (CFD Analyst): 2008–2009
- University of Johannesburg (Lecturer → Senior Lecturer): Jan 2015 – Jan 2023
- IBM Research Africa (Staff Research Scientist): Feb 2023 – Dec 2024
- University of Johannesburg (Visiting SRA, adjunct): Jul 2023 – Dec 2024  ← concurrent with IBM
- University of Pretoria (Associate Professor): Jan 2025 – present

## Steps
- [ ] Log into NRF Connect
- [ ] Edit Career History section
- [ ] Add IBM entry with correct dates
- [ ] Add UJ SRA entry (type: adjunct/visiting) with correct dates
- [ ] Ensure UP entry shows Jan 2025 start
- [ ] Screenshot or export for records" \
  --label "area:cv-nrf,priority:critical" \
  --milestone "M2: NRF Connect CV complete" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[CV-NRF] Enter all review-period journal publications (2019-2026) in NRF Connect" \
  --body "## Goal
All non-ATLAS journal papers from 2019–2026 must be captured in NRF Connect before selecting Best-5.

## Papers to enter (from CV)
- Makhanya & Bhamjee et al. (2026) BSPC vol.120 — DOI 10.1016/j.bspc.2025.110018
- Ralijaona, Igumbor, Bhamjee et al. (2024) Computers & Fluids vol.275 — DOI 10.1016/j.compfluid.2024.106242
- Mokoena, Bhamjee et al. (2023) R&D Journal SAIMechE vol.39 — DOI 10.17159/...
- Makhanya, Connell, Bhamjee et al. (2023) Math. Comp. App. vol.28(3) — DOI 10.3390/mca28030064
- Bhamjee, Connell, Nel (2022) Math. Comp. App. vol.27(6) — DOI 10.3390/mca27060088
- Potgieter, Bhamjee, Kruger (2021) R&D Journal SAIMechE vol.37 — DOI 10.17159/...
- Potgieter, Bester, Bhamjee (2020) Solar Energy vol.195 — DOI 10.1016/j.solener.2019.11.058

## For each paper
- [ ] Enter via DOI auto-import if available
- [ ] Verify author order, volume, pages
- [ ] Confirm Scopus Q1 classification
- [ ] Mark own contribution percentage

## Notes
ATLAS collaboration papers (200+) — use ORCID sync to import; verify at least the Best-5 ATLAS papers are individually visible." \
  --label "area:cv-nrf,priority:critical" \
  --milestone "M2: NRF Connect CV complete" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[CV-NRF] Enter pre-2019 best outputs (Section E) in NRF Connect — target 8-10" \
  --body "## Goal
Populate Section E with up to 10 pre-2019 outputs to show depth before the review window.

## Confirmed outputs to enter
1. Bhamjee, Nurick, Madyira (2013) Energy and Buildings vol.57, pp.289-301
2. ATLAS Collaboration (2018) Phys. Lett. B vol.787, pp.68-88 (WZ resonance search)
3. Select 3-4 more representative ATLAS papers from 2015-2018 — ask Prof. Connell for recommended list
4. Any UJ NRF Thuthuka outputs from 2017-2018 not yet captured
5. Potgieter, Nurick, Bhamjee (2016) solar heater SACAM paper if journal version exists

## Steps
- [ ] Consult with Prof. Connell on best ATLAS pre-2019 paper selection
- [ ] Enter all in NRF Connect
- [ ] Select them formally in the 'Best outputs before review period' section" \
  --label "area:cv-nrf,priority:high" \
  --milestone "M2: NRF Connect CV complete" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[CV-NRF] Enter all postgraduate supervision records in NRF Connect" \
  --body "## Goal
NRF Connect supervision section must list all MEng completions and ongoing PhD/MEng students.

## MEng completions (graduated)
- T. Jooma Abbajee (2026, UJ, co-supervisor) — Reservoir Computing
- K.M. Makhanya (2025, UJ, co-supervisor) — Pulmonary acoustics CFD
- T.F. Mokoena (2022, UJ, main supervisor) — BEATS beamline equipment
- T. Ramokoka (2022, UJ, main supervisor) — VP shunt modelling
- T.B. Molale (2021, UJ, co-supervisor) — Steam turbine blade
- A. Potgieter (2020, UJ, Cum Laude, main supervisor) — Fluidised bed
- D.M. Chirnside (2019, UJ, main supervisor) — Air-core formation
- S.A.T. Tina (2017, UJ, Cum Laude, co-supervisor) — Hydrocyclone optimisation
- M.S.W. Potgieter (2016, UJ, Cum Laude, co-supervisor) — Solar air heater

## PhD/MEng ongoing at UP
- A.Y. Akinbowale (PhD, UP) — Quantum ML for HEP
- M. Ramokali (PhD, UP) — Hybrid classical-quantum CFD
- M. Takoutchouang (PhD, UP) — FSI in pathological arteries
- M.S.W. Potgieter (PhD, UP) — Hybrid LBM-ML
- A. Essop (PhD, UP) — Novel numerical scheme
- T. Jooma Abbajee (PhD, UJ, co-supervisor) — Graph dynamical RC
- M.P. Connell (PhD, UJ, co-supervisor) — Higgs BSM searches
- M. Maila (MEng, UP) — Hydrocyclone multiphase
- B. Kazembe (MEng, UP) — Fluidised bed DDPM
- M.Y. Rasool (MEng, UP, co-supervisor) — BSM Higgs at ATLAS

## For each student
- [ ] Citizenship status
- [ ] Study level and degree name
- [ ] Thesis title
- [ ] Supervised from/to dates
- [ ] Role (supervisor / co-supervisor)
- [ ] Status (completed / in progress)" \
  --label "area:cv-nrf,priority:high" \
  --milestone "M2: NRF Connect CV complete" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[CV-NRF] Enter grants, patents, conference keynotes in NRF Connect" \
  --body "## Goal
Ensure the CV section for grants, patents, and significant conference outputs is fully populated.

## Grants
- 2025 UP RDP: R50,000 — Advancing computational techniques for multiphase flow
- 2022 UJ URC Equipment Grant: R284,517 — COVID-19 digital twins
- 2021 UJ GES COVID-19: R80,000
- 2020-2021 ESRF: €8,750 — BEATS beamline equipment
- 2017-2019 NRF Thuthuka (Post-PhD): R602,000 — Multiphase flow modelling

## Patents
- ZA2023/09448 (granted 30 Jul 2024) — Air temperature forecasting
- US18/200,050 (pending) — Same invention, USA

## Keynotes / invited talks
- CHPC National Conference 2017 — Keynote: 'Modelling of Multiphase Flow in Process Equipment'
- CHPC National Conference 2025 — Invited talk: 'Entangled Worlds: Engineering, Physics, Applied Mathematics, and the Future of HPC'

## Steps
- [ ] Enter all grants under Grants section
- [ ] Enter both patents under Patents section (note type: utility patent)
- [ ] Enter keynotes under Keynote and Plenary Addresses (NOT under Other conference outputs)" \
  --label "area:cv-nrf,priority:high" \
  --milestone "M2: NRF Connect CV complete" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[CV-UP] Update UP CV with corrected timeline and new outputs" \
  --body "## Goal
Ensure the UP academic CV matches the NRF Connect CV — consistency is checked during faculty review.

## Changes required
- [ ] Correct employment dates: IBM Feb 2023–Dec 2024; UJ SRA Jul 2023–Dec 2024; UP Jan 2025–present
- [ ] Add SAIP 2025 conference papers (Abbajee/RC and Cassim/Greenhouse)
- [ ] Add IEEE IGARSS 2025 paper
- [ ] Add CERG-FLUX Lab founding (2026) under Research Lab Leadership
- [ ] Add MKM411 SciML lecture notebooks and PINN heat transfer as 'Other scholarly contributions'
- [ ] Update h-indices: GS 63, Scopus 31, WoS 27 (April 2026)
- [ ] Confirm Kruger2026 LOC membership is listed under organising committees" \
  --label "area:cv-up,priority:high" \
  --milestone "M2: NRF Connect CV complete" \
  --repo muaazbhamjee/cv-mbhamjee


# ── MILESTONE 3 — NARRATIVE SECTIONS ─────────────────────────────────────────

gh issue create \
  --title "[APP-A] Finalise Section A — Career Profile Narrative" \
  --body "## Goal
Complete Section A. Max 5,500 characters including spaces. Must open with ATLAS UP Institutional Rep role.

## Checklist
- [ ] Confirm opening sentence names UP Institutional Representative and Team Leader role explicitly
- [ ] IBM dates corrected to Feb 2023–Dec 2024
- [ ] UJ SRA role (Jul 2023–Dec 2024) mentioned as concurrent/adjunct post
- [ ] NITheCS Fellowship sentence inserted (from issue #[NITheCS status issue])
- [ ] ESRF international grant (€8,750) mentioned
- [ ] IUTAM Vice-Presidency named as peer recognition
- [ ] CHPC keynote (2017) and invited talk (2025) mentioned
- [ ] Character count verified ≤ 5,500 (paste into Word or use online counter)
- [ ] No bullet points — pure narrative prose
- [ ] Text copied into NRF Connect Section A field" \
  --label "area:application,priority:high" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP-C] Decide Best-5 composition — Output 5 keep or substitute" \
  --body "## Decision required
Current Output 5 = Solar Energy (2020), where you are 3rd author.

## Option A — Keep Solar Energy (2020)
- Rationale: Q1, IF 5.742, establishes sustainability from start of review window
- Risk: you are 3rd author; independence signal is weak
- Mitigation: add Scopus citation count; make corresponding-author role explicit

## Option B — Replace with MCA 2022 (Cyclonic Flow / Bhamjee M., Connell S.H., Nel A.L.)
- Rationale: you are first author on your core LBM topic; stronger independence signal
- Risk: lower journal prestige (MCA is MDPI, not Elsevier)
- Check: confirm author order and your exact contribution on that paper

## Option C — Replace with Mokoena et al. (2023) R&D Journal SAIMechE (BEATS detector)
- Rationale: connects your CFD expertise to ATLAS; you are second author
- Risk: still not first-author

## Steps
- [ ] Pull Scopus citation count for Solar Energy 2020 from librarian report
- [ ] Confirm author order and contribution % for MCA 2022 paper
- [ ] Make decision and record it as a comment on this issue
- [ ] Update annotated application draft accordingly" \
  --label "area:strategy,priority:high" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP-C] Add citation counts to all Best-5 output motivation paragraphs" \
  --body "## Goal
Every output motivation should include a citation count or explain why it is not yet available.

## Outputs needing counts
- Output 1 (Nature 2024): use InspireHEP count (see InspireHEP issue)
- Output 2 (Physics Reports 2025): use InspireHEP count
- Output 3 (Computers & Fluids 2024): use Scopus count from librarian report
- Output 4 (BSPC 2026): use Scopus count — may be 0 or very low; frame around recency
- Output 5 (Solar Energy 2020 or substitute): use Scopus count

## Format
'X citations (Scopus, April 2026)' — including the database and draw date.
For ATLAS papers: 'X citations (InspireHEP, April 2026)'.

## Done when
- [ ] All five motivation paragraphs contain a citation figure or a framed recency statement
- [ ] Counts cross-referenced with librarian report" \
  --label "area:application,priority:high" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP-C] Strengthen ATLAS contribution statements for Outputs 1 and 2" \
  --body "## Goal
The contribution statements for the ATLAS outputs must be specific and defensible, not vague.
The formal letter from Prof. Connell (see EXTERNAL issue) provides the external verification.
This issue covers the text in the application itself.

## For Output 1 (Nature 2024)
- [ ] Name the formal title explicitly: 'as UP Institutional Representative and Team Leader'
- [ ] State specific work: ITk environmental monitoring, AQT supervision of [N] SA students
- [ ] Add: 'A formal contribution statement from the SA-ATLAS Institutional Board is included as supplementary attachment'
- [ ] State InspireHEP citation count

## For Output 2 (Physics Reports 2025)
- [ ] Same title reference
- [ ] Link contribution to data quality for the Higgs measurements
- [ ] State InspireHEP citation count

## Done when
- [ ] Both contribution statements revised
- [ ] Reference to formal letter added
- [ ] Text entered in NRF Connect Best Outputs section" \
  --label "area:application,priority:critical" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP-C] Clarify first-author vs lead-researcher for Output 3 (Computers & Fluids)" \
  --body "## Goal
Ralijaona M. is first author but you claim lead researcher and corresponding author (~70%).
This inconsistency must be addressed explicitly in the contribution statement.

## Text to add
'First authorship was assigned to Ralijaona M. as the executing postgraduate candidate, consistent with the convention of recognising the researcher who ran the simulations; corresponding authorship and intellectual leadership of the project — including conceptualisation of the coupled CFD–UVGI–evaporation framework and development of the numerical methodology — remained with the applicant.'

## Done when
- [ ] Clarifying sentence added to Output 3 contribution statement
- [ ] Scopus citation count added to motivation paragraph
- [ ] Revised text entered in NRF Connect" \
  --label "area:application,priority:high" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP-D] Populate Section D — Best student supervision outputs (target 4-5 entries)" \
  --body "## Goal
Section D currently has 2 entries. NRF Connect requires properly populated entries — not placeholders.

## Confirmed outputs to add
1. Abbajee T.J., Anderson K.D., Bhamjee M., Visaya M.V. (2025). Reservoir Computing for Predicting Chaotic Dynamical Systems. SAIP 2025, pp.1026-1031. [Co-supervisor, UJ]
2. Ramokoka T. & Bhamjee M. (2021). VP shunt modelling. SACAM2020. DOI 10.25923/y61v-4k91. [Main supervisor]
3. Makhanya K.M. et al. (2023). CFD for lung acoustics diagnosis. Math. Comp. App. vol.28(3), p.64. [Principal supervisor — this is the conference version, separate from BSPC 2026]
4. Connell M.P., Bhamjee M. et al. (2022). ATLAS ITk Environmental Monitoring. SAIP 2022, pp.553-558. [Local ATLAS AQT supervisor]

## Decision needed
- [ ] Confirm whether to add the Mokoena/BEATS FEA paper (R&D Journal 2023) here
- [ ] Confirm whether BSPC 2026 stays in Best-5 or moves to Section D

## Done when
- [ ] Minimum 4 entries with full references
- [ ] Each entry has role annotation (supervisor/co-supervisor, student name, degree level)
- [ ] No repeat of outputs listed in Section C" \
  --label "area:application,priority:high" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP-E] Populate Section E — pre-2019 outputs (target 8-10 entries)" \
  --body "## Goal
Section E has 1 entry. Up to 10 are allowed and each additional entry strengthens the longitudinal research record.

## Confirmed
1. Bhamjee, Nurick, Madyira (2013). Energy and Buildings vol.57. ✔ already listed.

## To add
2-6. 3-5 representative ATLAS pre-2019 papers (ask Prof. Connell for recommended selection)
7. Physics Letters B (2018) WZ resonance search paper
8. Earlier hydrocyclone papers if in peer-reviewed journals (check 2017-2018 SACAM proceedings)
9. Any DHET-accredited outputs from Thuthuka funding period (2017-2019)

## Steps
- [ ] Email Prof. Connell for recommended ATLAS pre-2019 paper selection
- [ ] Enter all in NRF Connect under correct output types
- [ ] Select them in the 'Best outputs before review period' Section E on NRF Connect" \
  --label "area:application,priority:normal" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP-F] Revise Section F — Completed Research narrative" \
  --body "## Goal
Section F is largely complete but needs three specific updates.

## Updates required
- [ ] Update ATLAS paragraph: explicitly name 'UP Institutional Representative and Team Leader' role (not just 'detector operations and environmental monitoring')
- [ ] Move IEEE IGARSS 2025 and SAIP 2025 references here — they are published, not forthcoming
- [ ] Add a sentence on the Reservoir Computing paper (SAIP 2025, Abbajee et al.) — strengthens the SciML/dynamical systems thread
- [ ] Add the CHPC 2025 invited talk reference as peer recognition
- [ ] Character count check ≤ 11,000 characters

## Done when
- [ ] All three updates made
- [ ] Text transferred to NRF Connect Section F" \
  --label "area:application,priority:high" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP-G] Finalise Section G — Self-Assessment" \
  --body "## Goal
Section G is the most important narrative section. It must be assertive, evidence-based, and specifically address the C1 criteria: quality, coherence, independence, sustainability.

## Specific changes required
- [ ] Update h-index figures: GS 63, Scopus 31, WoS 27 (April 2026)
- [ ] Add explanation of h-index spread: ATLAS collaboration papers inflate GS counts; Scopus and WoS are more representative of independent contribution profile
- [ ] Insert citation counts for Outputs 3, 4, 5 (from librarian report)
- [ ] Replace 'I believe my research constitutes...' with 'My research over the review period constitutes...'
- [ ] Add IUTAM Vice-Presidency and CHPC keynote/invited talk as evidence of peer recognition
- [ ] Reference formal ATLAS contribution letter for Outputs 1 and 2
- [ ] Character count check ≤ 5,500

## Done when
- [ ] All updates made
- [ ] Text transferred to NRF Connect Section G" \
  --label "area:application,priority:critical" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP-H] Finalise Section H — Ongoing and Planned Future Research" \
  --body "## Goal
Section H must cover the genuine 2027–2032 vision. Remove published outputs; add forthcoming ones.

## Changes required
- [ ] REMOVE: IEEE IGARSS 2025 and SAIP 2025 (already published — moved to Section F)
- [ ] ADD: Physics of Fluids LBM-DEM manuscript — 'in preparation, anticipated submission [Quarter/Year]'
- [ ] ADD: ADSC 2026 abstract — 'Teaching Machines to Respect Physics' submitted to ADSC conference at Wits
- [ ] ADD: NITheCS Fellowship sentence (once status confirmed — see EXTERNAL issue)
- [ ] ADD: Quantum postdoc recruitment status (once confirmed)
- [ ] ADD: DSI QuTI funding application status
- [ ] Update Programme 3 (quantum) — make it concrete with specific actions, not aspirational only
- [ ] Character count check ≤ 5,500

## Done when
- [ ] All changes made
- [ ] Text transferred to NRF Connect Section H" \
  --label "area:application,priority:high" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP-H] Confirm Physics of Fluids LBM-DEM manuscript timeline" \
  --body "## Goal
The LBM-DEM hydrocyclone manuscript (in preparation for Physics of Fluids) is the most strategically important forthcoming output. Its status and target submission quarter must be confirmed for Section H.

## Questions to answer
- [ ] What is the current state of the manuscript? (drafting / results complete / under internal review)
- [ ] What is the realistic submission quarter? (Q3 2025 / Q4 2025 / Q1 2026?)
- [ ] If submitted before the NRF call closes, it could be noted in Section H as 'under review' rather than 'in preparation' — is this achievable?

## Done when
- [ ] Timeline confirmed
- [ ] Section H placeholder updated with correct status and quarter" \
  --label "area:strategy,priority:high" \
  --milestone "M3: Narrative sections drafted" \
  --repo muaazbhamjee/cv-mbhamjee


# ── MILESTONE 4 — REVIEWERS ───────────────────────────────────────────────────

gh issue create \
  --title "[APP-I] Enter all reviewer details in NRF Connect Section I" \
  --body "## Goal
Section I requires actual names, emails, institutions, specialisations, and your relationship to each reviewer. Profile descriptions only are not sufficient.

## Slots needed
Minimum 6, maximum 10. Aim for 8. At least 3 international.

## For each reviewer — data to enter on NRF Connect
- Full name
- Email address
- Institution (no more than one per institution)
- Specialisation (2–3 words)
- Your association (acquaintance / professional colleague / etc.)
- Reason for nomination (1 sentence)
- Priority order

## Critical checks before nominating anyone
- [ ] Not a co-author on any paper in last 5 years (ATLAS papers count for HEP nominees)
- [ ] Not from UP Mechanical & Aeronautical Engineering
- [ ] Associate Professor level or above

## Once reviewers are confirmed (see EXTERNAL issue)
- [ ] Enter all in NRF Connect
- [ ] Cross-check: maximum one reviewer per institution
- [ ] Note any excluded reviewers if needed (max 3 exclusions)" \
  --label "area:application,priority:critical" \
  --milestone "M4: Reviewers confirmed" \
  --repo muaazbhamjee/cv-mbhamjee


# ── MILESTONE 5 — PEER REVIEW PREPARATION ────────────────────────────────────

gh issue create \
  --title "[STRATEGY] Identify 1-2 NRF-rated researchers to review draft before submission" \
  --body "## Goal
The UP guide strongly recommends sharing the draft with NRF-rated researchers (C or B rated, in your field) before final submission. Aim to share by end of October 2025 to allow 3 weeks for feedback.

## Candidate profiles
- Rated researcher in CFD/multiphase flow (not a current co-author)
- Rated researcher in computational engineering (not at UP Mechanical & Aeronautical)
- Optionally: a rated researcher who has recently applied for a C-rating themselves

## Steps
- [ ] Identify 2 candidates
- [ ] Confirm willingness to review (email, 2-week turnaround request)
- [ ] Share complete annotated draft with specific questions:
  -- Does the coherence argument hold?
  -- Are the independence claims in the Best-5 convincing?
  -- Are there obvious gaps vs. the C1 criteria?
- [ ] Incorporate feedback into final draft" \
  --label "area:strategy,priority:high" \
  --milestone "M5: Ready for peer review" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP] Upload PDF copies of all 5 Best Outputs to NRF Connect" \
  --body "## Goal
NRF Connect requires PDF copies of the 5 Best Outputs to be uploaded as attachments.

## Papers to upload
1. Nature (2024) — quantum entanglement with top quarks
2. Physics Reports (2025) — Higgs characterisation Run 2
3. Computers & Fluids (2024) — UVGI droplet infectiousness
4. Biomedical Signal Processing and Control (2026) — pulmonary acoustics
5. Solar Energy (2020) — hybrid solar air heater [or substitute if Output 5 decision changes]

## Steps
- [ ] Obtain PDFs for all 5 (check institutional access or author accepted manuscripts)
- [ ] Name files clearly: 'Output1_Nature2024.pdf', etc.
- [ ] Upload each via NRF Connect Attachments section
- [ ] Verify upload success (file size, no corruption)" \
  --label "area:cv-nrf,priority:critical" \
  --milestone "M5: Ready for peer review" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[APP] Upload ATLAS formal contribution letter as attachment in NRF Connect" \
  --body "## Goal
Once the formal letter from Prof. Connell / SA-ATLAS Institutional Board is received, it must be uploaded as a supplementary attachment on NRF Connect, and referenced in the Output 1 and Output 2 contribution statements.

## Steps
- [ ] Receive letter (see EXTERNAL issue)
- [ ] Convert to PDF if not already
- [ ] Upload via NRF Connect Attachments as: 'ATLAS_Contribution_Letter_Connell.pdf'
- [ ] Add reference sentence to Output 1 contribution statement
- [ ] Add reference sentence to Output 2 contribution statement" \
  --label "area:application,priority:critical" \
  --milestone "M5: Ready for peer review" \
  --repo muaazbhamjee/cv-mbhamjee

gh issue create \
  --title "[ADMIN] Final pre-submission checklist — NRF Connect" \
  --body "## Goal
A final check of the complete NRF Connect application before clicking Final Submit.

## Checklist
### CV section
- [ ] All review-period publications entered
- [ ] Pre-2019 best outputs selected (Section E)
- [ ] All supervision records complete
- [ ] Career history correct
- [ ] Grants, patents, keynotes entered
- [ ] h-indices up to date with draw dates

### Application sections
- [ ] A: Career Profile ≤ 5,500 chars
- [ ] B: Research Expertise — fields and panels correct
- [ ] C: Best-5 — all 5 entries complete, contribution statements specific, citation counts present
- [ ] D: Student supervision outputs — 4+ entries
- [ ] E: Pre-2019 — 8-10 entries selected
- [ ] F: Completed research ≤ 11,000 chars
- [ ] G: Self-assessment ≤ 5,500 chars
- [ ] H: Future research ≤ 5,500 chars
- [ ] I: 6-8 reviewers with full details entered
- [ ] Attachments: 5 Best Output PDFs uploaded
- [ ] Attachments: ATLAS contribution letter uploaded
- [ ] Declaration signed (digital or hard copy per NRF requirements)

### Final steps
- [ ] Click Final Submit on NRF Connect (this makes the application visible to the Research Office)
- [ ] Notify UP Research Office that application has been submitted for faculty review" \
  --label "area:admin,priority:critical" \
  --milestone "M6: Final submission" \
  --repo muaazbhamjee/cv-mbhamjee


# ══════════════════════════════════════════════════════════════════════════════
# STEP 5 — Add all issues to the GitHub Project board
# ══════════════════════════════════════════════════════════════════════════════
# After creating the project (Step 3), run this to add all open issues.
# Replace PROJECT_NUMBER with the number returned in Step 3.

PROJECT_NUMBER=1   # <-- update this after you create the project

# Get the project node ID
PROJECT_ID=$(gh api graphql -f query="
  query {
    user(login: \"muaazbhamjee\") {
      projectV2(number: $PROJECT_NUMBER) { id }
    }
  }
" --jq '.data.user.projectV2.id')

echo "Project ID: $PROJECT_ID"

# Add all open issues to the project
gh issue list --repo muaazbhamjee/cv-mbhamjee --state open --limit 50 --json number,id \
  --jq '.[].id' | while read ISSUE_ID; do
    gh api graphql -f query="
      mutation {
        addProjectV2ItemById(input: {
          projectId: \"$PROJECT_ID\"
          contentId: \"$ISSUE_ID\"
        }) { item { id } }
      }
    " > /dev/null && echo "Added issue $ISSUE_ID"
done

echo "All issues added to project board."
echo "Visit the board at: https://github.com/users/muaazbhamjee/projects/$PROJECT_NUMBER"


# ══════════════════════════════════════════════════════════════════════════════
# STEP 6 — Suggested Kanban column assignments for first session
# (set these manually on the board after Step 5, or via the API)
# ══════════════════════════════════════════════════════════════════════════════
#
# 🔜 THIS SESSION (do today, 24 April)
#   - [ADMIN] Set up GitHub Project Kanban board
#   - [ADMIN] Confirm UP internal NRF deadline for 2027 call
#   - [ADMIN] Log into NRF Connect and audit current CV state
#   - [ADMIN] Save annotated application draft to repo
#
# 📥 BACKLOG → move to 🔜 THIS SESSION on Fri 2 May
#   - [EXTERNAL] Request bibliometrics report from librarian
#   - [EXTERNAL] Request ATLAS formal contribution letter
#   - [EXTERNAL] Confirm NITheCS Fellowship status
#   - [EXTERNAL] Check InspireHEP citation counts
#
# Everything else → 📥 BACKLOG


# ══════════════════════════════════════════════════════════════════════════════
# STEP 7 — Suggested Friday session schedule (09:00–11:00)
# ══════════════════════════════════════════════════════════════════════════════
#
# Fri 25 Apr  — Session 0 (TODAY): planning, repo setup, send external requests
# Fri  2 May  — Session 1: NRF Connect audit; career history corrections; InspireHEP checks
# Fri  9 May  — Session 2: NRF Connect CV — review-period journal papers
# Fri 16 May  — Session 3: NRF Connect CV — supervision records
# Fri 23 May  — Session 4: NRF Connect CV — grants, patents, keynotes; pre-2019 entries
# Fri 30 May  — Session 5: Section A (Career Profile) — finalise and enter
# Fri  6 Jun  — Session 6: Section C Output 5 decision; citation counts; contribution statements
# Fri 13 Jun  — Session 7: Section D (student outputs) — populate 4-5 entries
# Fri 20 Jun  — Session 8: Section E (pre-2019) — populate 8-10 entries
# Fri 27 Jun  — Session 9: Section F (completed research) — revise and enter
# Fri  4 Jul  — Session 10: Section G (self-assessment) — finalise
# Fri 11 Jul  — Session 11: Section H (future research) — finalise
# Fri 18 Jul  — Session 12: Reviewer identification — research candidates
# Fri 25 Jul  — Session 13: Reviewer conflict checks; Section I entries on NRF Connect
# Fri  1 Aug  — Session 14: Full draft review — coherence and character count checks
# Fri  8 Aug  — Buffer session — catch-up / polish
# --- August/September: share with 1-2 rated researchers for peer review ---
# Fri  3 Oct  — Session 15: Incorporate peer review feedback
# Fri 10 Oct  — Session 16: ATLAS letter received? Upload + update contribution statements
# Fri 17 Oct  — Session 17: Upload all 5 Best Output PDFs to NRF Connect
# Fri 24 Oct  — Session 18: Final character count checks all sections
# Fri 31 Oct  — Session 19: Final pre-submission checklist; Final Submit on NRF Connect
# --- November/January: UP faculty review and institutional approval ---
# By 15 Jan 2026 — UP internal deadline (confirm exact date for 2027 call)
