
# Application Load Testing through CI

> Automated CI pipeline that deploys microservices to a local Kubernetes cluster, runs load tests, captures real metrics and comments it in the PR.

## What This Does

1. **Open a PR** → GitHub Actions triggers
2. **Provisions KinD cluster** → multi-node local Kubernetes
3. **Deploys services** → `bar` and `foo` via Helm (http-echo app)
4. **Sets up ingress** → Nginx routes traffic by hostname
5. **Deploys Prometheus** → monitoring with cAdvisor + Node Exporter
6. **Runs k6 load tests** → 110 seconds, up to 50 concurrent users
7. **Captures metrics** → CPU & memory (cluster + per-pod)
8. **Posts results** → as a PR comment

## Quick Start

### CI (Automated)
Just open a PR to `main`. GitHub Actions handles everything.

## Features
- Automated Deployment: Spins up KinD cluster + full stack in minutes

- Load Testing: k6-based performance testing with detailed metrics

- Real-time Monitoring: Prometheus + cAdvisor for container insights

- PR Integration: Auto-posts test results as GitHub comments

- Production-Ready: Helm charts, RBAC, Ingress - the works


## Project Structure

```
.
├── .github/workflows/
│   └── ci.yaml                 \# CI pipeline
├── application/
│   ├── http-echo/              \# Go microservice Dockerfile
│   └── foo-bar-app/            \# Helm chart
├── infrastructure_setup/       
│   ├── ingress_controller.yaml
│   ├── ingress.yaml
│   ├── rbac.yaml
└── testing/
    └── load-test.js             \# k6 test

```
## Architecture

```

┌──────────────────────────────────────────────┐
│           GitHub Actions Runner              │
├──────────────────────────────────────────────┤
│  ┌────────────┐  ┌────────────┐  ┌─────────┐ │
│  │ KinD       │  │ Prometheus │  │  k6     │ │
│  │ Cluster    │──│ Monitoring │──│ Testing │ │
│  └────────────┘  └────────────┘  └─────────┘ │ 
│         │                                    │
│  ┌──────▼────────────────────────────────┐   │
│  │  Nginx Ingress Controller             │   │ 
│  └──────┬───────────────────────┬────────┘   │
│         │                       │            │
│  ┌──────▼──────┐        ┌───────▼──────┐     │
│  │ foo service │        │  bar service │     │
│  │ (http-echo) │        │  (http-echo) │     │
│  └─────────────┘        └──────────────┘     │
└──────────────────────────────────────────────┘
```

## Tech Stack

- **K8s**: KinD (2-node local cluster)
- **Ingress**: Nginx
- **Load Testing**: k6
- **Monitoring**: Prometheus + cAdvisor + Node Exporter
- **CI/CD**: GitHub Actions
- **Deployment**: Helm

## Expected Results

After the test completes, you'll see:

```
## 📊 Load Test Results

✅ Status: PASSED

### Performance Metrics

✓ is status 200
✓ is response time < 200ms
checks.........................: 100.00% ✓ 6248      ✗ 0   
http_req_duration..............: avg=626.04µs min=413.89µs med=584.18µs max=10.38ms  p(90)=773.8µs  p(95)=842.91µs
http_req_failed................: 0.00%   ✓ 0         ✗ 3124
http_reqs......................: 3124    28.297338/s
default ✓ [ 100% ] 00/50 VUs  1m50s


### Resource Utilization

- Cluster CPU: 3.03%
- Cluster Memory: 34.90%
- Total Container Memory: 328.21 MB
- Total Container CPU: 0.49%


### Per-Pod Metrics

- bar-68649df785-xnf2f: CPU=0.12%, Memory=8.69MB
- bar-68649df785-ftdwg: CPU=0.11%, Memory=10.55MB
- foo-64d874f5f4-h6nhq: CPU=0.13%, Memory=10.66MB
- foo-64d874f5f4-hmpz4: CPU=0.13%, Memory=8.67MB

```

## Design Decisions

**Why KinD?** Fast, disposable clusters perfect for CI

**Why k6?** Modern, scriptable, built-in metrics

**Why Prometheus?** Industry standard, powerful PromQL queries


### CI won't trigger?

- Enable Actions: `Settings` → `Actions` → Allow all actions
- Give permissions: `Settings` → `Actions` → `Workflow permissions` → Read & Write

## Known Limitations

- CPU metrics need ~60s history (rate calculations require data)
- First run might show lower CPU (cold start effect)
- Metrics are cluster-scoped (no per-request tracing)


---

Built with ☕ and a lot of `kubectl get pods`. It took me around 4 hours overall to build this.

