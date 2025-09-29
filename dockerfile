# ---- Build Stage ----
FROM node:18-alpine AS build

# Set workdir
WORKDIR /app

# Install dependencies first (cached if unchanged)
COPY package*.json ./
RUN npm ci --only=production

# Copy source code
COPY . .

# ---- Runtime Stage ----
FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy only the built app and dependencies from build stage
COPY --from=build /app /app

# Use non-root user for security
USER node

# Expose service port
EXPOSE 3000

# Run the app
CMD ["node", "src/index.js"]
