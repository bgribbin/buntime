# syntax=docker/dockerfile:1
FROM oven/bun:1.3 AS builder
WORKDIR /app

COPY package.json ./
RUN bun install
COPY . .

RUN bun build --target=bun --production --outdir=dist ./src/index.ts

FROM oven/bun:1.3 AS runner
WORKDIR /app
COPY --from=builder /app/dist .

EXPOSE 3000
CMD ["bun", "dist/index.js"]
