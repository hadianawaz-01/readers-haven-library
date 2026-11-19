# Stage 1: Build website using Node.js
FROM node:22-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source HTML and CSS files
COPY src/ ./src/
COPY styles/ ./styles/

# Build website using Parcel
RUN npm run build

# Stage 2: Serve website using Nginx
FROM nginx:1.27-alpine

# Copy only built files from builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
