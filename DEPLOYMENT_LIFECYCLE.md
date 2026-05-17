# End-to-End Deployment Lifecycle

## Overview
Complete deployment lifecycle with failure points and mitigations.

---

## Stage 1: Code Development
**Action:** Developer writes code on a feature branch

**Failure Points:** Breaking changes, secrets committed to code

**Mitigation:** Pre-commit hooks, .gitignore for .env files

---

## Stage 2: Pull Request and Code Review

**Failure Points:** CI fails, merge conflicts, bad review

**Mitigation:** Required CI checks, branch protection, 1 reviewer minimum

---

## Stage 3: CI Pipeline

**Failure Points:** Build error, test failure, registry auth issue

**Mitigation:** Build caching, retry logic, separate jobs

---

## Stage 4: Docker Image Build

**Failure Points:** Base image unavailable, dependency install fails

**Mitigation:** Multi-stage builds, pinned base image versions

---

## Stage 5: Deploy to Server

**Failure Points:** Server unreachable, disk full, wrong env vars

**Mitigation:** Health checks, rollback script, monitoring alerts

---

## Stage 6: Nginx Reverse Proxy

**Failure Points:** Config error 502, SSL expired, DNS issue

**Mitigation:** nginx -t before reload, certbot auto-renew

---

## Stage 7: Health Check

**Failure Points:** App crashes after start, DB migration failed

**Mitigation:** Docker HEALTHCHECK directive, auto-rollback on failure

---

## Stage 8: Monitoring

**Failure Points:** Silent failures, memory leaks, disk fills up

**Mitigation:** Prometheus + Grafana, ELK logging, log rotation

---

## Deployment Strategies

| Strategy   | Description                    | Use Case         |
|------------|--------------------------------|------------------|
| Rolling    | Replace instances one by one   | Zero-downtime    |
| Blue-Green | Two identical environments     | Instant rollback |
| Canary     | Small percent traffic to new   | Risk reduction   |
| Recreate   | Stop old then start new        | Simple apps      |

---

## Rollback Plan

    docker stop devops-app
    docker run -d --name devops-app -p 3000:3000 devops-app:PREVIOUS_SHA
