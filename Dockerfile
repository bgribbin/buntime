# syntax=docker/dockerfile:1
FROM oven/bun:1.3 AS builder
WORKDIR /app

COPY package.json ./
RUN bun install
COPY . .

RUN bun build --target=bun --production --outdir=dist ./server/index.ts

FROM debian:bookworm-slim AS runner
WORKDIR /app
COPY --from=builder /app/dist .
COPY --from=builder /app/public ./public
EXPOSE 3000
CMD ["bun", "dist/index.js"]
