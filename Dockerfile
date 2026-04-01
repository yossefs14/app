# ── Stage 1: install dependencies ────────────────────────
FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# ── Stage 2: final image ──────────────────────────────────
FROM node:20-alpine
WORKDIR /app

# Non-root user for security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

COPY --from=deps /app/node_modules ./node_modules
COPY index.js queries.js ./

RUN chown -R appuser:appgroup /app
USER appuser

EXPOSE 3000
CMD ["node", "index.js"]


