# Stage 1: Build the React application
FROM node:18-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

# Fix OpenSSL issue with Webpack
ENV NODE_OPTIONS="--openssl-legacy-provider"

COPY . .
RUN npm run build

# Stage 2: Serve the React application using Nginx
FROM nginx:stable-alpine

# Add metadata
LABEL maintainer="DevOps Team"
LABEL app="React Application"
LABEL environment="production"

COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 5000
CMD ["nginx", "-g", "daemon off;"]
