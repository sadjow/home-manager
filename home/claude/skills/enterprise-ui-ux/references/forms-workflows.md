# Enterprise Form & Workflow UI/UX Best Practices (2024-2026)

> Comprehensive reference for corporate back-office information systems used daily by professionals.

---

## Table of Contents

1. [Form Layout](#1-form-layout)
2. [Validation](#2-validation)
3. [Multi-Step Forms / Wizards](#3-multi-step-forms--wizards)
4. [Data Entry Optimization](#4-data-entry-optimization)
5. [Complex Inputs](#5-complex-inputs)
6. [Approval Workflows](#6-approval-workflows)
7. [Accessibility](#7-accessibility)
8. [Performance](#8-performance)
9. [Sources](#9-sources)

---

## 1. Form Layout

### Single Column vs Multi-Column

**Use single-column layouts as the default.** Research from Baymard Institute shows that 16% of e-commerce sites still use multi-column forms, leading to checkout abandonment when users misinterpret the field sequence. NNGroup confirms: forms should never consist of more than one column because users interpret field sequences inconsistently.

Users complete single-column forms an average of **15.4 seconds faster** than multi-column equivalents.

**Exception:** Semantically related short fields (first name + last name, city + zip code, card number + expiry) can sit side-by-side without usability issues, as long as the overall layout remains single-column.

```html
<!-- Single-column layout with related inline fields -->
<form class="form" novalidate>
  <div class="form-section">
    <h2 class="form-section__heading">Personal Information</h2>

    <!-- Related fields can share a row -->
    <div class="form-row form-row--inline">
      <div class="form-field">
        <label for="first-name" class="form-field__label">
          First name
          <span class="form-field__required" aria-hidden="true">*</span>
        </label>
        <input
          type="text"
          id="first-name"
          name="first-name"
          autocomplete="given-name"
          required
          aria-required="true"
          class="form-field__input"
        />
      </div>
      <div class="form-field">
        <label for="last-name" class="form-field__label">
          Last name
          <span class="form-field__required" aria-hidden="true">*</span>
        </label>
        <input
          type="text"
          id="last-name"
          name="last-name"
          autocomplete="family-name"
          required
          aria-required="true"
          class="form-field__input"
        />
      </div>
    </div>

    <!-- Standard single-column field -->
    <div class="form-field">
      <label for="email" class="form-field__label">
        Email address
        <span class="form-field__required" aria-hidden="true">*</span>
      </label>
      <input
        type="email"
        id="email"
        name="email"
        autocomplete="email"
        required
        aria-required="true"
        class="form-field__input"
      />
    </div>
  </div>
</form>
```

```css
.form {
  max-width: 40rem;     /* constrain width for readability */
  margin: 0 auto;
}

.form-section {
  margin-block-end: 2rem;
  padding-block-end: 2rem;
  border-block-end: 1px solid var(--color-border, #e0e0e0);
}

.form-section__heading {
  font-size: 1.25rem;
  font-weight: 600;
  margin-block-end: 1.5rem;
  color: var(--color-heading, #1a1a1a);
}

.form-field {
  margin-block-end: 1.5rem;
}

.form-row--inline {
  display: flex;
  gap: 1rem;
}

.form-row--inline .form-field {
  flex: 1;
}

/* Collapse to single column on narrow viewports */
@media (max-width: 30rem) {
  .form-row--inline {
    flex-direction: column;
    gap: 0;
  }
}
```

### Label Placement: Top-Aligned

**Top-aligned labels produce the fastest completion times.** They have the least visual distance between label and input, creating the strongest cognitive association. Left-aligned labels produce the slowest completion times due to the eye-tracking distance.

Right-aligned labels improve proximity but create ragged left edges, slowing scanning on lengthy forms.

**Recommendation for enterprise daily-use forms:** Top-aligned labels by default. Consider right-aligned side labels only for very dense data-entry screens where vertical space is limited and users are highly trained.

```html
<!-- Top-aligned label pattern -->
<div class="form-field">
  <label for="department" class="form-field__label">
    Department
  </label>
  <p class="form-field__hint" id="department-hint">
    Select the department this request will be routed to.
  </p>
  <select
    id="department"
    name="department"
    aria-describedby="department-hint"
    class="form-field__select"
  >
    <option value="">-- Select department --</option>
    <option value="finance">Finance</option>
    <option value="hr">Human Resources</option>
    <option value="ops">Operations</option>
  </select>
</div>
```

```css
.form-field__label {
  display: block;
  font-weight: 600;
  font-size: 0.875rem;
  margin-block-end: 0.25rem;
  color: var(--color-label, #333);
}

.form-field__hint {
  font-size: 0.8125rem;
  color: var(--color-hint, #666);
  margin-block-end: 0.5rem;
  line-height: 1.4;
}

.form-field__input,
.form-field__select,
.form-field__textarea {
  display: block;
  width: 100%;
  padding: 0.625rem 0.75rem;
  font-size: 1rem;
  line-height: 1.5;
  border: 1px solid var(--color-input-border, #ccc);
  border-radius: 0.25rem;
  background-color: var(--color-input-bg, #fff);
  color: var(--color-input-text, #1a1a1a);
  transition: border-color 150ms ease, box-shadow 150ms ease;
}

.form-field__input:focus,
.form-field__select:focus,
.form-field__textarea:focus {
  outline: 2px solid var(--color-focus, #2563eb);
  outline-offset: 2px;
  border-color: var(--color-focus, #2563eb);
}
```

### Field Grouping with Fieldset and Legend

Group related fields using semantic `<fieldset>` and `<legend>` elements. This benefits screen reader users, who hear the legend announced when entering the group, and sighted users, who can quickly scan form sections.

```html
<!-- Grouping related fields -->
<fieldset class="form-fieldset">
  <legend class="form-fieldset__legend">Shipping Address</legend>

  <div class="form-field">
    <label for="street" class="form-field__label">Street address</label>
    <input
      type="text"
      id="street"
      name="street"
      autocomplete="shipping street-address"
      class="form-field__input"
    />
  </div>

  <div class="form-row form-row--inline">
    <div class="form-field" style="flex: 2;">
      <label for="city" class="form-field__label">City</label>
      <input
        type="text"
        id="city"
        name="city"
        autocomplete="shipping address-level2"
        class="form-field__input"
      />
    </div>
    <div class="form-field" style="flex: 1;">
      <label for="zip" class="form-field__label">Postal code</label>
      <input
        type="text"
        id="zip"
        name="zip"
        autocomplete="shipping postal-code"
        inputmode="numeric"
        class="form-field__input"
      />
    </div>
  </div>

  <div class="form-field">
    <label for="country" class="form-field__label">Country</label>
    <select
      id="country"
      name="country"
      autocomplete="shipping country"
      class="form-field__select"
    >
      <option value="">-- Select country --</option>
      <option value="US">United States</option>
      <option value="BR">Brazil</option>
      <!-- ... -->
    </select>
  </div>
</fieldset>
```

```css
.form-fieldset {
  border: 1px solid var(--color-border, #e0e0e0);
  border-radius: 0.5rem;
  padding: 1.5rem;
  margin-block-end: 2rem;
}

.form-fieldset__legend {
  font-weight: 700;
  font-size: 1.125rem;
  padding-inline: 0.5rem;
  color: var(--color-heading, #1a1a1a);
}
```

### Progressive Disclosure

Reveal information in manageable layers. Show advanced or conditional fields only when relevant, based on prior selections.

```html
<!-- Progressive disclosure: show fields conditionally -->
<div class="form-field">
  <label for="expense-type" class="form-field__label">Expense type</label>
  <select id="expense-type" name="expense-type" class="form-field__select"
          aria-controls="travel-details">
    <option value="">-- Select type --</option>
    <option value="travel">Travel</option>
    <option value="supplies">Office Supplies</option>
    <option value="software">Software License</option>
  </select>
</div>

<!-- Conditionally revealed section -->
<fieldset
  id="travel-details"
  class="form-fieldset form-fieldset--conditional"
  hidden
>
  <legend class="form-fieldset__legend">Travel Details</legend>
  <div class="form-field">
    <label for="destination" class="form-field__label">Destination</label>
    <input type="text" id="destination" name="destination"
           class="form-field__input" />
  </div>
  <div class="form-row form-row--inline">
    <div class="form-field">
      <label for="depart-date" class="form-field__label">Departure date</label>
      <input type="date" id="depart-date" name="depart-date"
             class="form-field__input" />
    </div>
    <div class="form-field">
      <label for="return-date" class="form-field__label">Return date</label>
      <input type="date" id="return-date" name="return-date"
             class="form-field__input" />
    </div>
  </div>
</fieldset>
```

```js
// Progressive disclosure controller
document.getElementById('expense-type').addEventListener('change', (e) => {
  const travelDetails = document.getElementById('travel-details');
  const shouldShow = e.target.value === 'travel';
  travelDetails.hidden = !shouldShow;

  // Manage required state of revealed fields
  travelDetails.querySelectorAll('input').forEach((input) => {
    if (shouldShow) {
      input.setAttribute('required', '');
      input.setAttribute('aria-required', 'true');
    } else {
      input.removeAttribute('required');
      input.removeAttribute('aria-required');
      input.value = '';
    }
  });
});
```

---

## 2. Validation

### The Reward-Early, Punish-Late Pattern

This is the gold standard for inline validation timing, originally developed by Mihael Konjevic and widely recommended by Smashing Magazine and Vitaly Friedman.

**Rules:**

| Field state before edit | When to validate | Rationale |
|---|---|---|
| Previously **invalid** (has error) | **Immediately** as user types (on input) | Remove the error as soon as the fix is confirmed (reward early) |
| Previously **valid** or **untouched** | **On blur** (after user leaves field) | Do not interrupt while typing (punish late) |
| **Empty required field** | **On submit** only | Cannot know if user intends to fill it later |

**Debounce timing:** When validating during typing (for erroneous fields), wait 300-500ms after the last keystroke. For password strength and username availability, inline-as-you-type with 500-1000ms debounce is acceptable.

```html
<!-- Field with validation states -->
<div class="form-field" data-validation-state="idle">
  <label for="invoice-number" class="form-field__label">
    Invoice number
    <span class="form-field__required" aria-hidden="true">*</span>
  </label>
  <p class="form-field__hint" id="invoice-hint">
    Format: INV-YYYY-NNNN (e.g., INV-2025-0042)
  </p>
  <input
    type="text"
    id="invoice-number"
    name="invoice-number"
    required
    aria-required="true"
    aria-describedby="invoice-hint invoice-error"
    aria-invalid="false"
    pattern="INV-\d{4}-\d{4}"
    class="form-field__input"
  />
  <p
    class="form-field__error"
    id="invoice-error"
    role="alert"
    aria-live="assertive"
    hidden
  >
    <!-- Error message injected here -->
  </p>
  <p class="form-field__success" id="invoice-success" hidden>
    <span aria-hidden="true">&#10003;</span> Valid invoice number
  </p>
</div>
```

```css
/* Validation visual states */
.form-field__input[aria-invalid="true"] {
  border-color: var(--color-error, #dc2626);
  box-shadow: inset 0 0 0 1px var(--color-error, #dc2626);
}

.form-field__input[aria-invalid="true"]:focus {
  outline-color: var(--color-error, #dc2626);
}

.form-field__error {
  color: var(--color-error, #dc2626);
  font-size: 0.8125rem;
  margin-block-start: 0.375rem;
  display: flex;
  align-items: flex-start;
  gap: 0.25rem;
  line-height: 1.4;
}

.form-field__error::before {
  content: '';
  display: inline-block;
  width: 1rem;
  height: 1rem;
  flex-shrink: 0;
  /* Use an SVG error icon as background */
  background: url("data:image/svg+xml,...") no-repeat center / contain;
}

/* Success state */
.form-field__success {
  color: var(--color-success, #16a34a);
  font-size: 0.8125rem;
  margin-block-start: 0.375rem;
}

/* Never rely solely on color; use icons + text */
.form-field[data-validation-state="valid"] .form-field__input {
  border-color: var(--color-success, #16a34a);
}
```

```js
// Reward-early, punish-late validation controller
class FieldValidator {
  constructor(field) {
    this.field = field;
    this.input = field.querySelector('input, select, textarea');
    this.errorEl = field.querySelector('.form-field__error');
    this.successEl = field.querySelector('.form-field__success');
    this.wasInvalid = false;
    this.debounceTimer = null;

    this.input.addEventListener('blur', () => this.handleBlur());
    this.input.addEventListener('input', () => this.handleInput());
  }

  handleBlur() {
    // Punish late: validate on blur for fields not yet marked invalid
    if (!this.wasInvalid) {
      this.validate();
    }
  }

  handleInput() {
    // Reward early: validate immediately (debounced) for previously-invalid fields
    if (this.wasInvalid) {
      clearTimeout(this.debounceTimer);
      this.debounceTimer = setTimeout(() => this.validate(), 300);
    }
  }

  validate() {
    const isValid = this.input.checkValidity();

    if (!isValid) {
      this.showError(this.getErrorMessage());
      this.wasInvalid = true;
    } else {
      this.clearError();
      if (this.wasInvalid) {
        this.showSuccess();
      }
      this.wasInvalid = false;
    }
  }

  showError(message) {
    this.input.setAttribute('aria-invalid', 'true');
    this.errorEl.textContent = message;
    this.errorEl.hidden = false;
    this.successEl.hidden = true;
    this.field.dataset.validationState = 'invalid';
  }

  clearError() {
    this.input.setAttribute('aria-invalid', 'false');
    this.errorEl.textContent = '';
    this.errorEl.hidden = true;
    this.field.dataset.validationState = 'valid';
  }

  showSuccess() {
    this.successEl.hidden = false;
    // Auto-hide success after 3 seconds to reduce visual clutter
    setTimeout(() => { this.successEl.hidden = true; }, 3000);
  }

  getErrorMessage() {
    const input = this.input;
    if (input.validity.valueMissing) return `${this.getLabelText()} is required.`;
    if (input.validity.patternMismatch) return input.title || 'Please match the required format.';
    if (input.validity.typeMismatch) return `Please enter a valid ${input.type}.`;
    if (input.validity.tooShort) return `Must be at least ${input.minLength} characters.`;
    return 'Please correct this field.';
  }

  getLabelText() {
    const label = this.field.querySelector('label');
    return label?.textContent?.replace('*', '').trim() || 'This field';
  }
}
```

### Form-Level Error Summary

On submit, display an error summary at the top of the form with links to each invalid field. This is a WCAG requirement (3.3.1) and a pattern used by the UK Government Design System (GOV.UK).

```html
<!-- Error summary: shown on failed submission -->
<div
  class="form-error-summary"
  role="alert"
  aria-labelledby="error-summary-heading"
  tabindex="-1"
  hidden
>
  <h2 id="error-summary-heading" class="form-error-summary__heading">
    There are 3 problems with your submission
  </h2>
  <ul class="form-error-summary__list">
    <li>
      <a href="#invoice-number">Invoice number must match format INV-YYYY-NNNN</a>
    </li>
    <li>
      <a href="#amount">Amount is required</a>
    </li>
    <li>
      <a href="#vendor">Please select a vendor</a>
    </li>
  </ul>
</div>
```

```css
.form-error-summary {
  border: 2px solid var(--color-error, #dc2626);
  border-radius: 0.5rem;
  padding: 1.25rem;
  margin-block-end: 2rem;
  background-color: var(--color-error-bg, #fef2f2);
}

.form-error-summary__heading {
  font-size: 1.125rem;
  font-weight: 700;
  color: var(--color-error, #dc2626);
  margin-block-end: 0.75rem;
}

.form-error-summary__list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.form-error-summary__list li {
  margin-block-end: 0.5rem;
}

.form-error-summary__list a {
  color: var(--color-error, #dc2626);
  text-decoration: underline;
  font-weight: 500;
}

.form-error-summary__list a:hover {
  text-decoration: none;
}
```

```js
// Form submission with error summary
function handleSubmit(form) {
  const errorSummary = form.querySelector('.form-error-summary');
  const errorList = errorSummary.querySelector('.form-error-summary__list');
  const invalidFields = form.querySelectorAll(':invalid');

  if (invalidFields.length > 0) {
    errorList.innerHTML = '';

    const heading = errorSummary.querySelector('h2');
    heading.textContent = `There ${
      invalidFields.length === 1 ? 'is 1 problem' : `are ${invalidFields.length} problems`
    } with your submission`;

    invalidFields.forEach((field) => {
      const label = form.querySelector(`label[for="${field.id}"]`);
      const li = document.createElement('li');
      const a = document.createElement('a');
      a.href = `#${field.id}`;
      a.textContent = `${label?.textContent?.replace('*', '').trim()}: ${field.validationMessage}`;
      li.appendChild(a);
      errorList.appendChild(li);
    });

    errorSummary.hidden = false;
    errorSummary.focus();
    return false;
  }

  errorSummary.hidden = true;
  return true;
}
```

---

## 3. Multi-Step Forms / Wizards

### Progress Indicator

Use a step indicator for linear forms with 3+ sections. The USWDS (U.S. Web Design System) step indicator provides a well-tested, accessible pattern.

```html
<!-- Step indicator based on USWDS pattern -->
<div class="step-indicator" aria-label="Progress">
  <ol class="step-indicator__segments" role="list">
    <li class="step-indicator__segment step-indicator__segment--complete">
      <span class="step-indicator__segment-label">
        Requestor Info
        <span class="sr-only">completed</span>
      </span>
    </li>
    <li class="step-indicator__segment step-indicator__segment--current"
        aria-current="step">
      <span class="step-indicator__segment-label">
        Expense Details
        <span class="sr-only">current step</span>
      </span>
    </li>
    <li class="step-indicator__segment">
      <span class="step-indicator__segment-label">
        Attachments
        <span class="sr-only">not yet reached</span>
      </span>
    </li>
    <li class="step-indicator__segment">
      <span class="step-indicator__segment-label">
        Review & Submit
        <span class="sr-only">not yet reached</span>
      </span>
    </li>
  </ol>
  <div class="step-indicator__header">
    <h2 class="step-indicator__heading">
      <span class="step-indicator__heading-counter">
        <span class="sr-only">Step</span>
        <span class="step-indicator__current-step">2</span>
        <span class="sr-only">of</span>
        <span class="step-indicator__total-steps">4</span>
      </span>
      <span class="step-indicator__heading-text">Expense Details</span>
    </h2>
  </div>
</div>
```

```css
.step-indicator__segments {
  display: flex;
  list-style: none;
  padding: 0;
  margin: 0;
  gap: 0.25rem;
  counter-reset: step;
}

.step-indicator__segment {
  flex: 1;
  height: 0.5rem;
  background-color: var(--color-step-pending, #e5e7eb);
  border-radius: 999px;
  position: relative;
}

.step-indicator__segment--complete {
  background-color: var(--color-step-complete, #2563eb);
}

.step-indicator__segment--current {
  background-color: var(--color-step-current, #2563eb);
}

.step-indicator__segment-label {
  display: block;
  font-size: 0.75rem;
  color: var(--color-hint, #666);
  margin-block-start: 0.75rem;
  text-align: center;
}

.step-indicator__segment--complete .step-indicator__segment-label,
.step-indicator__segment--current .step-indicator__segment-label {
  color: var(--color-label, #333);
  font-weight: 600;
}

.step-indicator__header {
  margin-block-start: 1.5rem;
}

.step-indicator__heading {
  font-size: 1.25rem;
  font-weight: 700;
}

.step-indicator__heading-counter {
  color: var(--color-hint, #666);
  font-weight: 400;
  margin-inline-end: 0.5rem;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border-width: 0;
}
```

### Page Title for Multi-Step

Include the step in the `<title>` so screen reader users and browser tab labels communicate progress:

```html
<title>Step 2 of 4: Expense Details - Expense Report - ACME Corp</title>
```

### Step Validation

Validate each step before advancing. Prevent forward navigation to unvalidated steps but always allow backward navigation to completed steps.

```html
<!-- Step navigation buttons -->
<div class="step-navigation" role="group" aria-label="Form navigation">
  <button type="button" class="btn btn--secondary" id="btn-back"
          aria-label="Go back to Requestor Info">
    Back
  </button>
  <button type="button" class="btn btn--ghost" id="btn-save"
          aria-label="Save progress and continue later">
    Save Draft
  </button>
  <button type="button" class="btn btn--primary" id="btn-next"
          aria-label="Continue to Attachments">
    Continue
  </button>
</div>
```

```css
.step-navigation {
  display: flex;
  gap: 1rem;
  margin-block-start: 2rem;
  padding-block-start: 1.5rem;
  border-block-start: 1px solid var(--color-border, #e0e0e0);
}

.btn {
  padding: 0.625rem 1.5rem;
  font-size: 0.9375rem;
  font-weight: 600;
  border-radius: 0.375rem;
  cursor: pointer;
  border: 2px solid transparent;
  transition: background-color 150ms ease, border-color 150ms ease;
}

.btn--primary {
  background-color: var(--color-primary, #2563eb);
  color: #fff;
  margin-inline-start: auto;
}

.btn--primary:hover {
  background-color: var(--color-primary-hover, #1d4ed8);
}

.btn--secondary {
  background-color: transparent;
  color: var(--color-primary, #2563eb);
  border-color: var(--color-primary, #2563eb);
}

.btn--ghost {
  background-color: transparent;
  color: var(--color-hint, #666);
  border-color: transparent;
}

.btn:focus-visible {
  outline: 2px solid var(--color-focus, #2563eb);
  outline-offset: 2px;
}
```

### Save Partial State

For enterprise forms that require detailed inputs (budgets, specs, team assignments), save progress automatically and support explicit "Save Draft" actions.

```js
// Auto-save partial form state
class FormAutoSave {
  constructor(form, { storageKey, debounceMs = 2000 }) {
    this.form = form;
    this.storageKey = storageKey;
    this.debounceMs = debounceMs;
    this.timer = null;
    this.statusEl = form.querySelector('.autosave-status');

    this.restore();
    this.form.addEventListener('input', () => this.scheduleAutoSave());
    this.form.addEventListener('change', () => this.scheduleAutoSave());
  }

  scheduleAutoSave() {
    clearTimeout(this.timer);
    this.timer = setTimeout(() => this.save(), this.debounceMs);
  }

  save() {
    const data = new FormData(this.form);
    const serialized = Object.fromEntries(data.entries());
    localStorage.setItem(this.storageKey, JSON.stringify({
      data: serialized,
      savedAt: new Date().toISOString(),
      currentStep: this.form.dataset.currentStep,
    }));
    this.showStatus('Draft saved');
  }

  restore() {
    const stored = localStorage.getItem(this.storageKey);
    if (!stored) return;

    const { data, savedAt } = JSON.parse(stored);
    Object.entries(data).forEach(([name, value]) => {
      const field = this.form.elements[name];
      if (field) field.value = value;
    });
    this.showStatus(`Restored draft from ${new Date(savedAt).toLocaleString()}`);
  }

  showStatus(message) {
    if (!this.statusEl) return;
    this.statusEl.textContent = message;
    this.statusEl.setAttribute('role', 'status');
    setTimeout(() => { this.statusEl.textContent = ''; }, 4000);
  }

  clear() {
    localStorage.removeItem(this.storageKey);
  }
}
```

```html
<!-- Auto-save status indicator -->
<p class="autosave-status" aria-live="polite" aria-atomic="true"></p>
```

---

## 4. Data Entry Optimization

### Autofill and Autocomplete Attributes

Use HTML `autocomplete` attributes (WCAG 1.3.5, Level AA). There are 53 standardized autofill tokens. This enables browser autofill, reduces keystrokes, and helps users with cognitive disabilities.

```html
<!-- Correct autocomplete tokens for common enterprise fields -->
<input autocomplete="given-name"   name="first_name"  />
<input autocomplete="family-name"  name="last_name"   />
<input autocomplete="email"        name="email"        type="email" />
<input autocomplete="tel"          name="phone"        type="tel" />
<input autocomplete="organization" name="company"      />

<!-- Billing address -->
<input autocomplete="billing street-address" name="billing_street" />
<input autocomplete="billing address-level2" name="billing_city"   />
<input autocomplete="billing postal-code"    name="billing_zip"    />
<input autocomplete="billing country"        name="billing_country" />

<!-- Shipping address -->
<input autocomplete="shipping street-address" name="shipping_street" />

<!-- Credit card -->
<input autocomplete="cc-name"   name="card_name"   />
<input autocomplete="cc-number" name="card_number"  inputmode="numeric" />
<input autocomplete="cc-exp"    name="card_expiry"  />
<input autocomplete="cc-csc"    name="card_cvv"     inputmode="numeric" />
```

### Smart Defaults

Pre-fill fields with the most likely values based on context, user history, or organizational defaults.

```html
<!-- Smart defaults for a purchase order form -->
<div class="form-field">
  <label for="currency" class="form-field__label">Currency</label>
  <select id="currency" name="currency" class="form-field__select">
    <!-- Default based on user's locale / org setting -->
    <option value="USD" selected>USD - US Dollar</option>
    <option value="EUR">EUR - Euro</option>
    <option value="BRL">BRL - Brazilian Real</option>
    <option value="GBP">GBP - British Pound</option>
  </select>
</div>

<div class="form-field">
  <label for="request-date" class="form-field__label">Request date</label>
  <input
    type="date"
    id="request-date"
    name="request-date"
    class="form-field__input"
  />
  <!-- Default to today via JS -->
</div>
```

```js
// Set smart defaults
document.getElementById('request-date').valueAsDate = new Date();
```

### Typeahead / Combobox for Large Datasets

For fields with hundreds of possible values (vendor names, cost centers, employee directories), use a combobox with typeahead filtering instead of a plain `<select>`.

```html
<!-- Accessible combobox / typeahead -->
<div class="form-field combobox" role="combobox"
     aria-expanded="false" aria-haspopup="listbox">
  <label for="vendor-search" class="form-field__label">Vendor</label>
  <input
    type="text"
    id="vendor-search"
    class="form-field__input"
    role="combobox"
    aria-autocomplete="list"
    aria-controls="vendor-listbox"
    aria-activedescendant=""
    autocomplete="off"
    placeholder="Start typing vendor name..."
  />
  <ul id="vendor-listbox" role="listbox" class="combobox__listbox" hidden>
    <!-- Options populated dynamically -->
  </ul>
  <p class="combobox__status sr-only" aria-live="polite" aria-atomic="true">
    <!-- "3 results available" announced to screen readers -->
  </p>
</div>
```

```css
.combobox {
  position: relative;
}

.combobox__listbox {
  position: absolute;
  z-index: 10;
  top: 100%;
  left: 0;
  right: 0;
  max-height: 16rem;
  overflow-y: auto;
  border: 1px solid var(--color-input-border, #ccc);
  border-radius: 0 0 0.25rem 0.25rem;
  background: var(--color-input-bg, #fff);
  box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
  list-style: none;
  padding: 0;
  margin: 0;
}

.combobox__option {
  padding: 0.625rem 0.75rem;
  cursor: pointer;
  font-size: 0.9375rem;
}

.combobox__option:hover,
.combobox__option[aria-selected="true"] {
  background-color: var(--color-option-hover, #eff6ff);
}

.combobox__option mark {
  background-color: var(--color-highlight, #fef08a);
  font-weight: 600;
}
```

### Recently Used Values

Track and surface frequently or recently used values at the top of dropdown lists.

```html
<ul id="vendor-listbox" role="listbox" class="combobox__listbox">
  <li role="presentation" class="combobox__group-label">Recently used</li>
  <li role="option" id="vendor-1" class="combobox__option">Acme Supplies Inc.</li>
  <li role="option" id="vendor-2" class="combobox__option">Global Tech Partners</li>
  <li role="separator" aria-hidden="true"></li>
  <li role="presentation" class="combobox__group-label">All vendors</li>
  <li role="option" id="vendor-3" class="combobox__option">ABC Logistics</li>
  <!-- ... -->
</ul>
```

### Keyboard Shortcuts for Power Users

Enterprise power users spend hours daily in forms. Provide keyboard shortcuts that echo familiar conventions.

```html
<!-- Keyboard shortcut legend (available via Ctrl+/ or ?) -->
<dialog id="shortcuts-dialog" class="shortcuts-dialog" aria-labelledby="shortcuts-heading">
  <h2 id="shortcuts-heading">Keyboard Shortcuts</h2>
  <dl class="shortcuts-list">
    <div class="shortcuts-list__item">
      <dt><kbd>Ctrl</kbd> + <kbd>Enter</kbd></dt>
      <dd>Submit form</dd>
    </div>
    <div class="shortcuts-list__item">
      <dt><kbd>Ctrl</kbd> + <kbd>S</kbd></dt>
      <dd>Save draft</dd>
    </div>
    <div class="shortcuts-list__item">
      <dt><kbd>Alt</kbd> + <kbd>N</kbd></dt>
      <dd>Next step</dd>
    </div>
    <div class="shortcuts-list__item">
      <dt><kbd>Alt</kbd> + <kbd>P</kbd></dt>
      <dd>Previous step</dd>
    </div>
    <div class="shortcuts-list__item">
      <dt><kbd>Escape</kbd></dt>
      <dd>Cancel / close dialog</dd>
    </div>
    <div class="shortcuts-list__item">
      <dt><kbd>?</kbd></dt>
      <dd>Show this help</dd>
    </div>
  </dl>
  <button type="button" class="btn btn--secondary" autofocus>Close</button>
</dialog>
```

```css
.shortcuts-dialog {
  max-width: 28rem;
  border-radius: 0.5rem;
  border: 1px solid var(--color-border, #e0e0e0);
  box-shadow: 0 10px 15px -3px rgb(0 0 0 / 0.1);
  padding: 1.5rem;
}

.shortcuts-dialog::backdrop {
  background-color: rgb(0 0 0 / 0.3);
}

.shortcuts-list__item {
  display: flex;
  justify-content: space-between;
  padding: 0.5rem 0;
  border-block-end: 1px solid var(--color-border, #e0e0e0);
}

kbd {
  display: inline-block;
  padding: 0.125rem 0.375rem;
  font-size: 0.8125rem;
  font-family: inherit;
  background: var(--color-kbd-bg, #f3f4f6);
  border: 1px solid var(--color-border, #d1d5db);
  border-radius: 0.25rem;
  box-shadow: 0 1px 0 var(--color-border, #d1d5db);
}
```

```js
// Global keyboard shortcut handler
document.addEventListener('keydown', (e) => {
  // Ctrl+Enter to submit
  if (e.ctrlKey && e.key === 'Enter') {
    e.preventDefault();
    document.querySelector('form')?.requestSubmit();
  }

  // Ctrl+S to save draft
  if (e.ctrlKey && e.key === 's') {
    e.preventDefault();
    document.getElementById('btn-save')?.click();
  }

  // ? to show shortcut help (only when not in an input)
  if (e.key === '?' && !['INPUT', 'TEXTAREA', 'SELECT'].includes(e.target.tagName)) {
    document.getElementById('shortcuts-dialog')?.showModal();
  }
});
```

---

## 5. Complex Inputs

### Date and Time Pickers

Per NNGroup: use calendar pickers for dates within a year of the present. For dates far in the past or future (date of birth, historical records), use text input fields.

**Always accept flexible formatting:** dashes, slashes, dots, spaces. Do not require leading zeros. Spell out month names or use separate fields to avoid DD/MM vs MM/DD ambiguity.

```html
<!-- Date input: separate fields for unambiguous entry -->
<fieldset class="form-fieldset">
  <legend class="form-fieldset__legend">Date of birth</legend>
  <div class="form-row form-row--inline form-row--compact">
    <div class="form-field">
      <label for="dob-month" class="form-field__label">Month</label>
      <select id="dob-month" name="dob-month" autocomplete="bday-month"
              class="form-field__select">
        <option value="">MM</option>
        <option value="01">01 - January</option>
        <option value="02">02 - February</option>
        <!-- ... -->
        <option value="12">12 - December</option>
      </select>
    </div>
    <div class="form-field">
      <label for="dob-day" class="form-field__label">Day</label>
      <input type="text" id="dob-day" name="dob-day"
             inputmode="numeric" maxlength="2" autocomplete="bday-day"
             class="form-field__input form-field__input--narrow"
             placeholder="DD" />
    </div>
    <div class="form-field">
      <label for="dob-year" class="form-field__label">Year</label>
      <input type="text" id="dob-year" name="dob-year"
             inputmode="numeric" maxlength="4" autocomplete="bday-year"
             class="form-field__input form-field__input--narrow"
             placeholder="YYYY" />
    </div>
  </div>
</fieldset>

<!-- Date range: calendar picker for near-future dates -->
<fieldset class="form-fieldset">
  <legend class="form-fieldset__legend">Travel dates</legend>
  <div class="form-row form-row--inline">
    <div class="form-field">
      <label for="depart" class="form-field__label">Departure</label>
      <input type="date" id="depart" name="depart"
             min="2025-01-01" class="form-field__input" />
    </div>
    <div class="form-field">
      <label for="return" class="form-field__label">Return</label>
      <input type="date" id="return" name="return"
             class="form-field__input" />
    </div>
  </div>
</fieldset>
```

```css
.form-field__input--narrow {
  max-width: 5rem;
  text-align: center;
}

.form-row--compact {
  gap: 0.75rem;
}

.form-row--compact .form-field {
  flex: 0 0 auto;
}
```

### Currency Inputs

Use the ISO 4217 currency code (not symbols, since `$` is ambiguous). Separate the currency selector from the amount field. Use `inputmode="decimal"` for numeric entry on mobile.

```html
<!-- Currency input -->
<fieldset class="form-fieldset">
  <legend class="form-fieldset__legend">Amount</legend>
  <div class="currency-input">
    <div class="currency-input__code">
      <label for="currency-code" class="sr-only">Currency</label>
      <select id="currency-code" name="currency-code" class="form-field__select"
              aria-label="Currency">
        <option value="USD">USD</option>
        <option value="EUR">EUR</option>
        <option value="BRL">BRL</option>
        <option value="GBP">GBP</option>
      </select>
    </div>
    <div class="currency-input__amount">
      <label for="amount" class="sr-only">Amount</label>
      <input
        type="text"
        id="amount"
        name="amount"
        inputmode="decimal"
        pattern="[0-9]*\.?[0-9]{0,2}"
        placeholder="0.00"
        aria-describedby="amount-hint"
        class="form-field__input"
      />
    </div>
  </div>
  <p id="amount-hint" class="form-field__hint">Enter the amount in the selected currency.</p>
</fieldset>
```

```css
.currency-input {
  display: flex;
}

.currency-input__code select {
  border-radius: 0.25rem 0 0 0.25rem;
  border-inline-end: none;
  min-width: 5rem;
}

.currency-input__amount {
  flex: 1;
}

.currency-input__amount input {
  border-radius: 0 0.25rem 0.25rem 0;
}
```

### Phone Number Fields

Provide a country code selector with flag indicators. Accept any reasonable format and normalize server-side. Use `type="tel"` and `autocomplete="tel"`.

```html
<!-- Phone number input -->
<div class="form-field phone-input">
  <label for="phone" class="form-field__label">Phone number</label>
  <div class="phone-input__wrapper">
    <select id="phone-country" name="phone-country" class="form-field__select"
            aria-label="Country code">
      <option value="+1">+1 (US)</option>
      <option value="+55">+55 (BR)</option>
      <option value="+44">+44 (UK)</option>
      <option value="+49">+49 (DE)</option>
    </select>
    <input
      type="tel"
      id="phone"
      name="phone"
      autocomplete="tel-national"
      class="form-field__input"
      placeholder="(555) 123-4567"
      aria-describedby="phone-hint"
    />
  </div>
  <p id="phone-hint" class="form-field__hint">
    We accept any format. We will normalize it for you.
  </p>
</div>
```

```css
.phone-input__wrapper {
  display: flex;
}

.phone-input__wrapper select {
  flex: 0 0 8rem;
  border-radius: 0.25rem 0 0 0.25rem;
  border-inline-end: none;
}

.phone-input__wrapper input {
  flex: 1;
  border-radius: 0 0.25rem 0.25rem 0;
}
```

### File Upload with Drag-and-Drop and Preview

Support both click-to-browse and drag-and-drop. Show progress, file previews, and provide an accessible alternative.

```html
<!-- File upload with drag-and-drop -->
<div class="form-field">
  <label for="attachments" class="form-field__label">Attachments</label>
  <div
    class="file-upload"
    id="file-drop-zone"
    role="region"
    aria-label="File upload area"
  >
    <div class="file-upload__prompt">
      <svg class="file-upload__icon" aria-hidden="true" width="40" height="40" viewBox="0 0 24 24">
        <path d="M12 16V4m0 0L8 8m4-4l4 4M4 17v2a1 1 0 001 1h14a1 1 0 001-1v-2"
              stroke="currentColor" stroke-width="1.5" fill="none" stroke-linecap="round"/>
      </svg>
      <p class="file-upload__text">
        Drag and drop files here, or
        <label for="attachments" class="file-upload__browse" role="button" tabindex="0">
          browse files
        </label>
      </p>
      <p class="file-upload__constraints">
        PDF, PNG, JPG up to 10 MB each. Maximum 5 files.
      </p>
    </div>
    <input
      type="file"
      id="attachments"
      name="attachments"
      multiple
      accept=".pdf,.png,.jpg,.jpeg"
      class="file-upload__input sr-only"
      aria-describedby="file-upload-status"
    />
  </div>

  <!-- File list with previews and progress -->
  <ul class="file-upload__list" aria-live="polite" id="file-upload-status">
    <!-- Populated dynamically -->
  </ul>
</div>
```

```css
.file-upload {
  border: 2px dashed var(--color-input-border, #ccc);
  border-radius: 0.5rem;
  padding: 2rem;
  text-align: center;
  transition: border-color 150ms ease, background-color 150ms ease;
  cursor: pointer;
}

.file-upload:hover,
.file-upload--dragover {
  border-color: var(--color-primary, #2563eb);
  background-color: var(--color-primary-bg, #eff6ff);
}

.file-upload__icon {
  color: var(--color-hint, #9ca3af);
  margin-block-end: 0.75rem;
}

.file-upload__text {
  font-size: 0.9375rem;
  color: var(--color-label, #333);
}

.file-upload__browse {
  color: var(--color-primary, #2563eb);
  text-decoration: underline;
  cursor: pointer;
}

.file-upload__constraints {
  font-size: 0.8125rem;
  color: var(--color-hint, #666);
  margin-block-start: 0.5rem;
}

/* File list items */
.file-upload__list {
  list-style: none;
  padding: 0;
  margin-block-start: 1rem;
}

.file-upload__item {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem;
  border: 1px solid var(--color-border, #e0e0e0);
  border-radius: 0.375rem;
  margin-block-end: 0.5rem;
}

.file-upload__item-preview {
  width: 2.5rem;
  height: 2.5rem;
  object-fit: cover;
  border-radius: 0.25rem;
  flex-shrink: 0;
}

.file-upload__item-info {
  flex: 1;
  min-width: 0;
}

.file-upload__item-name {
  font-size: 0.875rem;
  font-weight: 500;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.file-upload__item-size {
  font-size: 0.75rem;
  color: var(--color-hint, #666);
}

.file-upload__item-progress {
  width: 100%;
  height: 0.375rem;
  border-radius: 999px;
  appearance: none;
  margin-block-start: 0.25rem;
}

.file-upload__item-progress::-webkit-progress-bar {
  background: var(--color-border, #e5e7eb);
  border-radius: 999px;
}

.file-upload__item-progress::-webkit-progress-value {
  background: var(--color-primary, #2563eb);
  border-radius: 999px;
}

.file-upload__item-remove {
  background: none;
  border: none;
  color: var(--color-hint, #666);
  cursor: pointer;
  padding: 0.25rem;
  flex-shrink: 0;
}

.file-upload__item-remove:hover {
  color: var(--color-error, #dc2626);
}
```

---

## 6. Approval Workflows

### Status Indicators

Use clear, visually distinct status badges with both color and text (never color alone). A timeline pattern shows the full history of a request.

```html
<!-- Status badge component -->
<span class="status-badge status-badge--pending">
  <span class="status-badge__dot" aria-hidden="true"></span>
  Pending Approval
</span>

<span class="status-badge status-badge--approved">
  <span class="status-badge__dot" aria-hidden="true"></span>
  Approved
</span>

<span class="status-badge status-badge--rejected">
  <span class="status-badge__dot" aria-hidden="true"></span>
  Rejected
</span>

<span class="status-badge status-badge--draft">
  <span class="status-badge__dot" aria-hidden="true"></span>
  Draft
</span>

<span class="status-badge status-badge--in-review">
  <span class="status-badge__dot" aria-hidden="true"></span>
  In Review
</span>
```

```css
.status-badge {
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.25rem 0.75rem;
  border-radius: 999px;
  font-size: 0.8125rem;
  font-weight: 600;
  line-height: 1.4;
}

.status-badge__dot {
  width: 0.5rem;
  height: 0.5rem;
  border-radius: 50%;
  flex-shrink: 0;
}

.status-badge--draft {
  background-color: #f3f4f6;
  color: #374151;
}
.status-badge--draft .status-badge__dot { background-color: #6b7280; }

.status-badge--pending {
  background-color: #fef3c7;
  color: #92400e;
}
.status-badge--pending .status-badge__dot { background-color: #f59e0b; }

.status-badge--in-review {
  background-color: #dbeafe;
  color: #1e40af;
}
.status-badge--in-review .status-badge__dot { background-color: #3b82f6; }

.status-badge--approved {
  background-color: #dcfce7;
  color: #166534;
}
.status-badge--approved .status-badge__dot { background-color: #22c55e; }

.status-badge--rejected {
  background-color: #fee2e2;
  color: #991b1b;
}
.status-badge--rejected .status-badge__dot { background-color: #ef4444; }
```

### Approval Action Buttons

```html
<!-- Approval actions for a reviewer -->
<div class="approval-actions" role="group" aria-label="Approval actions">
  <button type="button" class="btn btn--approve">
    <svg aria-hidden="true" width="16" height="16" viewBox="0 0 16 16">
      <path d="M13.5 4.5L6 12 2.5 8.5" stroke="currentColor"
            stroke-width="2" fill="none" stroke-linecap="round"/>
    </svg>
    Approve
  </button>
  <button type="button" class="btn btn--request-changes">
    Request Changes
  </button>
  <button type="button" class="btn btn--reject">
    Reject
  </button>
</div>

<!-- Confirmation dialog for destructive actions -->
<dialog id="reject-dialog" class="confirm-dialog" aria-labelledby="reject-heading">
  <h2 id="reject-heading">Reject this request?</h2>
  <div class="form-field">
    <label for="reject-reason" class="form-field__label">
      Reason for rejection
      <span class="form-field__required" aria-hidden="true">*</span>
    </label>
    <textarea
      id="reject-reason"
      name="reject-reason"
      required
      aria-required="true"
      rows="3"
      class="form-field__textarea"
      placeholder="Provide a reason so the requestor can make corrections..."
    ></textarea>
  </div>
  <div class="confirm-dialog__actions">
    <button type="button" class="btn btn--secondary" value="cancel">Cancel</button>
    <button type="button" class="btn btn--reject" value="confirm">Reject Request</button>
  </div>
</dialog>
```

```css
.approval-actions {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.btn--approve {
  display: inline-flex;
  align-items: center;
  gap: 0.375rem;
  background-color: var(--color-success, #16a34a);
  color: #fff;
  border: 2px solid transparent;
}

.btn--approve:hover {
  background-color: #15803d;
}

.btn--request-changes {
  background-color: transparent;
  color: var(--color-warning, #d97706);
  border: 2px solid var(--color-warning, #d97706);
}

.btn--reject {
  background-color: transparent;
  color: var(--color-error, #dc2626);
  border: 2px solid var(--color-error, #dc2626);
}

.btn--reject:hover {
  background-color: var(--color-error, #dc2626);
  color: #fff;
}
```

### Audit Trail / Activity Timeline

```html
<!-- Audit trail timeline -->
<section aria-labelledby="activity-heading">
  <h3 id="activity-heading">Activity</h3>

  <ol class="timeline" aria-label="Request activity history">
    <li class="timeline__item timeline__item--approved">
      <div class="timeline__marker" aria-hidden="true"></div>
      <div class="timeline__content">
        <div class="timeline__header">
          <strong class="timeline__actor">Sarah Chen</strong>
          <span class="timeline__action">approved this request</span>
          <time class="timeline__time" datetime="2025-06-15T14:32:00Z">
            Jun 15, 2025 at 2:32 PM
          </time>
        </div>
        <p class="timeline__comment">
          Looks good. Budget allocation confirmed with finance.
        </p>
      </div>
    </li>

    <li class="timeline__item timeline__item--comment">
      <div class="timeline__marker" aria-hidden="true"></div>
      <div class="timeline__content">
        <div class="timeline__header">
          <strong class="timeline__actor">James Rivera</strong>
          <span class="timeline__action">commented</span>
          <time class="timeline__time" datetime="2025-06-14T09:15:00Z">
            Jun 14, 2025 at 9:15 AM
          </time>
        </div>
        <p class="timeline__comment">
          Can you attach the vendor quote for reference?
        </p>
      </div>
    </li>

    <li class="timeline__item timeline__item--submitted">
      <div class="timeline__marker" aria-hidden="true"></div>
      <div class="timeline__content">
        <div class="timeline__header">
          <strong class="timeline__actor">Alex Morgan</strong>
          <span class="timeline__action">submitted this request</span>
          <time class="timeline__time" datetime="2025-06-13T16:45:00Z">
            Jun 13, 2025 at 4:45 PM
          </time>
        </div>
      </div>
    </li>
  </ol>
</section>

<!-- Add comment form -->
<form class="comment-form" aria-label="Add a comment">
  <div class="form-field">
    <label for="new-comment" class="form-field__label">Add a comment</label>
    <textarea
      id="new-comment"
      name="comment"
      rows="3"
      class="form-field__textarea"
      placeholder="Type your comment..."
    ></textarea>
  </div>
  <button type="submit" class="btn btn--primary">Post Comment</button>
</form>
```

```css
.timeline {
  list-style: none;
  padding: 0;
  margin: 0;
  position: relative;
}

.timeline::before {
  content: '';
  position: absolute;
  left: 0.6875rem;
  top: 1.5rem;
  bottom: 1.5rem;
  width: 2px;
  background-color: var(--color-border, #e0e0e0);
}

.timeline__item {
  display: flex;
  gap: 1rem;
  padding-block-end: 1.5rem;
  position: relative;
}

.timeline__marker {
  width: 1.5rem;
  height: 1.5rem;
  border-radius: 50%;
  flex-shrink: 0;
  border: 2px solid var(--color-border, #e0e0e0);
  background-color: #fff;
  z-index: 1;
}

.timeline__item--submitted .timeline__marker {
  background-color: var(--color-primary, #2563eb);
  border-color: var(--color-primary, #2563eb);
}

.timeline__item--comment .timeline__marker {
  background-color: #fff;
  border-color: var(--color-hint, #9ca3af);
}

.timeline__item--approved .timeline__marker {
  background-color: var(--color-success, #22c55e);
  border-color: var(--color-success, #22c55e);
}

.timeline__item--rejected .timeline__marker {
  background-color: var(--color-error, #ef4444);
  border-color: var(--color-error, #ef4444);
}

.timeline__header {
  display: flex;
  flex-wrap: wrap;
  gap: 0.25rem;
  align-items: baseline;
  font-size: 0.875rem;
}

.timeline__actor {
  color: var(--color-heading, #1a1a1a);
}

.timeline__action {
  color: var(--color-hint, #666);
}

.timeline__time {
  color: var(--color-hint, #9ca3af);
  font-size: 0.75rem;
  margin-inline-start: auto;
}

.timeline__comment {
  margin-block-start: 0.5rem;
  font-size: 0.875rem;
  color: var(--color-label, #333);
  background-color: var(--color-comment-bg, #f9fafb);
  padding: 0.75rem;
  border-radius: 0.375rem;
  border: 1px solid var(--color-border, #e0e0e0);
}
```

---

## 7. Accessibility

### WCAG 3.3.x Coverage

| Criterion | Level | Requirement | Implementation |
|---|---|---|---|
| **3.3.1** Error Identification | A | Identify and describe errors in text | Error summary + inline messages linked via `aria-describedby` |
| **3.3.2** Labels or Instructions | A | Provide labels/instructions for inputs | `<label>` elements, hint text, format examples |
| **3.3.3** Error Suggestion | AA | Provide correction suggestions | Specific messages like "Must be at least 8 characters" |
| **3.3.4** Error Prevention (Legal/Financial) | AA | Allow review, confirm, or reverse submissions | Review step in wizards, confirmation dialogs |
| **1.3.5** Identify Input Purpose | AA | Programmatically identify input purpose | `autocomplete` attributes on all personal data fields |

### Required Field Indicators

Never rely solely on the asterisk `*`. Provide text and ARIA attributes.

```html
<!-- Accessible required field pattern -->
<p class="form__required-note">
  Fields marked with <span aria-hidden="true">*</span>
  <span class="sr-only">asterisk</span> are required.
</p>

<div class="form-field">
  <label for="approver" class="form-field__label">
    Approving manager
    <span class="form-field__required" aria-hidden="true">*</span>
  </label>
  <select
    id="approver"
    name="approver"
    required
    aria-required="true"
    class="form-field__select"
  >
    <option value="">-- Select manager --</option>
    <option value="jsmith">Jane Smith</option>
    <option value="bwilson">Bob Wilson</option>
  </select>
</div>
```

### Error Announcements with ARIA Live Regions

Use `role="alert"` (equivalent to `aria-live="assertive"`) for error messages that must be announced immediately. Use `aria-live="polite"` for non-critical status updates (like auto-save confirmations).

The error container **must exist in the DOM on page load** (even if hidden or empty) for screen readers (including iOS VoiceOver) to detect and announce changes.

```html
<!-- Error announcement pattern -->

<!-- Pre-existing container in DOM (critical for VoiceOver support) -->
<div id="form-errors" role="alert" aria-atomic="true">
  <!-- Error messages injected here -->
</div>

<!-- Field-level error linked via aria-describedby -->
<div class="form-field">
  <label for="budget" class="form-field__label">Annual budget</label>
  <input
    type="text"
    id="budget"
    name="budget"
    inputmode="numeric"
    aria-describedby="budget-error"
    aria-invalid="false"
    class="form-field__input"
  />
  <p id="budget-error" class="form-field__error" role="alert" aria-live="assertive"></p>
</div>
```

### Form Labeling Checklist

```html
<!-- Complete accessible field anatomy -->
<div class="form-field">
  <!-- 1. Visible label -->
  <label for="cost-center" class="form-field__label">
    Cost center
    <span class="form-field__required" aria-hidden="true">*</span>
  </label>

  <!-- 2. Hint / instructions -->
  <p class="form-field__hint" id="cost-center-hint">
    6-digit code from your department's budget allocation.
  </p>

  <!-- 3. Input with full ARIA binding -->
  <input
    type="text"
    id="cost-center"
    name="cost-center"
    required
    aria-required="true"
    aria-describedby="cost-center-hint cost-center-error"
    aria-invalid="false"
    inputmode="numeric"
    maxlength="6"
    pattern="\d{6}"
    autocomplete="off"
    class="form-field__input"
  />

  <!-- 4. Error message (pre-exists in DOM, initially empty) -->
  <p id="cost-center-error" class="form-field__error"
     role="alert" aria-live="assertive"></p>
</div>
```

### Keyboard Navigation

Follow the W3C ARIA Authoring Practices Guide:

- **Tab / Shift+Tab**: Move between form fields and interactive elements
- **Arrow keys**: Navigate within composite widgets (radio groups, select menus, date pickers)
- **Enter / Space**: Activate buttons, toggle checkboxes, open dropdowns
- **Escape**: Close dialogs, dropdowns, and popovers
- **Home / End**: Jump to first/last option in lists

Never use `tabindex` values greater than 0. Maintain DOM order that matches visual order.

```html
<!-- Skip link for long forms -->
<a href="#form-actions" class="skip-link">
  Skip to form actions
</a>

<!-- ... long form content ... -->

<div id="form-actions" class="step-navigation" tabindex="-1">
  <button type="submit" class="btn btn--primary">Submit Request</button>
</div>
```

```css
.skip-link {
  position: absolute;
  top: -100%;
  left: 0;
  z-index: 100;
  padding: 0.75rem 1.5rem;
  background: var(--color-primary, #2563eb);
  color: #fff;
  text-decoration: none;
  font-weight: 600;
  border-radius: 0 0 0.375rem 0;
}

.skip-link:focus {
  top: 0;
}
```

---

## 8. Performance

### Debounced Validation

```js
// Reusable debounce utility
function debounce(fn, ms) {
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), ms);
  };
}

// Async field validation (username availability, server-side checks)
const validateAsync = debounce(async (input, endpoint) => {
  const field = input.closest('.form-field');
  field.dataset.validationState = 'validating';

  try {
    const response = await fetch(`${endpoint}?value=${encodeURIComponent(input.value)}`);
    const { valid, message } = await response.json();

    if (!valid) {
      setFieldError(input, message);
    } else {
      clearFieldError(input);
    }
  } catch {
    // Network error: do not block the user, validate on submit instead
    field.dataset.validationState = 'idle';
  }
}, 500);
```

### Optimistic Submission

Show immediate success feedback while the server processes. Roll back on failure.

```js
// Optimistic form submission pattern
async function submitForm(form) {
  const submitBtn = form.querySelector('[type="submit"]');
  const formData = new FormData(form);

  // Immediate optimistic feedback
  submitBtn.disabled = true;
  submitBtn.textContent = 'Submitting...';
  showToast('Request submitted successfully', 'success');
  navigateToList();

  try {
    const response = await fetch(form.action, {
      method: form.method || 'POST',
      body: formData,
    });

    if (!response.ok) {
      throw new Error(`Server responded with ${response.status}`);
    }

    const result = await response.json();
    updateListItem(result.id, result);
  } catch (error) {
    // Roll back: return user to form with data preserved
    showToast('Submission failed. Your data has been saved as a draft.', 'error');
    navigateBackToForm(formData);
    submitBtn.disabled = false;
    submitBtn.textContent = 'Submit Request';
  }
}
```

### Form State Management

For complex enterprise forms, use a dedicated form state library. Current best practices (2025-2026):

| Approach | When to use | Library examples |
|---|---|---|
| **Uncontrolled + Constraint Validation API** | Simple forms, few fields | Native HTML |
| **React Hook Form** | React apps, performance-critical | `react-hook-form` + `zod` |
| **TanStack Form** | Framework-agnostic, complex workflows | `@tanstack/react-form` |
| **React 19 Actions** | React 19+ apps, server actions | `useActionState`, `useOptimistic` |
| **URL / query state** | Filter forms, search, shareable state | `nuqs`, `URLSearchParams` |

```js
// React Hook Form + Zod example for type-safe enterprise forms
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { z } from 'zod';

const expenseSchema = z.object({
  title: z.string().min(1, 'Title is required').max(200),
  amount: z.coerce.number().positive('Amount must be greater than zero'),
  currency: z.enum(['USD', 'EUR', 'BRL', 'GBP']),
  category: z.enum(['travel', 'supplies', 'software', 'other']),
  date: z.string().date('Please enter a valid date'),
  notes: z.string().max(1000).optional(),
});

function ExpenseForm() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
  } = useForm({
    resolver: zodResolver(expenseSchema),
    defaultValues: {
      currency: 'USD',
      date: new Date().toISOString().split('T')[0],
    },
  });

  const onSubmit = async (data) => {
    await fetch('/api/expenses', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data),
    });
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)} noValidate>
      <div className="form-field">
        <label htmlFor="title" className="form-field__label">Title</label>
        <input
          id="title"
          type="text"
          aria-invalid={!!errors.title}
          aria-describedby={errors.title ? 'title-error' : undefined}
          className="form-field__input"
          {...register('title')}
        />
        {errors.title && (
          <p id="title-error" className="form-field__error" role="alert">
            {errors.title.message}
          </p>
        )}
      </div>
      {/* Additional fields follow the same pattern */}
      <button type="submit" className="btn btn--primary" disabled={isSubmitting}>
        {isSubmitting ? 'Submitting...' : 'Submit Expense'}
      </button>
    </form>
  );
}
```

### Preventing Unsaved Data Loss

```js
// Warn before navigating away with unsaved changes
class UnsavedChangesGuard {
  constructor(form) {
    this.form = form;
    this.initialState = new FormData(form);
    this.submitted = false;

    form.addEventListener('submit', () => { this.submitted = true; });
    window.addEventListener('beforeunload', (e) => this.handleUnload(e));
  }

  hasChanges() {
    if (this.submitted) return false;
    const current = new FormData(this.form);
    for (const [key, value] of current.entries()) {
      if (this.initialState.get(key) !== value) return true;
    }
    return false;
  }

  handleUnload(e) {
    if (this.hasChanges()) {
      e.preventDefault();
      // Modern browsers show a generic message
    }
  }
}
```

---

## 9. Sources

### Form Layout
- [Avoid Extensive Multicolumn Layouts - Baymard Institute](https://baymard.com/blog/avoid-multi-column-forms)
- [How to Design UI Forms in 2026 - Interaction Design Foundation](https://www.interaction-design.org/literature/article/ui-form-design)
- [Field Labels in Forms Affect UX & Completion Rates - Formsite](https://www.formsite.com/blog/field-labels-positions/)
- [Research: How Layout Affects Form Completion Rates - Reform](https://www.reform.app/blog/research-how-layout-affects-form-completion-rates)
- [Designing More Efficient Forms - UX Planet](https://uxplanet.org/designing-more-efficient-forms-structure-inputs-labels-and-actions-e3a47007114f)
- [Grouping Form Controls with Fieldset and Legend - Accessibility Developer Guide](https://www.accessibility-developer-guide.com/examples/forms/grouping-with-fieldset-legend/)
- [Foundations: Fieldset and Legend - TetraLogical](https://tetralogical.com/blog/2025/01/31/foundations-fieldset-and-legend/)

### Validation
- [Inline Validation UX - Smart Interface Design Patterns (Vitaly Friedman)](https://smart-interface-design-patterns.com/articles/inline-validation-ux/)
- [A Complete Guide To Live Validation UX - Smashing Magazine](https://www.smashingmagazine.com/2022/09/inline-validation-web-forms-ux/)
- [Usability Testing of Inline Form Validation - Baymard Institute](https://baymard.com/blog/inline-form-validation)
- [Accessible Form Validation Best Practices - UXPin](https://www.uxpin.com/studio/blog/accessible-form-validation-best-practices/)
- [The UX of Form Validation: Inline or After Submission - LogRocket](https://blog.logrocket.com/ux-design/ux-form-validation-inline-after-submission/)

### Multi-Step Forms
- [Step Indicator - U.S. Web Design System (USWDS)](https://designsystem.digital.gov/components/step-indicator/)
- [Multi-Page Forms - W3C WAI](https://www.w3.org/WAI/tutorials/forms/multi-page/)
- [8 Best Multi-Step Form Examples in 2025 - Webstacks](https://www.webstacks.com/blog/multi-step-form)
- [Progressive Disclosure - NN/g](https://www.nngroup.com/articles/progressive-disclosure/)

### Data Entry Optimization
- [Developing a Keyboard Interface - W3C WAI ARIA APG](https://www.w3.org/WAI/ARIA/apg/practices/keyboard-interface/)
- [How to Design Great Keyboard Shortcuts - Knock](https://knock.app/blog/how-to-design-great-keyboard-shortcuts)
- [Keyboard-Only Navigation for Improved Accessibility - NN/g](https://www.nngroup.com/articles/keyboard-accessibility/)

### Complex Inputs
- [Date-Input Form Fields: UX Design Guidelines - NN/g](https://www.nngroup.com/articles/date-input/)
- [Phone Inputs and You: The Designer's Essential UI Guide - Evil Martians](https://evilmartians.com/chronicles/phone-inputs-and-you-the-designers-essential-ui-guide)
- [Wise Design - Money Input](https://wise.design/components/money-input)
- [Building a Modern Drag-and-Drop Upload UI - Filestack](https://blog.filestack.com/building-modern-drag-and-drop-upload-ui/)
- [File Upload UX Best Practices - Uploadcare](https://uploadcare.com/blog/file-uploader-ux-best-practices/)

### Accessibility
- [WCAG 3.3.1 Error Identification - W3C WAI](https://www.w3.org/WAI/WCAG22/Understanding/error-identification.html)
- [ARIA19: Using ARIA role=alert or Live Regions to Identify Errors - W3C](https://w3c.github.io/wcag/techniques/aria/ARIA19)
- [WCAG 3.3.2 Labels or Instructions - W3C WAI](https://www.w3.org/WAI/WCAG21/Understanding/labels-or-instructions.html)
- [H98: Using HTML Autocomplete Attributes - W3C WAI](https://www.w3.org/WAI/WCAG21/Techniques/html/H98)
- [Understanding Success Criterion 1.3.5: Identify Input Purpose - W3C WAI](https://www.w3.org/WAI/WCAG21/Understanding/identify-input-purpose.html)
- [Form Accessibility Guide - TestParty](https://testparty.ai/blog/form-accessibility-guide)

### Approval Workflows
- [Approval Workflow Design Patterns - Cflow](https://www.cflowapps.com/approval-workflow-design-patterns/)
- [Design Patterns for Approval Processes - ACM](https://dl.acm.org/doi/fullHtml/10.1145/3628034.3628035)
- [Understanding Approval Workflows - Wrike](https://www.wrike.com/workflow-guide/approval-workflow/)

### Performance & State Management
- [React State Management in 2025 - Developer Way](https://www.developerway.com/posts/react-state-management-2025)
- [TanStack Form - GitHub](https://github.com/TanStack/form)
- [Best Practices for Handling Forms in React (2025 Edition)](https://medium.com/@farzanekazemi8517/best-practices-for-handling-forms-in-react-2025-edition-62572b14452f)

### Enterprise UX General
- [Enterprise UX Design in 2026 - Tenet](https://www.wearetenet.com/blog/enterprise-ux-design)
- [Top 7 Enterprise UX Design Patterns - Onething Design](https://www.onething.design/post/top-7-enterprise-ux-design-patterns)
- [Enterprise UX Design Guide - Pencil & Paper](https://www.pencilandpaper.io/articles/enterprise-ux-design-guide)
- [10 UX/UI Best Practices for Modern Digital Products in 2025 - devPulse](https://devpulse.com/insights/ux-ui-design-best-practices-2025-enterprise-applications/)
