# Etapa 1: Construir la aplicación Angular
FROM node:18 AS build
RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build --prod
RUN ls -l /app/dist/my-app
# Etapa 2: Configurar Nginx para servir la aplicación
FROM nginx
COPY --from=build /app/dist/my-app /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer el puerto en el que Nginx servirá la aplicación
EXPOSE 80
