FROM node:18 as build-step
#FROM node:14 as build-step
    RUN mkdir -p /app
    WORKDIR /app
    COPY package.json /app
    RUN npm install
    RUN npm install -g npm@10.8.1
    COPY . /app
    RUN npm run build --prod

FROM nginx:latest
COPY --from=build-step /app/dist/my-app /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
