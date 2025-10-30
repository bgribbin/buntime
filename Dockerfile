FROM oven/bun:1.3

WORKDIR /app

COPY . .

RUN bun install
RUN bun run build
EXPOSE 3000
CMD ["bun", "src/index.ts"]
