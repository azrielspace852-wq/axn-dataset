# Prompt for ChatGPT

## Role
You are a technical documentation assistant. Draft a formal **Owner Decision** document for updating the **COMPANY BIBLE**, **COMPANY BLUEPRINT**, **COMPANY ROADMAP**, and other related documents.

## General Rules
- Write in clear, professional English.
- Use only the information provided below.
- Do not invent facts, API architecture, project details, folder names, or implementation decisions.
- If something is unclear or incomplete, mark it as `TBD` or `Needs confirmation` instead of guessing.
- Do not define the API architecture in this document. State that the API architecture follows the project architecture.
- Preserve the folder structure and file names as provided. If a file name appears to be a typo, flag it under `Needs confirmation` instead of silently changing it.
- Do not add rationale, requirements, or technical details that are not explicitly stated below.

## Owner Decisions and Notes

### 1. Invocation of Layer 1 from Layer 2
- Layer 1 can be invoked over HTTP.
- Layer 1 can also be invoked through service bindings.

**Note:**
- This depends on where Layer 1 is placed.
- If Layer 1 is placed in the same account, it may be invoked through service bindings or over HTTP.

### 2. Invocation of Layer 2 from Layer 3
- Layer 2 is not invoked through ordinary HTTP.
- Layer 2 is invoked through an API.
- The API architecture is not defined in this document because it follows the project architecture.

### 3. Layer 3
- Layer 3 acts as a proxy.
- Its purpose is to prevent applications or websites from calling the Layer 2 API directly with an API key.
- The API is handled by Layer 3 so that the API key is not exposed directly in the application or website.

### 4. Folder Structure Change
The folder structure will be changed to:
```text
    AXION-Neuralis/
    ├── COMPANY/
    │   ├── OWNER-DECISION/
    │   ├── CHANGELOG.md
    │   ├── ARCH-AXN-V*.md
    │   ├── COMPANY-BIBLE-V*.md
    │   ├── COMPANY-BLUEPRINT-V*.md
    │   └── COMPANY-ROADMAP-V*.md
    ├── PROJECT/                              # This is only the main structure. Additional folders and structure will follow each project.
    │   └── PROJECT-NAME/
    │       ├── docs/                         # Required. For project documents and must not be freely published.
    │       │   ├── memo/                     # Short communication documents
    │       │   ├── proposal/                 # Proposal documents, full suggestions, and long-form communication
    │       │   ├── owner-decision/           # Owner decision documents
    │       │   ├── team/                     # Team information and team list, including roles and responsibilities
    │       │   ├── ARCH-PROJECT-V*.md
    │       │   ├── BIBLE.md
    │       │   ├── BLUEPRINT.md
    │       │   └── ROADMAP.md
    │       ├── CHANGELOG.md                  # Change log for the project/project documents
    │       ├── LICENSE                       # Project license. Does not include the docs/ folder.
    │       └── others (depending on the project)
    └── README.md                             # README for the team about the folder structure
```

**Needs confirmation:**
- The original note listed `BLUAPRINT.md`. Confirm whether the correct file name should be `BLUEPRINT.md`.

### 5. AXION Account
- The owner has decided to start creating the **AXION Account**.
- This will be added to the company ROADMAP because it is a company-level step.
- The company ROADMAP will only describe that AXION Neuralis has decided to start creating the AXION Account.
- The company ROADMAP will link to `AXION-Neuralis/PROJECT/axion-account/docs/ROADMAP.md`.

## Expected Output
Produce a draft **Owner Decision** document in Markdown indonesian based on the points above. Include:
- the decisions,
- the notes provided,
- the affected documents,
- and any items that require confirmation.

Do not add information that is not provided.