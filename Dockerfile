# syntax=docker/dockerfile:1
FROM oven/bun:1.3 AS builder
WORKDIR /app

# Copy dependency files
COPY package.json bun.lock* ./

# Install dependencies
RUN bun install --frozen-lockfile

# Copy source files
COPY . .

# Build the application
RUN bun build --target=bun --production --outdir=dist ./src/index.ts

FROM oven/bun:1.3 AS runner
WORKDIR /app

# Copy built files from builder stage
COPY --from=builder /app/dist .

# Set production environment
ENV NODE_ENV=production
ENV PORT=3000

EXPOSE 3000

# Run the built application
CMD ["bun", "index.js"]
