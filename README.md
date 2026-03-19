# Assignment 16: CI Pipeline and Quality Gates

Part of the **ILA Rails and React Engineering Certification - Level 1**

---

## Overview

This assignment implements a **Continuous Integration (CI) pipeline** using **GitHub Actions** to enforce automated quality checks across a full-stack application.

The project includes:

* A **Rails backend**
* A **React frontend**

The CI pipeline ensures that:

* Tests are executed automatically
* Code quality is validated via linting
* Failures block merges (quality gates)

---

## Project Structure

```text
assignment-16/
  backend/        # Rails API
  frontend/       # React app
  .github/
    workflows/
      ci.yml      # CI pipeline
```

---

## CI Pipeline Design

The CI pipeline is triggered on:

* `push` to `main`
* `pull_request`

It consists of the following jobs:

---

### 1. Security Scan (Backend)

* Runs **Brakeman** for static analysis
* Runs **Bundler Audit** for dependency vulnerabilities

```bash
bin/brakeman
bin/bundler-audit
```

---

### 2. Linting (Backend)

* Uses **RuboCop**
* Enforces Ruby style guidelines
* Fails the pipeline on any lint errors

```bash
bundle exec rubocop
```

---

### 3. Backend Tests (Rails)

* Uses **RSpec**
* Runs against a **PostgreSQL service container**

Steps:

* Setup database
* Run migrations
* Execute tests

```bash
bundle exec rails db:create db:migrate
bundle exec rspec
```

---

### 4. Frontend Checks (React)

* Runs **Jest tests**
* Runs **ESLint**

```bash
npm test -- --watchAll=false
npm run lint
```

---

## Quality Gates

The pipeline enforces strict quality gates:

| Check            | Behavior          |
| ---------------- | ----------------- |
| ❌ Test failure   | Pipeline fails    |
| ❌ Lint error     | Pipeline fails    |
| ❌ Security issue | Pipeline fails    |
| ✅ All pass       | Pipeline succeeds |

This ensures only **clean, tested, and secure code** is merged.

---

## Validation Strategy

The pipeline was tested using failure scenarios:

### 1. Test Failure

* Modified test expectation → CI failed

### 2. Lint Failure

* Introduced formatting issue → CI failed

### 3. Fix & Re-run

* Corrected issues → CI passed

---

## Challenges Faced

### 1. PostgreSQL Connection in CI

* Initial failures due to Rails attempting socket connection
* Fixed by configuring CI to use service container (`postgres` host)

---

### 2. ESLint Configuration Conflict

* Conflict between modern ESLint config and CRA setup
* Resolved by using compatible ESLint version and `.eslintrc`

---

### 3. RuboCop Line Ending Issues

* Local environment passed but CI failed
* Root cause: newline/line-ending inconsistencies
* Addressed using `.editorconfig` and normalization

---

## Key Learnings

* CI environments differ from local setups (especially networking)
* Service containers require **explicit host configuration**
* Linting acts as a **first-class quality gate**
* Small formatting issues can break builds
* Debugging CI requires inspecting logs and environment variables

---

## Completion Criteria

* CI runs from a clean checkout ✔
* Backend and frontend jobs execute ✔
* Lint and tests enforced as quality gates ✔
* Failures block pipeline ✔
* Workflow is documented ✔

---

## Self-Check Answers

### 1. What are pipeline quality gates?

Automated checks (tests, linting, security scans) that must pass before code can be merged.

---

### 2. How is CI environment bootstrapped?

By:

* Installing dependencies
* Setting up runtime environments (Ruby, Node)
* Initializing services (PostgreSQL)

---

### 3. How does failing lint affect merge readiness?

Failing lint causes the CI pipeline to fail, preventing code from being merged until issues are resolved.

---

## Outcome

This assignment demonstrates a **production-style CI pipeline** that:

* Automates validation
* Enforces code quality
* Prevents regressions
* Provides fast developer feedback

---
