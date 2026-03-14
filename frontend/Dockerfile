# Build stage
FROM node:18-alpine AS build
WORKDIR /app

# Copy package files
COPY package.json ./

# Install pnpm and dependencies
RUN npm install -g pnpm@8.15.0 && pnpm install

# Copy source code
COPY . .

# Build the app
RUN pnpm build

# Production stage
FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html

# Remove default nginx static assets
RUN rm -rf ./*

# Copy built app from build stage
COPY --from=build /app/dist .

# Copy nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
