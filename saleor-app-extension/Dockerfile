# -------------------------
# Stage 1: Build
# -------------------------
    FROM node:22-alpine AS builder

    WORKDIR /app
    
    # Install pnpm globally
    RUN corepack enable && corepack prepare pnpm@9.12.3 --activate
    
    # Copy only important files first for better layer caching
    COPY package.json pnpm-lock.yaml ./
    
    # Install dependencies
    RUN pnpm install
    
    # Now copy the rest of the source code
    COPY . .
    
    # Build the Next.js app
    RUN pnpm build
    
    # -------------------------
    # Stage 2: Production Runtime
    # -------------------------
    FROM node:22-alpine
    
    WORKDIR /app
    
    # Install pnpm globally
    RUN corepack enable && corepack prepare pnpm@9.12.3 --activate
    
    # Copy ONLY the built app and needed files
    COPY --from=builder /app/public ./public
    COPY --from=builder /app/.next ./.next
    COPY --from=builder /app/node_modules ./node_modules
    COPY --from=builder /app/package.json ./package.json
    COPY --from=builder /app/next.config.js ./next.config.js
    
    # Expose port
    EXPOSE 3000
    
    # Expose HTTPS port
EXPOSE 3000

# Start Next.js app with HTTPS
CMD ["pnpm", "exec", "next", "start", "--hostname", "0.0.0.0", "--port", "3000"]


    