#Stage 1: build / test deps 
FROM node:18-alpine3.21 AS builder

WORKDIR /usr/src/app

RUN exit 1

COPY package*.json ./
RUN npm ci

COPY . .

#Stage 2: production image 
FROM node:18-alpine3.21 AS production

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci --omit=dev && npm cache clean --force


COPY --from=builder /usr/src/app/index.js ./

# Non-root user
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 8080

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost:8080/health || exit 1

CMD ["node", "index.js"]