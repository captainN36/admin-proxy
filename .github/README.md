# GitHub Actions — admin

- Workflow: [`workflows/ci.yml`](./workflows/ci.yml)
- CI: [`actions/ci/action.yml`](./actions/ci/action.yml) — pnpm, `pnpm run lint`
- Deploy: [`actions/ssh-make-deploy/action.yml`](./actions/ssh-make-deploy/action.yml)

## Triggers

| Event | Action |
|-------|--------|
| PR / push to `develop`, `main` | lint; deploy on push when vars set |
| `workflow_dispatch` | develop / production |
| `repository_dispatch` | `admin-develop`, `admin-production` |

## Deploy flow (defaults)

1. Pull **admin** + **infra** (`main`) on server  
2. `make build ENV=dev SERVICE=admin`  
3. `make deploy-admin ENV=dev` — recreate admin + nginx

Requires **api** already healthy for admin login.

## Server paths (example)

| Variable | Example |
|----------|---------|
| `DEV_SOURCE_DIR` | `/home/via-marketplace/admin` |
| `DEV_INFRA_DIR` | `/home/via-marketplace/infra` |
| `DEV_INFRA_GIT_REF` | `main` |
| `DEV_DEPLOY_TARGET` | `deploy-admin` |
| `DEV_BUILD_ARGS` | `admin` |

## URLs (dev)

| App | URL |
|-----|-----|
| Admin UI | `http://admin-via-marketplace.huy.lat:9081` |
| Direct admin port | `http://localhost:9082` |
| API | `http://api-via-marketplace.huy.lat:9081` |

`NEXT_PUBLIC_API_URL` in `infra/environments/dev/admin.env` must point at the **API** host (`api-via-marketplace.huy.lat:9081`), not the admin UI.

## First deploy on a new server

```bash
cd /home/via-marketplace/infra
make dev-deploy-dev
```

Then admin CI can roll `deploy-admin` only.
