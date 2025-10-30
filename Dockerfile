# syntax=docker/dockerfile:1
FROM oven/bun:1.3 AS builder
WORKDIR /app
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile
COPY . .
RUN bun run compile

FROM debian:bookworm-slim AS runner
WORKDIR /app
COPY --from=builder /app/server .
EXPOSE 3000
CMD ["./server"]
