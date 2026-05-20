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

## Server paths (example)

| Variable | Example |
|----------|---------|
| `DEV_SOURCE_DIR` | `/home/via-marketplace/admin` |
| `DEV_INFRA_DIR` | `/home/via-marketplace/infra` |
| `DEV_INFRA_GIT_REF` | `main` |

## Deploy defaults (in `workflows/ci.yml`)

| Step | Default |
|------|---------|
| Build | `make build ENV=dev SERVICE=admin` |
| Deploy | `make up-nobuild ENV=dev ARGS=admin` |

Requires `up-nobuild` in infra `Makefile` on branch `main`. First full stack: `cd infra && make up-dev`.

## URLs (dev, nginx port 9081)

| App | URL |
|-----|-----|
| Admin UI | `http://admin-via-marketplace.huy.lat:9081` |
| API (login) | `http://api-via-marketplace.huy.lat:9081/admin/auth/login` |

`NEXT_PUBLIC_API_URL` in `infra/environments/dev/admin.env` must point at the **API** host, not the admin UI host.

Override only if needed: `DEV_BUILD_ARGS`, `DEV_DEPLOY_TARGET`, `DEV_DEPLOY_ARGS`.
