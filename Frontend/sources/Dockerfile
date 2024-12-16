# Name the node stage "builder"
FROM node:23 AS builder
# Set working directory
WORKDIR /app
ENV REACT_APP_AUTH_REGION=${REACT_APP_AUTH_REGION}
ENV REACT_APP_AUTH_USER_POOL_ID=${REACT_APP_AUTH_USER_POOL_ID}
ENV REACT_APP_AUTH_USER_POOL_WEB_CLIENT_ID=${REACT_APP_AUTH_USER_POOL_WEB_CLIENT_ID}
# Copy all files from current directory to working dir in image
COPY . .
RUN npm install && npm run build
# nginx state for serving content
FROM nginx:alpine
# Set working directory to nginx asset directory
WORKDIR /usr/share/nginx/html
# Remove default nginx static assets
RUN rm -rf ./*
# Copy static assets from builder stage
COPY --from=builder /app/build .
# Containers run nginx with global directives and daemon off
EXPOSE 80
ENTRYPOINT  ["nginx", "-g", "daemon off;"]