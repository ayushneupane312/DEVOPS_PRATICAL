DevOps Practical Execution Task

Prepared by: Ayush Neupane | GitHub: @ayushneupane312

Table of Contents

Overview
Repository Structure
Task 1 — Git Init & Push
Task 2 — Branching Strategy
Task 3 — Merge Conflict Resolution
Task 4 — Optimized Dockerfile
Task 5 — Container Debug
Task 6 — Docker Compose
Task 7 — GitHub Actions CI
Task 8 — Bash Deployment Script
Task 9 — Environment Variables
Task 10 — Nginx Reverse Proxy
Task 11 — Netlify Deployment
Task 12 — Log Analysis
Task 13 — Container Debugging
Task 14 — CI/CD YAML
Task 15 — Deployment Lifecycle

Overview
This repository contains the complete implementation of all 15 DevOps practical tasks covering Git, Docker, CI/CD, Nginx, Netlify, log analysis, and end-to-end deployment lifecycle.
CategoryTools UsedVersion ControlGit, GitHubContainerizationDocker, Docker ComposeCI/CDGitHub ActionsWeb ServerNginxFrontend HostingNetlifyScriptingBashRuntimeNode.js (Alpine)DatabasePostgreSQL

Repository Structure
DEVOPS_PRATICAL/
├── app/
│   ├── server.js               # Node.js HTTP server
│   └── package.json            # App dependencies
├── .github/
│   └── workflows/
│       ├── ci.yml              # Task 7: CI Pipeline
│       └── cicd.yml            # Task 14: Full CI/CD Pipeline
├── nginx/
│   ├── nginx.conf              # Task 10: Reverse proxy config
│   └── setup-nginx.sh          # Nginx install script
├── frontend/
│   └── index.html              # Task 11: Static frontend
├── logs/
│   └── app.log                 # Task 12: Sample log file
├── auth.js                     # Task 2: JWT auth module (Dev A)
├── profile.js                  # Task 2: User profile module (Dev B)
├── config.js                   # Task 3: Conflict-resolved config
├── Dockerfile                  # Task 4: Optimized multi-stage build
├── .dockerignore               # Docker build exclusions
├── docker-compose.yml          # Task 6: App + PostgreSQL setup
├── deploy.sh                   # Task 8: Automated deploy script
├── debug-container.sh          # Task 5: Container run & debug
├── debug-failing-container.sh  # Task 13: Container debug tool
├── analyze-logs.sh             # Task 12: Log analysis script
├── netlify.toml                # Task 11: Netlify config
├── .env.example                # Task 9: Environment variable template
├── load-env.js                 # Task 9: Env loader with validation
├── DEPLOYMENT_LIFECYCLE.md     # Task 15: Lifecycle documentation
└── README.md                   # This file

Task 1 — Git Init & Push
Initialized a Git repository with proper commit messages following Conventional Commits specification.
bashgit init
git add .
git commit -m "chore: initial project setup with README and gitignore"
git remote add origin https://github.com/ayushneupane312/DEVOPS_PRATICAL.git
git push -u origin main
Commit Convention Used:
PrefixPurposefeat:New featurefix:Bug fixchore:Maintenanceci:CI/CD changesdocs:Documentation

Task 2 — Branching Strategy
Simulated a real team workflow with 3 developers working on separate feature branches.
main
 └── develop
      ├── feature/user-auth      ← Developer A (JWT Authentication)
      ├── feature/user-profile   ← Developer B (User Profile)
      ├── feature/port-3000      ← Config change
      └── feature/port-8080      ← Config change (conflict source)
Workflow:
bash# Developer A
git checkout -b feature/user-auth
git commit -m "feat: add JWT authentication module"
git push origin feature/user-auth

# Developer B
git checkout -b feature/user-profile
git commit -m "feat: add user profile module"
git push origin feature/user-profile

# Team Lead merges via PR
git merge --no-ff feature/user-auth -m "Merge feature/user-auth into develop (PR #1 approved)"
git merge --no-ff feature/user-profile -m "Merge feature/user-profile into develop (PR #2 approved)"

Task 3 — Merge Conflict Resolution
Simulated a merge conflict where two developers edited the same file (config.js).
Conflict:
<<<<<<< HEAD
const PORT = 3000;
=======
const PORT = 8080;
>>>>>>> feature/port-8080
Resolution:
js// Resolved: use environment variable with fallback
const PORT = process.env.PORT || 3000;
bashgit add config.js
git commit -m "fix: resolve merge conflict - use env PORT with fallback"

Task 4 — Optimized Dockerfile
Multi-stage Dockerfile using Alpine Linux for minimal image size.
dockerfile# Stage 1: Builder
FROM node:20-alpine AS builder
WORKDIR /app
COPY app/package*.json ./
RUN npm ci --only=production

# Stage 2: Production (minimal)
FROM node:20-alpine
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY app/ .
RUN chown -R appuser:appgroup /app
USER appuser
EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=10s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["node", "server.js"]
Optimizations Applied:

Alpine base image (~5MB vs ~900MB full Ubuntu)
Multi-stage build removes dev dependencies
npm ci for deterministic installs
Non-root user for security
.dockerignore to exclude unnecessary files
Built-in HEALTHCHECK


Task 5 — Container Debug
File: debug-container.sh
bash# Build and run
docker build -t devops-app:latest .
docker run -d -p 3000:3000 --name devops-app devops-app:latest

# Debug commands
docker ps -a                          # Check status
docker logs devops-app                # View logs
docker exec -it devops-app /bin/sh    # Shell access
docker inspect devops-app             # Full metadata
docker stats devops-app --no-stream   # Resource usage
Common Issues & Fixes:
IssueFixPort conflictChange host port: -p 3001:3000Missing env varAdd -e KEY=VALUE or --env-file .envPermission deniedFix USER in DockerfileApp crashesCheck CMD vs ENTRYPOINT

Task 6 — Docker Compose
Multi-container setup with Node.js app + PostgreSQL database.
bash# Start all services
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop everything
docker-compose down -v
Services:
ServiceImagePortappCustom (Dockerfile)3000dbpostgres:15-alpine5432
See full config: docker-compose.yml

Task 7 — GitHub Actions CI
File: .github/workflows/ci.yml
Triggers on every push and pull request to main and develop.
Push/PR → Checkout → Setup Node → Install → Test → Build Docker Image
Pipeline Steps:

Checkout code
Setup Node.js 20 with caching
npm ci — install dependencies
npm test — run tests
docker build — build image


Task 8 — Bash Deployment Script
File: deploy.sh
bash./deploy.sh
Features:

Timestamped logging to deploy.log
Builds Docker image
Stops and removes old container
Starts new container with --restart unless-stopped
Health check with 5 retries
Auto-cleanup of dangling images
set -euo pipefail for safe error handling


Task 9 — Environment Variables
Files: .env.example, load-env.js
bash# Copy template and fill values
cp .env.example .env
NODE_ENV=production
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_NAME=appdb
DB_USER=appuser
DB_PASS=your_secure_password_here
JWT_SECRET=your_jwt_secret_here_min_32_chars
Security Rules:

.env is in .gitignore — never committed
Secrets stored in GitHub Actions Secrets
Required variable validation on startup
Never hardcode secrets in source code


Task 10 — Nginx Reverse Proxy
File: nginx/nginx.conf
nginxserver {
    listen 80;
    return 301 https://$host$request_uri;  # HTTP → HTTPS redirect
}

server {
    listen 443 ssl http2;
    location / {
        proxy_pass http://127.0.0.1:3000;  # Forward to Node.js
    }
}
Setup:
bashcd nginx && ./setup-nginx.sh
# Get SSL certificate
sudo certbot --nginx -d example.com

Task 11 — Netlify Deployment
Files: netlify.toml, frontend/index.html
Deploy via CLI:
bashnpm install -g netlify-cli
netlify login
netlify deploy --prod --dir=frontend
Auto Deploy via GitHub:

Connect repo in Netlify dashboard
Set publish directory to frontend
Every push to main auto-deploys


Task 12 — Log Analysis
Files: analyze-logs.sh, logs/app.log
bash./analyze-logs.sh
Output:
 Total lines:  9
ERROR count:  6
  WARN count:  1
 INFO count:   2

🔎 Root Cause Analysis:
   DB connection refused - check if DB is running
    OOM - increase container memory limit
    Auth failures - check credentials
    TypeError - add null checks in code

Task 13 — Container Debugging
File: debug-failing-container.sh
bash./debug-failing-container.sh <container-name>
Debug Steps:

Container status check
Last 30 log lines
Exit code analysis
Resource usage (CPU/RAM)
Proposed fixes

Exit Code Reference:
CodeMeaning0Clean exit1Application error137OOM Killed126Permission denied127Command not found

Task 14 — CI/CD YAML
File: .github/workflows/cicd.yml
Full 3-stage pipeline:
Push to main
    │
    ▼
┌─────────┐     ┌─────────┐     ┌──────────┐
│  BUILD  │────▶│  TEST   │────▶│  DEPLOY  │
│         │     │         │     │          │
│ Docker  │     │ npm test│     │ SSH into │
│ build & │     │ Health  │     │ server & │
│ push to │     │ check   │     │ restart  │
│ GHCR    │     │         │     │ container│
└─────────┘     └─────────┘     └──────────┘

Build — Docker image pushed to GitHub Container Registry
Test — Unit tests + container health check
Deploy — SSH into server, pull image, restart container (main branch only)


Task 15 — Deployment Lifecycle
File: DEPLOYMENT_LIFECYCLE.md
Complete 8-stage lifecycle documented with failure points and mitigations:
StageActionKey Risk1Code DevelopmentSecrets committed2Pull Request & ReviewBad code merged3CI PipelineBuild/test failure4Docker Image BuildBase image unavailable5Deploy to ServerServer unreachable6Nginx Reverse ProxySSL expiry / 502 error7Health CheckApp crashes post-start8MonitoringSilent failures
Deployment Strategies:
StrategyDescriptionUse CaseRollingReplace instances one by oneZero-downtimeBlue-GreenTwo identical environmentsInstant rollbackCanarySmall % traffic to new versionRisk reductionRecreateStop old, start newSimple/dev apps
