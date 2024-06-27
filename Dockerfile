# Stage 1
FROM node:18.10.0 AS build
WORKDIR /usr/test/app
COPY package.json ./
RUN npm install
COPY . .
RUN npm run build

# Stage 2
FROM nginx:1.22.1-alpine
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /usr/test/app/dist/my-app /usr/share/nginx/html
