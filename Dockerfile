# syntax=docker/dockerfile:1

FROM node:20-alpine AS deps
RUN apk add --no-cache libc6-compat \
  && corepack enable \
  && corepack prepare pnpm@10.24.0 --activate
WORKDIR /app
ENV HUSKY=0
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --ignore-scripts

FROM node:20-alpine AS builder
ENV HUSKY=0
RUN corepack enable && corepack prepare pnpm@10.24.0 --activate
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY . .

ARG NEXT_PUBLIC_APP_SLUG=via-marketplace-admin
ARG NEXT_PUBLIC_APP_NAME=Via Marketplace Admin
ARG NEXT_PUBLIC_API_URL=http://api-via-marketplace.huy.lat
ARG NEXT_PUBLIC_BASE_PATH=

ENV NEXT_PUBLIC_APP_SLUG=${NEXT_PUBLIC_APP_SLUG}
ENV NEXT_PUBLIC_APP_NAME=${NEXT_PUBLIC_APP_NAME}
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}
ENV NEXT_PUBLIC_BASE_PATH=${NEXT_PUBLIC_BASE_PATH}

RUN pnpm run build

FROM node:20-alpine AS runner
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
ENV HOSTNAME=0.0.0.0
ENV API_URL=http://api:3000

RUN addgroup --system --gid 1001 nodejs && adduser --system --uid 1001 nextjs

COPY --from=builder /app/public ./public
COPY --from=builder --chown=nextjs:nodejs /app/.next/standalone ./
COPY --from=builder --chown=nextjs:nodejs /app/.next/static ./.next/static

USER nextjs
EXPOSE 3000
CMD ["node", "server.js"]
