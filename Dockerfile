# Stage 1: Build the React app
FROM node:18-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the package.json and package-lock.json to install dependencies
COPY package*.json ./

# Install the dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React app
RUN npm run build

# Stage 2: Serve the built app with an HTTP server
FROM nginx:1.23-alpine

# Remove default NGINX static assets
RUN rm -rf /usr/share/nginx/html/*

# Copy the built React app from the previous stage
COPY --from=build /app/dist /usr/share/nginx/html

# Expose the port NGINX will run on
EXPOSE 80

# Start NGINX server
CMD ["nginx", "-g", "daemon off;"]