# Stage 1: Build the application
FROM node:18-alpine AS build

# Create and set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to leverage Docker caching
COPY package*.json ./

# Install dependencies (clean install)
RUN npm ci

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Stage 2: Serve the application using a lightweight web server
FROM nginx:1.27.0-alpine

# Create and set the final build working directory
WORKDIR /usr/share/nginx/html

# Remove every thing from / dir
RUN rm -rf ./*

# Copy the build output from the previous stage
COPY --from=build /app/dist/ ./

# Copy custom nginx configuration (if needed)
COPY /src/config/nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]
