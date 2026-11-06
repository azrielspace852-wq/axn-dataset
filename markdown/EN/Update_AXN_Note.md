# Task: Update AXN Note to Version 1.1.3

## Context
You are working on **AXN Note**, a note-taking application. Please implement the following set of updates, fixes, and improvements.

## Working Instructions
- Create and maintain a **task list** in your workspace to track every item below. Do not skip, forget, or overlook any point.
- Once **all** tasks are complete, package the project as a **ZIP file** and deliver it to me.
- **Communicate with me in Indonesian** throughout the entire process.

---

## 1. AutoComplete (Paired Character Completion)

**Current state:** Space-based AutoComplete is already working correctly.

**Requirement:** Implement automatic pairing for the following characters:
- **Openers:** `[`, `{`, `(`, `"`, `'`
- **Closers:** `]`, `}`, `)`, `"`, `'`

**Behavior rules:**
1. When the user types an **opener**, its corresponding **closer** must appear immediately after the cursor.
2. **Duplicate prevention:** If a matching closer already exists on the same line without a preceding opener, typing the opener must **not** insert another closer.
3. **Smart deletion:**
   - If the user deletes an **opener**, its paired **closer** must also be deleted.
   - If the user deletes a **closer**, its paired **opener** must **remain** (only the closer is removed).

---

## 2. UI/UX Improvements

**Current state:** The UI looks good overall, but there are layout issues to fix.

**Issues to resolve on the Editor and Preview pages:**
- Currently, when the user types a long line, the **entire page** (including the top toolbar) stretches horizontally.
- **Expected behavior:** Only the text area (the note-editing / preview area) should expand.
- The top bar and any non-text-area elements must **not** stretch or overflow.
- Only the text area should be scrollable horizontally and vertically.

**Additional requirements:**
- Update both the **Editor** and **Preview** pages accordingly.
- Add a **viewport mode selector** with the following options: `Mobile`, `Desktop`, `Tablet`, `Auto`.
- Default mode: `Auto`. Users must be able to switch between modes.

---

## 3. New Feature: Viewport Mode

- Add a feature to change the display mode: `Desktop`, `Mobile`, `Tablet`, `Auto`.
- Default value: `Auto`.
- The setting must be changeable from the **Settings** page.

---

## 4. Update `CHANGELOG.md`
- Reflect all changes implemented above.

## 5. Update `README.md`
- Update the documentation to match the latest version.

## 6. Update `docs.html`
- Synchronize the documentation with `CHANGELOG.md` and `README.md`.

## 7. Version Bump
- Bump the version from **1.1.0** to **1.1.3**.

---

## Final Deliverable
- Complete **every** item above — do not skip or miss a single point.
- Track your progress using a task list in your workspace.
- When finished, deliver the project as a **ZIP file**.
- Respond and communicate with me in **Indonesian**.