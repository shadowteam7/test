# Stage 1
FROM node:20.12.2 AS build
WORKDIR /usr/test/app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build --prod

# Stage 2
FROM nginx:1.26.1-alpine-slim 
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /usr/test/app/dist/my-app /usr/share/nginx/html
