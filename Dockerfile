FROM node:14-alpine as build-step
#FROM node:14 as build-step
    RUN mkdir -p /app
    WORKDIR /app
    COPY package.json /app
    RUN npm install
    RUN npm install -g npm@7.20.5
    COPY . /app
    RUN npm run build --prod

FROM nginx:latest
COPY --from=build-step /app/dist/angularapp /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
