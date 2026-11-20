# ============================================
# STAGE 1: BUILDER
# ============================================

# Use a pinned Node.js Alpine image for building the website
FROM node:22-alpine AS builder

# Set the working directory inside the builder container
WORKDIR /app

# Copy package files first for better Docker layer caching
COPY package*.json ./

# Install exact dependencies from package-lock.json
RUN npm ci

# Copy HTML source files
COPY src/ ./src/

# Copy shared CSS files
COPY styles/ ./styles/

# Build all HTML pages using Parcel
RUN npm run build


# ============================================
# STAGE 2: RUNTIME
# ============================================

# Use a small Nginx image to serve the static website
FROM nginx:1.27-alpine

# Copy only the generated website from the builder stage
COPY --from=builder /app/dist/ /usr/share/nginx/html/

# Expose the HTTP port
EXPOSE 80

# Keep Nginx running in the foreground
CMD ["nginx", "-g", "daemon off;"]