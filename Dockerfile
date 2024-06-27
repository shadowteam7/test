# Use Node 18 as the base image
FROM node:18-alpine as build-step

# Create and set the working directory
RUN mkdir -p /app
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json /app
RUN npm install

# Angular 17 projects should work with the npm version that comes with Node 18, so the explicit npm install command for an older version is removed.

# Copy the rest of the application
COPY . /app

# Build the Angular project
RUN npm run build --prod
RUN ls /app/dist/my-app
# Use the latest nginx as the base for the final image
FROM nginx:latest

# Copy the built Angular app to the nginx serve directory
COPY --from=build-step /app/dist/my-app /usr/share/nginx/html

# Copy the nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf
